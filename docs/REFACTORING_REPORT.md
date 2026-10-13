# Relatório Técnico de Refatoração — Trato Fino

## 1. Visão geral

Este documento apresenta as alterações técnicas realizadas no projeto Trato Fino, abrangendo a reorganização da estrutura do repositório, a padronização dos comandos de execução, a centralização das variáveis de ambiente, a revisão dos scripts de manutenção e a preservação dos artefatos relacionados ao banco de dados.

O trabalho teve como objetivo melhorar a organização e a manutenibilidade do código, reduzir a duplicação de configurações, tornar a inicialização do ambiente mais previsível e estabelecer uma base mais consistente para a evolução do sistema.

A refatoração também considerou os objetivos acadêmicos do projeto, especialmente:

* Organização e modularização do código-fonte.
* Separação de responsabilidades.
* Orientação a Objetos e encapsulamento.
* Modelagem e persistência de dados.
* Segurança no gerenciamento de configurações.
* Preservação da integridade dos dados.
* Padronização dos procedimentos de desenvolvimento.

A preservação dos dados existentes foi tratada como requisito prioritário. As alterações estruturais foram conduzidas de forma a preservar os artefatos originais do banco de dados e evitar operações desnecessárias que pudessem modificar sua estrutura ou seu conteúdo.

## 2. Arquitetura e organização do repositório

### 2.1. Organização dos componentes

A estrutura do projeto foi organizada para separar os componentes executáveis e suas respectivas responsabilidades.

A API está localizada em `apps/api/`, enquanto a interface de terminal (CLI) está em `apps/cli/`. Essa organização facilita a identificação dos componentes, a localização dos arquivos e a manutenção independente de cada aplicação.

Os principais diretórios e arquivos do projeto estão organizados da seguinte forma:

```text
projectBarbearia/
├── apps/
│   ├── api/
│   │   ├── prisma/
│   │   ├── scripts/
│   │   ├── src/
│   │   ├── tests/
│   │   └── package.json
│   └── cli/
│       ├── src/
│       └── package.json
├── backups/
├── database/
│   └── trato_fino.sql
├── scripts/
├── docker-compose.yml
├── package.json
├── pnpm-workspace.yaml
├── pnpm-lock.yaml
├── .env
└── .env.example
```

A estrutura acima representa os principais componentes do projeto, sem pretender listar todos os arquivos existentes.

### 2.2. Separação de responsabilidades

A organização dos diretórios estabelece uma divisão mais clara entre a camada de serviços da API e a aplicação de terminal.

Essa separação facilita:

* A manutenção dos componentes de forma independente.
* A localização de funcionalidades específicas.
* A identificação das dependências de cada aplicação.
* A execução de comandos direcionados a cada componente.
* A evolução da arquitetura sem concentrar todas as responsabilidades em um único local.

A estrutura também favorece a aplicação de princípios de organização de software, como a separação de responsabilidades e a redução do acoplamento entre componentes.

## 3. Workspace e gerenciamento de comandos

### 3.1. Configuração do workspace pnpm

A configuração do workspace foi atualizada para refletir a organização atual do repositório, contemplando os caminhos `apps/api/` e `apps/cli/`.

O arquivo `pnpm-workspace.yaml` foi ajustado para reconhecer a estrutura das aplicações. Os manifests e lockfiles foram preservados, com atualização dos caminhos dos importers no lockfile pnpm da raiz.

Nenhuma dependência foi adicionada ou removida durante a refatoração descrita neste relatório.

### 3.2. Comandos de conveniência

Os comandos definidos no `package.json` da raiz foram revisados para utilizar os caminhos atualizados das aplicações.

Essa abordagem centraliza as operações mais comuns de desenvolvimento e manutenção, incluindo:

* Inicialização do ambiente.
* Execução da API.
* Execução da CLI.
* Compilação dos componentes.
* Execução dos testes disponíveis.
* Geração do Prisma Client.
* Operações de manutenção do banco de dados.
* Criação e restauração de backups.

A centralização desses comandos reduz a necessidade de navegar manualmente entre diretórios e facilita a padronização dos procedimentos utilizados durante o desenvolvimento.

