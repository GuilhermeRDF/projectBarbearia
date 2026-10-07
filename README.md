# Trato Fino — Sistema de Barbearia

Aplicação local de gerenciamento de barbearia, composta por:

* Backend em **Node.js + Express**
* ORM **Prisma**
* Banco de dados **PostgreSQL 16**
* PostgreSQL executado em **Docker**
* Frontend em **terminal/CLI**
* Autenticação com **bcrypt**
* Proteção de dados pessoais com **AES-256-GCM**
* Blind index com **HMAC-SHA-256**
* Controle de acesso com **ADMIN** e **CLIENTE**
* Auditoria e registro de acesso a dados sensíveis
* Sistema de **backup e restauração do PostgreSQL**

---

# 1. Requisitos

Antes de instalar o sistema em outro computador, instale:

## Node.js

Versão recomendada:

```text
Node.js 20+
```

Verifique:

```powershell
node --version
```

Exemplo:

```text
v20.x.x
```

ou versão superior.

---

## pnpm

Verifique:

```powershell
pnpm --version
```

Caso não esteja instalado:

```powershell
npm install -g pnpm
```

Depois:

```powershell
pnpm --version
```

---

## Docker Desktop

O sistema utiliza PostgreSQL em Docker.

Instale o Docker Desktop e confirme:

```powershell
docker --version
```

Depois:

```powershell
docker compose version
```

O Docker Desktop deve estar **aberto e em execução** antes de iniciar o banco.

---

# 2. Transferência para outro computador

O projeto foi estruturado para que a pasta inteira possa ser compactada em ZIP e transferida para outro computador.

O ZIP deve conter:

```text
projectBarbearia/
├── backend/
│   └── .env
├── database/
├── docs/
├── frontend/
├── scripts/
├── backups/
│   └── trato_fino_YYYY-MM-DD_HH-MM-SS.dump
├── docker-compose.yml
├── package.json
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
├── .env
└── README.md
```

O arquivo:

```text
backups/*.dump
```

contém o estado atual do banco PostgreSQL no momento em que o backup foi criado.

O arquivo:

```text
backend/.env
```

também é transferido junto com o projeto.

Isso é importante porque as chaves utilizadas para criptografar os dados pessoais precisam permanecer as mesmas.

> **IMPORTANTE:** o ZIP contém informações sensíveis. Não publique o ZIP, o `backend/.env` ou os arquivos `.dump` em repositórios públicos.

---

# 3. Copiar e descompactar o projeto

Descompacte o ZIP no computador novo.

Exemplo:

```text
C:\Users\NovoUsuario\Desktop\projectBarbearia
```

Entre na pasta:

```powershell
cd "C:\Users\NovoUsuario\Desktop\projectBarbearia"
```

Confirme:

```powershell
dir
```

Devem existir arquivos/pastas semelhantes a:

```text
backend
backups
database
docs
frontend
scripts
docker-compose.yml
package.json
pnpm-lock.yaml
pnpm-workspace.yaml
README.md
```

---

# 4. Variáveis de ambiente

O arquivo principal do backend fica em:

```text
backend\.env
```

Ele é transferido junto com o ZIP.

As principais variáveis são:

```text
DATABASE_URL
JWT_SECRET
PII_ENCRYPTION_KEY
PII_BLIND_INDEX_KEY
PII_KEY_VERSION
PORT
```

Exemplo estrutural:

```env
DATABASE_URL=postgresql://trato_fino_app:SUA_SENHA@localhost:5432/trato_fino?schema=public

JWT_SECRET="SUA_CHAVE_JWT"

PII_ENCRYPTION_KEY="SUA_CHAVE_AES_256_EM_BASE64URL"

PII_BLIND_INDEX_KEY="SUA_CHAVE_HMAC_EM_BASE64URL"

PII_KEY_VERSION="1"

PORT=3000
```

No cenário de transferência por ZIP, **não é necessário criar um novo `backend/.env` se o arquivo existente foi transferido junto com o projeto**.

## Importante

As chaves:

```text
PII_ENCRYPTION_KEY
PII_BLIND_INDEX_KEY
```

não devem ser alteradas quando já existem dados criptografados.

Os dados pessoais existentes foram criptografados utilizando essas chaves.

