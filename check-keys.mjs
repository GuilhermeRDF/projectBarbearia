import crypto from "node:crypto";
import fs from "node:fs";

const sql = fs.readFileSync("./database/trato_fino.sql", "utf8");

const match = sql.match(
  /'v1:([^']+)'/
);

if (!match) {
  throw new Error("Nenhum ciphertext v1 encontrado no SQL.");
}

const value = match[1];

const keys = [
  {
    nome: "base64url",
    key: Buffer.from(
      "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",
      "base64url"
    )
  },
  {
    nome: "hex",
    key: Buffer.from(
      "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",
      "hex"
    )
  },
  {
    nome: "utf8",
    key: Buffer.from(
      "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",
      "utf8"
    )
  }
];

const raw = Buffer.from(value, "base64url");
const iv = raw.subarray(0, 12);
const tag = raw.subarray(12, 28);
const ciphertext = raw.subarray(28);

for (const item of keys) {
  try {
    if (item.key.length !== 32) {
      console.log(`${item.nome}: ignorada (${item.key.length} bytes)`);
      continue;
    }

    const decipher = crypto.createDecipheriv(
      "aes-256-gcm",
      item.key,
      iv
    );

    decipher.setAuthTag(tag);

    const plaintext = Buffer.concat([
      decipher.update(ciphertext),
      decipher.final()
    ]).toString("utf8");

    console.log(`${item.nome}: SUCESSO -> ${plaintext}`);
  } catch {
    console.log(`${item.nome}: falhou`);
  }
}