### 3.3. Resolução da raiz do projeto

Os scripts de desenvolvimento, configuração, backup e restauração foram ajustados para resolver a raiz do repositório independentemente do diretório a partir do qual são executados.

Essa mudança reduz a dependência do diretório de trabalho atual e torna a resolução de caminhos mais previsível.

Como resultado, os scripts passam a utilizar uma referência consistente para localizar os arquivos de configuração, os diretórios das aplicações e os recursos necessários à execução das operações.

## 4. Centralização das variáveis de ambiente

### 4.1. Consolidação da configuração

A configuração de runtime foi centralizada no arquivo `.env` da raiz do projeto.

Os arquivos `.env` anteriormente existentes em diretórios aninhados foram removidos após a consolidação. Também foi mantido um arquivo `.env.example` com um modelo sanitizado para documentar as variáveis necessárias à configuração do ambiente.

A centralização busca reduzir a duplicação de parâmetros e evitar divergências entre configurações utilizadas pelos diferentes componentes.

As variáveis contempladas na configuração consolidada são:

| Variável              | Finalidade                                                          |
| --------------------- | ------------------------------------------------------------------- |
| `POSTGRES_DB`         | Define o nome do banco PostgreSQL.                                  |
| `POSTGRES_USER`       | Define o usuário de conexão do PostgreSQL.                          |
| `POSTGRES_PASSWORD`   | Define a senha do usuário do PostgreSQL.                            |
| `DATABASE_URL`        | Define a string de conexão utilizada pelo Prisma.                   |
| `JWT_SECRET`          | Define o segredo utilizado na assinatura e validação de tokens JWT. |
| `PII_ENCRYPTION_KEY`  | Define a chave destinada à criptografia de informações pessoais.    |
| `PII_BLIND_INDEX_KEY` | Define a chave destinada à geração de índices de busca protegidos.  |
| `PII_KEY_VERSION`     | Identifica a versão da chave criptográfica.                         |
| `PORT`                | Define a porta de execução da API.                                  |
| `API_URL`             | Define o endereço-base da API utilizado pela CLI.                   |

Também foi preservada a variável `PII_ENCRYPTION_KEY_ROOT_CONFLICT`, que mantém o valor conflitante existente anteriormente na raiz. Essa variável é considerada inativa na configuração descrita e foi mantida para permitir a investigação da divergência criptográfica.

Nenhum valor de senha, segredo ou chave é documentado neste relatório.

### 4.2. Carregamento antecipado da configuração

Os pontos de inicialização da API e do seed foram ajustados para carregar o `.env` da raiz antes da importação de módulos que dependem das configurações criptográficas.

A ordem de carregamento é importante porque módulos podem avaliar variáveis de ambiente durante sua inicialização. Quando isso ocorre antes da leitura do arquivo de configuração, os componentes podem utilizar valores ausentes ou incorretos.

O ajuste busca garantir uma fonte de configuração consistente para os componentes que dependem dessas variáveis.

### 4.3. Validação da conexão PostgreSQL

A `DATABASE_URL` foi verificada estruturalmente em relação às variáveis de configuração do PostgreSQL.

A verificação confirmou a correspondência entre os campos de usuário, senha e nome do banco de dados.

Essa validação estrutural permite verificar a consistência da configuração, mas não representa, isoladamente, uma comprovação de conectividade, autenticação ou compatibilidade completa entre o banco e os modelos definidos no Prisma.

## 5. Segurança e proteção de dados pessoais

### 5.1. Verificação das chaves criptográficas

Durante a validação das configurações criptográficas, foi identificada uma divergência relacionada à chave utilizada para acessar dados pessoais criptografados.

A validação do ciphertext de referência falhou tanto para o valor configurado em `PII_ENCRYPTION_KEY` quanto para o valor preservado em `PII_ENCRYPTION_KEY_ROOT_CONFLICT`.

Dessa forma, a compatibilidade da chave de criptografia com o conteúdo criptografado existente não foi confirmada.

