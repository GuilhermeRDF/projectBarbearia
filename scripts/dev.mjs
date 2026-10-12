import { spawn } from 'node:child_process';
import http from 'node:http';
import { ROOT_DIR } from './load-env.mjs';

const isWindows = process.platform === 'win32';
const PNPM = isWindows ? 'pnpm.cmd' : 'pnpm';
const DOCKER = isWindows ? 'docker.exe' : 'docker';

const API_URL = process.env.API_URL || 'http://localhost:3000';
const API_HOST = new URL(API_URL).hostname;

function run(command, args = [], options = {}) {
  const child = spawn(command, args, {
    cwd: ROOT_DIR,
    stdio: 'inherit',
    shell: isWindows && command.endsWith('.cmd'),
    windowsHide: true,
    ...options,
  });

  return child;
}

function waitForProcess(child) {
  return new Promise((resolve) => {
    child.once('close', (code) => resolve(code ?? 1));
    child.once('error', (error) => {
      console.error('❌ Erro:', error.message);
      resolve(1);
    });
  });
}

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function runCommand(command, args, timeout = 15000) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      stdio: ['ignore', 'pipe', 'pipe'],
      windowsHide: true,
      shell: false,
    });

    let stdout = '';
    let stderr = '';
    let settled = false;

    const timer = setTimeout(() => {
      child.kill();
      finish(new Error(`Tempo limite excedido: ${command}`));
    }, timeout);

    function finish(error, result) {
      if (settled) return;
      settled = true;
      clearTimeout(timer);

      if (error) reject(error);
      else resolve(result);
    }

    child.stdout?.on('data', (data) => {
      stdout += data.toString();
    });

    child.stderr?.on('data', (data) => {
      stderr += data.toString();
    });

    child.once('error', (error) => finish(error));

    child.once('close', (code) => {
      if (code === 0) {
        finish(null, { stdout, stderr });
      } else {
        finish(
          new Error(
            stderr.trim() ||
              stdout.trim() ||
              `Comando terminou com código ${code}`
          )
        );
      }
    });
  });
}

async function dockerResponds() {
  try {
    await runCommand(DOCKER, ['info'], 10000);
    return true;
  } catch {
    return false;
  }
}

async function ensureDocker() {
  console.log('🐳 Verificando Docker Desktop...');

  if (await dockerResponds()) {
    console.log('✅ Docker Engine já está funcionando.');
    return;
  }

  if (isWindows) {
    console.log('🚀 Tentando iniciar o Docker Desktop...');

    try {
      await runCommand(DOCKER, ['desktop', 'start'], 30000);
    } catch {
      // Algumas versões do Docker Desktop não oferecem esse comando.
      // Nesse caso, tentamos iniciar pelo executável do Windows.
      try {
        await runCommand(
          'powershell.exe',
          [
            '-NoProfile',
            '-Command',
            'Start-Process "$Env:ProgramFiles\\Docker\\Docker\\Docker Desktop.exe"',
          ],
          10000
        );
      } catch (error) {
        throw new Error(
          'Não foi possível iniciar o Docker Desktop automaticamente. ' +
            'Abra o Docker Desktop pelo menu Iniciar e tente novamente. ' +
            error.message
        );
      }
    }
  } else {
    throw new Error(
      'O Docker não está disponível. Inicie o serviço Docker e tente novamente.'
    );
  }

  console.log('⏳ Aguardando o Docker Engine iniciar...');

  for (let attempt = 1; attempt <= 60; attempt++) {
    if (await dockerResponds()) {
      console.log('✅ Docker Engine está pronto.');
      return;
    }

    await delay(2000);
  }

  throw new Error(
    'O Docker Desktop não ficou pronto após 120 segundos. ' +
      'Verifique se ele abriu corretamente.'
  );
}

