# CLI — Trato Fino

Aplicação de terminal (não é uma aplicação web). Entrada: `src/main.ts`. A CLI se comunica com a API HTTP e não deve acessar PostgreSQL/Prisma diretamente.

## Funcionalidades documentadas

- Perfil CLIENTE: agendar atendimentos, consultar agendamentos, serviços e barbeiros, consultar cadastro, alterar senha e solicitar redefinição.
- Perfil ADMIN: administrar clientes, barbeiros, serviços, agenda e comandas; consultar PII com auditoria; tratar redefinições e gerar senhas temporárias.
- Cadastro público cria CLIENTE; não há cadastro público de administrador.

## Configuração e execução

A URL da API é definida por `API_URL` no `.env` da raiz (padrão `http://localhost:3000`). A raiz carrega o ambiente e passa as variáveis para os processos.

```bash
pnpm cli:dev
pnpm cli:build
```

Para uso independente, inicie a API primeiro e confirme que ela responde na URL configurada. Senhas não devem ser impressas durante a digitação; senhas temporárias são exibidas apenas nos fluxos que as geram.
