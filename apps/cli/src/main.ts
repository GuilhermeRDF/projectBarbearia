import { createInterface, type Interface } from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';

const API_URL = (process.env.API_URL ?? 'http://localhost:3000').replace(/\/$/, '');

type Usuario = {
  id: string;
  nome: string;
  email: string;
  telefone?: string | null;
  role: 'ADMIN' | 'CLIENTE';
  barbeariaId?: string | null;
  senhaTemporaria?: boolean;
};

type Cliente = {
  id: string;
  nome: string;
  email: string;
  telefone?: string | null;
  criadoEm: string;
};

type Barbeiro = {
  id: string;
  nome: string;
  especialidade?: string | null;
  horarioInicio: string;
  horarioFim: string;
  inicioAlmoco?: string | null;
  fimAlmoco?: string | null;
  comissaoPorcent: number;
};

type Servico = {
  id: string;
  nome: string;
  preco: number;
  duracaoMinutos: number;
};

type Agendamento = {
  id: string;
  dataHora: string;
  status: string;
  usuario: Cliente;
  barbeiro: {
    id: string;
    nome: string;
  };
  servico: Servico;
  comanda?: {
    id: string;
    valorTotal: number;
    status: string;
    formaPagto?: string | null;
  } | null;
};

type ResetRequest = {
  id: string;
  clienteId: string;
  email: string;
  solicitadoEm: string;
  expiraEm: string;
};

/**
 * Interface readline usada somente para entradas normais.
 *
 * IMPORTANTE:
 * Para senha não utilizamos readline, porque no Windows
 * ele pode continuar fazendo echo dos caracteres.
 */
let rl: Interface | null = createInterface({
  input,
  output,
});

let token = '';
let usuario: Usuario | null = null;

/* ============================================================
 * API
 * ============================================================
 */

async function api<T>(
  path: string,
  options: RequestInit = {},
): Promise<T> {
  const headers = new Headers(options.headers);

  headers.set('Content-Type', 'application/json');

  if (token) {
    headers.set('Authorization', `Bearer ${token}`);
  }

  let response: Response;

  try {
    response = await fetch(`${API_URL}${path}`, {
      ...options,
      headers,
    });
  } catch (error: any) {
    throw new Error(
      `Não foi possível conectar à API em ${API_URL}. ` +
      `Verifique o PostgreSQL/API. ` +
      `Detalhes: ${error?.message ?? 'erro de conexão'}`,
    );
  }

  const text = await response.text();

  let data: any = {};

  try {
    data = text ? JSON.parse(text) : {};
  } catch {
    data = {
      error: text,
    };
  }

  if (!response.ok) {
    const details = Array.isArray(data.detalhes)
      ? `\n${data.detalhes.join('\n')}`
      : '';

    throw new Error(
      `${data.error ?? `HTTP ${response.status}`}${details}`,
    );
  }

  return data as T;
}

/* ============================================================
 * ENTRADA DE DADOS
 * ============================================================
 */

async function pergunta(label: string): Promise<string> {
  /**
   * Se por algum motivo a interface estiver fechada,
   * recriamos antes de perguntar.
   */
  if (!rl) {
    rl = createInterface({
      input,
      output,
    });
  }

  return (await rl.question(label)).trim();
}

/**
 * Leitura segura de senha.
 *
 * Não utiliza readline enquanto a senha está sendo digitada.
 * Isso é importante principalmente no Windows, onde o readline
 * pode continuar fazendo echo dos caracteres.
 */