async function ensurePostgres() {
  console.log('');
  console.log('🐘 Verificando PostgreSQL...');

  await runCommand(DOCKER, ['compose', 'up', '-d'], 120000);

  console.log('⏳ Aguardando PostgreSQL ficar saudável...');

  for (let attempt = 1; attempt <= 60; attempt++) {
    try {
      const result = await runCommand(
        DOCKER,
        [
          'inspect',
          '--format',
          '{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}',
          'trato-fino-postgres',
        ],
        10000
      );

      const status = result.stdout.trim();

      if (status === 'healthy' || status === 'running') {
        console.log(`✅ PostgreSQL está ${status}.`);
        return;
      }
    } catch {
      // O container ainda pode estar iniciando.
    }

    await delay(2000);
  }

  throw new Error(
    'O PostgreSQL não ficou pronto após 120 segundos. ' +
      'Verifique o container com: docker compose ps'
  );
}

async function setupDatabase() {
  console.log('');
  console.log('🛠️ Preparando schema e Prisma...');

  const setup = run(PNPM, ['db:setup'], { cwd: ROOT_DIR });
  const setupCode = await waitForProcess(setup);

  if (setupCode !== 0) {
    throw new Error(`Falha na preparação do banco. Código: ${setupCode}`);
  }

  const generate = run(PNPM, [
    '--dir',
    'apps/api',
    'exec',
    'prisma',
    'generate',
  ]);

  const generateCode = await waitForProcess(generate);

  if (generateCode !== 0) {
    throw new Error(
      `Falha ao gerar Prisma Client. Código: ${generateCode}`
    );
  }
}

function waitForApi(timeout = 30000) {
  return new Promise((resolve, reject) => {
    const startedAt = Date.now();

    console.log(`🔎 Aguardando API em ${API_URL}...`);

    function check() {
      const request = http.get(API_URL, (response) => {
        response.resume();
        console.log(`✅ API respondeu com HTTP ${response.statusCode}.`);
        resolve();
      });

      request.setTimeout(2000, () => request.destroy());

      request.once('error', () => {
        if (Date.now() - startedAt >= timeout) {
          reject(
            new Error(`A API não respondeu em ${API_URL} após 30 segundos.`)
          );
          return;
        }

        setTimeout(check, 500);
      });
    }

    check();
  });
}

async function main() {
  console.log('');
  console.log('========================================');
  console.log('  TRATO FINO - AMBIENTE DE DESENVOLVIMENTO');
  console.log('========================================');
  console.log('Verificando Docker, PostgreSQL, API e CLI...');
  console.log('');

  await ensureDocker();
  await ensurePostgres();
  await setupDatabase();

  console.log('');
  console.log('🚀 Iniciando backend...');

  const backend = run(PNPM, ['--dir', 'apps/api', 'dev'], {
    stdio: ['ignore', 'inherit', 'inherit'],
  });

  let backendFinished = false;
  let cli;

  backend.once('close', (code) => {
    backendFinished = true;
    console.log(`⚠️ Backend encerrado (código ${code ?? 0}).`);

    if (cli && !cli.killed) {
      cli.kill();
    }
  });

  try {
    await waitForApi();
  } catch (error) {
    console.error('❌', error.message);
    backend.kill();
    process.exitCode = 1;
    return;
  }

  if (backendFinished) {
    throw new Error('O backend encerrou antes de ficar disponível.');
  }

  console.log('');
  console.log('========================================');
  console.log('✅ BACKEND PRONTO');
  console.log('========================================');
  console.log(`API: ${API_URL}`);
  console.log('');

  console.log('💻 Iniciando terminal CLI...');

  cli = run(PNPM, ['--dir', 'apps/cli', 'dev'], {
    env: {
      ...process.env,
      API_URL,
    },
  });

  cli.once('close', (code) => {
    console.log(`💻 CLI encerrado (código ${code ?? 0}).`);

    if (!backend.killed) {
      backend.kill();
    }

    process.exitCode = code ?? 0;
  });
}

main().catch((error) => {
  console.error('');
  console.error('❌ Erro ao iniciar o Trato Fino:');
  console.error(error.message);
  process.exitCode = 1;
});