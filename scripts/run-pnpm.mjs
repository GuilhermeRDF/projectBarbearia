import { spawn } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const isWindows = process.platform === 'win32';
const command = isWindows ? 'pnpm.cmd' : 'pnpm';
const child = spawn(command, process.argv.slice(2), { cwd: root, env: process.env, stdio: 'inherit', shell: isWindows });
child.once('error', (error) => { console.error(`Não foi possível iniciar pnpm: ${error.message}`); process.exitCode = 1; });
child.once('close', (code) => { process.exitCode = code ?? 1; });
