-- Trato Fino: padronização física do PostgreSQL com preservação de dados.

-- O fluxo detecta o schema moderno ou arquiva as quatro tabelas da migration histórica incompatível.

BEGIN;

DO $$

DECLARE has_modern_schema BOOLEAN;

BEGIN

  has_modern_schema :=
    to_regclass('"Barbearia"') IS NOT NULL OR to_regclass('"barbearia"') IS NOT NULL;
  PERFORM set_config('trato_fino.legacy_mode', CASE WHEN has_modern_schema THEN 'false' ELSE 'true' END, true);
  IF has_modern_schema THEN

    IF to_regclass(format('%I', 'Barbearia')) IS NULL AND to_regclass(format('%I', 'barbearia')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Barbearia/barbearia ausente.';
    END IF;

    IF to_regclass(format('%I', 'Usuario')) IS NULL AND to_regclass(format('%I', 'usuario')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Usuario/usuario ausente.';
    END IF;

    IF to_regclass(format('%I', 'CredencialUsuario')) IS NULL AND to_regclass(format('%I', 'credencial_usuario')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela CredencialUsuario/credencial_usuario ausente.';
    END IF;

    IF to_regclass(format('%I', 'DadosPessoaisUsuario')) IS NULL AND to_regclass(format('%I', 'dados_pessoais_usuario')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela DadosPessoaisUsuario/dados_pessoais_usuario ausente.';
    END IF;

    IF to_regclass(format('%I', 'PerfilAcesso')) IS NULL AND to_regclass(format('%I', 'perfil_acesso')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela PerfilAcesso/perfil_acesso ausente.';
    END IF;

    IF to_regclass(format('%I', 'Permissao')) IS NULL AND to_regclass(format('%I', 'permissao')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Permissao/permissao ausente.';
    END IF;

    IF to_regclass(format('%I', 'UsuarioPerfil')) IS NULL AND to_regclass(format('%I', 'usuario_perfil')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela UsuarioPerfil/usuario_perfil ausente.';
    END IF;

    IF to_regclass(format('%I', 'PerfilPermissao')) IS NULL AND to_regclass(format('%I', 'perfil_permissao')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela PerfilPermissao/perfil_permissao ausente.';
    END IF;

    IF to_regclass(format('%I', 'PerfilCliente')) IS NULL AND to_regclass(format('%I', 'perfil_cliente')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela PerfilCliente/perfil_cliente ausente.';
    END IF;

    IF to_regclass(format('%I', 'PerfilFuncionario')) IS NULL AND to_regclass(format('%I', 'perfil_funcionario')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela PerfilFuncionario/perfil_funcionario ausente.';
    END IF;

    IF to_regclass(format('%I', 'SessaoAutenticacao')) IS NULL AND to_regclass(format('%I', 'sessao_autenticacao')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela SessaoAutenticacao/sessao_autenticacao ausente.';
    END IF;

    IF to_regclass(format('%I', 'TokenRedefinicaoSenha')) IS NULL AND to_regclass(format('%I', 'token_redefinicao_senha')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela TokenRedefinicaoSenha/token_redefinicao_senha ausente.';
    END IF;

    IF to_regclass(format('%I', 'TentativaLogin')) IS NULL AND to_regclass(format('%I', 'tentativa_login')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela TentativaLogin/tentativa_login ausente.';
    END IF;

    IF to_regclass(format('%I', 'Servico')) IS NULL AND to_regclass(format('%I', 'servico')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Servico/servico ausente.';
    END IF;

    IF to_regclass(format('%I', 'ServicoBarbeiro')) IS NULL AND to_regclass(format('%I', 'servico_barbeiro')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela ServicoBarbeiro/servico_barbeiro ausente.';
    END IF;

    IF to_regclass(format('%I', 'HorarioTrabalho')) IS NULL AND to_regclass(format('%I', 'horario_trabalho')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela HorarioTrabalho/horario_trabalho ausente.';
    END IF;

    IF to_regclass(format('%I', 'BloqueioAgenda')) IS NULL AND to_regclass(format('%I', 'bloqueio_agenda')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela BloqueioAgenda/bloqueio_agenda ausente.';
    END IF;

    IF to_regclass(format('%I', 'Agendamento')) IS NULL AND to_regclass(format('%I', 'agendamento')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Agendamento/agendamento ausente.';
    END IF;

    IF to_regclass(format('%I', 'ServicoAgendamento')) IS NULL AND to_regclass(format('%I', 'servico_agendamento')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela ServicoAgendamento/servico_agendamento ausente.';
    END IF;

    IF to_regclass(format('%I', 'HistoricoAgendamento')) IS NULL AND to_regclass(format('%I', 'historico_agendamento')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela HistoricoAgendamento/historico_agendamento ausente.';
    END IF;

    IF to_regclass(format('%I', 'ObservacaoAgendamento')) IS NULL AND to_regclass(format('%I', 'observacao_agendamento')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela ObservacaoAgendamento/observacao_agendamento ausente.';
    END IF;

    IF to_regclass(format('%I', 'Notificacao')) IS NULL AND to_regclass(format('%I', 'notificacao')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Notificacao/notificacao ausente.';
    END IF;

    IF to_regclass(format('%I', 'LogAuditoria')) IS NULL AND to_regclass(format('%I', 'log_auditoria')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela LogAuditoria/log_auditoria ausente.';
    END IF;

    IF to_regclass(format('%I', 'LogAcessoDadoSensivel')) IS NULL AND to_regclass(format('%I', 'log_acesso_dado_sensivel')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela LogAcessoDadoSensivel/log_acesso_dado_sensivel ausente.';
    END IF;

    IF to_regclass(format('%I', 'ConsentimentoPrivacidade')) IS NULL AND to_regclass(format('%I', 'consentimento_privacidade')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela ConsentimentoPrivacidade/consentimento_privacidade ausente.';
    END IF;

    IF to_regclass(format('%I', 'SolicitacaoPrivacidade')) IS NULL AND to_regclass(format('%I', 'solicitacao_privacidade')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela SolicitacaoPrivacidade/solicitacao_privacidade ausente.';
    END IF;

    IF to_regclass(format('%I', 'PoliticaRetencaoDados')) IS NULL AND to_regclass(format('%I', 'politica_retencao_dados')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela PoliticaRetencaoDados/politica_retencao_dados ausente.';
    END IF;

    IF to_regclass(format('%I', 'Pagamento')) IS NULL AND to_regclass(format('%I', 'pagamento')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Pagamento/pagamento ausente.';
    END IF;

    IF to_regclass(format('%I', 'Avaliacao')) IS NULL AND to_regclass(format('%I', 'avaliacao')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Avaliacao/avaliacao ausente.';
    END IF;

    IF to_regclass(format('%I', 'Comanda')) IS NULL AND to_regclass(format('%I', 'comanda')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela Comanda/comanda ausente.';
    END IF;

    IF to_regclass(format('%I', 'ItemComanda')) IS NULL AND to_regclass(format('%I', 'item_comanda')) IS NULL THEN
      RAISE EXCEPTION 'Esquema moderno parcial: tabela ItemComanda/item_comanda ausente.';
    END IF;

  ELSE

    IF to_regclass('clientes') IS NULL AND to_regclass('barbeiros') IS NULL AND to_regclass('servicos') IS NULL AND to_regclass('agendamentos') IS NULL THEN

      RAISE EXCEPTION 'Schema não reconhecido. Consulte docs/migracao-segura.md; nenhum dado foi alterado.';

    END IF;

  END IF;

  -- Arquiva tabelas da migration inicial antiga; os registros permanecem preservados.

  IF to_regclass('clientes') IS NOT NULL THEN

    IF to_regclass('legacy_20260916_clientes') IS NOT NULL THEN RAISE EXCEPTION 'Tabela de arquivo legacy_20260916_clientes já existe.'; END IF;

    ALTER TABLE "clientes" RENAME TO "legacy_20260916_clientes";

  END IF;

  IF to_regclass('barbeiros') IS NOT NULL THEN

    IF to_regclass('legacy_20260916_barbeiros') IS NOT NULL THEN RAISE EXCEPTION 'Tabela de arquivo legacy_20260916_barbeiros já existe.'; END IF;

    ALTER TABLE "barbeiros" RENAME TO "legacy_20260916_barbeiros";

  END IF;

  IF to_regclass('servicos') IS NOT NULL THEN

    IF to_regclass('legacy_20260916_servicos') IS NOT NULL THEN RAISE EXCEPTION 'Tabela de arquivo legacy_20260916_servicos já existe.'; END IF;

    ALTER TABLE "servicos" RENAME TO "legacy_20260916_servicos";

  END IF;

  IF to_regclass('agendamentos') IS NOT NULL THEN

    IF to_regclass('legacy_20260916_agendamentos') IS NOT NULL THEN RAISE EXCEPTION 'Tabela de arquivo legacy_20260916_agendamentos já existe.'; END IF;

    ALTER TABLE "agendamentos" RENAME TO "legacy_20260916_agendamentos";

  END IF;

END $$;



DO $$
BEGIN
  IF to_regclass('"Agendamento"') IS NOT NULL
     AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='Agendamento' AND column_name='dataHora')
  THEN
    IF EXISTS (SELECT 1 FROM "Agendamento" WHERE "dataHora" IS DISTINCT FROM "inicioAgendado") THEN
      RAISE EXCEPTION 'Agendamento.dataHora diverge de inicioAgendado; reconcilie antes de migrar.';
    END IF;
    ALTER TABLE "Agendamento" DROP COLUMN "dataHora";
  ELSIF to_regclass('"agendamento"') IS NOT NULL
     AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_data_hora')
  THEN
    IF EXISTS (SELECT 1 FROM agendamento WHERE agendamento_data_hora IS DISTINCT FROM agendamento_inicio_agendado) THEN
      RAISE EXCEPTION 'agendamento_data_hora diverge de agendamento_inicio_agendado.';
    END IF;
    ALTER TABLE agendamento DROP COLUMN agendamento_data_hora;
  END IF;
END $$;



DO $$ BEGIN
  IF to_regclass(format('%I', 'Barbearia')) IS NOT NULL THEN
    ALTER TABLE "Barbearia" RENAME TO "barbearia";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'Usuario')) IS NOT NULL THEN
    ALTER TABLE "Usuario" RENAME TO "usuario";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'CredencialUsuario')) IS NOT NULL THEN
    ALTER TABLE "CredencialUsuario" RENAME TO "credencial_usuario";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'DadosPessoaisUsuario')) IS NOT NULL THEN
    ALTER TABLE "DadosPessoaisUsuario" RENAME TO "dados_pessoais_usuario";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'PerfilAcesso')) IS NOT NULL THEN
    ALTER TABLE "PerfilAcesso" RENAME TO "perfil_acesso";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'Permissao')) IS NOT NULL THEN
    ALTER TABLE "Permissao" RENAME TO "permissao";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'UsuarioPerfil')) IS NOT NULL THEN
    ALTER TABLE "UsuarioPerfil" RENAME TO "usuario_perfil";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'PerfilPermissao')) IS NOT NULL THEN
    ALTER TABLE "PerfilPermissao" RENAME TO "perfil_permissao";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'PerfilCliente')) IS NOT NULL THEN
    ALTER TABLE "PerfilCliente" RENAME TO "perfil_cliente";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'PerfilFuncionario')) IS NOT NULL THEN
    ALTER TABLE "PerfilFuncionario" RENAME TO "perfil_funcionario";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'SessaoAutenticacao')) IS NOT NULL THEN
    ALTER TABLE "SessaoAutenticacao" RENAME TO "sessao_autenticacao";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'TokenRedefinicaoSenha')) IS NOT NULL THEN
    ALTER TABLE "TokenRedefinicaoSenha" RENAME TO "token_redefinicao_senha";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'TentativaLogin')) IS NOT NULL THEN
    ALTER TABLE "TentativaLogin" RENAME TO "tentativa_login";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'Servico')) IS NOT NULL THEN
    ALTER TABLE "Servico" RENAME TO "servico";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'ServicoBarbeiro')) IS NOT NULL THEN
    ALTER TABLE "ServicoBarbeiro" RENAME TO "servico_barbeiro";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'HorarioTrabalho')) IS NOT NULL THEN
    ALTER TABLE "HorarioTrabalho" RENAME TO "horario_trabalho";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'BloqueioAgenda')) IS NOT NULL THEN
    ALTER TABLE "BloqueioAgenda" RENAME TO "bloqueio_agenda";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'Agendamento')) IS NOT NULL THEN
    ALTER TABLE "Agendamento" RENAME TO "agendamento";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'ServicoAgendamento')) IS NOT NULL THEN
    ALTER TABLE "ServicoAgendamento" RENAME TO "servico_agendamento";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'HistoricoAgendamento')) IS NOT NULL THEN
    ALTER TABLE "HistoricoAgendamento" RENAME TO "historico_agendamento";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'ObservacaoAgendamento')) IS NOT NULL THEN
    ALTER TABLE "ObservacaoAgendamento" RENAME TO "observacao_agendamento";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'Notificacao')) IS NOT NULL THEN
    ALTER TABLE "Notificacao" RENAME TO "notificacao";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'LogAuditoria')) IS NOT NULL THEN
    ALTER TABLE "LogAuditoria" RENAME TO "log_auditoria";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'LogAcessoDadoSensivel')) IS NOT NULL THEN
    ALTER TABLE "LogAcessoDadoSensivel" RENAME TO "log_acesso_dado_sensivel";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'ConsentimentoPrivacidade')) IS NOT NULL THEN
    ALTER TABLE "ConsentimentoPrivacidade" RENAME TO "consentimento_privacidade";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'SolicitacaoPrivacidade')) IS NOT NULL THEN
    ALTER TABLE "SolicitacaoPrivacidade" RENAME TO "solicitacao_privacidade";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'PoliticaRetencaoDados')) IS NOT NULL THEN
    ALTER TABLE "PoliticaRetencaoDados" RENAME TO "politica_retencao_dados";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'Pagamento')) IS NOT NULL THEN
    ALTER TABLE "Pagamento" RENAME TO "pagamento";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'Avaliacao')) IS NOT NULL THEN
    ALTER TABLE "Avaliacao" RENAME TO "avaliacao";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'Comanda')) IS NOT NULL THEN
    ALTER TABLE "Comanda" RENAME TO "comanda";
  END IF;
END $$;

DO $$ BEGIN
  IF to_regclass(format('%I', 'ItemComanda')) IS NOT NULL THEN
    ALTER TABLE "ItemComanda" RENAME TO "item_comanda";
  END IF;