Se as chaves forem alteradas, os dados antigos poderão deixar de ser descriptografáveis.

---

# 5. PostgreSQL

O sistema utiliza:

```text
PostgreSQL 16 Alpine
```

executado através do Docker Compose.

Configuração:

```text
Host: 127.0.0.1
Porta: 5432
Banco: trato_fino
Usuário: trato_fino_app
```

O PostgreSQL utiliza um volume persistente:

```text
trato_fino_pgdata
```

---

# 6. Primeira instalação em um computador novo

Quando o projeto for transferido para um computador novo e já existir um backup em:

```text
backups/
```

utilize o seguinte fluxo:

```text
1. Instalar Node.js
       ↓
2. Instalar pnpm
       ↓
3. Instalar Docker Desktop
       ↓
4. Descompactar o projeto
       ↓
5. pnpm install
       ↓
6. docker compose up -d
       ↓
7. pnpm restore
       ↓
8. npm run dev
       ↓
9. Trato Fino CLI
```

---

# 7. Instalar dependências

Dentro da pasta do projeto:

```powershell
pnpm install
```

Aguarde a conclusão.

Depois confira:

```powershell
node --version
```

e:

```powershell
pnpm --version
```

---

# 8. Iniciar o PostgreSQL

Execute:

```powershell
docker compose up -d
```

Verifique:

```powershell
docker compose ps
```

O resultado esperado é semelhante a:

```text
NAME                  IMAGE                STATUS
trato-fino-postgres   postgres:16-alpine   Up (healthy)
```

---

# 9. Restaurar o backup atual

Depois que o PostgreSQL estiver funcionando, execute:

```powershell
pnpm restore
```

O comando procura automaticamente o arquivo `.dump` mais recente dentro de:

```text
backups/
```

Por exemplo:

```text
backups/
└── trato_fino_2026-10-05_19-45-30.dump
```

O `pnpm restore`:

1. Localiza o backup mais recente;
2. Verifica o PostgreSQL;
3. Inicia o Docker caso necessário;
4. Aguarda o PostgreSQL ficar disponível;
5. Copia o backup para o container;
6. Restaura o banco;
7. Remove o arquivo temporário utilizado dentro do container.

Ao final deverá aparecer:

```text
==============================================
   ✅ RESTAURAÇÃO CONCLUÍDA COM SUCESSO
==============================================
```

---

# 10. IMPORTANTE — ordem da restauração

Em um computador novo **não execute primeiro**:

```powershell
pnpm db:setup
```

quando o objetivo for recuperar o estado atual através do backup `.dump`.

Utilize:

```powershell
pnpm install
docker compose up -d
pnpm restore
npm run dev
```

O backup `.dump` é o responsável por recuperar o estado atual do banco.

O `database/trato_fino.sql` permanece como uma base de restauração inicial/preservada do projeto, mas o backup `.dump` representa o estado operacional mais recente quando criado.

---

# 11. Inicialização normal depois da restauração

Depois que o backup já tiver sido restaurado, normalmente basta:

```powershell
cd "C:\Users\NovoUsuario\Desktop\projectBarbearia"
```

e:

```powershell
docker compose up -d
```

Depois:

```powershell
npm run dev
```

O sistema iniciará:

```text
PostgreSQL
    ↓
Prisma
    ↓
Backend
    ↓
API
    ↓
CLI
```

---

# 12. Tela inicial

O terminal deverá apresentar:

```text
========================================================================
  TRATO FINO — SISTEMA DE BARBEARIA
========================================================================

1. Entrar
2. Cadastrar
0. Sair
```

---

# 13. Backup do banco

Para criar um novo backup do banco PostgreSQL:

```powershell
pnpm backup
```

O sistema cria automaticamente um arquivo dentro de:

```text
backups/
```

Exemplo:

```text
backups/
└── trato_fino_2026-10-05_19-45-30.dump
```

O nome contém a data e hora do backup.

---

# 14. Como funciona o backup

O backup é criado diretamente a partir do PostgreSQL executado no Docker.

O processo utiliza:

```text
pg_dump
```

no formato customizado do PostgreSQL.

O arquivo `.dump` contém os dados atuais do banco.

Isso inclui, entre outros:

* usuários;
* credenciais;
* dados pessoais criptografados;
* clientes;
* barbeiros;
* serviços;
* agendamentos;
* histórico;
* comandas;
* pagamentos;
* avaliações;
* notificações;
* logs;
* auditoria;
* configurações armazenadas no banco.

---

# 15. Backup e restauração

### Criar backup

```powershell
pnpm backup
```

### Restaurar backup

```powershell
pnpm restore
```

O `restore` seleciona automaticamente o `.dump` mais recente.

Exemplo:

```text
backups/
├── trato_fino_2026-10-01_10-00-00.dump
├── trato_fino_2026-10-03_18-30-00.dump
└── trato_fino_2026-10-05_19-45-30.dump
```

Nesse caso, será utilizado:

```text
trato_fino_2026-10-05_19-45-30.dump
```

---

# 16. ATENÇÃO ao executar `pnpm restore`

A restauração substitui os dados atuais do banco pelo conteúdo do backup selecionado.

Portanto:

```powershell
pnpm restore
```

deve ser utilizado principalmente para:

* instalar o sistema em outro computador;
* recuperar o banco a partir de um backup;
* recuperar dados após uma falha;
* migrar o sistema para outro ambiente.

Não execute `pnpm restore` casualmente em um banco que contém dados mais recentes que o backup.

---

# 17. Criar backup antes de alterações importantes

Antes de realizar alterações importantes no sistema, é recomendado:

```powershell
pnpm backup
```

Depois faça as alterações.

Isso permite recuperar o estado anterior caso alguma operação cause problemas.

---

# 18. Persistência do banco

O PostgreSQL utiliza o volume:

```text
trato_fino_pgdata
```

Reiniciar o computador ou o container não deve apagar os dados.

Verifique:

```powershell
docker compose ps
```

Para iniciar:

```powershell
docker compose up -d
```

Para parar:

```powershell
docker compose down
```

## Atenção

Não execute:

```powershell
docker compose down -v
```

se quiser preservar o banco.

O parâmetro:

```text
-v
```

remove os volumes associados e pode apagar o banco persistente.

Caso precise reinstalar o banco em outro computador, utilize o:

```powershell
pnpm restore
```

com o backup `.dump`.

---

# 19. `database/trato_fino.sql` x `backups/*.dump`

Existem dois tipos de arquivos de banco no projeto.

## `database/trato_fino.sql`

Representa a base SQL preservada do projeto.

Exemplo:

```text
database/
└── trato_fino.sql
```

É útil para uma restauração/base inicial quando necessário.

## `backups/*.dump`

Representa backups operacionais do PostgreSQL.

Exemplo:

```text
backups/
└── trato_fino_2026-10-05_19-45-30.dump
```

Para migrar o sistema atual para outro computador, **prefira o backup `.dump` mais recente**.

---

# 20. Seed

O seed atual é idempotente.

Execute manualmente somente quando necessário:

```powershell
pnpm --filter backend exec prisma db seed
```

O seed verifica os registros existentes e cria somente o que estiver faltando.

Ele não deve apagar os dados existentes.

Não é necessário executar o seed manualmente a cada inicialização.

---

# 21. `db:setup`

O comando:

```powershell
pnpm db:setup
```

é utilizado para preparar o ambiente do PostgreSQL e da aplicação.

Ele pode:

1. Inicializar o PostgreSQL;
2. Gerar o Prisma Client;
3. Aplicar o schema;
4. Restaurar a base inicial quando aplicável;
5. Executar o seed;
6. Configurar a aplicação.

Em uma migração que possui um backup `.dump` atual, **prefira `pnpm restore` para recuperar o banco**.

---

# 22. Prisma

### Gerar Prisma Client

```powershell
pnpm --filter backend exec prisma generate
```

### Aplicar/verificar schema

```powershell
pnpm --filter backend exec prisma db push
```

### Executar seed

```powershell
pnpm --filter backend exec prisma db seed
```

---

# 23. Inicialização normal da aplicação

Com o banco já configurado:

```powershell
npm run dev
```

O processo inicia:

1. PostgreSQL;
2. Prisma;
3. Backend;
4. API;
5. CLI.

A API ficará disponível em:

```text
http://localhost:3000
```

---

# 24. Login inicial

O seed cria inicialmente um usuário administrador e um usuário cliente.

## ADMIN

```text
E-mail:

admin@tratofino.com
```

