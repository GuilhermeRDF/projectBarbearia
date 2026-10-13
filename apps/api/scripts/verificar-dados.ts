
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('\n=== CONTAGEM DE REGISTROS ===');

  console.log(`Usuários: ${await prisma.usuario.count()}`);
  console.log(`Clientes: ${await prisma.perfilCliente.count()}`);
  console.log(`Serviços: ${await prisma.servico.count()}`);
  console.log(`Agendamentos: ${await prisma.agendamento.count()}`);
  console.log(`Comandas: ${await prisma.comanda.count()}`);

  console.log('\n=== AGENDAMENTOS, SERVIÇOS E COMANDAS ===');

  const agendamentos = await prisma.agendamento.findMany({
    orderBy: { inicioAgendado: 'asc' },
    select: {
      id: true,
      inicioAgendado: true,
      fimAgendado: true,
      status: true,
      usuarioId: true,
      barbeiroId: true,
      servico: {
        select: {
          nome: true,
          preco: true,
        },
      },
      servicos: {
        select: {
          preco: true,
          duracaoMinutos: true,
          servico: {
            select: { nome: true },
          },
        },
      },
      comanda: {
        select: {
          id: true,
          agendamentoId: true,
          status: true,
          valorTotal: true,
        },
      },
      historico: {
        orderBy: { criadoEm: 'asc' },
        select: {
          acao: true,
          statusAnterior: true,
          novoStatus: true,
          criadoEm: true,
        },
      },
    },
  });

  for (const ag of agendamentos) {
    console.log(JSON.stringify({
      id: ag.id,
      inicio: ag.inicioAgendado,
      fim: ag.fimAgendado,
      status: ag.status,
      usuarioId: ag.usuarioId,
      barbeiroId: ag.barbeiroId,
      servicoPrincipal: ag.servico.nome,
      servicos: ag.servicos.map(s => ({
        nome: s.servico.nome,
        preco: s.preco.toString(),
        duracaoMinutos: s.duracaoMinutos,
      })),
      comanda: ag.comanda ? {
        id: ag.comanda.id,
        agendamentoId: ag.comanda.agendamentoId,
        status: ag.comanda.status,
        valorTotal: ag.comanda.valorTotal.toString(),
      } : null,
      historico: ag.historico,
    }, null, 2));
  }

  console.log('\n=== COMANDAS SEM AGENDAMENTO ASSOCIADO ===');

  const comandasSemAgendamento = await prisma.comanda.findMany({
    where: { agendamentoId: null },
    select: {
      id: true,
      usuarioId: true,
      status: true,
      valorTotal: true,
    },
  });

  console.log(JSON.stringify(
    comandasSemAgendamento.map(c => ({
      ...c,
      valorTotal: c.valorTotal.toString(),
    })),
    null,
    2,
  ));

  console.log('\n=== CHAVES ESTRANGEIRAS NÃO VALIDADAS ===');

  const restricoes = await prisma.$queryRaw<
    Array<{ tabela: string; restricao: string }>
  >`
    SELECT
      conrelid::regclass::text AS tabela,
      conname AS restricao
    FROM pg_constraint
    WHERE contype = 'f'
      AND NOT convalidated
    ORDER BY conrelid::regclass::text, conname
  `;

  console.log(
    restricoes.length === 0
      ? 'Nenhuma chave estrangeira pendente de validação.'
      : JSON.stringify(restricoes, null, 2),
  );
}

main()
  .catch((erro) => {
    console.error('Falha na verificação:', erro);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });