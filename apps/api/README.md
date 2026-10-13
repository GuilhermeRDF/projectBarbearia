# API — Trato Fino

API REST em Express + TypeScript, com PostgreSQL e Prisma.

## Organização

- `src/controllers/`: handlers HTTP.
- `src/services/`: regras de negócio.
- `src/domain/`: regras puras testáveis, como validação de intervalos.
- `src/middlewares/`: autenticação/autorização HTTP.
- `src/lib/`: Prisma, criptografia e auditoria.
- `prisma/schema.prisma`: schema Prisma com nomes lógicos em TypeScript e nomes físicos em `snake_case` no PostgreSQL.
- `prisma/migrations/`: histórico de migrações versionadas.
- `prisma/seed.ts`: dados iniciais idempotentes.
- `tests/`: testes automatizados de regras de negócio.

## Convenção de nomes

Todas as tabelas usam `snake_case`; todas as colunas físicas recebem prefixo da entidade. Exemplo: `agendamento.agendamento_id`, `agendamento.agendamento_usuario_id` e `agendamento.agendamento_inicio_agendado`. Os nomes de modelos/propriedades Prisma continuam idiomáticos no TypeScript por meio de `@@map` e `@map`.

## Ambiente

A API carrega `.env` da raiz do repositório. Configure `DATABASE_URL`, `JWT_SECRET`, `PII_ENCRYPTION_KEY`, `PII_BLIND_INDEX_KEY`, `PII_KEY_VERSION` e `PORT`. Não coloque credenciais reais em arquivos versionados. Preserve as chaves de criptografia se o banco já contém dados cifrados.

## Comandos

```bash
pnpm dev
pnpm build
pnpm test
pnpm db:generate
pnpm db:migrate:status
pnpm db:migrate:dev
pnpm db:migrate:deploy
pnpm db:seed
```

`db:push` continua disponível para experimentos locais, mas não deve ser usado como processo de deploy de produção. A migração e seu plano de backup/rollback estão em `docs/migracao-segura.md`.

## Migração do banco

Leia `docs/migracao-segura.md` antes de executar a migração. Faça backup, teste restauração e valide em uma cópia do banco antes do ambiente principal. A migration aborta em inconsistências conhecidas em vez de descartar dados.