A senha temporária é exibida no terminal durante a criação inicial.

Exemplo:

```text
🔐 ADMIN criado
   E-mail: admin@tratofino.com
   Senha temporária: TF-XXXXXXXXXXXXXXXX
```

Copie a senha no momento da criação.

A senha não é armazenada em texto puro.

Ela é armazenada somente como:

```text
bcrypt hash
```

---

# 25. CLIENTE

O seed também cria um cliente inicial:

```text
E-mail:

cliente@tratofino.com
```

A senha temporária também é exibida somente no momento da criação.

---

# 26. Senhas temporárias

As senhas temporárias seguem o padrão:

```text
TF- + caracteres aleatórios
```

A senha:

* é gerada aleatoriamente;
* não é armazenada em texto puro;
* é armazenada somente como hash bcrypt;
* é marcada como temporária;
* deve ser utilizada no primeiro acesso;
* deve ser substituída por uma senha permanente.

O sistema não permite recuperar uma senha temporária antiga.

Caso seja necessário gerar outra senha, o administrador deve utilizar o fluxo de redefinição.

---

# 27. Cadastro público

A tela pública possui:

```text
1. Entrar
2. Cadastrar
0. Sair
```

O cadastro público sempre cria:

```text
CLIENTE
```

O usuário não pode escolher `ADMIN` durante o cadastro público.

Novos administradores somente podem ser criados por um administrador autenticado.

---

# 28. Perfis de acesso

O sistema possui dois perfis de aplicação:

## ADMIN

Pode administrar:

* clientes;
* usuários;
* agenda;
* serviços;
* barbeiros;
* comandas;
* avaliações;
* relatórios;
* configurações administrativas;
* acesso controlado aos dados pessoais.

O acesso à PII é realizado pelo backend e registrado em auditoria.

## CLIENTE

Pode:

* consultar o próprio cadastro;
* alterar a própria senha;
* consultar serviços;
* consultar barbeiros;
* criar agendamentos;
* consultar os próprios agendamentos;
* cancelar/alterar operações permitidas pelo sistema.

Um CLIENTE não pode acessar dados de outros clientes.

---

# 29. Segurança das senhas

As senhas nunca são armazenadas diretamente no banco.

O sistema utiliza:

```text
bcrypt
```

O banco armazena somente o hash.

Não existe uma operação para descriptografar uma senha.

Isso também vale para senhas temporárias.

---

# 30. Proteção dos dados pessoais

Dados pessoais são armazenados utilizando:

```text
AES-256-GCM
```

Os campos de pesquisa utilizam:

```text
HMAC-SHA-256
```

através de blind indexes.

As informações protegidas incluem dados como:

* nome;
* CPF;
* e-mail;
* telefone.

---

# 31. Acesso administrativo à PII

O ADMIN não recebe a chave criptográfica e não acessa o banco diretamente.

Quando uma operação administrativa precisa consultar dados pessoais:

```text
CLI
 ↓
API Express
 ↓
Autorização/RBAC
 ↓
Descriptografia no backend
 ↓
Registro de auditoria
 ↓
Resposta ao administrador
```

O acesso é registrado em:

```text
LogAcessoDadoSensivel
```

e:

```text
LogAuditoria
```

As senhas nunca entram nesse processo.

---

# 32. Sessões

As sessões de autenticação podem ser revogadas.

O sistema não precisa armazenar o token de sessão em texto puro.

Quando aplicável, somente o hash do token é armazenado.

Isso permite invalidar sessões anteriores, inclusive durante determinados processos de redefinição de senha.

---

# 33. Bloqueio de login

O sistema possui proteção contra tentativas consecutivas de autenticação.

Após cinco falhas consecutivas, o usuário pode ser temporariamente bloqueado conforme as regras implementadas no backend.

As tentativas são registradas.

---

# 34. Agendamentos

O sistema possui estrutura para:

* clientes;
* barbeiros;
* serviços;
* horários;
* agendamentos;
* bloqueios de agenda;
* histórico de alterações.

O backend possui proteção contra sobreposição de agendamentos utilizando transações.

---

# 35. Verificar PostgreSQL

Para visualizar o estado do banco:

```powershell
docker compose ps
```

Para visualizar os logs:

```powershell
docker compose logs postgres
```

