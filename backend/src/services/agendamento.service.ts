import { prisma } from '../lib/prisma';

function timeToMinutes(timeStr: string | null | undefined): number {
  if (!timeStr) return 0;

  const [hours, minutes] = timeStr.split(':').map(Number);

  return hours * 60 + (minutes || 0);
}

function minutesToTime(minutes: number): string {
  const h = Math.floor(minutes / 60).toString().padStart(2, '0');
  const m = (minutes % 60).toString().padStart(2, '0');

  return `${h}:${m}`;
}

export class AgendamentoService {
  static async calcularHorariosDisponiveis(
    barbeiroId: string,
    servicoId: string,
    dataStr: string
  ) {
    const barbeiro = await prisma.barbeiro.findUnique({
      where: {
        id: barbeiroId,
      },
    });

    const servico = await prisma.servico.findUnique({
      where: {
        id: servicoId,
      },
    });

    if (!barbeiro || !servico) {
      throw new Error('Barbeiro ou serviço não encontrado');
    }

    const inicioDia = new Date(`${dataStr}T00:00:00.000Z`);
    const fimDia = new Date(`${dataStr}T23:59:59.999Z`);

    const agendamentosExistentes =
      await prisma.agendamento.findMany({
        where: {
          barbeiroId: barbeiroId,

          status: {
            not: 'CANCELADO',
          },

          dataHora: {
            gte: inicioDia,
            lte: fimDia,
          },
        },

        include: {
          servico: true,
        },
      });

    const intervalosOcupados = agendamentosExistentes.map((agendamento) => {
      const dataHora = new Date(agendamento.dataHora);

      const inicioMin =
        dataHora.getUTCHours() * 60 +
        dataHora.getUTCMinutes();

      const duracao =
        agendamento.servico?.duracaoMinutos ??
        servico.duracaoMinutos;

      return {
        inicio: inicioMin,
        fim: inicioMin + duracao,
      };
    });

    const expInicio = timeToMinutes(barbeiro.horarioInicio);
    const expFim = timeToMinutes(barbeiro.horarioFim);

    const almocoInicio = barbeiro.inicioAlmoco
      ? timeToMinutes(barbeiro.inicioAlmoco)
      : null;

    const almocoFim = barbeiro.fimAlmoco
      ? timeToMinutes(barbeiro.fimAlmoco)
      : null;

    const duracaoServico = servico.duracaoMinutos;

    const intervaloPasso = 30;

    const horariosLivres: string[] = [];

    for (
      let minutoAtual = expInicio;
      minutoAtual + duracaoServico <= expFim;
      minutoAtual += intervaloPasso
    ) {
      const slotInicio = minutoAtual;
      const slotFim = minutoAtual + duracaoServico;

      // Verifica horário de almoço
      if (almocoInicio !== null && almocoFim !== null) {
        const conflitaComAlmoco =
          slotInicio < almocoFim &&
          slotFim > almocoInicio;

        if (conflitaComAlmoco) {
          continue;
        }
      }

      // Verifica agendamentos existentes
      const temConflito = intervalosOcupados.some(
        (ocupado) =>
          slotInicio < ocupado.fim &&
          slotFim > ocupado.inicio
      );

      if (!temConflito) {
        horariosLivres.push(minutesToTime(slotInicio));
      }
    }

    return horariosLivres;
  }
}