END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'barbearia')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_id') THEN
      ALTER TABLE "barbearia" RENAME COLUMN "id" TO "barbearia_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: barbearia.id e barbearia.barbearia_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='nome')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_nome') THEN
      ALTER TABLE "barbearia" RENAME COLUMN "nome" TO "barbearia_nome";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='nome')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_nome') THEN
      RAISE EXCEPTION 'Colunas duplicadas: barbearia.nome e barbearia.barbearia_nome.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='slug')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_slug') THEN
      ALTER TABLE "barbearia" RENAME COLUMN "slug" TO "barbearia_slug";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='slug')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_slug') THEN
      RAISE EXCEPTION 'Colunas duplicadas: barbearia.slug e barbearia.barbearia_slug.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='telefone')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_telefone') THEN
      ALTER TABLE "barbearia" RENAME COLUMN "telefone" TO "barbearia_telefone";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='telefone')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_telefone') THEN
      RAISE EXCEPTION 'Colunas duplicadas: barbearia.telefone e barbearia.barbearia_telefone.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='endereco')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_endereco') THEN
      ALTER TABLE "barbearia" RENAME COLUMN "endereco" TO "barbearia_endereco";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='endereco')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_endereco') THEN
      RAISE EXCEPTION 'Colunas duplicadas: barbearia.endereco e barbearia.barbearia_endereco.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='logoUrl')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_logo_url') THEN
      ALTER TABLE "barbearia" RENAME COLUMN "logoUrl" TO "barbearia_logo_url";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='logoUrl')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_logo_url') THEN
      RAISE EXCEPTION 'Colunas duplicadas: barbearia.logoUrl e barbearia.barbearia_logo_url.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_criado_em') THEN
      ALTER TABLE "barbearia" RENAME COLUMN "criadoEm" TO "barbearia_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='barbearia' AND column_name='barbearia_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: barbearia.criadoEm e barbearia.barbearia_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'usuario')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_id') THEN
      ALTER TABLE "usuario" RENAME COLUMN "id" TO "usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.id e usuario.usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='barbeariaId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_barbearia_id') THEN
      ALTER TABLE "usuario" RENAME COLUMN "barbeariaId" TO "usuario_barbearia_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='barbeariaId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_barbearia_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.barbeariaId e usuario.usuario_barbearia_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='role')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_role') THEN
      ALTER TABLE "usuario" RENAME COLUMN "role" TO "usuario_role";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='role')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_role') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.role e usuario.usuario_role.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='estaAtivo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_esta_ativo') THEN
      ALTER TABLE "usuario" RENAME COLUMN "estaAtivo" TO "usuario_esta_ativo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='estaAtivo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_esta_ativo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.estaAtivo e usuario.usuario_esta_ativo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='eEquipe')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_e_equipe') THEN
      ALTER TABLE "usuario" RENAME COLUMN "eEquipe" TO "usuario_e_equipe";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='eEquipe')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_e_equipe') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.eEquipe e usuario.usuario_e_equipe.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='eSuperusuario')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_e_superusuario') THEN
      ALTER TABLE "usuario" RENAME COLUMN "eSuperusuario" TO "usuario_e_superusuario";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='eSuperusuario')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_e_superusuario') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.eSuperusuario e usuario.usuario_e_superusuario.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='quantidadeFalhasLogin')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_quantidade_falhas_login') THEN
      ALTER TABLE "usuario" RENAME COLUMN "quantidadeFalhasLogin" TO "usuario_quantidade_falhas_login";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='quantidadeFalhasLogin')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_quantidade_falhas_login') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.quantidadeFalhasLogin e usuario.usuario_quantidade_falhas_login.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='bloqueadoAte')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_bloqueado_ate') THEN
      ALTER TABLE "usuario" RENAME COLUMN "bloqueadoAte" TO "usuario_bloqueado_ate";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='bloqueadoAte')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_bloqueado_ate') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.bloqueadoAte e usuario.usuario_bloqueado_ate.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='senhaAlteradaEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_senha_alterada_em') THEN
      ALTER TABLE "usuario" RENAME COLUMN "senhaAlteradaEm" TO "usuario_senha_alterada_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='senhaAlteradaEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_senha_alterada_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.senhaAlteradaEm e usuario.usuario_senha_alterada_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='ultimoLoginEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_ultimo_login_em') THEN
      ALTER TABLE "usuario" RENAME COLUMN "ultimoLoginEm" TO "usuario_ultimo_login_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='ultimoLoginEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_ultimo_login_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.ultimoLoginEm e usuario.usuario_ultimo_login_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='excluidoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_excluido_em') THEN
      ALTER TABLE "usuario" RENAME COLUMN "excluidoEm" TO "usuario_excluido_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='excluidoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_excluido_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.excluidoEm e usuario.usuario_excluido_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='anonimizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_anonimizado_em') THEN
      ALTER TABLE "usuario" RENAME COLUMN "anonimizadoEm" TO "usuario_anonimizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='anonimizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_anonimizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.anonimizadoEm e usuario.usuario_anonimizado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_criado_em') THEN
      ALTER TABLE "usuario" RENAME COLUMN "criadoEm" TO "usuario_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.criadoEm e usuario.usuario_criado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_atualizado_em') THEN
      ALTER TABLE "usuario" RENAME COLUMN "atualizadoEm" TO "usuario_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario' AND column_name='usuario_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario.atualizadoEm e usuario.usuario_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'credencial_usuario')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_id') THEN
      ALTER TABLE "credencial_usuario" RENAME COLUMN "id" TO "credencial_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: credencial_usuario.id e credencial_usuario.credencial_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_usuario_id') THEN
      ALTER TABLE "credencial_usuario" RENAME COLUMN "usuarioId" TO "credencial_usuario_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: credencial_usuario.usuarioId e credencial_usuario.credencial_usuario_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='hashSenha')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_hash_senha') THEN
      ALTER TABLE "credencial_usuario" RENAME COLUMN "hashSenha" TO "credencial_usuario_hash_senha";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='hashSenha')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_hash_senha') THEN
      RAISE EXCEPTION 'Colunas duplicadas: credencial_usuario.hashSenha e credencial_usuario.credencial_usuario_hash_senha.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='versaoSenha')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_versao_senha') THEN
      ALTER TABLE "credencial_usuario" RENAME COLUMN "versaoSenha" TO "credencial_usuario_versao_senha";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='versaoSenha')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_versao_senha') THEN
      RAISE EXCEPTION 'Colunas duplicadas: credencial_usuario.versaoSenha e credencial_usuario.credencial_usuario_versao_senha.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='mfaHabilitado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_mfa_habilitado') THEN
      ALTER TABLE "credencial_usuario" RENAME COLUMN "mfaHabilitado" TO "credencial_usuario_mfa_habilitado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='mfaHabilitado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_mfa_habilitado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: credencial_usuario.mfaHabilitado e credencial_usuario.credencial_usuario_mfa_habilitado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='senhaTemporaria')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_senha_temporaria') THEN
      ALTER TABLE "credencial_usuario" RENAME COLUMN "senhaTemporaria" TO "credencial_usuario_senha_temporaria";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='senhaTemporaria')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_senha_temporaria') THEN
      RAISE EXCEPTION 'Colunas duplicadas: credencial_usuario.senhaTemporaria e credencial_usuario.credencial_usuario_senha_temporaria.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_criado_em') THEN
      ALTER TABLE "credencial_usuario" RENAME COLUMN "criadoEm" TO "credencial_usuario_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: credencial_usuario.criadoEm e credencial_usuario.credencial_usuario_criado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_atualizado_em') THEN
      ALTER TABLE "credencial_usuario" RENAME COLUMN "atualizadoEm" TO "credencial_usuario_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='credencial_usuario' AND column_name='credencial_usuario_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: credencial_usuario.atualizadoEm e credencial_usuario.credencial_usuario_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'dados_pessoais_usuario')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_id') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "id" TO "dados_pessoais_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.id e dados_pessoais_usuario.dados_pessoais_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_usuario_id') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "usuarioId" TO "dados_pessoais_usuario_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.usuarioId e dados_pessoais_usuario.dados_pessoais_usuario_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='nomeCompletoCriptografado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_nome_completo_criptografado') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "nomeCompletoCriptografado" TO "dados_pessoais_usuario_nome_completo_criptografado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='nomeCompletoCriptografado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_nome_completo_criptografado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.nomeCompletoCriptografado e dados_pessoais_usuario.dados_pessoais_usuario_nome_completo_criptografado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='cpfCriptografado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_cpf_criptografado') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "cpfCriptografado" TO "dados_pessoais_usuario_cpf_criptografado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='cpfCriptografado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_cpf_criptografado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.cpfCriptografado e dados_pessoais_usuario.dados_pessoais_usuario_cpf_criptografado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='hashBuscaCpf')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_hash_busca_cpf') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "hashBuscaCpf" TO "dados_pessoais_usuario_hash_busca_cpf";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='hashBuscaCpf')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_hash_busca_cpf') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.hashBuscaCpf e dados_pessoais_usuario.dados_pessoais_usuario_hash_busca_cpf.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='emailCriptografado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_email_criptografado') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "emailCriptografado" TO "dados_pessoais_usuario_email_criptografado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='emailCriptografado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_email_criptografado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.emailCriptografado e dados_pessoais_usuario.dados_pessoais_usuario_email_criptografado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='hashBuscaEmail')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_hash_busca_email') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "hashBuscaEmail" TO "dados_pessoais_usuario_hash_busca_email";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='hashBuscaEmail')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_hash_busca_email') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.hashBuscaEmail e dados_pessoais_usuario.dados_pessoais_usuario_hash_busca_email.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='telefoneCriptografado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_telefone_criptografado') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "telefoneCriptografado" TO "dados_pessoais_usuario_telefone_criptografado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='telefoneCriptografado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_telefone_criptografado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.telefoneCriptografado e dados_pessoais_usuario.dados_pessoais_usuario_telefone_criptografado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='hashBuscaTelefone')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_hash_busca_telefone') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "hashBuscaTelefone" TO "dados_pessoais_usuario_hash_busca_telefone";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='hashBuscaTelefone')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_hash_busca_telefone') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.hashBuscaTelefone e dados_pessoais_usuario.dados_pessoais_usuario_hash_busca_telefone.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='versaoChaveCriptografia')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_versao_chave_criptografia') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "versaoChaveCriptografia" TO "dados_pessoais_usuario_versao_chave_criptografia";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='versaoChaveCriptografia')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_versao_chave_criptografia') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.versaoChaveCriptografia e dados_pessoais_usuario.dados_pessoais_usuario_versao_chave_criptografia.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_criado_em') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "criadoEm" TO "dados_pessoais_usuario_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.criadoEm e dados_pessoais_usuario.dados_pessoais_usuario_criado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_atualizado_em') THEN
      ALTER TABLE "dados_pessoais_usuario" RENAME COLUMN "atualizadoEm" TO "dados_pessoais_usuario_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='dados_pessoais_usuario' AND column_name='dados_pessoais_usuario_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: dados_pessoais_usuario.atualizadoEm e dados_pessoais_usuario.dados_pessoais_usuario_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'perfil_acesso')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_id') THEN
      ALTER TABLE "perfil_acesso" RENAME COLUMN "id" TO "perfil_acesso_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_acesso.id e perfil_acesso.perfil_acesso_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='codigo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_codigo') THEN
      ALTER TABLE "perfil_acesso" RENAME COLUMN "codigo" TO "perfil_acesso_codigo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='codigo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_codigo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_acesso.codigo e perfil_acesso.perfil_acesso_codigo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='nome')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_nome') THEN
      ALTER TABLE "perfil_acesso" RENAME COLUMN "nome" TO "perfil_acesso_nome";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='nome')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_nome') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_acesso.nome e perfil_acesso.perfil_acesso_nome.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='descricao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_descricao') THEN
      ALTER TABLE "perfil_acesso" RENAME COLUMN "descricao" TO "perfil_acesso_descricao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='descricao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_descricao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_acesso.descricao e perfil_acesso.perfil_acesso_descricao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='eSistema')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_e_sistema') THEN
      ALTER TABLE "perfil_acesso" RENAME COLUMN "eSistema" TO "perfil_acesso_e_sistema";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='eSistema')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_acesso' AND column_name='perfil_acesso_e_sistema') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_acesso.eSistema e perfil_acesso.perfil_acesso_e_sistema.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'permissao')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='permissao_id') THEN
      ALTER TABLE "permissao" RENAME COLUMN "id" TO "permissao_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='permissao_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: permissao.id e permissao.permissao_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='codigo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='permissao_codigo') THEN
      ALTER TABLE "permissao" RENAME COLUMN "codigo" TO "permissao_codigo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='codigo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='permissao_codigo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: permissao.codigo e permissao.permissao_codigo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='descricao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='permissao_descricao') THEN
      ALTER TABLE "permissao" RENAME COLUMN "descricao" TO "permissao_descricao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='descricao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='permissao' AND column_name='permissao_descricao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: permissao.descricao e permissao.permissao_descricao.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'usuario_perfil')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_id') THEN
      ALTER TABLE "usuario_perfil" RENAME COLUMN "id" TO "usuario_perfil_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario_perfil.id e usuario_perfil.usuario_perfil_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_usuario_id') THEN
      ALTER TABLE "usuario_perfil" RENAME COLUMN "usuarioId" TO "usuario_perfil_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario_perfil.usuarioId e usuario_perfil.usuario_perfil_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='perfilId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_perfil_id') THEN
      ALTER TABLE "usuario_perfil" RENAME COLUMN "perfilId" TO "usuario_perfil_perfil_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='perfilId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_perfil_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario_perfil.perfilId e usuario_perfil.usuario_perfil_perfil_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='atribuidoPor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_atribuido_por') THEN
      ALTER TABLE "usuario_perfil" RENAME COLUMN "atribuidoPor" TO "usuario_perfil_atribuido_por";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='atribuidoPor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_atribuido_por') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario_perfil.atribuidoPor e usuario_perfil.usuario_perfil_atribuido_por.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='atribuidoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_atribuido_em') THEN
      ALTER TABLE "usuario_perfil" RENAME COLUMN "atribuidoEm" TO "usuario_perfil_atribuido_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='atribuidoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='usuario_perfil' AND column_name='usuario_perfil_atribuido_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: usuario_perfil.atribuidoEm e usuario_perfil.usuario_perfil_atribuido_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'perfil_permissao')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='perfil_permissao_id') THEN
      ALTER TABLE "perfil_permissao" RENAME COLUMN "id" TO "perfil_permissao_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='perfil_permissao_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_permissao.id e perfil_permissao.perfil_permissao_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='perfilId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='perfil_permissao_perfil_id') THEN
      ALTER TABLE "perfil_permissao" RENAME COLUMN "perfilId" TO "perfil_permissao_perfil_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='perfilId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='perfil_permissao_perfil_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_permissao.perfilId e perfil_permissao.perfil_permissao_perfil_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='permissaoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='perfil_permissao_permissao_id') THEN
      ALTER TABLE "perfil_permissao" RENAME COLUMN "permissaoId" TO "perfil_permissao_permissao_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='permissaoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_permissao' AND column_name='perfil_permissao_permissao_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_permissao.permissaoId e perfil_permissao.perfil_permissao_permissao_id.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'perfil_cliente')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_id') THEN
      ALTER TABLE "perfil_cliente" RENAME COLUMN "id" TO "perfil_cliente_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_cliente.id e perfil_cliente.perfil_cliente_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_usuario_id') THEN
      ALTER TABLE "perfil_cliente" RENAME COLUMN "usuarioId" TO "perfil_cliente_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_cliente.usuarioId e perfil_cliente.perfil_cliente_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='observacoesOperacionais')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_observacoes_operacionais') THEN
      ALTER TABLE "perfil_cliente" RENAME COLUMN "observacoesOperacionais" TO "perfil_cliente_observacoes_operacionais";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='observacoesOperacionais')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_observacoes_operacionais') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_cliente.observacoesOperacionais e perfil_cliente.perfil_cliente_observacoes_operacionais.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_criado_em') THEN
      ALTER TABLE "perfil_cliente" RENAME COLUMN "criadoEm" TO "perfil_cliente_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_cliente.criadoEm e perfil_cliente.perfil_cliente_criado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_atualizado_em') THEN
      ALTER TABLE "perfil_cliente" RENAME COLUMN "atualizadoEm" TO "perfil_cliente_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_cliente' AND column_name='perfil_cliente_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_cliente.atualizadoEm e perfil_cliente.perfil_cliente_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'perfil_funcionario')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_id') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "id" TO "perfil_funcionario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.id e perfil_funcionario.perfil_funcionario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_usuario_id') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "usuarioId" TO "perfil_funcionario_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.usuarioId e perfil_funcionario.perfil_funcionario_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='barbeariaId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_barbearia_id') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "barbeariaId" TO "perfil_funcionario_barbearia_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='barbeariaId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_barbearia_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.barbeariaId e perfil_funcionario.perfil_funcionario_barbearia_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='nomeExibicao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_nome_exibicao') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "nomeExibicao" TO "perfil_funcionario_nome_exibicao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='nomeExibicao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_nome_exibicao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.nomeExibicao e perfil_funcionario.perfil_funcionario_nome_exibicao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='bio')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_bio') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "bio" TO "perfil_funcionario_bio";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='bio')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_bio') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.bio e perfil_funcionario.perfil_funcionario_bio.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='urlFoto')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_url_foto') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "urlFoto" TO "perfil_funcionario_url_foto";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='urlFoto')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_url_foto') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.urlFoto e perfil_funcionario.perfil_funcionario_url_foto.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='dataAdmissao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_data_admissao') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "dataAdmissao" TO "perfil_funcionario_data_admissao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='dataAdmissao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_data_admissao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.dataAdmissao e perfil_funcionario.perfil_funcionario_data_admissao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='estaDisponivel')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_esta_disponivel') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "estaDisponivel" TO "perfil_funcionario_esta_disponivel";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='estaDisponivel')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_esta_disponivel') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.estaDisponivel e perfil_funcionario.perfil_funcionario_esta_disponivel.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='especialidade')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_especialidade') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "especialidade" TO "perfil_funcionario_especialidade";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='especialidade')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_especialidade') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.especialidade e perfil_funcionario.perfil_funcionario_especialidade.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='horarioInicio')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_horario_inicio') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "horarioInicio" TO "perfil_funcionario_horario_inicio";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='horarioInicio')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_horario_inicio') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.horarioInicio e perfil_funcionario.perfil_funcionario_horario_inicio.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='horarioFim')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_horario_fim') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "horarioFim" TO "perfil_funcionario_horario_fim";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='horarioFim')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_horario_fim') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.horarioFim e perfil_funcionario.perfil_funcionario_horario_fim.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='inicioAlmoco')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_inicio_almoco') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "inicioAlmoco" TO "perfil_funcionario_inicio_almoco";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='inicioAlmoco')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_inicio_almoco') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.inicioAlmoco e perfil_funcionario.perfil_funcionario_inicio_almoco.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='fimAlmoco')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_fim_almoco') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "fimAlmoco" TO "perfil_funcionario_fim_almoco";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='fimAlmoco')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_fim_almoco') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.fimAlmoco e perfil_funcionario.perfil_funcionario_fim_almoco.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='comissaoPorcent')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_comissao_porcent') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "comissaoPorcent" TO "perfil_funcionario_comissao_porcent";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='comissaoPorcent')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_comissao_porcent') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.comissaoPorcent e perfil_funcionario.perfil_funcionario_comissao_porcent.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_criado_em') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "criadoEm" TO "perfil_funcionario_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.criadoEm e perfil_funcionario.perfil_funcionario_criado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_atualizado_em') THEN
      ALTER TABLE "perfil_funcionario" RENAME COLUMN "atualizadoEm" TO "perfil_funcionario_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='perfil_funcionario' AND column_name='perfil_funcionario_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: perfil_funcionario.atualizadoEm e perfil_funcionario.perfil_funcionario_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'sessao_autenticacao')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_id') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "id" TO "sessao_autenticacao_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.id e sessao_autenticacao.sessao_autenticacao_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_usuario_id') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "usuarioId" TO "sessao_autenticacao_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.usuarioId e sessao_autenticacao.sessao_autenticacao_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='hashToken')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_hash_token') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "hashToken" TO "sessao_autenticacao_hash_token";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='hashToken')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_hash_token') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.hashToken e sessao_autenticacao.sessao_autenticacao_hash_token.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='hashIdDispositivo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_hash_id_dispositivo') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "hashIdDispositivo" TO "sessao_autenticacao_hash_id_dispositivo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='hashIdDispositivo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_hash_id_dispositivo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.hashIdDispositivo e sessao_autenticacao.sessao_autenticacao_hash_id_dispositivo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='enderecoIp')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_endereco_ip') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "enderecoIp" TO "sessao_autenticacao_endereco_ip";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='enderecoIp')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_endereco_ip') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.enderecoIp e sessao_autenticacao.sessao_autenticacao_endereco_ip.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='agenteUsuario')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_agente_usuario') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "agenteUsuario" TO "sessao_autenticacao_agente_usuario";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='agenteUsuario')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_agente_usuario') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.agenteUsuario e sessao_autenticacao.sessao_autenticacao_agente_usuario.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='emitidoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_emitido_em') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "emitidoEm" TO "sessao_autenticacao_emitido_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='emitidoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_emitido_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.emitidoEm e sessao_autenticacao.sessao_autenticacao_emitido_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='expiraEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_expira_em') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "expiraEm" TO "sessao_autenticacao_expira_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='expiraEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_expira_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.expiraEm e sessao_autenticacao.sessao_autenticacao_expira_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='revogadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_revogado_em') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "revogadoEm" TO "sessao_autenticacao_revogado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='revogadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_revogado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.revogadoEm e sessao_autenticacao.sessao_autenticacao_revogado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='motivoRevogacao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_motivo_revogacao') THEN
      ALTER TABLE "sessao_autenticacao" RENAME COLUMN "motivoRevogacao" TO "sessao_autenticacao_motivo_revogacao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='motivoRevogacao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='sessao_autenticacao' AND column_name='sessao_autenticacao_motivo_revogacao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: sessao_autenticacao.motivoRevogacao e sessao_autenticacao.sessao_autenticacao_motivo_revogacao.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'token_redefinicao_senha')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_id') THEN
      ALTER TABLE "token_redefinicao_senha" RENAME COLUMN "id" TO "token_redefinicao_senha_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: token_redefinicao_senha.id e token_redefinicao_senha.token_redefinicao_senha_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_usuario_id') THEN
      ALTER TABLE "token_redefinicao_senha" RENAME COLUMN "usuarioId" TO "token_redefinicao_senha_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: token_redefinicao_senha.usuarioId e token_redefinicao_senha.token_redefinicao_senha_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='hashToken')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_hash_token') THEN
      ALTER TABLE "token_redefinicao_senha" RENAME COLUMN "hashToken" TO "token_redefinicao_senha_hash_token";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='hashToken')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_hash_token') THEN
      RAISE EXCEPTION 'Colunas duplicadas: token_redefinicao_senha.hashToken e token_redefinicao_senha.token_redefinicao_senha_hash_token.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='expiraEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_expira_em') THEN
      ALTER TABLE "token_redefinicao_senha" RENAME COLUMN "expiraEm" TO "token_redefinicao_senha_expira_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='expiraEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_expira_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: token_redefinicao_senha.expiraEm e token_redefinicao_senha.token_redefinicao_senha_expira_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='usadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_usado_em') THEN
      ALTER TABLE "token_redefinicao_senha" RENAME COLUMN "usadoEm" TO "token_redefinicao_senha_usado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='usadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_usado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: token_redefinicao_senha.usadoEm e token_redefinicao_senha.token_redefinicao_senha_usado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='ipSolicitacao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_ip_solicitacao') THEN
      ALTER TABLE "token_redefinicao_senha" RENAME COLUMN "ipSolicitacao" TO "token_redefinicao_senha_ip_solicitacao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='ipSolicitacao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_ip_solicitacao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: token_redefinicao_senha.ipSolicitacao e token_redefinicao_senha.token_redefinicao_senha_ip_solicitacao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_criado_em') THEN
      ALTER TABLE "token_redefinicao_senha" RENAME COLUMN "criadoEm" TO "token_redefinicao_senha_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='token_redefinicao_senha' AND column_name='token_redefinicao_senha_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: token_redefinicao_senha.criadoEm e token_redefinicao_senha.token_redefinicao_senha_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'tentativa_login')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_id') THEN
      ALTER TABLE "tentativa_login" RENAME COLUMN "id" TO "tentativa_login_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: tentativa_login.id e tentativa_login.tentativa_login_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_usuario_id') THEN
      ALTER TABLE "tentativa_login" RENAME COLUMN "usuarioId" TO "tentativa_login_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: tentativa_login.usuarioId e tentativa_login.tentativa_login_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='hashBuscaIdentificador')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_hash_busca_identificador') THEN
      ALTER TABLE "tentativa_login" RENAME COLUMN "hashBuscaIdentificador" TO "tentativa_login_hash_busca_identificador";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='hashBuscaIdentificador')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_hash_busca_identificador') THEN
      RAISE EXCEPTION 'Colunas duplicadas: tentativa_login.hashBuscaIdentificador e tentativa_login.tentativa_login_hash_busca_identificador.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='foiBemSucedida')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_foi_bem_sucedida') THEN
      ALTER TABLE "tentativa_login" RENAME COLUMN "foiBemSucedida" TO "tentativa_login_foi_bem_sucedida";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='foiBemSucedida')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_foi_bem_sucedida') THEN
      RAISE EXCEPTION 'Colunas duplicadas: tentativa_login.foiBemSucedida e tentativa_login.tentativa_login_foi_bem_sucedida.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='enderecoIp')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_endereco_ip') THEN
      ALTER TABLE "tentativa_login" RENAME COLUMN "enderecoIp" TO "tentativa_login_endereco_ip";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='enderecoIp')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_endereco_ip') THEN
      RAISE EXCEPTION 'Colunas duplicadas: tentativa_login.enderecoIp e tentativa_login.tentativa_login_endereco_ip.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='agenteUsuario')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_agente_usuario') THEN
      ALTER TABLE "tentativa_login" RENAME COLUMN "agenteUsuario" TO "tentativa_login_agente_usuario";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='agenteUsuario')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_agente_usuario') THEN
      RAISE EXCEPTION 'Colunas duplicadas: tentativa_login.agenteUsuario e tentativa_login.tentativa_login_agente_usuario.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_criado_em') THEN
      ALTER TABLE "tentativa_login" RENAME COLUMN "criadoEm" TO "tentativa_login_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='tentativa_login' AND column_name='tentativa_login_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: tentativa_login.criadoEm e tentativa_login.tentativa_login_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'servico')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_id') THEN
      ALTER TABLE "servico" RENAME COLUMN "id" TO "servico_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.id e servico.servico_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='barbeariaId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_barbearia_id') THEN
      ALTER TABLE "servico" RENAME COLUMN "barbeariaId" TO "servico_barbearia_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='barbeariaId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_barbearia_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.barbeariaId e servico.servico_barbearia_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='nome')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_nome') THEN
      ALTER TABLE "servico" RENAME COLUMN "nome" TO "servico_nome";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='nome')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_nome') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.nome e servico.servico_nome.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='descricao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_descricao') THEN
      ALTER TABLE "servico" RENAME COLUMN "descricao" TO "servico_descricao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='descricao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_descricao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.descricao e servico.servico_descricao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='preco')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_preco') THEN
      ALTER TABLE "servico" RENAME COLUMN "preco" TO "servico_preco";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='preco')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_preco') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.preco e servico.servico_preco.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='duracaoMinutos')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_duracao_minutos') THEN
      ALTER TABLE "servico" RENAME COLUMN "duracaoMinutos" TO "servico_duracao_minutos";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='duracaoMinutos')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_duracao_minutos') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.duracaoMinutos e servico.servico_duracao_minutos.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='estaAtivo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_esta_ativo') THEN
      ALTER TABLE "servico" RENAME COLUMN "estaAtivo" TO "servico_esta_ativo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='estaAtivo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_esta_ativo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.estaAtivo e servico.servico_esta_ativo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_criado_em') THEN
      ALTER TABLE "servico" RENAME COLUMN "criadoEm" TO "servico_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.criadoEm e servico.servico_criado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_atualizado_em') THEN
      ALTER TABLE "servico" RENAME COLUMN "atualizadoEm" TO "servico_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico' AND column_name='servico_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico.atualizadoEm e servico.servico_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'servico_barbeiro')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_id') THEN
      ALTER TABLE "servico_barbeiro" RENAME COLUMN "id" TO "servico_barbeiro_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_barbeiro.id e servico_barbeiro.servico_barbeiro_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='barbeiroId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_barbeiro_id') THEN
      ALTER TABLE "servico_barbeiro" RENAME COLUMN "barbeiroId" TO "servico_barbeiro_barbeiro_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='barbeiroId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_barbeiro_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_barbeiro.barbeiroId e servico_barbeiro.servico_barbeiro_barbeiro_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servicoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_servico_id') THEN
      ALTER TABLE "servico_barbeiro" RENAME COLUMN "servicoId" TO "servico_barbeiro_servico_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servicoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_servico_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_barbeiro.servicoId e servico_barbeiro.servico_barbeiro_servico_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='precoPersonalizado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_preco_personalizado') THEN
      ALTER TABLE "servico_barbeiro" RENAME COLUMN "precoPersonalizado" TO "servico_barbeiro_preco_personalizado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='precoPersonalizado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_preco_personalizado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_barbeiro.precoPersonalizado e servico_barbeiro.servico_barbeiro_preco_personalizado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='duracaoPersonalizadaMinutos')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_duracao_personalizada_minutos') THEN
      ALTER TABLE "servico_barbeiro" RENAME COLUMN "duracaoPersonalizadaMinutos" TO "servico_barbeiro_duracao_personalizada_minutos";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='duracaoPersonalizadaMinutos')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_duracao_personalizada_minutos') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_barbeiro.duracaoPersonalizadaMinutos e servico_barbeiro.servico_barbeiro_duracao_personalizada_minutos.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='estaAtivo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_esta_ativo') THEN
      ALTER TABLE "servico_barbeiro" RENAME COLUMN "estaAtivo" TO "servico_barbeiro_esta_ativo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='estaAtivo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_barbeiro' AND column_name='servico_barbeiro_esta_ativo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_barbeiro.estaAtivo e servico_barbeiro.servico_barbeiro_esta_ativo.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'horario_trabalho')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_id') THEN
      ALTER TABLE "horario_trabalho" RENAME COLUMN "id" TO "horario_trabalho_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: horario_trabalho.id e horario_trabalho.horario_trabalho_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='barbeiroId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_barbeiro_id') THEN
      ALTER TABLE "horario_trabalho" RENAME COLUMN "barbeiroId" TO "horario_trabalho_barbeiro_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='barbeiroId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_barbeiro_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: horario_trabalho.barbeiroId e horario_trabalho.horario_trabalho_barbeiro_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='diaSemana')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_dia_semana') THEN
      ALTER TABLE "horario_trabalho" RENAME COLUMN "diaSemana" TO "horario_trabalho_dia_semana";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='diaSemana')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_dia_semana') THEN
      RAISE EXCEPTION 'Colunas duplicadas: horario_trabalho.diaSemana e horario_trabalho.horario_trabalho_dia_semana.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horaInicio')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_hora_inicio') THEN
      ALTER TABLE "horario_trabalho" RENAME COLUMN "horaInicio" TO "horario_trabalho_hora_inicio";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horaInicio')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_hora_inicio') THEN
      RAISE EXCEPTION 'Colunas duplicadas: horario_trabalho.horaInicio e horario_trabalho.horario_trabalho_hora_inicio.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horaFim')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_hora_fim') THEN
      ALTER TABLE "horario_trabalho" RENAME COLUMN "horaFim" TO "horario_trabalho_hora_fim";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horaFim')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_hora_fim') THEN
      RAISE EXCEPTION 'Colunas duplicadas: horario_trabalho.horaFim e horario_trabalho.horario_trabalho_hora_fim.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='validoDesde')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_valido_desde') THEN
      ALTER TABLE "horario_trabalho" RENAME COLUMN "validoDesde" TO "horario_trabalho_valido_desde";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='validoDesde')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_valido_desde') THEN
      RAISE EXCEPTION 'Colunas duplicadas: horario_trabalho.validoDesde e horario_trabalho.horario_trabalho_valido_desde.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='validoAte')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_valido_ate') THEN
      ALTER TABLE "horario_trabalho" RENAME COLUMN "validoAte" TO "horario_trabalho_valido_ate";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='validoAte')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_valido_ate') THEN
      RAISE EXCEPTION 'Colunas duplicadas: horario_trabalho.validoAte e horario_trabalho.horario_trabalho_valido_ate.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='estaAtivo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_esta_ativo') THEN
      ALTER TABLE "horario_trabalho" RENAME COLUMN "estaAtivo" TO "horario_trabalho_esta_ativo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='estaAtivo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='horario_trabalho' AND column_name='horario_trabalho_esta_ativo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: horario_trabalho.estaAtivo e horario_trabalho.horario_trabalho_esta_ativo.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'bloqueio_agenda')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_id') THEN
      ALTER TABLE "bloqueio_agenda" RENAME COLUMN "id" TO "bloqueio_agenda_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: bloqueio_agenda.id e bloqueio_agenda.bloqueio_agenda_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='barbeiroId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_barbeiro_id') THEN
      ALTER TABLE "bloqueio_agenda" RENAME COLUMN "barbeiroId" TO "bloqueio_agenda_barbeiro_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='barbeiroId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_barbeiro_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: bloqueio_agenda.barbeiroId e bloqueio_agenda.bloqueio_agenda_barbeiro_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='inicioEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_inicio_em') THEN
      ALTER TABLE "bloqueio_agenda" RENAME COLUMN "inicioEm" TO "bloqueio_agenda_inicio_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='inicioEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_inicio_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: bloqueio_agenda.inicioEm e bloqueio_agenda.bloqueio_agenda_inicio_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='fimEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_fim_em') THEN
      ALTER TABLE "bloqueio_agenda" RENAME COLUMN "fimEm" TO "bloqueio_agenda_fim_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='fimEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_fim_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: bloqueio_agenda.fimEm e bloqueio_agenda.bloqueio_agenda_fim_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='motivo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_motivo') THEN
      ALTER TABLE "bloqueio_agenda" RENAME COLUMN "motivo" TO "bloqueio_agenda_motivo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='motivo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_motivo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: bloqueio_agenda.motivo e bloqueio_agenda.bloqueio_agenda_motivo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='criadoPor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_criado_por') THEN
      ALTER TABLE "bloqueio_agenda" RENAME COLUMN "criadoPor" TO "bloqueio_agenda_criado_por";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='criadoPor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_criado_por') THEN
      RAISE EXCEPTION 'Colunas duplicadas: bloqueio_agenda.criadoPor e bloqueio_agenda.bloqueio_agenda_criado_por.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_criado_em') THEN
      ALTER TABLE "bloqueio_agenda" RENAME COLUMN "criadoEm" TO "bloqueio_agenda_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='bloqueio_agenda' AND column_name='bloqueio_agenda_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: bloqueio_agenda.criadoEm e bloqueio_agenda.bloqueio_agenda_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'agendamento')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_id') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "id" TO "agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.id e agendamento.agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='barbeariaId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_barbearia_id') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "barbeariaId" TO "agendamento_barbearia_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='barbeariaId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_barbearia_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.barbeariaId e agendamento.agendamento_barbearia_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='codigoConfirmacao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_codigo_confirmacao') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "codigoConfirmacao" TO "agendamento_codigo_confirmacao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='codigoConfirmacao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_codigo_confirmacao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.codigoConfirmacao e agendamento.agendamento_codigo_confirmacao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_usuario_id') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "usuarioId" TO "agendamento_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.usuarioId e agendamento.agendamento_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='barbeiroId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_barbeiro_id') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "barbeiroId" TO "agendamento_barbeiro_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='barbeiroId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_barbeiro_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.barbeiroId e agendamento.agendamento_barbeiro_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='servicoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_servico_id') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "servicoId" TO "agendamento_servico_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='servicoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_servico_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.servicoId e agendamento.agendamento_servico_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='inicioAgendado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_inicio_agendado') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "inicioAgendado" TO "agendamento_inicio_agendado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='inicioAgendado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_inicio_agendado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.inicioAgendado e agendamento.agendamento_inicio_agendado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='fimAgendado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_fim_agendado') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "fimAgendado" TO "agendamento_fim_agendado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='fimAgendado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_fim_agendado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.fimAgendado e agendamento.agendamento_fim_agendado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='status')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_status') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "status" TO "agendamento_status";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='status')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_status') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.status e agendamento.agendamento_status.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='origem')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_origem') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "origem" TO "agendamento_origem";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='origem')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_origem') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.origem e agendamento.agendamento_origem.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='criadoPor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_criado_por') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "criadoPor" TO "agendamento_criado_por";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='criadoPor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_criado_por') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.criadoPor e agendamento.agendamento_criado_por.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='confirmadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_confirmado_em') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "confirmadoEm" TO "agendamento_confirmado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='confirmadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_confirmado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.confirmadoEm e agendamento.agendamento_confirmado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='canceladoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_cancelado_em') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "canceladoEm" TO "agendamento_cancelado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='canceladoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_cancelado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.canceladoEm e agendamento.agendamento_cancelado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='motivoCancelamento')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_motivo_cancelamento') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "motivoCancelamento" TO "agendamento_motivo_cancelamento";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='motivoCancelamento')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_motivo_cancelamento') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.motivoCancelamento e agendamento.agendamento_motivo_cancelamento.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='observacaoLegado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_observacao_legado') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "observacaoLegado" TO "agendamento_observacao_legado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='observacaoLegado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_observacao_legado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.observacaoLegado e agendamento.agendamento_observacao_legado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='versaoRegistro')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_versao_registro') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "versaoRegistro" TO "agendamento_versao_registro";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='versaoRegistro')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_versao_registro') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.versaoRegistro e agendamento.agendamento_versao_registro.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_criado_em') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "criadoEm" TO "agendamento_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.criadoEm e agendamento.agendamento_criado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_atualizado_em') THEN
      ALTER TABLE "agendamento" RENAME COLUMN "atualizadoEm" TO "agendamento_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='agendamento' AND column_name='agendamento_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: agendamento.atualizadoEm e agendamento.agendamento_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'servico_agendamento')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_id') THEN
      ALTER TABLE "servico_agendamento" RENAME COLUMN "id" TO "servico_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_agendamento.id e servico_agendamento.servico_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='agendamentoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_agendamento_id') THEN
      ALTER TABLE "servico_agendamento" RENAME COLUMN "agendamentoId" TO "servico_agendamento_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='agendamentoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_agendamento.agendamentoId e servico_agendamento.servico_agendamento_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servicoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_servico_id') THEN
      ALTER TABLE "servico_agendamento" RENAME COLUMN "servicoId" TO "servico_agendamento_servico_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servicoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_servico_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_agendamento.servicoId e servico_agendamento.servico_agendamento_servico_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='preco')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_preco') THEN
      ALTER TABLE "servico_agendamento" RENAME COLUMN "preco" TO "servico_agendamento_preco";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='preco')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_preco') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_agendamento.preco e servico_agendamento.servico_agendamento_preco.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='duracaoMinutos')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_duracao_minutos') THEN
      ALTER TABLE "servico_agendamento" RENAME COLUMN "duracaoMinutos" TO "servico_agendamento_duracao_minutos";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='duracaoMinutos')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='servico_agendamento' AND column_name='servico_agendamento_duracao_minutos') THEN
      RAISE EXCEPTION 'Colunas duplicadas: servico_agendamento.duracaoMinutos e servico_agendamento.servico_agendamento_duracao_minutos.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'historico_agendamento')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_id') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "id" TO "historico_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.id e historico_agendamento.historico_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='agendamentoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_agendamento_id') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "agendamentoId" TO "historico_agendamento_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='agendamentoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.agendamentoId e historico_agendamento.historico_agendamento_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='alteradoPor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_alterado_por') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "alteradoPor" TO "historico_agendamento_alterado_por";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='alteradoPor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_alterado_por') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.alteradoPor e historico_agendamento.historico_agendamento_alterado_por.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='acao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_acao') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "acao" TO "historico_agendamento_acao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='acao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_acao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.acao e historico_agendamento.historico_agendamento_acao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='inicioAnterior')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_inicio_anterior') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "inicioAnterior" TO "historico_agendamento_inicio_anterior";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='inicioAnterior')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_inicio_anterior') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.inicioAnterior e historico_agendamento.historico_agendamento_inicio_anterior.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='novoInicio')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_novo_inicio') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "novoInicio" TO "historico_agendamento_novo_inicio";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='novoInicio')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_novo_inicio') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.novoInicio e historico_agendamento.historico_agendamento_novo_inicio.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='barbeiroAnteriorId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_barbeiro_anterior_id') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "barbeiroAnteriorId" TO "historico_agendamento_barbeiro_anterior_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='barbeiroAnteriorId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_barbeiro_anterior_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.barbeiroAnteriorId e historico_agendamento.historico_agendamento_barbeiro_anterior_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='novoBarbeiroId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_novo_barbeiro_id') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "novoBarbeiroId" TO "historico_agendamento_novo_barbeiro_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='novoBarbeiroId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_novo_barbeiro_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.novoBarbeiroId e historico_agendamento.historico_agendamento_novo_barbeiro_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='statusAnterior')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_status_anterior') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "statusAnterior" TO "historico_agendamento_status_anterior";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='statusAnterior')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_status_anterior') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.statusAnterior e historico_agendamento.historico_agendamento_status_anterior.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='novoStatus')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_novo_status') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "novoStatus" TO "historico_agendamento_novo_status";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='novoStatus')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_novo_status') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.novoStatus e historico_agendamento.historico_agendamento_novo_status.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='motivo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_motivo') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "motivo" TO "historico_agendamento_motivo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='motivo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_motivo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.motivo e historico_agendamento.historico_agendamento_motivo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_criado_em') THEN
      ALTER TABLE "historico_agendamento" RENAME COLUMN "criadoEm" TO "historico_agendamento_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='historico_agendamento' AND column_name='historico_agendamento_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: historico_agendamento.criadoEm e historico_agendamento.historico_agendamento_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'observacao_agendamento')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_id') THEN
      ALTER TABLE "observacao_agendamento" RENAME COLUMN "id" TO "observacao_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: observacao_agendamento.id e observacao_agendamento.observacao_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='agendamentoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_agendamento_id') THEN
      ALTER TABLE "observacao_agendamento" RENAME COLUMN "agendamentoId" TO "observacao_agendamento_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='agendamentoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: observacao_agendamento.agendamentoId e observacao_agendamento.observacao_agendamento_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='autorId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_autor_id') THEN
      ALTER TABLE "observacao_agendamento" RENAME COLUMN "autorId" TO "observacao_agendamento_autor_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='autorId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_autor_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: observacao_agendamento.autorId e observacao_agendamento.observacao_agendamento_autor_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacaoCriptografada')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_observacao_criptografada') THEN
      ALTER TABLE "observacao_agendamento" RENAME COLUMN "observacaoCriptografada" TO "observacao_agendamento_observacao_criptografada";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacaoCriptografada')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_observacao_criptografada') THEN
      RAISE EXCEPTION 'Colunas duplicadas: observacao_agendamento.observacaoCriptografada e observacao_agendamento.observacao_agendamento_observacao_criptografada.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='versaoChaveCriptografia')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_versao_chave_criptografia') THEN
      ALTER TABLE "observacao_agendamento" RENAME COLUMN "versaoChaveCriptografia" TO "observacao_agendamento_versao_chave_criptografia";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='versaoChaveCriptografia')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_versao_chave_criptografia') THEN
      RAISE EXCEPTION 'Colunas duplicadas: observacao_agendamento.versaoChaveCriptografia e observacao_agendamento.observacao_agendamento_versao_chave_criptografia.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_criado_em') THEN
      ALTER TABLE "observacao_agendamento" RENAME COLUMN "criadoEm" TO "observacao_agendamento_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='observacao_agendamento' AND column_name='observacao_agendamento_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: observacao_agendamento.criadoEm e observacao_agendamento.observacao_agendamento_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'notificacao')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_id') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "id" TO "notificacao_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.id e notificacao.notificacao_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_usuario_id') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "usuarioId" TO "notificacao_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.usuarioId e notificacao.notificacao_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='agendamentoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_agendamento_id') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "agendamentoId" TO "notificacao_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='agendamentoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.agendamentoId e notificacao.notificacao_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='canal')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_canal') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "canal" TO "notificacao_canal";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='canal')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_canal') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.canal e notificacao.notificacao_canal.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='tipo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_tipo') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "tipo" TO "notificacao_tipo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='tipo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_tipo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.tipo e notificacao.notificacao_tipo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='provedor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_provedor') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "provedor" TO "notificacao_provedor";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='provedor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_provedor') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.provedor e notificacao.notificacao_provedor.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='idMensagemProvedor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_id_mensagem_provedor') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "idMensagemProvedor" TO "notificacao_id_mensagem_provedor";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='idMensagemProvedor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_id_mensagem_provedor') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.idMensagemProvedor e notificacao.notificacao_id_mensagem_provedor.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='status')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_status') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "status" TO "notificacao_status";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='status')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_status') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.status e notificacao.notificacao_status.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='conteudoCriptografado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_conteudo_criptografado') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "conteudoCriptografado" TO "notificacao_conteudo_criptografado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='conteudoCriptografado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_conteudo_criptografado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.conteudoCriptografado e notificacao.notificacao_conteudo_criptografado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='respostaCriptografada')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_resposta_criptografada') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "respostaCriptografada" TO "notificacao_resposta_criptografada";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='respostaCriptografada')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_resposta_criptografada') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.respostaCriptografada e notificacao.notificacao_resposta_criptografada.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='versaoChaveCriptografia')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_versao_chave_criptografia') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "versaoChaveCriptografia" TO "notificacao_versao_chave_criptografia";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='versaoChaveCriptografia')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_versao_chave_criptografia') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.versaoChaveCriptografia e notificacao.notificacao_versao_chave_criptografia.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='enviadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_enviado_em') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "enviadoEm" TO "notificacao_enviado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='enviadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_enviado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.enviadoEm e notificacao.notificacao_enviado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='entregueEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_entregue_em') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "entregueEm" TO "notificacao_entregue_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='entregueEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_entregue_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.entregueEm e notificacao.notificacao_entregue_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='lidoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_lido_em') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "lidoEm" TO "notificacao_lido_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='lidoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_lido_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.lidoEm e notificacao.notificacao_lido_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='falhouEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_falhou_em') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "falhouEm" TO "notificacao_falhou_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='falhouEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_falhou_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.falhouEm e notificacao.notificacao_falhou_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='respondidoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_respondido_em') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "respondidoEm" TO "notificacao_respondido_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='respondidoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_respondido_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.respondidoEm e notificacao.notificacao_respondido_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_criado_em') THEN
      ALTER TABLE "notificacao" RENAME COLUMN "criadoEm" TO "notificacao_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='notificacao' AND column_name='notificacao_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: notificacao.criadoEm e notificacao.notificacao_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'log_auditoria')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_id') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "id" TO "log_auditoria_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.id e log_auditoria.log_auditoria_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='usuarioAtorId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_usuario_ator_id') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "usuarioAtorId" TO "log_auditoria_usuario_ator_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='usuarioAtorId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_usuario_ator_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.usuarioAtorId e log_auditoria.log_auditoria_usuario_ator_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='tipoEvento')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_tipo_evento') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "tipoEvento" TO "log_auditoria_tipo_evento";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='tipoEvento')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_tipo_evento') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.tipoEvento e log_auditoria.log_auditoria_tipo_evento.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='tipoEntidade')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_tipo_entidade') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "tipoEntidade" TO "log_auditoria_tipo_entidade";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='tipoEntidade')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_tipo_entidade') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.tipoEntidade e log_auditoria.log_auditoria_tipo_entidade.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='entidadeId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_entidade_id') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "entidadeId" TO "log_auditoria_entidade_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='entidadeId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_entidade_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.entidadeId e log_auditoria.log_auditoria_entidade_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='resultado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_resultado') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "resultado" TO "log_auditoria_resultado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='resultado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_resultado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.resultado e log_auditoria.log_auditoria_resultado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='enderecoIp')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_endereco_ip') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "enderecoIp" TO "log_auditoria_endereco_ip";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='enderecoIp')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_endereco_ip') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.enderecoIp e log_auditoria.log_auditoria_endereco_ip.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='agenteUsuario')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_agente_usuario') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "agenteUsuario" TO "log_auditoria_agente_usuario";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='agenteUsuario')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_agente_usuario') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.agenteUsuario e log_auditoria.log_auditoria_agente_usuario.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='requisicaoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_requisicao_id') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "requisicaoId" TO "log_auditoria_requisicao_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='requisicaoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_requisicao_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.requisicaoId e log_auditoria.log_auditoria_requisicao_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='metadados')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_metadados') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "metadados" TO "log_auditoria_metadados";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='metadados')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_metadados') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.metadados e log_auditoria.log_auditoria_metadados.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='hashEventoAnterior')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_hash_evento_anterior') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "hashEventoAnterior" TO "log_auditoria_hash_evento_anterior";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='hashEventoAnterior')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_hash_evento_anterior') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.hashEventoAnterior e log_auditoria.log_auditoria_hash_evento_anterior.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='hashEvento')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_hash_evento') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "hashEvento" TO "log_auditoria_hash_evento";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='hashEvento')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_hash_evento') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.hashEvento e log_auditoria.log_auditoria_hash_evento.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_criado_em') THEN
      ALTER TABLE "log_auditoria" RENAME COLUMN "criadoEm" TO "log_auditoria_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_auditoria' AND column_name='log_auditoria_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_auditoria.criadoEm e log_auditoria.log_auditoria_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'log_acesso_dado_sensivel')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_id') THEN
      ALTER TABLE "log_acesso_dado_sensivel" RENAME COLUMN "id" TO "log_acesso_dado_sensivel_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_acesso_dado_sensivel.id e log_acesso_dado_sensivel.log_acesso_dado_sensivel_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='usuarioAtorId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_usuario_ator_id') THEN
      ALTER TABLE "log_acesso_dado_sensivel" RENAME COLUMN "usuarioAtorId" TO "log_acesso_dado_sensivel_usuario_ator_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='usuarioAtorId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_usuario_ator_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_acesso_dado_sensivel.usuarioAtorId e log_acesso_dado_sensivel.log_acesso_dado_sensivel_usuario_ator_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='usuarioTitularId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_usuario_titular_id') THEN
      ALTER TABLE "log_acesso_dado_sensivel" RENAME COLUMN "usuarioTitularId" TO "log_acesso_dado_sensivel_usuario_titular_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='usuarioTitularId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_usuario_titular_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_acesso_dado_sensivel.usuarioTitularId e log_acesso_dado_sensivel.log_acesso_dado_sensivel_usuario_titular_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='categoriaDado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_categoria_dado') THEN
      ALTER TABLE "log_acesso_dado_sensivel" RENAME COLUMN "categoriaDado" TO "log_acesso_dado_sensivel_categoria_dado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='categoriaDado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_categoria_dado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_acesso_dado_sensivel.categoriaDado e log_acesso_dado_sensivel.log_acesso_dado_sensivel_categoria_dado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='finalidade')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_finalidade') THEN
      ALTER TABLE "log_acesso_dado_sensivel" RENAME COLUMN "finalidade" TO "log_acesso_dado_sensivel_finalidade";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='finalidade')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_finalidade') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_acesso_dado_sensivel.finalidade e log_acesso_dado_sensivel.log_acesso_dado_sensivel_finalidade.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='acao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_acao') THEN
      ALTER TABLE "log_acesso_dado_sensivel" RENAME COLUMN "acao" TO "log_acesso_dado_sensivel_acao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='acao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_acao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_acesso_dado_sensivel.acao e log_acesso_dado_sensivel.log_acesso_dado_sensivel_acao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='requisicaoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_requisicao_id') THEN
      ALTER TABLE "log_acesso_dado_sensivel" RENAME COLUMN "requisicaoId" TO "log_acesso_dado_sensivel_requisicao_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='requisicaoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_requisicao_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_acesso_dado_sensivel.requisicaoId e log_acesso_dado_sensivel.log_acesso_dado_sensivel_requisicao_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_criado_em') THEN
      ALTER TABLE "log_acesso_dado_sensivel" RENAME COLUMN "criadoEm" TO "log_acesso_dado_sensivel_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='log_acesso_dado_sensivel' AND column_name='log_acesso_dado_sensivel_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: log_acesso_dado_sensivel.criadoEm e log_acesso_dado_sensivel.log_acesso_dado_sensivel_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'consentimento_privacidade')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_id') THEN
      ALTER TABLE "consentimento_privacidade" RENAME COLUMN "id" TO "consentimento_privacidade_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: consentimento_privacidade.id e consentimento_privacidade.consentimento_privacidade_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_usuario_id') THEN
      ALTER TABLE "consentimento_privacidade" RENAME COLUMN "usuarioId" TO "consentimento_privacidade_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: consentimento_privacidade.usuarioId e consentimento_privacidade.consentimento_privacidade_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='codigoFinalidade')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_codigo_finalidade') THEN
      ALTER TABLE "consentimento_privacidade" RENAME COLUMN "codigoFinalidade" TO "consentimento_privacidade_codigo_finalidade";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='codigoFinalidade')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_codigo_finalidade') THEN
      RAISE EXCEPTION 'Colunas duplicadas: consentimento_privacidade.codigoFinalidade e consentimento_privacidade.consentimento_privacidade_codigo_finalidade.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='versao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_versao') THEN
      ALTER TABLE "consentimento_privacidade" RENAME COLUMN "versao" TO "consentimento_privacidade_versao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='versao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_versao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: consentimento_privacidade.versao e consentimento_privacidade.consentimento_privacidade_versao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='concedido')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_concedido') THEN
      ALTER TABLE "consentimento_privacidade" RENAME COLUMN "concedido" TO "consentimento_privacidade_concedido";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='concedido')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_concedido') THEN
      RAISE EXCEPTION 'Colunas duplicadas: consentimento_privacidade.concedido e consentimento_privacidade.consentimento_privacidade_concedido.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='registradoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_registrado_em') THEN
      ALTER TABLE "consentimento_privacidade" RENAME COLUMN "registradoEm" TO "consentimento_privacidade_registrado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='registradoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_registrado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: consentimento_privacidade.registradoEm e consentimento_privacidade.consentimento_privacidade_registrado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='revogadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_revogado_em') THEN
      ALTER TABLE "consentimento_privacidade" RENAME COLUMN "revogadoEm" TO "consentimento_privacidade_revogado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='revogadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_revogado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: consentimento_privacidade.revogadoEm e consentimento_privacidade.consentimento_privacidade_revogado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='evidencia')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_evidencia') THEN
      ALTER TABLE "consentimento_privacidade" RENAME COLUMN "evidencia" TO "consentimento_privacidade_evidencia";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='evidencia')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='consentimento_privacidade' AND column_name='consentimento_privacidade_evidencia') THEN
      RAISE EXCEPTION 'Colunas duplicadas: consentimento_privacidade.evidencia e consentimento_privacidade.consentimento_privacidade_evidencia.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'solicitacao_privacidade')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_id') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "id" TO "solicitacao_privacidade_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.id e solicitacao_privacidade.solicitacao_privacidade_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_usuario_id') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "usuarioId" TO "solicitacao_privacidade_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.usuarioId e solicitacao_privacidade.solicitacao_privacidade_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='tipo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_tipo') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "tipo" TO "solicitacao_privacidade_tipo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='tipo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_tipo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.tipo e solicitacao_privacidade.solicitacao_privacidade_tipo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='status')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_status') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "status" TO "solicitacao_privacidade_status";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='status')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_status') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.status e solicitacao_privacidade.solicitacao_privacidade_status.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='abertoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_aberto_em') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "abertoEm" TO "solicitacao_privacidade_aberto_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='abertoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_aberto_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.abertoEm e solicitacao_privacidade.solicitacao_privacidade_aberto_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='prazoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_prazo_em') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "prazoEm" TO "solicitacao_privacidade_prazo_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='prazoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_prazo_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.prazoEm e solicitacao_privacidade.solicitacao_privacidade_prazo_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='concluidoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_concluido_em') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "concluidoEm" TO "solicitacao_privacidade_concluido_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='concluidoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_concluido_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.concluidoEm e solicitacao_privacidade.solicitacao_privacidade_concluido_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='tratadoPor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_tratado_por') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "tratadoPor" TO "solicitacao_privacidade_tratado_por";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='tratadoPor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_tratado_por') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.tratadoPor e solicitacao_privacidade.solicitacao_privacidade_tratado_por.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='observacoes')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_observacoes') THEN
      ALTER TABLE "solicitacao_privacidade" RENAME COLUMN "observacoes" TO "solicitacao_privacidade_observacoes";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='observacoes')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='solicitacao_privacidade' AND column_name='solicitacao_privacidade_observacoes') THEN
      RAISE EXCEPTION 'Colunas duplicadas: solicitacao_privacidade.observacoes e solicitacao_privacidade.solicitacao_privacidade_observacoes.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'politica_retencao_dados')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_id') THEN
      ALTER TABLE "politica_retencao_dados" RENAME COLUMN "id" TO "politica_retencao_dados_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: politica_retencao_dados.id e politica_retencao_dados.politica_retencao_dados_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='categoriaDado')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_categoria_dado') THEN
      ALTER TABLE "politica_retencao_dados" RENAME COLUMN "categoriaDado" TO "politica_retencao_dados_categoria_dado";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='categoriaDado')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_categoria_dado') THEN
      RAISE EXCEPTION 'Colunas duplicadas: politica_retencao_dados.categoriaDado e politica_retencao_dados.politica_retencao_dados_categoria_dado.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='diasRetencao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_dias_retencao') THEN
      ALTER TABLE "politica_retencao_dados" RENAME COLUMN "diasRetencao" TO "politica_retencao_dados_dias_retencao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='diasRetencao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_dias_retencao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: politica_retencao_dados.diasRetencao e politica_retencao_dados.politica_retencao_dados_dias_retencao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='baseLegal')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_base_legal') THEN
      ALTER TABLE "politica_retencao_dados" RENAME COLUMN "baseLegal" TO "politica_retencao_dados_base_legal";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='baseLegal')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_base_legal') THEN
      RAISE EXCEPTION 'Colunas duplicadas: politica_retencao_dados.baseLegal e politica_retencao_dados.politica_retencao_dados_base_legal.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='anonimizarAposExpiracao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_anonimizar_apos_expiracao') THEN
      ALTER TABLE "politica_retencao_dados" RENAME COLUMN "anonimizarAposExpiracao" TO "politica_retencao_dados_anonimizar_apos_expiracao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='anonimizarAposExpiracao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_anonimizar_apos_expiracao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: politica_retencao_dados.anonimizarAposExpiracao e politica_retencao_dados.politica_retencao_dados_anonimizar_apos_expiracao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='descricao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_descricao') THEN
      ALTER TABLE "politica_retencao_dados" RENAME COLUMN "descricao" TO "politica_retencao_dados_descricao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='descricao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_descricao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: politica_retencao_dados.descricao e politica_retencao_dados.politica_retencao_dados_descricao.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_atualizado_em') THEN
      ALTER TABLE "politica_retencao_dados" RENAME COLUMN "atualizadoEm" TO "politica_retencao_dados_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='politica_retencao_dados' AND column_name='politica_retencao_dados_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: politica_retencao_dados.atualizadoEm e politica_retencao_dados.politica_retencao_dados_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'pagamento')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_id') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "id" TO "pagamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.id e pagamento.pagamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='agendamentoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_agendamento_id') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "agendamentoId" TO "pagamento_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='agendamentoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.agendamentoId e pagamento.pagamento_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='clienteId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_cliente_id') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "clienteId" TO "pagamento_cliente_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='clienteId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_cliente_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.clienteId e pagamento.pagamento_cliente_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='valor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_valor') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "valor" TO "pagamento_valor";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='valor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_valor') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.valor e pagamento.pagamento_valor.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='status')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_status') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "status" TO "pagamento_status";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='status')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_status') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.status e pagamento.pagamento_status.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='metodo')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_metodo') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "metodo" TO "pagamento_metodo";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='metodo')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_metodo') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.metodo e pagamento.pagamento_metodo.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='provedor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_provedor') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "provedor" TO "pagamento_provedor";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='provedor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_provedor') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.provedor e pagamento.pagamento_provedor.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='idTransacaoProvedor')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_id_transacao_provedor') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "idTransacaoProvedor" TO "pagamento_id_transacao_provedor";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='idTransacaoProvedor')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_id_transacao_provedor') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.idTransacaoProvedor e pagamento.pagamento_id_transacao_provedor.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_pago_em') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "pagoEm" TO "pagamento_pago_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_pago_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.pagoEm e pagamento.pagamento_pago_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_criado_em') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "criadoEm" TO "pagamento_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.criadoEm e pagamento.pagamento_criado_em.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='atualizadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_atualizado_em') THEN
      ALTER TABLE "pagamento" RENAME COLUMN "atualizadoEm" TO "pagamento_atualizado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='atualizadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='pagamento' AND column_name='pagamento_atualizado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: pagamento.atualizadoEm e pagamento.pagamento_atualizado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'avaliacao')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_id') THEN
      ALTER TABLE "avaliacao" RENAME COLUMN "id" TO "avaliacao_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: avaliacao.id e avaliacao.avaliacao_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='agendamentoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_agendamento_id') THEN
      ALTER TABLE "avaliacao" RENAME COLUMN "agendamentoId" TO "avaliacao_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='agendamentoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: avaliacao.agendamentoId e avaliacao.avaliacao_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='clienteId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_cliente_id') THEN
      ALTER TABLE "avaliacao" RENAME COLUMN "clienteId" TO "avaliacao_cliente_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='clienteId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_cliente_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: avaliacao.clienteId e avaliacao.avaliacao_cliente_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='barbeiroId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_barbeiro_id') THEN
      ALTER TABLE "avaliacao" RENAME COLUMN "barbeiroId" TO "avaliacao_barbeiro_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='barbeiroId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_barbeiro_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: avaliacao.barbeiroId e avaliacao.avaliacao_barbeiro_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='nota')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_nota') THEN
      ALTER TABLE "avaliacao" RENAME COLUMN "nota" TO "avaliacao_nota";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='nota')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_nota') THEN
      RAISE EXCEPTION 'Colunas duplicadas: avaliacao.nota e avaliacao.avaliacao_nota.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='comentario')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_comentario') THEN
      ALTER TABLE "avaliacao" RENAME COLUMN "comentario" TO "avaliacao_comentario";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='comentario')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_comentario') THEN
      RAISE EXCEPTION 'Colunas duplicadas: avaliacao.comentario e avaliacao.avaliacao_comentario.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_criado_em') THEN
      ALTER TABLE "avaliacao" RENAME COLUMN "criadoEm" TO "avaliacao_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='avaliacao' AND column_name='avaliacao_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: avaliacao.criadoEm e avaliacao.avaliacao_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'comanda')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_id') THEN
      ALTER TABLE "comanda" RENAME COLUMN "id" TO "comanda_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: comanda.id e comanda.comanda_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='barbeariaId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_barbearia_id') THEN
      ALTER TABLE "comanda" RENAME COLUMN "barbeariaId" TO "comanda_barbearia_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='barbeariaId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_barbearia_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: comanda.barbeariaId e comanda.comanda_barbearia_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='usuarioId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_usuario_id') THEN
      ALTER TABLE "comanda" RENAME COLUMN "usuarioId" TO "comanda_usuario_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='usuarioId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_usuario_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: comanda.usuarioId e comanda.comanda_usuario_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='agendamentoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_agendamento_id') THEN
      ALTER TABLE "comanda" RENAME COLUMN "agendamentoId" TO "comanda_agendamento_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='agendamentoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_agendamento_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: comanda.agendamentoId e comanda.comanda_agendamento_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='valorTotal')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_valor_total') THEN
      ALTER TABLE "comanda" RENAME COLUMN "valorTotal" TO "comanda_valor_total";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='valorTotal')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_valor_total') THEN
      RAISE EXCEPTION 'Colunas duplicadas: comanda.valorTotal e comanda.comanda_valor_total.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='status')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_status') THEN
      ALTER TABLE "comanda" RENAME COLUMN "status" TO "comanda_status";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='status')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_status') THEN
      RAISE EXCEPTION 'Colunas duplicadas: comanda.status e comanda.comanda_status.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='formaPagto')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_forma_pagto') THEN
      ALTER TABLE "comanda" RENAME COLUMN "formaPagto" TO "comanda_forma_pagto";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='formaPagto')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_forma_pagto') THEN
      RAISE EXCEPTION 'Colunas duplicadas: comanda.formaPagto e comanda.comanda_forma_pagto.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='criadoEm')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_criado_em') THEN
      ALTER TABLE "comanda" RENAME COLUMN "criadoEm" TO "comanda_criado_em";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='criadoEm')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='comanda' AND column_name='comanda_criado_em') THEN
      RAISE EXCEPTION 'Colunas duplicadas: comanda.criadoEm e comanda.comanda_criado_em.';
    END IF;

  END IF;

