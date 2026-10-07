import { spawn } from 'node:child_process';
import http from 'node:http';

const isWindows = process.platform === 'win32';
const PNPM = isWindows ? 'pnpm.cmd' : 'pnpm';

function run(command, args = [], options = {}) {
  if (isWindows) {
    const commandLine = [command, ...args]
      .map((arg) => {
        const value = String(arg);

        if (/[\s"&|<>^]/.test(value)) {
          return `"${value.replace(/"/g, '\\"')}"`;
        }

        return value;
      })
      .join(' ');

    return spawn(
      process.env.ComSpec || 'cmd.exe',
      ['/d', '/s', '/c', commandLine],
      {
        stdio: 'inherit',
        ...options,
      }
    );
  }

  return spawn(command, args, {
    stdio: 'inherit',
    ...options,
  });
}

function waitForProcess(child) {
  return new Promise((resolve) => {
    child.once('close', (code) => {
      resolve(code ?? 0);
    });

    child.once('error', (error) => {
      console.error('❌ Erro:', error.message);
      resolve(1);
    });
  });
}

/**
 * Espera a API realmente responder.
 * Não considera apenas a porta aberta.
 */
function waitForApi(timeout = 30000) {
  return new Promise((resolve, reject) => {
    const startedAt = Date.now();

    console.log('🔎 Verificando API em http://localhost:3000...');

    const check = () => {
      const request = http.get(
        'http://localhost:3000',
        (response) => {
          response.resume();

          console.log(
            `✅ API respondeu com HTTP ${response.statusCode}.`
          );

          resolve();
        }
      );

      request.on('error', () => {
        if (Date.now() - startedAt >= timeout) {
          reject(
            new Error(
              'A API não ficou disponível em http://localhost:3000 dentro de 30 segundos.'
            )
          );
          return;
        }

        setTimeout(check, 500);
      });

      request.setTimeout(1000, () => {
        request.destroy();
      });
    };

    check();
  });
}

async function main() {
  console.log('');
  console.log('========================================');
  console.log('  TRATO FINO - AMBIENTE DE DESENVOLVIMENTO');
  console.log('========================================');
  console.log('Preparando banco e iniciando API + CLI...');
  console.log('');

  // =====================================================
  // 0. POSTGRESQL LOCAL
  // =====================================================

  console.log('🐘 Verificando PostgreSQL local...');
  const database = run('pnpm', ['db:setup']);
  const databaseCode = await waitForProcess(database);
  if (databaseCode !== 0) {
    throw new Error(`Falha ao preparar o PostgreSQL. Código: ${databaseCode}`);
  }

  // =====================================================
  // 1. PRISMA
  // =====================================================

  console.log('🔧 Gerando Prisma Client...');
  console.log('');

  const generate = run(PNPM, [
    '--dir',
    'backend',
    'exec',
    'prisma',
    'generate',
  ]);

  const generateCode = await waitForProcess(generate);

  if (generateCode !== 0) {
    throw new Error(
      `Falha ao gerar o Prisma Client. Código: ${generateCode}`
    );
  }

  // =====================================================
  // 2. BACKEND
  // =====================================================

  console.log('');
  console.log('🚀 Iniciando backend...');
  console.log('⏳ Aguardando API ficar disponível...');
  console.log('');

  const backend = run(
  PNPM,
  [
    '--dir',
    'backend',
    'dev',
  ],
  {
    stdio: ['ignore', 'inherit', 'inherit'],
  }
);

  let backendFinished = false;

  backend.once('error', (error) => {
    console.error('');
    console.error(
      '❌ Erro ao iniciar backend:',
      error.message
    );
  });

  backend.once('close', (code) => {
    backendFinished = true;

    console.log('');
    console.log(
      `⚠️ Backend encerrado (código ${code ?? 0}).`
    );
  });

  // =====================================================
  // 3. ESPERAR API
  // =====================================================

  try {
    await waitForApi(30000);
  } catch (error) {
    console.error('');
    console.error('❌', error.message);

    if (!backend.killed) {
      backend.kill();
    }

    process.exit(1);
  }

  if (backendFinished) {
    console.error('');
    console.error(
      '❌ O backend foi encerrado antes da API ficar disponível.'
    );

    process.exit(1);
  }

  // =====================================================
  // 4. API OK
  // =====================================================

  console.log('');
  console.log('========================================');
  console.log('✅ BACKEND PRONTO');
  console.log('========================================');
  console.log('API: http://localhost:3000');
  console.log('');
  console.log('💻 Iniciando sistema terminal...');
  console.log('');

  // =====================================================
  // 5. CLI
  // =====================================================

  const cli = run(
    PNPM,
    [
      '--dir',
      'frontend',
      'dev',
    ],
    {
      env: {
        ...process.env,
        API_URL: 'http://localhost:3000',
      },
    }
  );

  cli.once('error', (error) => {
    console.error('');
    console.error(
      '❌ Erro ao iniciar CLI:',
      error.message
    );
  });

  // =====================================================
  // 6. CLI TERMINOU
  // =====================================================

  cli.once('close', (code) => {
    console.log('');
    console.log(
      `💻 CLI encerrado (código ${code ?? 0}).`
    );

    if (!backend.killed) {
      backend.kill();
    }

    process.exit(code ?? 0);
  });

  // =====================================================
  // 7. BACKEND TERMINOU
  // =====================================================

  backend.once('close', () => {
    if (!cli.killed) {
      console.log('');
      console.log(
        '⚠️ Backend foi encerrado. Encerrando CLI...'
      );

      cli.kill();
    }
  });
}

main().catch((error) => {
  console.error('');
  console.error('❌ Erro:', error);
  process.exit(1);
});