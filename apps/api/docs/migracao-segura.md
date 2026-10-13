# Migração segura do banco — Trato Fino

## O que esta migração faz

- Renomeia as tabelas e colunas do schema moderno para `snake_case`, prefixando todas as colunas com a entidade.
- Preserva os IDs e os valores existentes; não recria tabelas modernas que já existem.
- Converte preços, pagamentos, comissões e totais de `FLOAT` para `NUMERIC/Decimal`.
- Converte os estados fechados de usuário, agendamento, comanda e pagamento para enums.
- Remove `Agendamento.dataHora` somente quando todos os valores forem idênticos a `inicioAgendado`; divergência aborta a transação.
- Adiciona constraints de integridade e uma constraint PostgreSQL de exclusão para impedir sobreposição de horários do mesmo barbeiro (exceto agendamentos cancelados).
- Se encontrar apenas as quatro tabelas da migration histórica antiga (`clientes`, `barbeiros`, `servicos`, `agendamentos`), renomeia-as para `legacy_20260916_*` e cria o schema moderno. As tabelas antigas ficam preservadas para consulta/exportação, mas **não são importadas automaticamente**: o modelo legado usa IDs inteiros e dados pessoais em texto, enquanto o modelo atual usa UUIDs, usuários, credenciais e PII cifrada. Importar esses registros exige uma migração de negócio separada e chaves de criptografia válidas.

## Antes de executar

1. Pare a API e qualquer worker que grave no banco.
2. Faça backup em arquivo fora do diretório do projeto:
   ```bash
   pg_dump --format=custom --no-owner --file=trato-fino-antes-migracao.dump "$DATABASE_URL"
   ```
3. Confira que o arquivo existe e faça um teste de restauração em um banco separado. Não confie somente no código de saída do backup.
4. Preserve exatamente `PII_ENCRYPTION_KEY`, `PII_BLIND_INDEX_KEY` e `PII_KEY_VERSION`; não troque chaves durante a migração.
5. Execute `pnpm db:migrate:status` e confirme qual histórico de migrations está aplicado.
6. Em uma cópia restaurada, execute a migração e compare contagens, IDs, relacionamentos, estados, totais financeiros e horários antes de migrar o ambiente principal.

## Execução

Depois de validar em uma cópia restaurada:

```bash
pnpm db:migrate:deploy
pnpm db:generate
pnpm api:build
pnpm api:test
```

A migração é transacional. Se uma validação, conversão de estado, check constraint ou conflito de agenda falhar, o PostgreSQL reverte a transação. A mensagem deve ser corrigida antes de tentar novamente; não remova a validação para forçar a execução.

## Rollback

- Se a migração falhar antes do `COMMIT`, corrija a causa e tente novamente após conferir o estado.
- Depois de um `COMMIT`, não tente reverter renomeando colunas manualmente. Restaure o dump em uma instância separada e valide a recuperação; para voltar ao banco antigo, faça um cutover controlado para o backup restaurado.
- O dump anterior é a recuperação confiável para a conversão `FLOAT` → `NUMERIC` e para a remoção da coluna redundante `dataHora`.
- As tabelas `legacy_20260916_*` são arquivo, não backup. Não as exclua até que os dados tenham sido validados e a política de retenção aprovada.

## Atenções de compatibilidade

- A migration antiga `20260916160836_init` cria um modelo simplificado com tabelas `clientes`, `barbeiros`, `servicos` e `agendamentos`; ela não corresponde ao schema moderno. A migração nova preserva essas tabelas como arquivo em instalações que ainda tenham somente o modelo legado.
- A constraint de exclusão requer a extensão PostgreSQL `btree_gist`. O usuário da migração precisa de permissão para criar a extensão, ou um administrador do banco deverá habilitá-la antes.
- A migração aborta se encontrar status fora dos enums definidos, divergência entre `dataHora` e `inicioAgendado`, intervalos inválidos, notas fora de 1–5, valores financeiros negativos ou agendamentos sobrepostos. Corrija os registros e repita.
- A migração protege a integridade do banco, mas a autorização multiempresa ainda precisa ser aplicada nas consultas/serviços. Não confie apenas no `barbeariaId` enviado pelo cliente.
- A migration adiciona constraints customizadas que não são expressas nativamente pelo schema Prisma (especialmente a exclusão de intervalos). Não use `prisma db push` para administrar produção, pois ele não é substituto de migrações versionadas e pode gerar drift.