END $$;

DO $$

BEGIN

  IF to_regclass(format('%I', 'item_comanda')) IS NOT NULL THEN

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='id')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_id') THEN
      ALTER TABLE "item_comanda" RENAME COLUMN "id" TO "item_comanda_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='id')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: item_comanda.id e item_comanda.item_comanda_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='comandaId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_comanda_id') THEN
      ALTER TABLE "item_comanda" RENAME COLUMN "comandaId" TO "item_comanda_comanda_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='comandaId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_comanda_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: item_comanda.comandaId e item_comanda.item_comanda_comanda_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='servicoId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_servico_id') THEN
      ALTER TABLE "item_comanda" RENAME COLUMN "servicoId" TO "item_comanda_servico_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='servicoId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_servico_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: item_comanda.servicoId e item_comanda.item_comanda_servico_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='barbeiroId')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_barbeiro_id') THEN
      ALTER TABLE "item_comanda" RENAME COLUMN "barbeiroId" TO "item_comanda_barbeiro_id";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='barbeiroId')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_barbeiro_id') THEN
      RAISE EXCEPTION 'Colunas duplicadas: item_comanda.barbeiroId e item_comanda.item_comanda_barbeiro_id.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='preco')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_preco') THEN
      ALTER TABLE "item_comanda" RENAME COLUMN "preco" TO "item_comanda_preco";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='preco')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_preco') THEN
      RAISE EXCEPTION 'Colunas duplicadas: item_comanda.preco e item_comanda.item_comanda_preco.';
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='comissao')
       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_comissao') THEN
      ALTER TABLE "item_comanda" RENAME COLUMN "comissao" TO "item_comanda_comissao";
    ELSIF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='comissao')
       AND EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema=current_schema() AND table_name='item_comanda' AND column_name='item_comanda_comissao') THEN
      RAISE EXCEPTION 'Colunas duplicadas: item_comanda.comissao e item_comanda.item_comanda_comissao.';
    END IF;

  END IF;

