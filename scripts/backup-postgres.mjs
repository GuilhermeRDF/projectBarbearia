import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { ROOT_DIR as rootDir } from './load-env.mjs';
const required = ['POSTGRES_USER', 'POSTGRES_DB'];
for (const key of required) {
  if (!process.env[key]) {
    console.error(`❌ ${key} não está definida no .env da raiz.`);
    process.exit(1);
  }
}
const backupDir = path.join(rootDir, 'backups');
fs.mkdirSync(backupDir, { recursive: true });
const timestamp = new Date().toISOString().replace('T', '_').replace(/:/g, '-').replace(/\.\d+Z$/, '');
const backupFile = path.join(backupDir, `trato_fino_${timestamp}.dump`);
const docker = process.platform === 'win32' ? 'docker.exe' : 'docker';
const args = ['exec', 'trato-fino-postgres', 'pg_dump', '-Fc', '-U', process.env.POSTGRES_USER, '-d', process.env.POSTGRES_DB];
console.log('📦 Criando backup PostgreSQL...');
const output = fs.createWriteStream(backupFile, { flags: 'wx' });
const child = spawn(docker, args, { cwd: rootDir, stdio: ['ignore', 'pipe', 'inherit'] });
child.stdout.pipe(output);
child.once('error', (error) => { output.destroy(); console.error(`❌ Não foi possível executar Docker: ${error.message}`); process.exitCode = 1; });
child.once('close', (code) => {
  output.end(() => {
    if (code !== 0) {
      console.error(`❌ Backup falhou (código ${code ?? 1}). O arquivo parcial, se houver, foi mantido para inspeção: ${path.basename(backupFile)}`);
      process.exitCode = code ?? 1;
      return;
    }
    const size = fs.statSync(backupFile).size;
    if (size === 0) { console.error('❌ O backup retornou vazio; arquivo preservado para inspeção.'); process.exitCode = 1; return; }
    console.log(`✅ Backup criado: backups/${path.basename(backupFile)} (${(size / 1024 / 1024).toFixed(2)} MB)`);
  });
});