async function perguntaSenha(label: string): Promise<string> {
  /**
   * Fecha completamente o readline antes de assumir o stdin.
   */
  if (rl) {
    rl.close();
    rl = null;
  }

  /**
   * Se não estivermos em um terminal interativo,
   * não é possível controlar o echo.
   */
  if (!input.isTTY) {
    return pergunta(label);
  }

  return new Promise<string>((resolve, reject) => {
    let value = '';
    let finalizado = false;

    const wasRaw = input.isRaw;

    const restaurarTerminal = () => {
      if (finalizado) {
        return;
      }

      finalizado = true;

      input.off('data', onData);

      try {
        input.setRawMode(Boolean(wasRaw));
      } catch {
        // Ignora caso o terminal já tenha sido restaurado.
      }

      input.pause();

      /**
       * Recria readline para as próximas perguntas normais.
       */
      rl = createInterface({
        input,
        output,
      });
    };

    const cancelar = () => {
      restaurarTerminal();
      reject(new Error('Operação cancelada.'));
    };

    const finalizar = () => {
      output.write('\n');
      restaurarTerminal();
      resolve(value);
    };

    const onData = (chunk: Buffer | string) => {
      const data = chunk.toString();

      for (const char of data) {
        /**
         * Ctrl+C
         */
        if (char === '\u0003') {
          cancelar();
          return;
        }

        /**
         * ENTER
         */
        if (char === '\r' || char === '\n') {
          finalizar();
          return;
        }

        /**
         * BACKSPACE / DELETE
         */
        if (char === '\u007f' || char === '\b') {
          if (value.length > 0) {
            value = value.slice(0, -1);

            /**
             * Remove visualmente o último asterisco.
             */
            output.write('\b \b');
          }

          continue;
        }

        /**
         * Ignora caracteres de controle.
         */
        if (char < ' ') {
          continue;
        }

        /**
         * Adiciona o caractere à senha,
         * mas mostra somente "*".
         */
        value += char;
        output.write('*');
      }
    };

    /**
     * Ativa modo raw.
     *
     * No Windows isso impede o terminal de fazer echo
     * automático dos caracteres digitados.
     */
    try {
      input.setRawMode(true);
    } catch (error) {
      restaurarTerminal();
      reject(
        new Error(
          'Não foi possível ativar o modo seguro de senha no terminal.',
        ),
      );
      return;
    }

    input.on('data', onData);
    input.resume();

    output.write(label);
  });
}

/* ============================================================
 * UTILITÁRIOS
 * ============================================================
 */

async function confirmar(label: string): Promise<boolean> {
  const r = (
    await pergunta(`${label} [s/N]: `)
  ).toLowerCase();

  return r === 's' || r === 'sim';
}

