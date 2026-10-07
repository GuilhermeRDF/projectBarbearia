import crypto from 'node:crypto';

const VERSION = 1;
const KEY_VERSION = Number(process.env.PII_KEY_VERSION ?? VERSION);

function getKey(envName: string): Buffer {
  const value = process.env[envName];
  if (!value) throw new Error(`Variável ${envName} não configurada.`);
  const key = Buffer.from(value, 'base64url');
  if (key.length !== 32) throw new Error(`${envName} deve conter uma chave base64url de 32 bytes.`);
  return key;
}

export function encrypt(value: string): string {
  const key = getKey('PII_ENCRYPTION_KEY');
  const iv = crypto.randomBytes(12);
  const cipher = crypto.createCipheriv('aes-256-gcm', key, iv);
  const ciphertext = Buffer.concat([cipher.update(value, 'utf8'), cipher.final()]);
  const tag = cipher.getAuthTag();
  return `v${KEY_VERSION}:${Buffer.concat([iv, tag, ciphertext]).toString('base64url')}`;
}

export function decrypt(value: string): string {
  const match = /^v(\d+):(.+)$/.exec(value);
  if (!match) throw new Error('Valor criptografado inválido.');
  const key = getKey('PII_ENCRYPTION_KEY');
  const raw = Buffer.from(match[2], 'base64url');
  const iv = raw.subarray(0, 12);
  const tag = raw.subarray(12, 28);
  const ciphertext = raw.subarray(28);
  const decipher = crypto.createDecipheriv('aes-256-gcm', key, iv);
  decipher.setAuthTag(tag);
  return Buffer.concat([decipher.update(ciphertext), decipher.final()]).toString('utf8');
}

export function blindIndex(value: string): string {
  const key = getKey('PII_BLIND_INDEX_KEY');
  return crypto.createHmac('sha256', key).update(value.trim().toLowerCase(), 'utf8').digest('hex');
}

export function hashToken(value: string): string {
  return crypto.createHash('sha256').update(value, 'utf8').digest('hex');
}

export const encryptionKeyVersion = KEY_VERSION;
