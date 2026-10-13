import { spawn } from 'node:child_process';
import { ROOT_DIR } from './load-env.mjs';

const isWindows = process.platform === 'win32';
const dockerCommand = isWindows ? 'docker.exe' : 'docker';
const pnpmCommand = isWindows ? 'pnpm.cmd' : 'pnpm';
const env = { ...process.env };

function run(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd: ROOT_DIR,
      stdio: 'inherit',
      env,
      shell: isWindows && command.endsWith('.cmd'),
      windowsHide: true,
      ...options,
    });

    child.once('error', reject);
    child.once('close', (code) => resolve(code ?? 1));
  });
}

async function main() {
  console.log('Iniciando PostgreSQL via Docker Compose...');

  const dockerCode = await run(dockerCommand, ['compose', 'up', '-d']);
  if (dockerCode !== 0) {
    throw new Error('Falha ao iniciar o PostgreSQL.');
  }

  console.log('Gerando Prisma Client sem alterar o banco...');

  const generateCode = await run(pnpmCommand, [
    '--dir',
    'apps/api',
    'exec',
    'prisma',
    'generate',
  ]);

  if (generateCode !== 0) {
    throw new Error('Prisma generate falhou.');
  }

  console.log('Setup concluído. Nenhuma migração, restauração ou seed foi executado.');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

