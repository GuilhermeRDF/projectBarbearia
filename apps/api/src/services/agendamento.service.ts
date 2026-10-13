import { prisma } from '../lib/prisma';
import { intervalosSeSobrepoem } from '../domain/agendamento';

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
    dataStr: string,
    barbeariaId?: string,
  ): Promise<string[]> {
    const [barbeiro, servico] = await Promise.all([
      prisma.perfilFuncionario.findFirst({
        where: {
          id: barbeiroId,
          ...(barbeariaId ? { barbeariaId } : {}),
          estaDisponivel: true,
        },
      }),
      prisma.servico.findFirst({
        where: {
          id: servicoId,
          ...(barbeariaId ? { barbeariaId } : {}),
          estaAtivo: true,
        },
      }),
    ]);

    if (!barbeiro || !servico) {
      throw new Error('Barbeiro ou serviço não encontrado');
    }

    const inicioDia = new Date(`${dataStr}T00:00:00.000Z`);
    const fimDia = new Date(`${dataStr}T23:59:59.999Z`);
    const agendamentos = await prisma.agendamento.findMany({
      where: {
        barbeiroId,
        ...(barbeariaId ? { barbeariaId } : {}),
        status: { not: 'CANCELADO' },
        inicioAgendado: { lt: fimDia },
        fimAgendado: { gt: inicioDia },
      },
      select: { inicioAgendado: true, fimAgendado: true },
    });

    const ocupados = agendamentos.map((a) => ({
      inicio: a.inicioAgendado.getUTCHours() * 60 + a.inicioAgendado.getUTCMinutes(),
      fim: a.fimAgendado.getUTCHours() * 60 + a.fimAgendado.getUTCMinutes(),
    }));

    const inicioExpediente = timeToMinutes(barbeiro.horarioInicio);
    const fimExpediente = timeToMinutes(barbeiro.horarioFim);
    const almocoInicio = barbeiro.inicioAlmoco ? timeToMinutes(barbeiro.inicioAlmoco) : null;
    const almocoFim = barbeiro.fimAlmoco ? timeToMinutes(barbeiro.fimAlmoco) : null;
    const duracao = servico.duracaoMinutos;
    const horarios: string[] = [];

    for (let minuto = inicioExpediente; minuto + duracao <= fimExpediente; minuto += 30) {
      const fim = minuto + duracao;
      if (almocoInicio !== null && almocoFim !== null &&
          intervalosSeSobrepoem(minuto, fim, almocoInicio, almocoFim)) continue;
      if (ocupados.some((o) => intervalosSeSobrepoem(minuto, fim, o.inicio, o.fim))) continue;
      horarios.push(minutesToTime(minuto));
    }

    return horarios;
  }
}
