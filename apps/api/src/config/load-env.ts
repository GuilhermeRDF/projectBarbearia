import dotenv from 'dotenv';
import path from 'node:path';

const apiEnvPath = path.resolve(
  __dirname,
  '../../../../apps/api/.env',
);

const result = dotenv.config({
  path: apiEnvPath,
  override: true,
});

if (result.error) {
  throw result.error;
}
