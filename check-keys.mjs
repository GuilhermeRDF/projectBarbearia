import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { ROOT_DIR } from './scripts/load-env.mjs';

const sqlPath = path.join(ROOT_DIR, 'database', 'trato_fino.sql');
const sql = fs.readFileSync(sqlPath, 'utf8');
const match = sql.match(/'v1:([^']+)'/);
if (!match) throw new Error('Nenhum ciphertext v1 encontrado no SQL.');

const encodedKey = process.env.PII_ENCRYPTION_KEY;
if (!encodedKey) throw new Error('PII_ENCRYPTION_KEY não está configurada no .env da raiz.');
const key = Buffer.from(encodedKey, 'base64url');
if (key.length !== 32) throw new Error('PII_ENCRYPTION_KEY não decodifica para uma chave de 32 bytes.');

const raw = Buffer.from(match[1], 'base64url');
if (raw.length < 29) throw new Error('Ciphertext v1 inválido ou incompleto.');
const iv = raw.subarray(0, 12);
const tag = raw.subarray(12, 28);
const ciphertext = raw.subarray(28);
try {
  const decipher = crypto.createDecipheriv('aes-256-gcm', key, iv);
  decipher.setAuthTag(tag);
  // Decrypt for validation only. Never print or persist the plaintext.
  decipher.update(ciphertext);
  decipher.final();
  console.log('PII_ENCRYPTION_KEY: valida para o ciphertext de referência.');
} catch {
  console.error('PII_ENCRYPTION_KEY: não descriptografa o ciphertext de referência.');
  process.exitCode = 1;
}