Para acompanhar em tempo real:

```powershell
docker compose logs -f postgres
```

Para sair:

```text
Ctrl + C
```

---

# 36. Parar a aplicação

Se o sistema estiver rodando:

```text
Ctrl + C
```

Isso encerra o Node/CLI.

O PostgreSQL continua disponível no Docker.

Para parar também o PostgreSQL:

```powershell
docker compose down
```

---

# 37. Reiniciar somente o PostgreSQL

```powershell
docker compose restart postgres
```

Depois:

```powershell
docker compose ps
```

---

# 38. Problemas com processos Node/Prisma no Windows

Se aparecer:

```text
EPERM
```

ou arquivos do Prisma não puderem ser substituídos, feche os terminais executando Node/Prisma.

Se necessário:

```powershell
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
```

e:

```powershell
Get-Process prisma -ErrorAction SilentlyContinue | Stop-Process -Force
```

Depois:

```powershell
pnpm --filter backend exec prisma generate
```

---

# 39. Problemas com scripts do pnpm

Se aparecer:

```text
ERR_PNPM_IGNORED_BUILDS
```

execute:

```powershell
pnpm approve-builds
```

Autorize os pacotes necessários.

Depois:

```powershell
pnpm install
```

e:

```powershell
pnpm --filter backend exec prisma generate
```

---

# 40. Problemas com PowerShell

Se aparecer uma mensagem semelhante a:

```text
npm.ps1 não pode ser carregado porque a execução de scripts foi desabilitada
```

utilize:

```powershell
npm.cmd run dev
```

ou:

```powershell
pnpm dev
```

---

# 41. Conferir API

Com a aplicação executando:

```text
http://localhost:3000
```

A rota raiz pode retornar:

```text
404
```

Isso não significa necessariamente que a API está quebrada.

Verifique no terminal do backend se aparece:

```text
🚀 Trato Fino API rodando em http://localhost:3000
```

---

# 42. Estrutura principal do projeto

```text
projectBarbearia/
│
├── backend/
│   ├── prisma/
│   │   ├── schema.prisma
│   │   └── seed.ts
│   │
│   ├── src/
│   │   ├── lib/
│   │   │   └── crypto.ts
│   │   └── server.ts
│   │
│   └── .env
│
├── backups/
│   └── trato_fino_YYYY-MM-DD_HH-MM-SS.dump
│
├── database/
│   └── trato_fino.sql
│
├── docs/
│
├── frontend/
│
├── scripts/
│   ├── setup-postgres.mjs
│   ├── dev.mjs
│   ├── backup-postgres.mjs
│   └── restore-postgres.mjs
│
├── docker-compose.yml
├── package.json
├── pnpm-lock.yaml
├── pnpm-workspace.yaml
├── .env
├── .env.example
└── README.md
```

---

# 43. Comandos principais

## Instalar dependências

```powershell
pnpm install
```

## Iniciar PostgreSQL

```powershell
docker compose up -d
```

## Verificar PostgreSQL

```powershell
docker compose ps
```

## Criar backup

```powershell
pnpm backup
```

## Restaurar backup

```powershell
pnpm restore
```

## Preparar banco

```powershell
pnpm db:setup
```

## Gerar Prisma Client

```powershell
pnpm --filter backend exec prisma generate
```

## Aplicar schema

```powershell
pnpm --filter backend exec prisma db push
```

## Executar seed

```powershell
pnpm --filter backend exec prisma db seed
```

## Executar aplicação

```powershell
npm run dev
```

## Parar containers

```powershell
docker compose down
```

## Reiniciar PostgreSQL

```powershell
docker compose restart postgres
```

## Ver logs do PostgreSQL

```powershell
docker compose logs -f postgres
```

---

# 44. Instalação completa em um computador novo com backup

Esse é o procedimento recomendado para transportar o Trato Fino para outro computador.

### 1. Instalar

Instale:

```text
Node.js 20+
pnpm
Docker Desktop
```

### 2. Descompactar

Descompacte o ZIP completo.

### 3. Entrar na pasta

```powershell
cd "C:\Users\SEU_USUARIO\Desktop\projectBarbearia"
```

### 4. Conferir os arquivos

```powershell
dir
```

Confirme principalmente que existem:

