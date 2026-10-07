# Frontend Terminal — Trato Fino

O frontend é uma CLI e usa a API local em `http://localhost:3000`.

## Cliente

O perfil CLIENTE pode:

- agendar atendimento;
- consultar os próprios agendamentos;
- consultar serviços e barbeiros;
- consultar o próprio cadastro;
- alterar a própria senha;
- solicitar redefinição de senha.

## Admin

O perfil ADMIN pode administrar clientes, barbeiros, serviços, agenda e comandas; consultar PII de clientes de forma auditada; atender solicitações de redefinição e gerar senhas temporárias.

Senhas nunca são impressas durante a digitação. Senhas temporárias são mostradas somente uma vez nas operações que as geram.


## Cadastro

Na tela pública, **Cadastrar** cria automaticamente um **CLIENTE**. Não existe cadastro público de administrador. Um ADMIN autenticado pode criar outro ADMIN pelo menu administrativo. A opção de redefinição de senha fica dentro do fluxo de login.
