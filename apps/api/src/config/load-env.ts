import dotenv from 'dotenv';
import path from 'node:path';

// Resolve from this file, not process.cwd(), so every entry point shares root configuration.
dotenv.config({ path: path.resolve(__dirname, '../../../../.env'), override: false });