```text
backend\.env
backups\*.dump
docker-compose.yml
package.json
```

### 5. Instalar dependências

```powershell
pnpm install
```

### 6. Iniciar PostgreSQL

```powershell
docker compose up -d
```

### 7. Conferir PostgreSQL

```powershell
docker compose ps
```

O container deverá estar:

```text
Up (healthy)
```

### 8. Restaurar o banco atual

```powershell
pnpm restore
```

### 9. Iniciar o sistema

```powershell
npm run dev
```

### 10. Utilizar o Trato Fino

O terminal apresentará:

```text
========================================================================
  TRATO FINO — SISTEMA DE BARBEARIA
========================================================================

1. Entrar
2. Cadastrar
0. Sair
```

---

# 45. Fluxo diário

Depois que o computador já estiver configurado:

```powershell
cd "C:\Users\SEU_USUARIO\Desktop\projectBarbearia"
```

Inicie o PostgreSQL:

```powershell
docker compose up -d
```

Depois:

```powershell
npm run dev
```

Não é necessário executar `pnpm restore` a cada inicialização.

---

# 46. Fluxo recomendado de backup

Antes de transportar o sistema para outro computador:

```powershell
pnpm backup
```

Confirme que apareceu um novo arquivo:

```text
backups/
└── trato_fino_YYYY-MM-DD_HH-MM-SS.dump
```

Depois compacte a pasta inteira:

```text
projectBarbearia/
```

O ZIP deverá conter o backup mais recente.

No outro computador:

```text
Descompactar
     ↓
pnpm install
     ↓
docker compose up -d
     ↓
pnpm restore
     ↓
npm run dev
```

---

# 47. Segurança do arquivo ZIP

O projeto contém informações sensíveis.

O ZIP pode conter:

```text
backend/.env
backups/*.dump
```

Esses arquivos podem conter informações necessárias para recuperar o sistema.

Portanto:

* não publique o ZIP no GitHub;
* não envie o ZIP para locais públicos;
* não compartilhe o `backend/.env` desnecessariamente;
* não compartilhe arquivos `.dump` publicamente;
* mantenha cópias de backup em local seguro.

As chaves criptográficas presentes no `.env` devem ser tratadas como segredos.

---

# 48. Checklist para outro computador

Antes de iniciar:

* [ ] Node.js 20+ instalado
* [ ] pnpm instalado
* [ ] Docker Desktop instalado
* [ ] Docker Desktop aberto
* [ ] Projeto descompactado
* [ ] `backend/.env` presente
* [ ] `backups/*.dump` presente
* [ ] Dependências instaladas
* [ ] PostgreSQL iniciado
* [ ] PostgreSQL `healthy`
* [ ] `pnpm restore` executado
* [ ] Restauração concluída com sucesso
* [ ] API iniciada
* [ ] CLI aberta

---

# 49. Fluxo completo de migração

```text
COMPUTADOR ORIGINAL
        │
        ▼
pnpm backup
        │
        ▼
Novo arquivo .dump
        │
        ▼
Compactar projectBarbearia
        │
        ▼
Transferir ZIP
        │
        ▼
COMPUTADOR NOVO
        │
        ▼
Descompactar projeto
        │
        ▼
Instalar Node.js
        │
        ▼
Instalar pnpm
        │
        ▼
Instalar Docker Desktop
        │
        ▼
pnpm install
        │
        ▼
docker compose up -d
        │
        ▼
pnpm restore
        │
        ▼
Banco restaurado
        │
        ▼
npm run dev
        │
        ▼
TRATO FINO CLI
```

---

# 50. Resumo dos comandos

### Computador novo com backup

```powershell
cd "C:\Users\SEU_USUARIO\Desktop\projectBarbearia"

pnpm install

docker compose up -d

docker compose ps

pnpm restore

npm run dev
```

### Uso normal

```powershell
docker compose up -d

npm run dev
```

### Criar backup

```powershell
pnpm backup
```

### Restaurar backup

```powershell
pnpm restore
```

### Parar PostgreSQL

```powershell
docker compose down
```

### Nunca utilizar para uma instalação normal

```powershell
docker compose down -v
```

```powershell
pnpm prisma migrate reset
```

ou qualquer outro comando destrutivo em um banco que contenha dados que precisam ser preservados.
