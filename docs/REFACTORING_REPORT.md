# Relatório técnico — refatoração Trato Fino

## Alterações implementadas

- API movida de `backend/` para `apps/api/`.
- CLI terminal movida de `frontend/` para `apps/cli/`, preservando a entrada e os fluxos existentes.
- Workspace pnpm e comandos de conveniência da raiz atualizados para os novos caminhos.
- `.env` runtime centralizado na raiz; os arquivos `.env` aninhados foram removidos após consolidação. `.env.example` é um modelo sanitizado.
- Scripts de desenvolvimento, setup, backup e restauração passaram a resolver a raiz do repositório independentemente do diretório de execução e a usar a configuração centralizada.
- API e seed carregam o `.env` da raiz; o carregamento ocorre antes dos módulos de criptografia.
- READMEs da raiz, API e CLI atualizados.
- `check-keys.mjs` deixou de imprimir plaintext de PII durante a validação; o resultado informa somente sucesso/falha.

## Ambiente

A configuração consolidada contém os nomes `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `DATABASE_URL`, `JWT_SECRET`, `PII_ENCRYPTION_KEY`, `PII_BLIND_INDEX_KEY`, `PII_KEY_VERSION`, `PORT` e `API_URL`. Foi preservado também `PII_ENCRYPTION_KEY_ROOT_CONFLICT`, variável inativa que retém o valor que existia na raiz antes da consolidação, pois havia conflito com a chave usada pela API. Nenhum valor é documentado neste relatório.

A `DATABASE_URL` foi validada estruturalmente: usuário, senha e nome do banco correspondem às variáveis PostgreSQL. A compatibilidade de `PII_ENCRYPTION_KEY` com o ciphertext de referência do SQL **não foi validada**: a checagem falhou tanto para a chave ativa quanto para o valor conflitante preservado. Requer intervenção manual antes de confiar em operações sobre dados criptografados.

## Dependências

Nenhuma dependência foi adicionada ou removida. Os manifests e lockfiles foram preservados; o lockfile pnpm da raiz teve apenas os caminhos dos importers atualizados para `apps/api` e `apps/cli`.

## Preservação

Os arquivos `database/trato_fino.sql`, o dump em `backups/`, o schema Prisma, o arquivo de lock de migrações, a migração SQL e a fonte da CLI foram comparados byte a byte com os arquivos do ZIP original e permaneceram idênticos. O provider Prisma continua `postgresql`. Nenhuma operação de banco, migração, `db push`, seed, backup ou restauração foi executada durante esta refatoração.

## Validações executadas

- `node --check` em todos os scripts `.mjs` e `check-keys.mjs`: sintaxe aprovada.
- Parse de JSON em `package.json`, manifests de API/CLI, `tsconfig.json` e `package-lock.json`: aprovado.
- Parse YAML em `pnpm-workspace.yaml`, `pnpm-lock.yaml` e `docker-compose.yml`: aprovado.
- Asserções de estrutura, provider PostgreSQL, contagem de `.env` e presença dos pontos de entrada: aprovadas.
- Busca por referências antigas `backend/` e `frontend/` nos arquivos ativos de projeto/documentação: nenhuma encontrada.
- Carregamento nativo do `.env` raiz e presença das variáveis requeridas: aprovado; valores não foram impressos.
- `node check-keys.mjs`: executado e falhou na validação criptográfica, conforme descrito acima.

## Validações não executadas

Builds TypeScript completos, testes da aplicação, geração Prisma, startup da API/CLI e testes de conectividade não foram concluídos: `pnpm` não está instalado/disponível neste ambiente e Corepack não conseguiu obter o pacote por falta de acesso ao registry. Também foram tentados `tsc --noEmit -p apps/api/tsconfig.json` e `tsc --noEmit -p apps/cli/tsconfig.json`; ambos falharam porque as dependências e tipos do projeto não estão instalados (por exemplo, `dotenv`, `express`, `@prisma/client` e `@types/node`). Docker também não está disponível, portanto não foi possível validar Compose contra o engine nem conectar ao PostgreSQL. Não há testes automatizados configurados no script de teste atual da API.

## Observação de integridade preexistente

A migração SQL preservada define tabelas legadas com IDs inteiros, enquanto o schema Prisma atual usa modelos e IDs UUID. O histórico foi preservado intocado conforme solicitado; a compatibilidade entre essa migração antiga e o schema atual precisa ser revisada manualmente antes de aplicar migrações ou `db push` em qualquer banco importante.

## Ações manuais pendentes

1. Confirmar com segurança a chave correta para os dados criptografados; não descartar `PII_ENCRYPTION_KEY_ROOT_CONFLICT` até resolver a discrepância.
2. Revisar a divergência entre a migração legada e o schema Prisma atual.
3. Em ambiente de desenvolvimento isolado, instalar dependências com pnpm, gerar Prisma Client e executar builds/testes da API e CLI.
4. Somente com autorização e backup verificado, testar o startup integrado e conectividade com PostgreSQL; não executar `pnpm restore` como validação.