function dinheiro(v: number) {
  return v.toLocaleString('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  });
}

function dataHora(v: string) {
  return new Date(v).toLocaleString('pt-BR', {
    dateStyle: 'short',
    timeStyle: 'short',
  });
}

function limpar() {
  console.clear();
}

function titulo(t: string) {
  console.log('\n' + '='.repeat(72));
  console.log(`  ${t}`);
  console.log('='.repeat(72));
}

function pausar() {
  return pergunta('\nPressione ENTER para continuar...');
}

function tabela(
  headers: string[],
  rows: string[][],
) {
  if (!rows.length) {
    console.log('Nenhum registro encontrado.');
    return;
  }

  const widths = headers.map((h, i) =>
    Math.max(
      h.length,
      ...rows.map((r) => String(r[i] ?? '').length),
    ),
  );

  const line = (r: string[]) =>
    r
      .map((c, i) => String(c ?? '').padEnd(widths[i]))
      .join('  ');

  console.log(line(headers));
  console.log(
    widths.map((w) => '-'.repeat(w)).join('  '),
  );

  rows.forEach((r) => console.log(line(r)));
}

/* ============================================================
 * AUTENTICAÇÃO
 * ============================================================
 */

async function logout() {
  if (token) {
    try {
      await api('/auth/logout', {
        method: 'POST',
      });
    } catch {
      // Logout local continua mesmo se a API falhar.
    }
  }

  token = '';
  usuario = null;
}

async function login() {
  titulo('ENTRAR');

  console.log(
    'Digite R no e-mail para solicitar redefinição de senha.',
  );

  const email = await pergunta('E-mail: ');

  if (email.trim().toLowerCase() === 'r') {
    await solicitarRedefinicao();
    return;
  }

  const senha = await perguntaSenha('Senha: ');

  const r = await api<{
    token: string;
    usuario: Usuario;
  }>('/auth/login', {
    method: 'POST',
    body: JSON.stringify({
      email,
      senha,
    }),
  });

  token = r.token;
  usuario = r.usuario;

  console.log(
    `\n✓ Login realizado. Olá, ${usuario.nome}!`,
  );

  if (usuario.senhaTemporaria) {
    console.log(
      '\n⚠ Esta é uma senha temporária. ' +
      'Você precisa definir uma senha permanente agora.',
    );

    await alterarSenha(senha, true);
  }
}

async function alterarSenha(
  senhaAtualInicial?: string,
  obrigatoria = false,
) {
  titulo(
    obrigatoria
      ? 'DEFINIR SENHA PERMANENTE'
      : 'ALTERAR SENHA',
  );

  const atual =
    senhaAtualInicial ??
    await perguntaSenha('Senha atual: ');

  const nova = await perguntaSenha(
    'Nova senha (mín. 8): ',
  );

  const confirmacao = await perguntaSenha(
    'Confirme a nova senha: ',
  );

  if (nova !== confirmacao) {
    throw new Error('As novas senhas não coincidem.');
  }

  await api('/auth/alterar-senha', {
    method: 'POST',
    body: JSON.stringify({
      senhaAtual: atual,
      novaSenha: nova,
    }),
  });

  if (usuario) {
    usuario.senhaTemporaria = false;
  }

  console.log('✓ Senha alterada com sucesso.');
}

async function solicitarRedefinicao() {
  titulo('ESQUECI MINHA SENHA');

  const email = await pergunta(
    'E-mail cadastrado: ',
  );

  const r = await api<{ mensagem: string }>(
    '/auth/solicitar-redefinicao',
    {
      method: 'POST',
      body: JSON.stringify({
        email,
      }),
    },
  );

  console.log(`\n✓ ${r.mensagem}`);

  console.log(
    'Por segurança, nenhuma senha ou token é exibido nesta etapa.',
  );
}

/* ============================================================
 * CADASTROS
 * ============================================================
 */

async function cadastrarPublico() {
  titulo('CADASTRAR');

  const nome = await pergunta('Nome: ');
  const email = await pergunta('E-mail: ');
  const telefone = await pergunta(
    'Telefone (opcional): ',
  );

  const senha = await perguntaSenha(
    'Senha (mín. 8): ',
  );

  const confirmacao = await perguntaSenha(
    'Confirme a senha: ',
  );

  if (senha !== confirmacao) {
    throw new Error('As senhas não coincidem.');
  }

  const r = await api<{ mensagem: string }>(
    '/auth/registrar',
    {
      method: 'POST',
      body: JSON.stringify({
        nome,
        email,
        telefone: telefone || undefined,
        senha,
      }),
    },
  );

  console.log(`\n✓ ${r.mensagem}`);
}

async function cadastrarAdmin() {
  titulo('NOVO ADMINISTRADOR');

  const nome = await pergunta('Nome: ');
  const email = await pergunta('E-mail: ');
  const telefone = await pergunta(
    'Telefone (opcional): ',
  );

  const senha = await perguntaSenha(
    'Senha (mín. 8): ',
  );

  const confirmacao = await perguntaSenha(
    'Confirme a senha: ',
  );

  if (senha !== confirmacao) {
    throw new Error('As senhas não coincidem.');
  }

  const r = await api<{ mensagem: string }>(
    '/admin/admins',
    {
      method: 'POST',
      body: JSON.stringify({
        nome,
        email,
        telefone: telefone || undefined,
        senha,
      }),
    },
  );

  console.log(`\n✓ ${r.mensagem}`);
}

async function listarClientes() {
  titulo('CLIENTES');

  const rows = await api<Cliente[]>('/clientes');

  tabela(
    ['ID', 'NOME', 'E-MAIL', 'TELEFONE'],
    rows.map((c) => [
      c.id.slice(0, 8),
      c.nome,
      c.email,
      c.telefone ?? '-',
    ]),
  );
}

async function cadastrarCliente() {
  titulo('NOVO CLIENTE');

  const nome = await pergunta('Nome: ');
  const email = await pergunta('E-mail: ');
  const telefone = await pergunta('Telefone: ');

  const r = await api<{
    cliente: Cliente;
    senhaTemporaria: string;
  }>('/clientes', {
    method: 'POST',
    body: JSON.stringify({
      nome,
      email,
      telefone: telefone || undefined,
    }),
  });

  console.log(
    `\n✓ Cliente cadastrado: ${r.cliente.nome}`,
  );

  console.log(
    `\nSENHA TEMPORÁRIA (exibir/copiar agora): ${r.senhaTemporaria}`,
  );

  console.log(
    'Ela não poderá ser consultada novamente no banco. ' +
    'O cliente deverá trocá-la no primeiro login.',
  );
}

async function listarBarbeiros() {
  titulo('BARBEIROS');

  const rows = await api<Barbeiro[]>('/barbeiros');

  tabela(
    [
      'ID',
      'NOME',
      'ESPECIALIDADE',
      'HORÁRIO',
      'COMISSÃO',
    ],
    rows.map((b) => [
      b.id.slice(0, 8),
      b.nome,
      b.especialidade ?? '-',
      `${b.horarioInicio}-${b.horarioFim}`,
      `${b.comissaoPorcent}%`,
    ]),
  );
}

async function cadastrarBarbeiro() {
  titulo('NOVO BARBEIRO');

  const nome = await pergunta('Nome: ');

  const especialidade = await pergunta(
    'Especialidade: ',
  );

  const horarioInicio =
    await pergunta('Início [08:00]: ') || '08:00';

  const horarioFim =
    await pergunta('Fim [18:00]: ') || '18:00';

  const inicioAlmoco =
    await pergunta('Início almoço [12:00]: ') || '12:00';

  const fimAlmoco =
    await pergunta('Fim almoço [13:00]: ') || '13:00';

  const comissao = Number(
    await pergunta('Comissão % [30]: ') || '30',
  );

  const b = await api<Barbeiro>('/barbeiros', {
    method: 'POST',
    body: JSON.stringify({
      nome,
      especialidade:
        especialidade || undefined,
      horarioInicio,
      horarioFim,
      inicioAlmoco,
      fimAlmoco,
      comissaoPorcent: comissao,
    }),
  });

  console.log(
    `\n✓ Barbeiro cadastrado: ${b.nome}`,
  );
}

async function listarServicos() {
  titulo('SERVIÇOS');

  const rows = await api<Servico[]>('/servicos');

  tabela(
    ['ID', 'SERVIÇO', 'PREÇO', 'DURAÇÃO'],
    rows.map((s) => [
      s.id.slice(0, 8),
      s.nome,
      dinheiro(s.preco),
      `${s.duracaoMinutos} min`,
    ]),
  );
}

async function cadastrarServico() {
  titulo('NOVO SERVIÇO');

  const nome = await pergunta('Nome: ');

  const preco = Number(
    (
      await pergunta('Preço: ')
    ).replace(',', '.'),
  );

  const duracaoMinutos = Number(
    await pergunta('Duração em minutos: '),
  );

  const s = await api<Servico>('/servicos', {
    method: 'POST',
    body: JSON.stringify({
      nome,
      preco,
      duracaoMinutos,
    }),
  });

  console.log(
    `\n✓ Serviço cadastrado: ${s.nome} — ${dinheiro(s.preco)}`,
  );
}

/* ============================================================
 * ESCOLHAS
 * ============================================================
 */

async function escolherCliente() {
  const rows = await api<Cliente[]>('/clientes');

  if (!rows.length) {
    throw new Error(
      'Cadastre pelo menos um cliente primeiro.',
    );
  }

  tabela(
    ['#', 'NOME', 'E-MAIL', 'TELEFONE'],
    rows.map((c, i) => [
      `${i + 1}`,
      c.nome,
      c.email,
      c.telefone ?? '-',
    ]),
  );

  const i =
    Number(await pergunta('Escolha o cliente: ')) - 1;

  if (!rows[i]) {
    throw new Error('Cliente inválido.');
  }

  return rows[i];
}

async function escolherBarbeiro() {
  const rows = await api<Barbeiro[]>('/barbeiros');

  if (!rows.length) {
    throw new Error(
      'Cadastre um barbeiro primeiro.',
    );
  }

  tabela(
    ['#', 'NOME', 'ESPECIALIDADE'],
    rows.map((b, i) => [
      `${i + 1}`,
      b.nome,
      b.especialidade ?? '-',
    ]),
  );

  const i =
    Number(await pergunta('Escolha o barbeiro: ')) - 1;

  if (!rows[i]) {
    throw new Error('Barbeiro inválido.');
  }

  return rows[i];
}

async function escolherServico() {
  const rows = await api<Servico[]>('/servicos');

  if (!rows.length) {
    throw new Error(
      'Cadastre um serviço primeiro.',
    );
  }

  tabela(
    ['#', 'SERVIÇO', 'PREÇO', 'DURAÇÃO'],
    rows.map((s, i) => [
      `${i + 1}`,
      s.nome,
      dinheiro(s.preco),
      `${s.duracaoMinutos} min`,
    ]),
  );

  const i =
    Number(await pergunta('Escolha o serviço: ')) - 1;

  if (!rows[i]) {
    throw new Error('Serviço inválido.');
  }

  return rows[i];
}

/* ============================================================
 * AGENDAMENTOS
 * ============================================================
 */

async function novoAgendamento() {
  titulo('NOVO AGENDAMENTO');

  const cliente =
    usuario?.role === 'CLIENTE'
      ? null
      : await escolherCliente();

  const barbeiro = await escolherBarbeiro();
  const servico = await escolherServico();

  const hoje = new Date()
    .toISOString()
    .slice(0, 10);

  const data =
    await pergunta(`Data [${hoje}]: `) || hoje;

  const horarios = await api<string[]>(
    `/horarios-disponiveis?barbeiroId=${encodeURIComponent(
      barbeiro.id,
    )}&servicoId=${encodeURIComponent(
      servico.id,
    )}&data=${encodeURIComponent(data)}`,
  );

  if (!horarios.length) {
    throw new Error(
      'Não há horários disponíveis para esta data.',
    );
  }

  horarios.forEach((h, i) =>
    console.log(`  ${i + 1}. ${h}`),
  );

  const hora =
    horarios[
      Number(
        await pergunta('Escolha o horário: '),
      ) - 1
    ];

  if (!hora) {
    throw new Error('Horário inválido.');
  }

  const observacao = await pergunta(
    'Observação (opcional): ',
  );

  const r = await api<{
    agendamento: Agendamento;
    comanda: any;
  }>('/agendamentos', {
    method: 'POST',
    body: JSON.stringify({
      clienteId: cliente?.id,
      barbeiroId: barbeiro.id,
      servicoId: servico.id,
      dataHora: `${data}T${hora}:00.000Z`,
      observacao: observacao || undefined,
    }),
  });

  console.log(
    `\n✓ Agendamento criado. ID: ${r.agendamento.id}\n` +
    `Comanda: ${r.comanda.id}`,
  );
}

async function listarAgendamentos() {
  titulo(
    usuario?.role === 'CLIENTE'
      ? 'MEUS AGENDAMENTOS'
      : 'AGENDAMENTOS',
  );

  const data = await pergunta(
    'Filtrar por data YYYY-MM-DD (ENTER = todos): ',
  );

  const rows = await api<Agendamento[]>(
    data
      ? `/agendamentos?data=${encodeURIComponent(data)}`
      : '/agendamentos',
  );

  tabela(
    [
      'ID',
      'DATA/HORA',
      'CLIENTE',
      'BARBEIRO',
      'SERVIÇO',
      'STATUS',
      'VALOR',
    ],
    rows.map((a) => [
      a.id.slice(0, 8),
      dataHora(a.dataHora),
      a.usuario.nome,
      a.barbeiro.nome,
      a.servico.nome,
      a.status,
      dinheiro(a.servico.preco),
    ]),
  );
}

async function atualizarStatusAgendamento() {
  titulo('ATUALIZAR AGENDAMENTO');

  const rows = await api<Agendamento[]>(
    '/agendamentos',
  );

  if (!rows.length) {
    throw new Error('Nenhum agendamento.');
  }

  tabela(
    [
      '#',
      'DATA/HORA',
      'CLIENTE',
      'SERVIÇO',
      'STATUS',
    ],
    rows.map((a, i) => [
      `${i + 1}`,
      dataHora(a.dataHora),
      a.usuario.nome,
      a.servico.nome,
      a.status,
    ]),
  );

  const a =
    rows[
      Number(await pergunta('Escolha: ')) - 1
    ];

  if (!a) {
    throw new Error('Agendamento inválido.');
  }

  const map = [
    'PENDENTE',
    'CONFIRMADO',
    'CONCLUIDO',
    'CANCELADO',
  ];

  console.log(
    '\n1. PENDENTE\n' +
    '2. CONFIRMADO\n' +
    '3. CONCLUIDO\n' +
    '4. CANCELADO',
  );

  const status =
    map[
      Number(
        await pergunta('Novo status: '),
      ) - 1
    ];

  if (!status) {
    throw new Error('Status inválido.');
  }

  await api(
    `/agendamentos/${a.id}/status`,
    {
      method: 'PATCH',
      body: JSON.stringify({
        status,
      }),
    },
  );

  console.log('✓ Status atualizado.');
}

/* ============================================================
 * COMANDAS
 * ============================================================
 */

async function listarComandas() {
  titulo('COMANDAS / FINANCEIRO');

  const rows = await api<any[]>('/comandas');

  tabela(
    [
      'ID',
      'CLIENTE',
      'VALOR',
      'STATUS',
      'PAGAMENTO',
    ],
    rows.map((c) => [
      c.id.slice(0, 8),
      c.usuario.nome,
      dinheiro(c.valorTotal),
      c.status,
      c.formaPagto ?? '-',
    ]),
  );
}

async function atualizarComanda() {
  titulo('ATUALIZAR COMANDA');

  const rows = await api<any[]>('/comandas');

  if (!rows.length) {
    throw new Error('Nenhuma comanda.');
  }

  tabela(
    [
      '#',
      'CLIENTE',
      'VALOR',
      'STATUS',
      'PAGAMENTO',
    ],
    rows.map((c, i) => [
      `${i + 1}`,
      c.usuario.nome,
      dinheiro(c.valorTotal),
      c.status,
      c.formaPagto ?? '-',
    ]),
  );

  const c =
    rows[
      Number(await pergunta('Escolha: ')) - 1
    ];

  if (!c) {
    throw new Error('Comanda inválida.');
  }

  const status = await pergunta(
    'Status [ABERTA/PAGA/CANCELADA] (ENTER mantém): ',
  );

  const formaPagto = await pergunta(
    'Forma de pagamento (ENTER mantém): ',
  );

  await api(
    `/comandas/${c.id}`,
    {
      method: 'PATCH',
      body: JSON.stringify({
        status: status || undefined,
        formaPagto: formaPagto || undefined,
      }),
    },
  );

  console.log('✓ Comanda atualizada.');
}

/* ============================================================
 * DADOS PESSOAIS
 * ============================================================
 */

async function minhasInformacoes() {
  titulo('MEU CADASTRO');

  const me = await api<Usuario>('/me');

  console.log(
    `Nome: ${me.nome}\n` +
    `E-mail: ${me.email}\n` +
    `Telefone: ${me.telefone ?? '-'}\n` +
    `Perfil: ${me.role}`,
  );
}

async function verDadosCliente() {
  titulo(
    'DADOS PESSOAIS — ACESSO ADMINISTRATIVO',
  );

  const rows = await api<Cliente[]>('/clientes');

  if (!rows.length) {
    throw new Error('Nenhum cliente.');
  }

  tabela(
    ['#', 'NOME', 'E-MAIL', 'TELEFONE'],
    rows.map((c, i) => [
      `${i + 1}`,
      c.nome,
      c.email,
      c.telefone ?? '-',
    ]),
  );

  const c =
    rows[
      Number(await pergunta('Cliente: ')) - 1
    ];

  if (!c) {
    throw new Error('Cliente inválido.');
  }

  const r = await api<{
    id: string;
    nome: string;
    email: string;
    telefone: string | null;
    cpf: string | null;
  }>(
    `/admin/clientes/${c.id}/dados-pessoais`,
  );

  console.log(
    `\nNome: ${r.nome}\n` +
    `E-mail: ${r.email}\n` +
    `Telefone: ${r.telefone ?? '-'}\n` +
    `CPF: ${r.cpf ?? '-'}`,
  );

  console.log(
    '\n⚠ Consulta registrada no log de acesso a dado sensível.',
  );
}

async function resetarSenhaCliente() {
  titulo('REDEFINIR SENHA DE CLIENTE');

  const rows = await api<Cliente[]>('/clientes');

  if (!rows.length) {
    throw new Error('Nenhum cliente.');
  }

  tabela(
    ['#', 'NOME', 'E-MAIL'],
    rows.map((c, i) => [
      `${i + 1}`,
      c.nome,
      c.email,
    ]),
  );

  const c =
    rows[
      Number(await pergunta('Cliente: ')) - 1
    ];

  if (!c) {
    throw new Error('Cliente inválido.');
  }

  if (
    !await confirmar(
      `Gerar nova senha temporária para ${c.nome}?`,
    )
  ) {
    return;
  }

  const r = await api<{
    mensagem: string;
    senhaTemporaria: string;
  }>(
    `/admin/clientes/${c.id}/resetar-senha`,
    {
      method: 'POST',
    },
  );

  console.log(
    `\n✓ ${r.mensagem}\n\n` +
    `SENHA TEMPORÁRIA: ${r.senhaTemporaria}\n\n` +
    `Anote/copie agora. Ela não pode ser recuperada posteriormente.`,
  );
}

async function listarSolicitacoesReset() {
  titulo('SOLICITAÇÕES DE REDEFINIÇÃO');

  const rows = await api<ResetRequest[]>(
    '/admin/redefinicoes',
  );

  tabela(
    [
      'ID',
      'CLIENTE',
      'E-MAIL',
      'SOLICITADO',
      'EXPIRA',
    ],
    rows.map((r) => [
      r.id.slice(0, 8),
      r.clienteId.slice(0, 8),
      r.email,
      dataHora(r.solicitadoEm),
      dataHora(r.expiraEm),
    ]),
  );
}

/* ============================================================
 * EXECUÇÃO
 * ============================================================
 */

async function executar(
  fn: () => Promise<void>,
) {
  try {
    await fn();
  } catch (e: any) {
    console.log(
      `\n✗ ${e?.message ?? 'Erro inesperado'}`,
    );
  }

  await pausar();
}

/* ============================================================
 * MENU PÚBLICO
 * ============================================================
 */

async function menuPublico() {
  while (!token) {
    limpar();

    titulo('TRATO FINO — SISTEMA DE BARBEARIA');

    console.log(
      '1. Entrar\n' +
      '2. Cadastrar\n' +
      '0. Sair',
    );

    const op = await pergunta('\nEscolha: ');

    if (op === '1') {
      await executar(login);
    } else if (op === '2') {
      await executar(cadastrarPublico);
    } else if (op === '0') {
      return false;
    }
  }

  return true;
}

/* ============================================================
 * MENU ADMIN
 * ============================================================
 */

async function menuAdmin(): Promise<boolean> {
  while (
    token &&
    usuario?.role === 'ADMIN'
  ) {
    limpar();

    titulo(
      `TRATO FINO — ADMIN | ${usuario.nome}`,
    );

    console.log(
      '1. Clientes\n' +
      '2. Cadastrar cliente\n' +
      '3. Cadastrar administrador\n' +
      '4. Dados pessoais de cliente\n' +
      '5. Solicitações de redefinição\n' +
      '6. Redefinir senha de cliente\n' +
      '7. Barbeiros\n' +
      '8. Cadastrar barbeiro\n' +
      '9. Serviços\n' +
      '10. Cadastrar serviço\n' +
      '11. Agendamentos\n' +
      '12. Atualizar status de agendamento\n' +
      '13. Comandas / financeiro\n' +
      '14. Atualizar comanda\n' +
      '15. Meu cadastro\n' +
      '16. Alterar minha senha\n' +
      '0. Sair',
    );

    const op = await pergunta('\nEscolha: ');

    const actions: Record<
      string,
      () => Promise<void>
    > = {
      '1': listarClientes,
      '2': cadastrarCliente,
      '3': cadastrarAdmin,
      '4': verDadosCliente,
      '5': listarSolicitacoesReset,
      '6': resetarSenhaCliente,
      '7': listarBarbeiros,
      '8': cadastrarBarbeiro,
      '9': listarServicos,
      '10': cadastrarServico,
      '11': listarAgendamentos,
      '12': atualizarStatusAgendamento,
      '13': listarComandas,
      '14': atualizarComanda,
      '15': minhasInformacoes,
      '16': () => alterarSenha(),
    };

    if (op === '0') {
      await logout();
      return false;
    }

    if (actions[op]) {
      await executar(actions[op]);
    }
  }

  return true;
}

/* ============================================================
 * MENU CLIENTE
 * ============================================================
 */

async function menuCliente(): Promise<boolean> {
  while (
    token &&
    usuario?.role === 'CLIENTE'
  ) {
    limpar();

    titulo(
      `TRATO FINO — CLIENTE | ${usuario.nome}`,
    );

    console.log(
      '1. Agendar atendimento\n' +
      '2. Meus agendamentos\n' +
      '3. Serviços\n' +
      '4. Barbeiros\n' +
      '5. Meu cadastro\n' +
      '6. Alterar minha senha\n' +
      '0. Sair',
    );

    const op = await pergunta('\nEscolha: ');

    const actions: Record<
      string,
      () => Promise<void>
    > = {
      '1': novoAgendamento,
      '2': listarAgendamentos,
      '3': listarServicos,
      '4': listarBarbeiros,
      '5': minhasInformacoes,
      '6': () => alterarSenha(),
    };

    if (op === '0') {
      await logout();
      return false;
    }

    if (actions[op]) {
      await executar(actions[op]);
    }
  }

  return true;
}

/* ============================================================
 * MAIN
 * ============================================================
 */

async function fecharReadline() {
  if (rl) {
    rl.close();
    rl = null;
  }

  if (input.isTTY) {
    try {
      input.setRawMode(false);
    } catch {
      // Terminal já pode estar normal.
    }
  }
}

async function main() {
  console.log(`API: ${API_URL}`);

  while (true) {
    const entrou = await menuPublico();

    if (!entrou) {
      break;
    }

    if (usuario?.role === 'ADMIN') {
      await menuAdmin();
    } else if (usuario?.role === 'CLIENTE') {
      await menuCliente();
    }
  }

  await fecharReadline();

  console.log('\nAté logo! 👋');
}

main().catch(async (e) => {
  console.error(e);

  await fecharReadline();

  process.exit(1);
});