# Backend — Trato Fino

API REST em Express + Prisma + SQLite.

## Primeiro uso

```bash
pnpm install
pnpm db:generate
pnpm db:push
pnpm db:seed
pnpm dev
```

A API inicia em `http://localhost:3000`.

Usuário de demonstração:
- dono: `admin@tratofino.com` / `123456`
- cliente: `cliente@tratofino.com` / `123456`

> A versão atual usa o `schema.prisma` como fonte de verdade. A migration antiga do projeto usava um modelo diferente (IDs inteiros e tabelas `clientes/agendamentos`) e foi removida para evitar conflito com o modelo atual baseado em UUID.
