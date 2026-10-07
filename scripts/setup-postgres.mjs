import { spawn } from 'node:child_process';

const isWindows = process.platform === 'win32';

const dockerCommand = isWindows ? 'docker.exe' : 'docker';
const pnpmCommand = isWindows ? 'pnpm.cmd' : 'pnpm';

const env = { ...process.env };

function runCommand(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd: process.cwd(),
      stdio: options.stdio ?? 'inherit',
      env,
      shell: isWindows,
      windowsHide: false,
    });

    child.once('error', reject);

    child.once('close', (code) => {
      resolve(code ?? 1);
    });
  });
}

function execCommand(command, args, input = '') {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd: process.cwd(),
      stdio: ['pipe', 'pipe', 'pipe'],
      env,
      shell: isWindows,
      windowsHide: false,
    });

    let stdout = '';
    let stderr = '';

    child.stdout.on('data', (data) => {
      stdout += data.toString();
    });

    child.stderr.on('data', (data) => {
      stderr += data.toString();
    });

    child.once('error', reject);

    child.once('close', (code) => {
      resolve({
        code: code ?? 1,
        stdout,
        stderr,
      });
    });

    if (input) {
      child.stdin.write(input);
    }

    child.stdin.end();
  });
}

async function waitForPostgres() {
  for (let i = 0; i < 30; i++) {
    const result = await execCommand(
      dockerCommand,
      [
        'compose',
        'exec',
        '-T',
        'postgres',
        'pg_isready',
        '-U',
        process.env.POSTGRES_USER ?? 'trato_fino_app',
        '-d',
        process.env.POSTGRES_DB ?? 'trato_fino',
      ],
    );

    if (result.code === 0) {
      return;
    }

    await new Promise((resolve) => setTimeout(resolve, 1000));
  }

  throw new Error('PostgreSQL não ficou pronto em 30 segundos.');
}

async function databaseHasData() {
  const result = await execCommand(
    dockerCommand,
    [
      'compose',
      'exec',
      '-T',
      'postgres',
      'psql',
      '-U',
      process.env.POSTGRES_USER ?? 'trato_fino_app',
      '-d',
      process.env.POSTGRES_DB ?? 'trato_fino',
      '-tA',
    ],
    'SELECT COUNT(*) FROM "Usuario";\n',
  );

  if (result.code !== 0) {
    throw new Error(
      result.stderr || 'Não foi possível verificar os dados existentes.',
    );
  }

  const count = Number(result.stdout.trim());

  return Number.isFinite(count) && count > 0;
}

async function restoreDatabase() {
  console.log('📦 Restaurando os dados preservados...');

  const restore = await execCommand(
    dockerCommand,
    [
      'compose',
      'exec',
      '-T',
      'postgres',
      'psql',
      '-v',
      'ON_ERROR_STOP=1',
      '-U',
      process.env.POSTGRES_USER ?? 'trato_fino_app',
      '-d',
      process.env.POSTGRES_DB ?? 'trato_fino',
      '-f',
      '/restore/trato_fino.sql',
    ],
  );

  if (restore.code !== 0) {
    throw new Error(
      restore.stderr || 'Falha ao restaurar os dados.',
    );
  }

  console.log('✅ Dados preservados restaurados.');
}

async function main() {
  console.log('🐘 Iniciando PostgreSQL local com volume persistente...');

  const dockerCode = await runCommand(
    dockerCommand,
    ['compose', 'up', '-d'],
  );

  if (dockerCode !== 0) {
    throw new Error(
      'Não foi possível iniciar o PostgreSQL via Docker Compose.',
    );
  }

  await waitForPostgres();

  console.log('🔧 Gerando Prisma Client...');

  const generateCode = await runCommand(
    pnpmCommand,
    [
      '--filter',
      'backend',
      'exec',
      'prisma',
      'generate',
    ],
  );

  if (generateCode !== 0) {
    throw new Error('Prisma generate falhou.');
  }

  console.log('🔧 Aplicando schema Prisma...');

  const schemaCode = await runCommand(
    pnpmCommand,
    [
      '--filter',
      'backend',
      'exec',
      'prisma',
      'db',
      'push',
    ],
  );

  if (schemaCode !== 0) {
    throw new Error('Prisma db push falhou.');
  }

  const hasData = await databaseHasData();

  if (hasData) {
    console.log(
      'ℹ️ Banco já possui dados. Restore ignorado para preservar os dados existentes.',
    );
  } else {
    await restoreDatabase();
  }

  console.log('🌱 Executando seed idempotente...');

  const seedCode = await runCommand(
    pnpmCommand,
    [
      '--filter',
      'backend',
      'db:seed',
    ],
  );

  if (seedCode !== 0) {
    throw new Error('Seed falhou.');
  }

  console.log('');
  console.log('✅ PostgreSQL do Trato Fino está pronto.');
  console.log('Persistência: volume Docker "trato_fino_pgdata".');
}

main().catch((error) => {
  console.error(`❌ ${error.message}`);
  process.exit(1);
});