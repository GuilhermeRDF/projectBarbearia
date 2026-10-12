import path from 'node:path';
import { fileURLToPath } from 'node:url';

export const ROOT_DIR = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
if (typeof process.loadEnvFile === 'function') {
  try { process.loadEnvFile(path.join(ROOT_DIR, '.env')); }
  catch (error) {
    if (error?.code !== 'ENOENT') throw error;
  }
} else {
  throw new Error('Node.js 20.12+ é necessário para carregar o .env raiz de forma nativa.');
}