END $$;



DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname='RoleUsuario') THEN CREATE TYPE "RoleUsuario" AS ENUM ('ADMIN','CLIENTE'); END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname='StatusAgendamento') THEN CREATE TYPE "StatusAgendamento" AS ENUM ('PENDENTE','CONFIRMADO','EM_ANDAMENTO','CONCLUIDO','CANCELADO','NAO_COMPARECEU'); END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname='StatusComanda') THEN CREATE TYPE "StatusComanda" AS ENUM ('ABERTA','PAGA','CANCELADA'); END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname='StatusPagamento') THEN CREATE TYPE "StatusPagamento" AS ENUM ('PENDENTE','APROVADO','RECUSADO','ESTORNADO','CANCELADO'); END IF;
END $$;



-- Schema-base para instalação que ainda possuía somente as tabelas legadas.

DO $baseline$

BEGIN

  IF current_setting('trato_fino.legacy_mode', true) = 'true' THEN

CREATE TABLE IF NOT EXISTS "barbearia" (
  "barbearia_id" TEXT NOT NULL PRIMARY KEY,
  "barbearia_nome" TEXT NOT NULL,
  "barbearia_slug" TEXT NOT NULL,
  "barbearia_telefone" TEXT,
  "barbearia_endereco" TEXT,
  "barbearia_logo_url" TEXT,
  "barbearia_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "usuario" (
  "usuario_id" TEXT NOT NULL PRIMARY KEY,
  "usuario_barbearia_id" TEXT,
  "usuario_role" "RoleUsuario" NOT NULL,
  "usuario_esta_ativo" BOOLEAN NOT NULL DEFAULT TRUE,
  "usuario_e_equipe" BOOLEAN NOT NULL DEFAULT FALSE,
  "usuario_e_superusuario" BOOLEAN NOT NULL DEFAULT FALSE,
  "usuario_quantidade_falhas_login" INTEGER NOT NULL DEFAULT 0,
  "usuario_bloqueado_ate" TIMESTAMP(3),
  "usuario_senha_alterada_em" TIMESTAMP(3),
  "usuario_ultimo_login_em" TIMESTAMP(3),
  "usuario_excluido_em" TIMESTAMP(3),
  "usuario_anonimizado_em" TIMESTAMP(3),
  "usuario_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "usuario_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "credencial_usuario" (
  "credencial_usuario_id" TEXT NOT NULL PRIMARY KEY,
  "credencial_usuario_usuario_id" TEXT NOT NULL,
  "credencial_usuario_hash_senha" TEXT NOT NULL,
  "credencial_usuario_versao_senha" INTEGER NOT NULL DEFAULT 1,
  "credencial_usuario_mfa_habilitado" BOOLEAN NOT NULL DEFAULT FALSE,
  "credencial_usuario_senha_temporaria" BOOLEAN NOT NULL DEFAULT FALSE,
  "credencial_usuario_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "credencial_usuario_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "dados_pessoais_usuario" (
  "dados_pessoais_usuario_id" TEXT NOT NULL PRIMARY KEY,
  "dados_pessoais_usuario_usuario_id" TEXT NOT NULL,
  "dados_pessoais_usuario_nome_completo_criptografado" TEXT NOT NULL,
  "dados_pessoais_usuario_cpf_criptografado" TEXT NOT NULL,
  "dados_pessoais_usuario_hash_busca_cpf" TEXT NOT NULL,
  "dados_pessoais_usuario_email_criptografado" TEXT NOT NULL,
  "dados_pessoais_usuario_hash_busca_email" TEXT NOT NULL,
  "dados_pessoais_usuario_telefone_criptografado" TEXT,
  "dados_pessoais_usuario_hash_busca_telefone" TEXT,
  "dados_pessoais_usuario_versao_chave_criptografia" INTEGER NOT NULL DEFAULT 1,
  "dados_pessoais_usuario_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "dados_pessoais_usuario_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "perfil_acesso" (
  "perfil_acesso_id" TEXT NOT NULL PRIMARY KEY,
  "perfil_acesso_codigo" TEXT NOT NULL,
  "perfil_acesso_nome" TEXT NOT NULL,
  "perfil_acesso_descricao" TEXT,
  "perfil_acesso_e_sistema" BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE IF NOT EXISTS "permissao" (
  "permissao_id" TEXT NOT NULL PRIMARY KEY,
  "permissao_codigo" TEXT NOT NULL,
  "permissao_descricao" TEXT
);
CREATE TABLE IF NOT EXISTS "usuario_perfil" (
  "usuario_perfil_id" TEXT NOT NULL PRIMARY KEY,
  "usuario_perfil_usuario_id" TEXT NOT NULL,
  "usuario_perfil_perfil_id" TEXT NOT NULL,
  "usuario_perfil_atribuido_por" TEXT,
  "usuario_perfil_atribuido_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "perfil_permissao" (
  "perfil_permissao_id" TEXT NOT NULL PRIMARY KEY,
  "perfil_permissao_perfil_id" TEXT NOT NULL,
  "perfil_permissao_permissao_id" TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS "perfil_cliente" (
  "perfil_cliente_id" TEXT NOT NULL PRIMARY KEY,
  "perfil_cliente_usuario_id" TEXT NOT NULL,
  "perfil_cliente_observacoes_operacionais" TEXT,
  "perfil_cliente_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "perfil_cliente_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "perfil_funcionario" (
  "perfil_funcionario_id" TEXT NOT NULL PRIMARY KEY,
  "perfil_funcionario_usuario_id" TEXT NOT NULL,
  "perfil_funcionario_barbearia_id" TEXT NOT NULL,
  "perfil_funcionario_nome_exibicao" TEXT,
  "perfil_funcionario_bio" TEXT,
  "perfil_funcionario_url_foto" TEXT,
  "perfil_funcionario_data_admissao" TIMESTAMP(3),
  "perfil_funcionario_esta_disponivel" BOOLEAN NOT NULL DEFAULT TRUE,
  "perfil_funcionario_especialidade" TEXT,
  "perfil_funcionario_horario_inicio" TEXT NOT NULL DEFAULT '08:00',
  "perfil_funcionario_horario_fim" TEXT NOT NULL DEFAULT '18:00',
  "perfil_funcionario_inicio_almoco" TEXT,
  "perfil_funcionario_fim_almoco" TEXT,
  "perfil_funcionario_comissao_porcent" NUMERIC(5,2) NOT NULL DEFAULT 30,
  "perfil_funcionario_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "perfil_funcionario_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "sessao_autenticacao" (
  "sessao_autenticacao_id" TEXT NOT NULL PRIMARY KEY,
  "sessao_autenticacao_usuario_id" TEXT NOT NULL,
  "sessao_autenticacao_hash_token" TEXT NOT NULL,
  "sessao_autenticacao_hash_id_dispositivo" TEXT,
  "sessao_autenticacao_endereco_ip" TEXT,
  "sessao_autenticacao_agente_usuario" TEXT,
  "sessao_autenticacao_emitido_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "sessao_autenticacao_expira_em" TIMESTAMP(3) NOT NULL,
  "sessao_autenticacao_revogado_em" TIMESTAMP(3),
  "sessao_autenticacao_motivo_revogacao" TEXT
);
CREATE TABLE IF NOT EXISTS "token_redefinicao_senha" (
  "token_redefinicao_senha_id" TEXT NOT NULL PRIMARY KEY,
  "token_redefinicao_senha_usuario_id" TEXT NOT NULL,
  "token_redefinicao_senha_hash_token" TEXT NOT NULL,
  "token_redefinicao_senha_expira_em" TIMESTAMP(3) NOT NULL,
  "token_redefinicao_senha_usado_em" TIMESTAMP(3),
  "token_redefinicao_senha_ip_solicitacao" TEXT,
  "token_redefinicao_senha_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "tentativa_login" (
  "tentativa_login_id" TEXT NOT NULL PRIMARY KEY,
  "tentativa_login_usuario_id" TEXT,
  "tentativa_login_hash_busca_identificador" TEXT NOT NULL,
  "tentativa_login_foi_bem_sucedida" BOOLEAN NOT NULL,
  "tentativa_login_endereco_ip" TEXT,
  "tentativa_login_agente_usuario" TEXT,
  "tentativa_login_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "servico" (
  "servico_id" TEXT NOT NULL PRIMARY KEY,
  "servico_barbearia_id" TEXT NOT NULL,
  "servico_nome" TEXT NOT NULL,
  "servico_descricao" TEXT,
  "servico_preco" NUMERIC(10,2) NOT NULL,
  "servico_duracao_minutos" INTEGER NOT NULL,
  "servico_esta_ativo" BOOLEAN NOT NULL DEFAULT TRUE,
  "servico_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "servico_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "servico_barbeiro" (
  "servico_barbeiro_id" TEXT NOT NULL PRIMARY KEY,
  "servico_barbeiro_barbeiro_id" TEXT NOT NULL,
  "servico_barbeiro_servico_id" TEXT NOT NULL,
  "servico_barbeiro_preco_personalizado" NUMERIC(10,2),
  "servico_barbeiro_duracao_personalizada_minutos" INTEGER,
  "servico_barbeiro_esta_ativo" BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE IF NOT EXISTS "horario_trabalho" (
  "horario_trabalho_id" TEXT NOT NULL PRIMARY KEY,
  "horario_trabalho_barbeiro_id" TEXT NOT NULL,
  "horario_trabalho_dia_semana" INTEGER NOT NULL,
  "horario_trabalho_hora_inicio" TEXT NOT NULL,
  "horario_trabalho_hora_fim" TEXT NOT NULL,
  "horario_trabalho_valido_desde" TIMESTAMP(3),
  "horario_trabalho_valido_ate" TIMESTAMP(3),
  "horario_trabalho_esta_ativo" BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE IF NOT EXISTS "bloqueio_agenda" (
  "bloqueio_agenda_id" TEXT NOT NULL PRIMARY KEY,
  "bloqueio_agenda_barbeiro_id" TEXT NOT NULL,
  "bloqueio_agenda_inicio_em" TIMESTAMP(3) NOT NULL,
  "bloqueio_agenda_fim_em" TIMESTAMP(3) NOT NULL,
  "bloqueio_agenda_motivo" TEXT,
  "bloqueio_agenda_criado_por" TEXT NOT NULL,
  "bloqueio_agenda_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "agendamento" (
  "agendamento_id" TEXT NOT NULL PRIMARY KEY,
  "agendamento_barbearia_id" TEXT NOT NULL,
  "agendamento_codigo_confirmacao" TEXT NOT NULL,
  "agendamento_usuario_id" TEXT NOT NULL,
  "agendamento_barbeiro_id" TEXT NOT NULL,
  "agendamento_servico_id" TEXT NOT NULL,
  "agendamento_inicio_agendado" TIMESTAMP(3) NOT NULL,
  "agendamento_fim_agendado" TIMESTAMP(3) NOT NULL,
  "agendamento_status" "StatusAgendamento" NOT NULL,
  "agendamento_origem" TEXT NOT NULL DEFAULT 'TERMINAL',
  "agendamento_criado_por" TEXT NOT NULL,
  "agendamento_confirmado_em" TIMESTAMP(3),
  "agendamento_cancelado_em" TIMESTAMP(3),
  "agendamento_motivo_cancelamento" TEXT,
  "agendamento_observacao_legado" TEXT,
  "agendamento_versao_registro" INTEGER NOT NULL DEFAULT 1,
  "agendamento_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "agendamento_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "servico_agendamento" (
  "servico_agendamento_id" TEXT NOT NULL PRIMARY KEY,
  "servico_agendamento_agendamento_id" TEXT NOT NULL,
  "servico_agendamento_servico_id" TEXT NOT NULL,
  "servico_agendamento_preco" NUMERIC(10,2) NOT NULL,
  "servico_agendamento_duracao_minutos" INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS "historico_agendamento" (
  "historico_agendamento_id" TEXT NOT NULL PRIMARY KEY,
  "historico_agendamento_agendamento_id" TEXT NOT NULL,
  "historico_agendamento_alterado_por" TEXT NOT NULL,
  "historico_agendamento_acao" TEXT NOT NULL,
  "historico_agendamento_inicio_anterior" TIMESTAMP(3),
  "historico_agendamento_novo_inicio" TIMESTAMP(3),
  "historico_agendamento_barbeiro_anterior_id" TEXT,
  "historico_agendamento_novo_barbeiro_id" TEXT,
  "historico_agendamento_status_anterior" TEXT,
  "historico_agendamento_novo_status" TEXT,
  "historico_agendamento_motivo" TEXT,
  "historico_agendamento_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "observacao_agendamento" (
  "observacao_agendamento_id" TEXT NOT NULL PRIMARY KEY,
  "observacao_agendamento_agendamento_id" TEXT NOT NULL,
  "observacao_agendamento_autor_id" TEXT NOT NULL,
  "observacao_agendamento_observacao_criptografada" TEXT NOT NULL,
  "observacao_agendamento_versao_chave_criptografia" INTEGER NOT NULL DEFAULT 1,
  "observacao_agendamento_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "notificacao" (
  "notificacao_id" TEXT NOT NULL PRIMARY KEY,
  "notificacao_usuario_id" TEXT NOT NULL,
  "notificacao_agendamento_id" TEXT,
  "notificacao_canal" TEXT NOT NULL,
  "notificacao_tipo" TEXT NOT NULL,
  "notificacao_provedor" TEXT,
  "notificacao_id_mensagem_provedor" TEXT,
  "notificacao_status" TEXT NOT NULL DEFAULT 'PENDENTE',
  "notificacao_conteudo_criptografado" TEXT,
  "notificacao_resposta_criptografada" TEXT,
  "notificacao_versao_chave_criptografia" INTEGER NOT NULL DEFAULT 1,
  "notificacao_enviado_em" TIMESTAMP(3),
  "notificacao_entregue_em" TIMESTAMP(3),
  "notificacao_lido_em" TIMESTAMP(3),
  "notificacao_falhou_em" TIMESTAMP(3),
  "notificacao_respondido_em" TIMESTAMP(3),
  "notificacao_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "log_auditoria" (
  "log_auditoria_id" TEXT NOT NULL PRIMARY KEY,
  "log_auditoria_usuario_ator_id" TEXT,
  "log_auditoria_tipo_evento" TEXT NOT NULL,
  "log_auditoria_tipo_entidade" TEXT NOT NULL,
  "log_auditoria_entidade_id" TEXT,
  "log_auditoria_resultado" TEXT NOT NULL,
  "log_auditoria_endereco_ip" TEXT,
  "log_auditoria_agente_usuario" TEXT,
  "log_auditoria_requisicao_id" TEXT,
  "log_auditoria_metadados" TEXT,
  "log_auditoria_hash_evento_anterior" TEXT,
  "log_auditoria_hash_evento" TEXT,
  "log_auditoria_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "log_acesso_dado_sensivel" (
  "log_acesso_dado_sensivel_id" TEXT NOT NULL PRIMARY KEY,
  "log_acesso_dado_sensivel_usuario_ator_id" TEXT NOT NULL,
  "log_acesso_dado_sensivel_usuario_titular_id" TEXT NOT NULL,
  "log_acesso_dado_sensivel_categoria_dado" TEXT NOT NULL,
  "log_acesso_dado_sensivel_finalidade" TEXT NOT NULL,
  "log_acesso_dado_sensivel_acao" TEXT NOT NULL,
  "log_acesso_dado_sensivel_requisicao_id" TEXT,
  "log_acesso_dado_sensivel_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "consentimento_privacidade" (
  "consentimento_privacidade_id" TEXT NOT NULL PRIMARY KEY,
  "consentimento_privacidade_usuario_id" TEXT NOT NULL,
  "consentimento_privacidade_codigo_finalidade" TEXT NOT NULL,
  "consentimento_privacidade_versao" TEXT NOT NULL,
  "consentimento_privacidade_concedido" BOOLEAN NOT NULL,
  "consentimento_privacidade_registrado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "consentimento_privacidade_revogado_em" TIMESTAMP(3),
  "consentimento_privacidade_evidencia" TEXT
);
CREATE TABLE IF NOT EXISTS "solicitacao_privacidade" (
  "solicitacao_privacidade_id" TEXT NOT NULL PRIMARY KEY,
  "solicitacao_privacidade_usuario_id" TEXT NOT NULL,
  "solicitacao_privacidade_tipo" TEXT NOT NULL,
  "solicitacao_privacidade_status" TEXT NOT NULL DEFAULT 'ABERTA',
  "solicitacao_privacidade_aberto_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "solicitacao_privacidade_prazo_em" TIMESTAMP(3),
  "solicitacao_privacidade_concluido_em" TIMESTAMP(3),
  "solicitacao_privacidade_tratado_por" TEXT,
  "solicitacao_privacidade_observacoes" TEXT
);
CREATE TABLE IF NOT EXISTS "politica_retencao_dados" (
  "politica_retencao_dados_id" TEXT NOT NULL PRIMARY KEY,
  "politica_retencao_dados_categoria_dado" TEXT NOT NULL,
  "politica_retencao_dados_dias_retencao" INTEGER,
  "politica_retencao_dados_base_legal" TEXT,
  "politica_retencao_dados_anonimizar_apos_expiracao" BOOLEAN NOT NULL DEFAULT TRUE,
  "politica_retencao_dados_descricao" TEXT,
  "politica_retencao_dados_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "pagamento" (
  "pagamento_id" TEXT NOT NULL PRIMARY KEY,
  "pagamento_agendamento_id" TEXT,
  "pagamento_cliente_id" TEXT NOT NULL,
  "pagamento_valor" NUMERIC(10,2) NOT NULL,
  "pagamento_status" "StatusPagamento" NOT NULL,
  "pagamento_metodo" TEXT,
  "pagamento_provedor" TEXT,
  "pagamento_id_transacao_provedor" TEXT,
  "pagamento_pago_em" TIMESTAMP(3),
  "pagamento_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "pagamento_atualizado_em" TIMESTAMP(3) NOT NULL
);
CREATE TABLE IF NOT EXISTS "avaliacao" (
  "avaliacao_id" TEXT NOT NULL PRIMARY KEY,
  "avaliacao_agendamento_id" TEXT NOT NULL,
  "avaliacao_cliente_id" TEXT NOT NULL,
  "avaliacao_barbeiro_id" TEXT NOT NULL,
  "avaliacao_nota" INTEGER NOT NULL,
  "avaliacao_comentario" TEXT,
  "avaliacao_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "comanda" (
  "comanda_id" TEXT NOT NULL PRIMARY KEY,
  "comanda_barbearia_id" TEXT NOT NULL,
  "comanda_usuario_id" TEXT NOT NULL,
  "comanda_agendamento_id" TEXT,
  "comanda_valor_total" NUMERIC(10,2) NOT NULL DEFAULT 0,
  "comanda_status" "StatusComanda" NOT NULL,
  "comanda_forma_pagto" TEXT,
  "comanda_criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS "item_comanda" (
  "item_comanda_id" TEXT NOT NULL PRIMARY KEY,
  "item_comanda_comanda_id" TEXT NOT NULL,
  "item_comanda_servico_id" TEXT,
  "item_comanda_barbeiro_id" TEXT,
  "item_comanda_preco" NUMERIC(10,2) NOT NULL,
  "item_comanda_comissao" NUMERIC(10,2) NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS "barbearia_barbearia_slug_key" ON "barbearia" ("barbearia_slug");
CREATE UNIQUE INDEX IF NOT EXISTS "credencial_usuario_credencial_usuario_usuario_id_key" ON "credencial_usuario" ("credencial_usuario_usuario_id");
CREATE UNIQUE INDEX IF NOT EXISTS "dados_pessoais_usuario_dados_pessoais_usuario_usuario_id_key" ON "dados_pessoais_usuario" ("dados_pessoais_usuario_usuario_id");
CREATE UNIQUE INDEX IF NOT EXISTS "dados_pessoais_usuario_dados_pessoais_usuario_has_da48cc17" ON "dados_pessoais_usuario" ("dados_pessoais_usuario_hash_busca_cpf");
CREATE UNIQUE INDEX IF NOT EXISTS "dados_pessoais_usuario_dados_pessoais_usuario_has_f694e435" ON "dados_pessoais_usuario" ("dados_pessoais_usuario_hash_busca_email");
CREATE UNIQUE INDEX IF NOT EXISTS "perfil_acesso_perfil_acesso_codigo_key" ON "perfil_acesso" ("perfil_acesso_codigo");
CREATE UNIQUE INDEX IF NOT EXISTS "permissao_permissao_codigo_key" ON "permissao" ("permissao_codigo");
CREATE UNIQUE INDEX IF NOT EXISTS "usuario_perfil_usuario_perfil_usuario_id_usuario__120ef7e1" ON "usuario_perfil" ("usuario_perfil_usuario_id", "usuario_perfil_perfil_id");
CREATE UNIQUE INDEX IF NOT EXISTS "perfil_permissao_perfil_permissao_perfil_id_perfi_fc56a614" ON "perfil_permissao" ("perfil_permissao_perfil_id", "perfil_permissao_permissao_id");
CREATE UNIQUE INDEX IF NOT EXISTS "perfil_cliente_perfil_cliente_usuario_id_key" ON "perfil_cliente" ("perfil_cliente_usuario_id");
CREATE UNIQUE INDEX IF NOT EXISTS "perfil_funcionario_perfil_funcionario_usuario_id_key" ON "perfil_funcionario" ("perfil_funcionario_usuario_id");
CREATE UNIQUE INDEX IF NOT EXISTS "sessao_autenticacao_sessao_autenticacao_hash_token_key" ON "sessao_autenticacao" ("sessao_autenticacao_hash_token");
CREATE UNIQUE INDEX IF NOT EXISTS "token_redefinicao_senha_token_redefinicao_senha_h_d73bf053" ON "token_redefinicao_senha" ("token_redefinicao_senha_hash_token");
CREATE UNIQUE INDEX IF NOT EXISTS "servico_barbeiro_servico_barbeiro_barbeiro_id_ser_c74a2f85" ON "servico_barbeiro" ("servico_barbeiro_barbeiro_id", "servico_barbeiro_servico_id");
CREATE UNIQUE INDEX IF NOT EXISTS "agendamento_agendamento_codigo_confirmacao_key" ON "agendamento" ("agendamento_codigo_confirmacao");
CREATE UNIQUE INDEX IF NOT EXISTS "servico_agendamento_servico_agendamento_agendamen_4cd587aa" ON "servico_agendamento" ("servico_agendamento_agendamento_id", "servico_agendamento_servico_id");
CREATE UNIQUE INDEX IF NOT EXISTS "politica_retencao_dados_politica_retencao_dados_c_69a172ed" ON "politica_retencao_dados" ("politica_retencao_dados_categoria_dado");
CREATE UNIQUE INDEX IF NOT EXISTS "avaliacao_avaliacao_agendamento_id_key" ON "avaliacao" ("avaliacao_agendamento_id");
CREATE UNIQUE INDEX IF NOT EXISTS "comanda_comanda_agendamento_id_key" ON "comanda" ("comanda_agendamento_id");
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='usuario_usuario_barbearia_id_fkey' AND conrelid='"usuario"'::regclass) THEN
    ALTER TABLE "usuario" ADD CONSTRAINT "usuario_usuario_barbearia_id_fkey" FOREIGN KEY ("usuario_barbearia_id") REFERENCES "barbearia" ("barbearia_id") ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='credencial_usuario_credencial_usuario_usuario_id_fkey' AND conrelid='"credencial_usuario"'::regclass) THEN
    ALTER TABLE "credencial_usuario" ADD CONSTRAINT "credencial_usuario_credencial_usuario_usuario_id_fkey" FOREIGN KEY ("credencial_usuario_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='dados_pessoais_usuario_dados_pessoais_usuario_usu_53a9279b' AND conrelid='"dados_pessoais_usuario"'::regclass) THEN
    ALTER TABLE "dados_pessoais_usuario" ADD CONSTRAINT "dados_pessoais_usuario_dados_pessoais_usuario_usu_53a9279b" FOREIGN KEY ("dados_pessoais_usuario_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='usuario_perfil_usuario_perfil_usuario_id_fkey' AND conrelid='"usuario_perfil"'::regclass) THEN
    ALTER TABLE "usuario_perfil" ADD CONSTRAINT "usuario_perfil_usuario_perfil_usuario_id_fkey" FOREIGN KEY ("usuario_perfil_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='usuario_perfil_usuario_perfil_perfil_id_fkey' AND conrelid='"usuario_perfil"'::regclass) THEN
    ALTER TABLE "usuario_perfil" ADD CONSTRAINT "usuario_perfil_usuario_perfil_perfil_id_fkey" FOREIGN KEY ("usuario_perfil_perfil_id") REFERENCES "perfil_acesso" ("perfil_acesso_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='perfil_permissao_perfil_permissao_perfil_id_fkey' AND conrelid='"perfil_permissao"'::regclass) THEN
    ALTER TABLE "perfil_permissao" ADD CONSTRAINT "perfil_permissao_perfil_permissao_perfil_id_fkey" FOREIGN KEY ("perfil_permissao_perfil_id") REFERENCES "perfil_acesso" ("perfil_acesso_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='perfil_permissao_perfil_permissao_permissao_id_fkey' AND conrelid='"perfil_permissao"'::regclass) THEN
    ALTER TABLE "perfil_permissao" ADD CONSTRAINT "perfil_permissao_perfil_permissao_permissao_id_fkey" FOREIGN KEY ("perfil_permissao_permissao_id") REFERENCES "permissao" ("permissao_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='perfil_cliente_perfil_cliente_usuario_id_fkey' AND conrelid='"perfil_cliente"'::regclass) THEN
    ALTER TABLE "perfil_cliente" ADD CONSTRAINT "perfil_cliente_perfil_cliente_usuario_id_fkey" FOREIGN KEY ("perfil_cliente_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='perfil_funcionario_perfil_funcionario_usuario_id_fkey' AND conrelid='"perfil_funcionario"'::regclass) THEN
    ALTER TABLE "perfil_funcionario" ADD CONSTRAINT "perfil_funcionario_perfil_funcionario_usuario_id_fkey" FOREIGN KEY ("perfil_funcionario_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='perfil_funcionario_perfil_funcionario_barbearia_id_fkey' AND conrelid='"perfil_funcionario"'::regclass) THEN
    ALTER TABLE "perfil_funcionario" ADD CONSTRAINT "perfil_funcionario_perfil_funcionario_barbearia_id_fkey" FOREIGN KEY ("perfil_funcionario_barbearia_id") REFERENCES "barbearia" ("barbearia_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='sessao_autenticacao_sessao_autenticacao_usuario_id_fkey' AND conrelid='"sessao_autenticacao"'::regclass) THEN
    ALTER TABLE "sessao_autenticacao" ADD CONSTRAINT "sessao_autenticacao_sessao_autenticacao_usuario_id_fkey" FOREIGN KEY ("sessao_autenticacao_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='token_redefinicao_senha_token_redefinicao_senha_u_4b57c4b2' AND conrelid='"token_redefinicao_senha"'::regclass) THEN
    ALTER TABLE "token_redefinicao_senha" ADD CONSTRAINT "token_redefinicao_senha_token_redefinicao_senha_u_4b57c4b2" FOREIGN KEY ("token_redefinicao_senha_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='tentativa_login_tentativa_login_usuario_id_fkey' AND conrelid='"tentativa_login"'::regclass) THEN
    ALTER TABLE "tentativa_login" ADD CONSTRAINT "tentativa_login_tentativa_login_usuario_id_fkey" FOREIGN KEY ("tentativa_login_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='servico_servico_barbearia_id_fkey' AND conrelid='"servico"'::regclass) THEN
    ALTER TABLE "servico" ADD CONSTRAINT "servico_servico_barbearia_id_fkey" FOREIGN KEY ("servico_barbearia_id") REFERENCES "barbearia" ("barbearia_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='servico_barbeiro_servico_barbeiro_barbeiro_id_fkey' AND conrelid='"servico_barbeiro"'::regclass) THEN
    ALTER TABLE "servico_barbeiro" ADD CONSTRAINT "servico_barbeiro_servico_barbeiro_barbeiro_id_fkey" FOREIGN KEY ("servico_barbeiro_barbeiro_id") REFERENCES "perfil_funcionario" ("perfil_funcionario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='servico_barbeiro_servico_barbeiro_servico_id_fkey' AND conrelid='"servico_barbeiro"'::regclass) THEN
    ALTER TABLE "servico_barbeiro" ADD CONSTRAINT "servico_barbeiro_servico_barbeiro_servico_id_fkey" FOREIGN KEY ("servico_barbeiro_servico_id") REFERENCES "servico" ("servico_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='horario_trabalho_horario_trabalho_barbeiro_id_fkey' AND conrelid='"horario_trabalho"'::regclass) THEN
    ALTER TABLE "horario_trabalho" ADD CONSTRAINT "horario_trabalho_horario_trabalho_barbeiro_id_fkey" FOREIGN KEY ("horario_trabalho_barbeiro_id") REFERENCES "perfil_funcionario" ("perfil_funcionario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='bloqueio_agenda_bloqueio_agenda_barbeiro_id_fkey' AND conrelid='"bloqueio_agenda"'::regclass) THEN
    ALTER TABLE "bloqueio_agenda" ADD CONSTRAINT "bloqueio_agenda_bloqueio_agenda_barbeiro_id_fkey" FOREIGN KEY ("bloqueio_agenda_barbeiro_id") REFERENCES "perfil_funcionario" ("perfil_funcionario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='agendamento_agendamento_barbearia_id_fkey' AND conrelid='"agendamento"'::regclass) THEN
    ALTER TABLE "agendamento" ADD CONSTRAINT "agendamento_agendamento_barbearia_id_fkey" FOREIGN KEY ("agendamento_barbearia_id") REFERENCES "barbearia" ("barbearia_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='agendamento_agendamento_barbeiro_id_fkey' AND conrelid='"agendamento"'::regclass) THEN
    ALTER TABLE "agendamento" ADD CONSTRAINT "agendamento_agendamento_barbeiro_id_fkey" FOREIGN KEY ("agendamento_barbeiro_id") REFERENCES "perfil_funcionario" ("perfil_funcionario_id") ON DELETE RESTRICT ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='agendamento_agendamento_servico_id_fkey' AND conrelid='"agendamento"'::regclass) THEN
    ALTER TABLE "agendamento" ADD CONSTRAINT "agendamento_agendamento_servico_id_fkey" FOREIGN KEY ("agendamento_servico_id") REFERENCES "servico" ("servico_id") ON DELETE RESTRICT ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='servico_agendamento_servico_agendamento_agendamento_id_fkey' AND conrelid='"servico_agendamento"'::regclass) THEN
    ALTER TABLE "servico_agendamento" ADD CONSTRAINT "servico_agendamento_servico_agendamento_agendamento_id_fkey" FOREIGN KEY ("servico_agendamento_agendamento_id") REFERENCES "agendamento" ("agendamento_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='servico_agendamento_servico_agendamento_servico_id_fkey' AND conrelid='"servico_agendamento"'::regclass) THEN
    ALTER TABLE "servico_agendamento" ADD CONSTRAINT "servico_agendamento_servico_agendamento_servico_id_fkey" FOREIGN KEY ("servico_agendamento_servico_id") REFERENCES "servico" ("servico_id") ON DELETE RESTRICT ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='historico_agendamento_historico_agendamento_agend_7bcddd4a' AND conrelid='"historico_agendamento"'::regclass) THEN
    ALTER TABLE "historico_agendamento" ADD CONSTRAINT "historico_agendamento_historico_agendamento_agend_7bcddd4a" FOREIGN KEY ("historico_agendamento_agendamento_id") REFERENCES "agendamento" ("agendamento_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='observacao_agendamento_observacao_agendamento_age_62f3e07e' AND conrelid='"observacao_agendamento"'::regclass) THEN
    ALTER TABLE "observacao_agendamento" ADD CONSTRAINT "observacao_agendamento_observacao_agendamento_age_62f3e07e" FOREIGN KEY ("observacao_agendamento_agendamento_id") REFERENCES "agendamento" ("agendamento_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='observacao_agendamento_observacao_agendamento_autor_id_fkey' AND conrelid='"observacao_agendamento"'::regclass) THEN
    ALTER TABLE "observacao_agendamento" ADD CONSTRAINT "observacao_agendamento_observacao_agendamento_autor_id_fkey" FOREIGN KEY ("observacao_agendamento_autor_id") REFERENCES "usuario" ("usuario_id") ON DELETE RESTRICT ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='notificacao_notificacao_usuario_id_fkey' AND conrelid='"notificacao"'::regclass) THEN
    ALTER TABLE "notificacao" ADD CONSTRAINT "notificacao_notificacao_usuario_id_fkey" FOREIGN KEY ("notificacao_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='notificacao_notificacao_agendamento_id_fkey' AND conrelid='"notificacao"'::regclass) THEN
    ALTER TABLE "notificacao" ADD CONSTRAINT "notificacao_notificacao_agendamento_id_fkey" FOREIGN KEY ("notificacao_agendamento_id") REFERENCES "agendamento" ("agendamento_id") ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='consentimento_privacidade_consentimento_privacida_e18be017' AND conrelid='"consentimento_privacidade"'::regclass) THEN
    ALTER TABLE "consentimento_privacidade" ADD CONSTRAINT "consentimento_privacidade_consentimento_privacida_e18be017" FOREIGN KEY ("consentimento_privacidade_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='pagamento_pagamento_agendamento_id_fkey' AND conrelid='"pagamento"'::regclass) THEN
    ALTER TABLE "pagamento" ADD CONSTRAINT "pagamento_pagamento_agendamento_id_fkey" FOREIGN KEY ("pagamento_agendamento_id") REFERENCES "agendamento" ("agendamento_id") ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='pagamento_pagamento_cliente_id_fkey' AND conrelid='"pagamento"'::regclass) THEN
    ALTER TABLE "pagamento" ADD CONSTRAINT "pagamento_pagamento_cliente_id_fkey" FOREIGN KEY ("pagamento_cliente_id") REFERENCES "usuario" ("usuario_id") ON DELETE RESTRICT ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='avaliacao_avaliacao_agendamento_id_fkey' AND conrelid='"avaliacao"'::regclass) THEN
    ALTER TABLE "avaliacao" ADD CONSTRAINT "avaliacao_avaliacao_agendamento_id_fkey" FOREIGN KEY ("avaliacao_agendamento_id") REFERENCES "agendamento" ("agendamento_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='avaliacao_avaliacao_barbeiro_id_fkey' AND conrelid='"avaliacao"'::regclass) THEN
    ALTER TABLE "avaliacao" ADD CONSTRAINT "avaliacao_avaliacao_barbeiro_id_fkey" FOREIGN KEY ("avaliacao_barbeiro_id") REFERENCES "perfil_funcionario" ("perfil_funcionario_id") ON DELETE RESTRICT ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='comanda_comanda_barbearia_id_fkey' AND conrelid='"comanda"'::regclass) THEN
    ALTER TABLE "comanda" ADD CONSTRAINT "comanda_comanda_barbearia_id_fkey" FOREIGN KEY ("comanda_barbearia_id") REFERENCES "barbearia" ("barbearia_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='comanda_comanda_usuario_id_fkey' AND conrelid='"comanda"'::regclass) THEN
    ALTER TABLE "comanda" ADD CONSTRAINT "comanda_comanda_usuario_id_fkey" FOREIGN KEY ("comanda_usuario_id") REFERENCES "usuario" ("usuario_id") ON DELETE RESTRICT ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='comanda_comanda_agendamento_id_fkey' AND conrelid='"comanda"'::regclass) THEN
    ALTER TABLE "comanda" ADD CONSTRAINT "comanda_comanda_agendamento_id_fkey" FOREIGN KEY ("comanda_agendamento_id") REFERENCES "agendamento" ("agendamento_id") ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='item_comanda_item_comanda_comanda_id_fkey' AND conrelid='"item_comanda"'::regclass) THEN
    ALTER TABLE "item_comanda" ADD CONSTRAINT "item_comanda_item_comanda_comanda_id_fkey" FOREIGN KEY ("item_comanda_comanda_id") REFERENCES "comanda" ("comanda_id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='item_comanda_item_comanda_servico_id_fkey' AND conrelid='"item_comanda"'::regclass) THEN
    ALTER TABLE "item_comanda" ADD CONSTRAINT "item_comanda_item_comanda_servico_id_fkey" FOREIGN KEY ("item_comanda_servico_id") REFERENCES "servico" ("servico_id") ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='item_comanda_item_comanda_barbeiro_id_fkey' AND conrelid='"item_comanda"'::regclass) THEN
    ALTER TABLE "item_comanda" ADD CONSTRAINT "item_comanda_item_comanda_barbeiro_id_fkey" FOREIGN KEY ("item_comanda_barbeiro_id") REFERENCES "perfil_funcionario" ("perfil_funcionario_id") ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
CREATE INDEX IF NOT EXISTS "usuario_usuario_barbearia_id_idx" ON "usuario" ("usuario_barbearia_id");
CREATE INDEX IF NOT EXISTS "usuario_usuario_esta_ativo_idx" ON "usuario" ("usuario_esta_ativo");
CREATE INDEX IF NOT EXISTS "usuario_perfil_usuario_perfil_usuario_id_idx" ON "usuario_perfil" ("usuario_perfil_usuario_id");
CREATE INDEX IF NOT EXISTS "usuario_perfil_usuario_perfil_perfil_id_idx" ON "usuario_perfil" ("usuario_perfil_perfil_id");
CREATE INDEX IF NOT EXISTS "perfil_funcionario_perfil_funcionario_barbearia_id_idx" ON "perfil_funcionario" ("perfil_funcionario_barbearia_id");
CREATE INDEX IF NOT EXISTS "sessao_autenticacao_sessao_autenticacao_usuario_id_idx" ON "sessao_autenticacao" ("sessao_autenticacao_usuario_id");
CREATE INDEX IF NOT EXISTS "sessao_autenticacao_sessao_autenticacao_expira_em_idx" ON "sessao_autenticacao" ("sessao_autenticacao_expira_em");
CREATE INDEX IF NOT EXISTS "token_redefinicao_senha_token_redefinicao_senha_u_18ae3a4e" ON "token_redefinicao_senha" ("token_redefinicao_senha_usuario_id");
CREATE INDEX IF NOT EXISTS "token_redefinicao_senha_token_redefinicao_senha_e_59c34f38" ON "token_redefinicao_senha" ("token_redefinicao_senha_expira_em");
CREATE INDEX IF NOT EXISTS "tentativa_login_tentativa_login_usuario_id_idx" ON "tentativa_login" ("tentativa_login_usuario_id");
CREATE INDEX IF NOT EXISTS "tentativa_login_tentativa_login_hash_busca_identificador_idx" ON "tentativa_login" ("tentativa_login_hash_busca_identificador");
CREATE INDEX IF NOT EXISTS "tentativa_login_tentativa_login_criado_em_idx" ON "tentativa_login" ("tentativa_login_criado_em");
CREATE INDEX IF NOT EXISTS "servico_servico_esta_ativo_idx" ON "servico" ("servico_esta_ativo");
CREATE INDEX IF NOT EXISTS "servico_servico_nome_idx" ON "servico" ("servico_nome");
CREATE INDEX IF NOT EXISTS "servico_servico_barbearia_id_idx" ON "servico" ("servico_barbearia_id");
CREATE INDEX IF NOT EXISTS "horario_trabalho_horario_trabalho_barbeiro_id_hor_5e39ced0" ON "horario_trabalho" ("horario_trabalho_barbeiro_id", "horario_trabalho_dia_semana");
CREATE INDEX IF NOT EXISTS "bloqueio_agenda_bloqueio_agenda_barbeiro_id_bloqu_0e6abe80" ON "bloqueio_agenda" ("bloqueio_agenda_barbeiro_id", "bloqueio_agenda_inicio_em", "bloqueio_agenda_fim_em");
CREATE INDEX IF NOT EXISTS "agendamento_agendamento_barbearia_id_idx" ON "agendamento" ("agendamento_barbearia_id");
CREATE INDEX IF NOT EXISTS "agendamento_agendamento_usuario_id_idx" ON "agendamento" ("agendamento_usuario_id");
CREATE INDEX IF NOT EXISTS "agendamento_agendamento_barbeiro_id_idx" ON "agendamento" ("agendamento_barbeiro_id");
CREATE INDEX IF NOT EXISTS "agendamento_agendamento_status_idx" ON "agendamento" ("agendamento_status");
CREATE INDEX IF NOT EXISTS "agendamento_agendamento_inicio_agendado_idx" ON "agendamento" ("agendamento_inicio_agendado");
CREATE INDEX IF NOT EXISTS "agendamento_agendamento_barbeiro_id_agendamento_i_b9a20730" ON "agendamento" ("agendamento_barbeiro_id", "agendamento_inicio_agendado", "agendamento_fim_agendado");
CREATE INDEX IF NOT EXISTS "historico_agendamento_historico_agendamento_agend_7024a93b" ON "historico_agendamento" ("historico_agendamento_agendamento_id");
CREATE INDEX IF NOT EXISTS "historico_agendamento_historico_agendamento_criado_em_idx" ON "historico_agendamento" ("historico_agendamento_criado_em");
CREATE INDEX IF NOT EXISTS "notificacao_notificacao_usuario_id_idx" ON "notificacao" ("notificacao_usuario_id");
CREATE INDEX IF NOT EXISTS "notificacao_notificacao_agendamento_id_idx" ON "notificacao" ("notificacao_agendamento_id");
CREATE INDEX IF NOT EXISTS "notificacao_notificacao_status_idx" ON "notificacao" ("notificacao_status");
CREATE INDEX IF NOT EXISTS "notificacao_notificacao_criado_em_idx" ON "notificacao" ("notificacao_criado_em");
CREATE INDEX IF NOT EXISTS "log_auditoria_log_auditoria_usuario_ator_id_idx" ON "log_auditoria" ("log_auditoria_usuario_ator_id");
CREATE INDEX IF NOT EXISTS "log_auditoria_log_auditoria_tipo_entidade_idx" ON "log_auditoria" ("log_auditoria_tipo_entidade");
CREATE INDEX IF NOT EXISTS "log_auditoria_log_auditoria_entidade_id_idx" ON "log_auditoria" ("log_auditoria_entidade_id");
CREATE INDEX IF NOT EXISTS "log_auditoria_log_auditoria_tipo_evento_idx" ON "log_auditoria" ("log_auditoria_tipo_evento");
CREATE INDEX IF NOT EXISTS "log_auditoria_log_auditoria_criado_em_idx" ON "log_auditoria" ("log_auditoria_criado_em");
CREATE INDEX IF NOT EXISTS "log_auditoria_log_auditoria_requisicao_id_idx" ON "log_auditoria" ("log_auditoria_requisicao_id");
CREATE INDEX IF NOT EXISTS "log_acesso_dado_sensivel_log_acesso_dado_sensivel_8004aeca" ON "log_acesso_dado_sensivel" ("log_acesso_dado_sensivel_usuario_ator_id");
CREATE INDEX IF NOT EXISTS "log_acesso_dado_sensivel_log_acesso_dado_sensivel_60f75b1b" ON "log_acesso_dado_sensivel" ("log_acesso_dado_sensivel_usuario_titular_id");
CREATE INDEX IF NOT EXISTS "log_acesso_dado_sensivel_log_acesso_dado_sensivel_0325d94e" ON "log_acesso_dado_sensivel" ("log_acesso_dado_sensivel_criado_em");
CREATE INDEX IF NOT EXISTS "consentimento_privacidade_consentimento_privacida_342449e2" ON "consentimento_privacidade" ("consentimento_privacidade_usuario_id", "consentimento_privacidade_codigo_finalidade", "consentimento_privacidade_versao");
CREATE INDEX IF NOT EXISTS "solicitacao_privacidade_solicitacao_privacidade_u_f975a82c" ON "solicitacao_privacidade" ("solicitacao_privacidade_usuario_id");
CREATE INDEX IF NOT EXISTS "solicitacao_privacidade_solicitacao_privacidade_status_idx" ON "solicitacao_privacidade" ("solicitacao_privacidade_status");
CREATE INDEX IF NOT EXISTS "solicitacao_privacidade_solicitacao_privacidade_a_822cc1e5" ON "solicitacao_privacidade" ("solicitacao_privacidade_aberto_em");
CREATE INDEX IF NOT EXISTS "pagamento_pagamento_cliente_id_idx" ON "pagamento" ("pagamento_cliente_id");
CREATE INDEX IF NOT EXISTS "pagamento_pagamento_agendamento_id_idx" ON "pagamento" ("pagamento_agendamento_id");
CREATE INDEX IF NOT EXISTS "avaliacao_avaliacao_cliente_id_idx" ON "avaliacao" ("avaliacao_cliente_id");
CREATE INDEX IF NOT EXISTS "avaliacao_avaliacao_barbeiro_id_idx" ON "avaliacao" ("avaliacao_barbeiro_id");
CREATE INDEX IF NOT EXISTS "comanda_comanda_barbearia_id_idx" ON "comanda" ("comanda_barbearia_id");

  END IF;

END

$baseline$;



DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM usuario WHERE usuario_role::text NOT IN ('ADMIN','CLIENTE')) THEN RAISE EXCEPTION 'Há usuario_role fora do enum ADMIN/CLIENTE.'; END IF;
  IF EXISTS (SELECT 1 FROM agendamento WHERE agendamento_status::text NOT IN ('PENDENTE','CONFIRMADO','EM_ANDAMENTO','CONCLUIDO','CANCELADO','NAO_COMPARECEU')) THEN RAISE EXCEPTION 'Há agendamento_status não reconhecido.'; END IF;
  IF EXISTS (SELECT 1 FROM comanda WHERE comanda_status::text NOT IN ('ABERTA','PAGA','CANCELADA')) THEN RAISE EXCEPTION 'Há comanda_status não reconhecido.'; END IF;
  IF EXISTS (SELECT 1 FROM pagamento WHERE pagamento_status::text NOT IN ('PENDENTE','APROVADO','RECUSADO','ESTORNADO','CANCELADO')) THEN RAISE EXCEPTION 'Há pagamento_status não reconhecido.'; END IF;
END $$;

ALTER TABLE "usuario" ALTER COLUMN "usuario_role" DROP DEFAULT;
ALTER TABLE "usuario" ALTER COLUMN "usuario_role" TYPE "RoleUsuario" USING "usuario_role"::text::"RoleUsuario";
ALTER TABLE "usuario" ALTER COLUMN "usuario_role" SET DEFAULT 'CLIENTE'::"RoleUsuario";

ALTER TABLE "agendamento" ALTER COLUMN "agendamento_status" DROP DEFAULT;
ALTER TABLE "agendamento" ALTER COLUMN "agendamento_status" TYPE "StatusAgendamento" USING "agendamento_status"::text::"StatusAgendamento";
ALTER TABLE "agendamento" ALTER COLUMN "agendamento_status" SET DEFAULT 'PENDENTE'::"StatusAgendamento";

ALTER TABLE "comanda" ALTER COLUMN "comanda_status" DROP DEFAULT;
ALTER TABLE "comanda" ALTER COLUMN "comanda_status" TYPE "StatusComanda" USING "comanda_status"::text::"StatusComanda";
ALTER TABLE "comanda" ALTER COLUMN "comanda_status" SET DEFAULT 'ABERTA'::"StatusComanda";

ALTER TABLE "pagamento" ALTER COLUMN "pagamento_status" DROP DEFAULT;
ALTER TABLE "pagamento" ALTER COLUMN "pagamento_status" TYPE "StatusPagamento" USING "pagamento_status"::text::"StatusPagamento";
ALTER TABLE "pagamento" ALTER COLUMN "pagamento_status" SET DEFAULT 'PENDENTE'::"StatusPagamento";

ALTER TABLE "servico" ALTER COLUMN "servico_preco" TYPE NUMERIC(10,2) USING ROUND("servico_preco"::numeric, 2);

ALTER TABLE "servico_barbeiro" ALTER COLUMN "servico_barbeiro_preco_personalizado" TYPE NUMERIC(10,2) USING ROUND("servico_barbeiro_preco_personalizado"::numeric, 2);

ALTER TABLE "perfil_funcionario" ALTER COLUMN "perfil_funcionario_comissao_porcent" TYPE NUMERIC(5,2) USING ROUND("perfil_funcionario_comissao_porcent"::numeric, 2);

ALTER TABLE "servico_agendamento" ALTER COLUMN "servico_agendamento_preco" TYPE NUMERIC(10,2) USING ROUND("servico_agendamento_preco"::numeric, 2);

ALTER TABLE "pagamento" ALTER COLUMN "pagamento_valor" TYPE NUMERIC(10,2) USING ROUND("pagamento_valor"::numeric, 2);

ALTER TABLE "comanda" ALTER COLUMN "comanda_valor_total" TYPE NUMERIC(10,2) USING ROUND("comanda_valor_total"::numeric, 2);

ALTER TABLE "item_comanda" ALTER COLUMN "item_comanda_preco" TYPE NUMERIC(10,2) USING ROUND("item_comanda_preco"::numeric, 2);

ALTER TABLE "item_comanda" ALTER COLUMN "item_comanda_comissao" TYPE NUMERIC(10,2) USING ROUND("item_comanda_comissao"::numeric, 2);

ALTER TABLE "servico" ADD CONSTRAINT "servico_preco_nao_negativo" CHECK (servico_preco >= 0);

ALTER TABLE "servico" ADD CONSTRAINT "servico_duracao_positiva" CHECK (servico_duracao_minutos > 0);

ALTER TABLE "perfil_funcionario" ADD CONSTRAINT "perfil_funcionario_comissao_valida" CHECK (perfil_funcionario_comissao_porcent >= 0 AND perfil_funcionario_comissao_porcent <= 100);

ALTER TABLE "servico_barbeiro" ADD CONSTRAINT "servico_barbeiro_preco_nao_negativo" CHECK (servico_barbeiro_preco_personalizado IS NULL OR servico_barbeiro_preco_personalizado >= 0);

ALTER TABLE "servico_barbeiro" ADD CONSTRAINT "servico_barbeiro_duracao_positiva" CHECK (servico_barbeiro_duracao_personalizada_minutos IS NULL OR servico_barbeiro_duracao_personalizada_minutos > 0);

ALTER TABLE "agendamento" ADD CONSTRAINT "agendamento_intervalo_valido" CHECK (agendamento_fim_agendado > agendamento_inicio_agendado);

ALTER TABLE "servico_agendamento" ADD CONSTRAINT "servico_agendamento_preco_nao_negativo" CHECK (servico_agendamento_preco >= 0 AND servico_agendamento_duracao_minutos > 0);

ALTER TABLE "pagamento" ADD CONSTRAINT "pagamento_valor_nao_negativo" CHECK (pagamento_valor >= 0);

ALTER TABLE "comanda" ADD CONSTRAINT "comanda_valor_nao_negativo" CHECK (comanda_valor_total >= 0);

ALTER TABLE "item_comanda" ADD CONSTRAINT "item_comanda_valores_nao_negativos" CHECK (item_comanda_preco >= 0 AND item_comanda_comissao >= 0);

ALTER TABLE "avaliacao" ADD CONSTRAINT "avaliacao_nota_valida" CHECK (avaliacao_nota >= 1 AND avaliacao_nota <= 5);

ALTER TABLE "horario_trabalho" ADD CONSTRAINT "horario_trabalho_dia_semana_valido" CHECK (horario_trabalho_dia_semana BETWEEN 0 AND 6);

ALTER TABLE "bloqueio_agenda" ADD CONSTRAINT "bloqueio_agenda_intervalo_valido" CHECK (bloqueio_agenda_fim_em > bloqueio_agenda_inicio_em);

CREATE EXTENSION IF NOT EXISTS btree_gist;
DO $$ BEGIN
  IF EXISTS (
    SELECT 1 FROM agendamento a
    JOIN agendamento b ON a.agendamento_barbeiro_id=b.agendamento_barbeiro_id
      AND a.agendamento_id < b.agendamento_id
      AND a.agendamento_inicio_agendado < b.agendamento_fim_agendado
      AND a.agendamento_fim_agendado > b.agendamento_inicio_agendado
    WHERE a.agendamento_status <> 'CANCELADO'::"StatusAgendamento"
      AND b.agendamento_status <> 'CANCELADO'::"StatusAgendamento"
  ) THEN
    RAISE EXCEPTION 'Existem agendamentos sobrepostos. Corrija os conflitos antes de migrar.';
  END IF;
END $$;
ALTER TABLE agendamento ADD CONSTRAINT agendamento_sem_sobreposicao
  EXCLUDE USING gist (
    agendamento_barbeiro_id WITH =,
    tsrange(agendamento_inicio_agendado, agendamento_fim_agendado, '[)') WITH &&
  )
  WHERE (agendamento_status <> 'CANCELADO'::"StatusAgendamento");

CREATE INDEX IF NOT EXISTS agendamento_barbearia_inicio_idx ON agendamento (agendamento_barbearia_id, agendamento_inicio_agendado);

CREATE INDEX IF NOT EXISTS pagamento_status_criado_idx ON pagamento (pagamento_status, pagamento_criado_em);

COMMIT;