Essa condição exige atenção porque a disponibilidade de uma chave no ambiente não comprova que ela seja compatível com os dados já armazenados.

Até que a origem da divergência seja esclarecida, não se deve substituir as chaves arbitrariamente, descartar a configuração de conflito ou executar operações em massa sobre dados criptografados.

A variável preservada deve ser tratada como um elemento de investigação, e não como uma chave validada para utilização operacional.

### 5.2. Proteção contra exposição de informações pessoais

O script `check-keys.mjs` foi ajustado para não imprimir informações pessoais em texto puro durante a execução da validação.

O resultado passou a indicar somente sucesso ou falha, evitando a exposição desnecessária de conteúdo sensível no terminal e em registros de execução.

A mudança reduz o risco de divulgação acidental de dados pessoais durante procedimentos de diagnóstico e manutenção.

### 5.3. Proteção de arquivos sensíveis

O arquivo `.env.example` foi mantido como modelo sanitizado da configuração necessária ao projeto.

Arquivos de ambiente reais e backups que possam conter credenciais, chaves criptográficas ou dados pessoais devem permanecer fora do versionamento.

A revisão dos arquivos preparados para commit e das regras do `.gitignore` é importante para impedir que informações sensíveis sejam incluídas indevidamente no repositório.

A remoção de um arquivo da área de preparação do Git não elimina o arquivo local nem remove automaticamente eventuais segredos que já tenham sido incorporados ao histórico do repositório.

## 6. Banco de dados e Prisma

### 6.1. Preservação dos artefatos existentes

Durante a refatoração, foram preservados os seguintes artefatos relacionados ao banco de dados:

* `database/trato_fino.sql`.
* O dump armazenado em `backups/`.
* O schema Prisma.
* O arquivo de lock das migrações.
* A migração SQL existente.
* A fonte da CLI.

Conforme o registro da execução, esses arquivos foram comparados byte a byte com seus correspondentes no ZIP original e permaneceram idênticos.

A preservação teve como objetivo manter a integridade dos arquivos de referência, evitar alterações acidentais e conservar o histórico necessário para a análise da estrutura e dos dados existentes.

### 6.2. Configuração do Prisma

O provider configurado no Prisma permanece como `postgresql`, e a conexão utiliza a variável `DATABASE_URL`.

O schema Prisma descreve os modelos, os campos e os relacionamentos esperados pela aplicação. As migrações SQL, por sua vez, registram as transformações estruturais previstas para o banco ao longo do desenvolvimento.

Esses elementos precisam estar alinhados à estrutura física efetivamente existente no PostgreSQL para que as operações de persistência funcionem corretamente.

A geração do Prisma Client produz o código necessário à comunicação entre a aplicação e o banco, mas não cria, por si só, as tabelas nem corrige incompatibilidades estruturais existentes.

### 6.3. Compatibilidade entre o schema e as migrações

Foi identificada uma divergência preexistente entre a migração SQL legada e o schema Prisma atual.

A migração preservada define tabelas legadas com identificadores inteiros, enquanto o schema Prisma atual utiliza modelos e identificadores UUID.

Essa diferença pode afetar a compatibilidade das chaves primárias, das chaves estrangeiras, dos relacionamentos e das operações de persistência.

O histórico de migrações foi preservado sem alterações durante a refatoração.

A compatibilidade entre a migração legada e o schema atual deve ser considerada antes de qualquer aplicação de migrações ou execução de `db push` em um banco importante.

### 6.4. Preservação e segurança das operações de banco

As alterações estruturais descritas neste relatório foram conduzidas separadamente das operações que modificam o banco de dados.

Durante a refatoração registrada, não foram executadas operações de banco, migrações, `db push`, seed, backup ou restauração.

Essa decisão teve como objetivo preservar os dados existentes e evitar mudanças involuntárias na estrutura física do banco durante a reorganização do projeto.

A preservação dos artefatos e a ausência dessas operações não comprovam, por si só, a compatibilidade completa entre o schema Prisma, o histórico de migrações e todas as tabelas existentes. Esses elementos devem ser considerados em conjunto ao avaliar a integridade e a evolução do banco de dados.
