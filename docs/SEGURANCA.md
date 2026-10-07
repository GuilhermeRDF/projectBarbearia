# Segurança e proteção de dados — Trato Fino

## Persistência PostgreSQL

O runtime usa PostgreSQL 16 em Docker. Os dados ficam no volume persistente `trato_fino_pgdata`, montado em `/var/lib/postgresql/data`. A porta é publicada somente em `127.0.0.1:5432`.

A persistência combina três camadas:

1. **PostgreSQL** mantém os registros estruturados e relacionamentos.
2. **Volume Docker** mantém os dados entre reinícios/atualizações do container.
3. **Criptografia da aplicação** protege PII mesmo dentro do banco: AES-256-GCM para valores e HMAC-SHA-256 para blind indexes.

A segurança física do volume depende do sistema operacional. Em Windows, recomenda-se BitLocker; em produção, use disco/volume criptografado e backup criptografado.

## Credenciais

Senhas nunca são armazenadas reversivelmente. `CredencialUsuario.hashSenha` contém somente hash bcrypt.

Senhas temporárias seguem o padrão `TF-` + 16 caracteres aleatórios gerados por `crypto.randomBytes`. O valor em texto puro só aparece na resposta da operação de criação/redefinição e não é salvo no banco. `senhaTemporaria=true` força a troca no primeiro login.

## Redefinição

O cliente pode solicitar redefinição pelo frontend. A solicitação usa token aleatório armazenado somente como hash e expira em 30 minutos. Como a instalação local não depende de um provedor de e-mail, o administrador conclui o fluxo pelo menu de solicitações, gerando uma senha temporária. Ao gerar a nova senha, tokens de redefinição pendentes e sessões antigas são invalidados.

## PII e acesso administrativo

Nome, e-mail, telefone e CPF ficam em `DadosPessoaisUsuario` e são cifrados. O administrador vê a PII somente através de endpoint autorizado. Cada consulta cria registro em `LogAcessoDadoSensivel` e também em `LogAuditoria`.

O administrador **não** vê chaves de criptografia pela aplicação e **não** pode recuperar senhas. Hash de senha não é senha.

## Perfis

Somente dois perfis de aplicação existem: `ADMIN` e `CLIENTE`. O modelo funcional de barbeiro continua em `PerfilFuncionario`, mas o usuário técnico associado usa o perfil `ADMIN`; isso evita um terceiro perfil de autenticação.

## Migração

Os dados da base anterior foram preservados no dump `database/trato_fino.sql`. PII continua cifrada no dump; credenciais continuam em hash. Registros funcionais de barbeiros, clientes, serviços, agendamento, comanda e auditoria são mantidos.

## Produção

Para produção, substitua o `.env` local por Secret Manager/KMS, use TLS para conexões PostgreSQL quando aplicável, configure backups criptografados, rotacione chaves e credenciais e restrinja a rede do banco.


## Regra de criação de perfis

O cadastro público nunca cria ADMIN: ele sempre cria CLIENTE. ADMIN só pode ser criado por outro ADMIN autenticado, com auditoria da operação.
