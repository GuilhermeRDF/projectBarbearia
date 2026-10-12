# API — Trato Fino

API REST em Express, com persistência PostgreSQL via Prisma. A entrada de desenvolvimento é `src/server.ts`; o build TypeScript gera `dist/`.

## Organização

- `src/controllers/`: handlers HTTP de autenticação e agendamentos.
- `src/services/`: regras de serviço de agendamento.
- `src/middlewares/`: autenticação e autorização HTTP.
- `src/lib/`: cliente Prisma, criptografia e auditoria.
- `prisma/schema.prisma`: schema PostgreSQL.
- `prisma/migrations/`: histórico existente, preservado.
- `prisma/seed.ts`: seed existente.

## Ambiente

A API carrega o `.env` da raiz do repositório, independentemente do diretório de execução. Usa `DATABASE_URL`, `JWT_SECRET`, `PII_ENCRYPTION_KEY`, `PII_BLIND_INDEX_KEY`, `PII_KEY_VERSION` e `PORT`. Não coloque valores reais na documentação. Preserve as chaves criptográficas existentes se o banco contém dados cifrados.

## Comandos (na raiz)

```bash
pnpm api:dev
pnpm api:build
pnpm api:test
pnpm db:generate
pnpm db:push
pnpm db:seed
```

`db:push` pode alterar a estrutura do banco. Não é executado como parte de uma validação segura. O script de teste atual não contém testes automatizados configurados.
