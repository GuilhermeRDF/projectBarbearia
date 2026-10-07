import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';

const rootDir = process.cwd();
const backendEnvPath = path.join(rootDir, 'backend', '.env');

// ============================================================
// Carrega backend/.env sem depender do pacote dotenv
// ============================================================

if (!fs.existsSync(backendEnvPath)) {
  console.error('❌ Arquivo backend/.env não encontrado.');
  console.error(`   Esperado em: ${backendEnvPath}`);
  process.exit(1);
}

const envContent = fs.readFileSync(backendEnvPath, 'utf8');

for (const line of envContent.split(/\r?\n/)) {
  const trimmed = line.trim();

  if (!trimmed || trimmed.startsWith('#')) {
    continue;
  }

  const separator = trimmed.indexOf('=');

  if (separator === -1) {
    continue;
  }

  const key = trimmed.slice(0, separator).trim();
  let value = trimmed.slice(separator + 1).trim();

  if (
    (value.startsWith('"') && value.endsWith('"')) ||
    (value.startsWith("'") && value.endsWith("'"))
  ) {
    value = value.slice(1, -1);
  }

  if (!process.env[key]) {
    process.env[key] = value;
  }
}

const databaseUrl = process.env.DATABASE_URL;

if (!databaseUrl) {
  console.error('❌ DATABASE_URL não encontrada em backend/.env.');
  process.exit(1);
}

// ============================================================
// Diretório de backups
// ============================================================

const backupDir = path.join(rootDir, 'backups');

fs.mkdirSync(backupDir, { recursive: true });

// ============================================================
// Nome do arquivo
// ============================================================

const now = new Date();

const timestamp = now
  .toISOString()
  .replace('T', '_')
  .replace(/:/g, '-')
  .replace(/\..+/, '');

const backupFile = path.join(
  backupDir,
  `trato_fino_${timestamp}.dump`
);

// ============================================================
// Início
// ============================================================

console.log('');
console.log('==============================================');
console.log('   TRATO FINO — BACKUP DO BANCO');
console.log('==============================================');
console.log('');

console.log('🔎 PostgreSQL encontrado no Docker.');
console.log('📦 Criando backup...');
console.log(`📁 Arquivo: ${backupFile}`);
console.log('');

// ============================================================
// Executa pg_dump dentro do container PostgreSQL
// ============================================================

const dockerCommand =
  process.platform === 'win32'
    ? 'docker.exe'
    : 'docker';

const dockerArgs = [
  'exec',
  'trato-fino-postgres',
  'pg_dump',
  '-Fc',
  '-U',
  'trato_fino_app',
  '-d',
  'trato_fino',
];

const output = fs.createWriteStream(backupFile);

const child = spawn(dockerCommand, dockerArgs, {
  stdio: ['ignore', 'pipe', 'inherit'],
});

child.stdout.pipe(output);

child.on('error', (error) => {
  output.close();

  console.error('');
  console.error('❌ Erro ao executar o Docker.');
  console.error(error.message);
  console.error('');
  console.error('Verifique se o Docker Desktop está aberto.');

  process.exit(1);
});

child.on('close', (code) => {
  output.close();

  if (code !== 0) {
    console.error('');
    console.error(`❌ O backup falhou. Código: ${code}`);

    try {
      fs.unlinkSync(backupFile);
    } catch {}

    process.exit(code ?? 1);
  }

  if (!fs.existsSync(backupFile)) {
    console.error('');
    console.error('❌ O arquivo de backup não foi criado.');
    process.exit(1);
  }

  const stats = fs.statSync(backupFile);

  if (stats.size === 0) {
    console.error('');
    console.error('❌ O arquivo de backup está vazio.');

    try {
      fs.unlinkSync(backupFile);
    } catch {}

    process.exit(1);
  }

  const sizeMB = stats.size / 1024 / 1024;

  console.log('');
  console.log('==============================================');
  console.log('   ✅ BACKUP CONCLUÍDO COM SUCESSO');
  console.log('==============================================');
  console.log('');
  console.log(`📦 Arquivo: ${backupFile}`);
  console.log(`📊 Tamanho: ${sizeMB.toFixed(2)} MB`);
  console.log('');
  console.log('💾 O backup contém os dados atuais');
  console.log('   do PostgreSQL do Trato Fino.');
  console.log('');
});