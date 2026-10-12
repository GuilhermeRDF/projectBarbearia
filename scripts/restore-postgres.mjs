import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { ROOT_DIR as rootDir } from './load-env.mjs';

const backupsDir = path.join(rootDir, 'backups');

const CONTAINER_NAME = 'trato-fino-postgres';
const DB_USER = process.env.POSTGRES_USER;
const DB_NAME = process.env.POSTGRES_DB;
if (!DB_USER || !DB_NAME) throw new Error('POSTGRES_USER e POSTGRES_DB devem estar definidos no .env da raiz.');

function run(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd: rootDir,
      stdio: options.stdio ?? 'inherit',
      shell: false,
    });

    let stdout = '';
    let stderr = '';

    if (child.stdout) {
      child.stdout.on('data', (data) => {
        stdout += data.toString();
      });
    }

    if (child.stderr) {
      child.stderr.on('data', (data) => {
        stderr += data.toString();
      });
    }

    child.on('error', reject);

    child.on('close', (code) => {
      if (code === 0) {
        resolve({ stdout, stderr });
      } else {
        reject(
          new Error(
            `Comando falhou com código ${code}: ${command} ${args.join(' ')}\n${stderr}`
          )
        );
      }
    });
  });
}

function getDockerCommand() {
  return process.platform === 'win32' ? 'docker.exe' : 'docker';
}

function findLatestBackup() {
  if (!fs.existsSync(backupsDir)) {
    throw new Error(
      `A pasta de backups não existe:\n${backupsDir}`
    );
  }

  const backups = fs
    .readdirSync(backupsDir)
    .filter((file) => file.toLowerCase().endsWith('.dump'))
    .map((file) => {
      const fullPath = path.join(backupsDir, file);
      const stat = fs.statSync(fullPath);

      return {
        file,
        fullPath,
        modifiedAt: stat.mtimeMs,
        size: stat.size,
      };
    })
    .filter((backup) => backup.size > 0)
    .sort((a, b) => b.modifiedAt - a.modifiedAt);

  if (backups.length === 0) {
    throw new Error(
      `Nenhum arquivo .dump válido foi encontrado em:\n${backupsDir}`
    );
  }

  return backups[0];
}

async function ensurePostgres() {
  const docker = getDockerCommand();

  console.log('🐳 Verificando PostgreSQL...');

  try {
    await run(docker, ['inspect', CONTAINER_NAME], {
      stdio: 'ignore',
    });

    console.log('✅ Container PostgreSQL encontrado.');
  } catch {
    console.log('🚀 Container PostgreSQL não está disponível.');
    console.log('   Iniciando Docker Compose...');

    await run(docker, ['compose', 'up', '-d']);

    console.log('✅ Docker Compose iniciado.');
  }

  console.log('⏳ Aguardando PostgreSQL ficar pronto...');

  for (let attempt = 1; attempt <= 30; attempt++) {
    try {
      await run(
        docker,
        [
          'exec',
          CONTAINER_NAME,
          'pg_isready',
          '-U',
          DB_USER,
          '-d',
          DB_NAME,
        ],
        {
          stdio: 'ignore',
        }
      );

      console.log('✅ PostgreSQL está pronto.');
      return;
    } catch {
      if (attempt === 30) {
        throw new Error(
          'PostgreSQL não ficou disponível após 30 tentativas.'
        );
      }

      await new Promise((resolve) => setTimeout(resolve, 1000));
    }
  }
}

async function restoreBackup(backup) {
  const docker = getDockerCommand();

  const containerBackupPath = `/tmp/${backup.file}`;

  console.log('');
  console.log('📦 Copiando backup para o container...');

  await run(docker, [
    'cp',
    backup.fullPath,
    `${CONTAINER_NAME}:${containerBackupPath}`,
  ]);

  console.log('✅ Backup copiado.');

  console.log('');
  console.log('♻️ Restaurando banco de dados...');
  console.log('   Banco:', DB_NAME);
  console.log('   Backup:', backup.file);

  await run(docker, [
    'exec',
    CONTAINER_NAME,
    'pg_restore',
    '--exit-on-error',
    '--clean',
    '--if-exists',
    '--no-owner',
    '--no-privileges',
    '-U',
    DB_USER,
    '-d',
    DB_NAME,
    containerBackupPath,
  ]);

  console.log('✅ Banco restaurado.');

  console.log('');
  console.log('🧹 Removendo arquivo temporário do container...');

  await run(docker, [
    'exec',
    CONTAINER_NAME,
    'rm',
    '-f',
    containerBackupPath,
  ]);

  console.log('✅ Limpeza concluída.');
}

async function main() {
  console.log('');
  console.log('==============================================');
  console.log('   TRATO FINO — RESTAURAÇÃO DO BANCO');
  console.log('==============================================');
  console.log('');

  const backup = findLatestBackup();

  console.log('📁 Backup encontrado:');
  console.log(`   ${backup.file}`);
  console.log(
    `   Tamanho: ${(backup.size / 1024 / 1024).toFixed(2)} MB`
  );

  console.log('');
  console.log('⚠️ ATENÇÃO:');
  console.log('   A restauração substituirá os dados atuais');
  console.log('   do PostgreSQL pelo conteúdo deste backup.');
  console.log('');

  await ensurePostgres();

  await restoreBackup(backup);

  console.log('');
  console.log('==============================================');
  console.log('   ✅ RESTAURAÇÃO CONCLUÍDA COM SUCESSO');
  console.log('==============================================');
  console.log('');
  console.log('💾 Os dados do backup foram restaurados.');
  console.log('🚀 Agora você pode executar: pnpm dev');
  console.log('');
}

main().catch((error) => {
  console.error('');
  console.error('==============================================');
  console.error('   ❌ ERRO NA RESTAURAÇÃO');
  console.error('==============================================');
  console.error('');
  console.error(error.message);
  console.error('');
  process.exit(1);
});