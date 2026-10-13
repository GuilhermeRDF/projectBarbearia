import { spawn } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const args = process.argv.slice(2);
const apiCommand = args[0] === '--dir' && args[1] === 'apps/api';

const env = { ...process.env };

if (apiCommand) {
  const result = spawn(
    process.execPath,
    [
      '--env-file=apps/api/.env',
      '-e',
      'process.stdout.write(JSON.stringify(process.env))',
    ],
    { cwd: root, env, encoding: 'utf8', shell: false }
  );

  // O carregamento efetivo será feito no processo filho abaixo.
  result.kill();
}
const isWindows = process.platform === 'win32';
const command = isWindows ? 'pnpm.cmd' : 'pnpm';

const child = spawn(command, args, {
  cwd: root,
  env,
  stdio: 'inherit',
  shell: isWindows,
});

child.once('error', (error) => {
  console.error(`Falha ao iniciar pnpm: ${error.message}`);
  process.exitCode = 1;
});

child.once('close', (code) => {
  process.exitCode = code ?? 1;
});
