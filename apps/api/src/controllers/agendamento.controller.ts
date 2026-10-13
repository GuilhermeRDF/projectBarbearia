import { Request, Response } from 'express';
import { Prisma } from '@prisma/client';
import { prisma } from '../lib/prisma';
import { AgendamentoService } from '../services/agendamento.service';
import { intervaloValido } from '../domain/agendamento';

export class AgendamentoController {
  static async obterHorariosDisponiveis(req: Request, res: Response) {
    try {
      const { barbeiroId, servicoId, data } = req.query;
      const barbeariaId = req.usuario?.barbeariaId;
      if (!barbeariaId) return res.status(403).json({ error: 'Barbearia não identificada na sessão' });
      if (!barbeiroId || !servicoId || !data) {
        return res.status(400).json({ error: 'Informe barbeiroId, servicoId e data (YYYY-MM-DD)' });
      }
      const horarios = await AgendamentoService.calcularHorariosDisponiveis(
        String(barbeiroId), String(servicoId), String(data),
        barbeariaId,
      );
      return res.json(horarios);
    } catch (err) {
      return res.status(400).json({ error: err instanceof Error ? err.message : 'Erro ao consultar horários' });
    }
  }

  static async criarAgendamento(req: Request, res: Response) {
    try {
      const usuarioId = req.usuario?.id;
      const { barbeiroId, servicoId, dataHora } = req.body as Record<string, unknown>;
      const barbeariaId = req.usuario?.barbeariaId;
      if (!usuarioId || !barbeariaId || typeof barbeiroId !== 'string' ||
          typeof servicoId !== 'string' || typeof dataHora !== 'string') {
        return res.status(400).json({ error: 'Dados obrigatórios do agendamento inválidos' });
      }
      const inicio = new Date(dataHora);
      const [servico, barbeiro] = await Promise.all([
        prisma.servico.findFirst({ where: { id: servicoId, barbeariaId, estaAtivo: true } }),
        prisma.perfilFuncionario.findFirst({ where: { id: barbeiroId, barbeariaId, estaDisponivel: true } }),
      ]);
      if (!servico || !barbeiro) return res.status(404).json({ error: 'Barbeiro ou serviço não encontrado' });
      const fim = new Date(inicio.getTime() + servico.duracaoMinutos * 60_000);
      if (!intervaloValido(inicio, fim)) return res.status(400).json({ error: 'Intervalo de agendamento inválido' });

      const resultado = await prisma.$transaction(async (tx) => {
        const conflito = await tx.agendamento.findFirst({
          where: {
            barbeiroId, barbeariaId, status: { not: 'CANCELADO' },
            inicioAgendado: { lt: fim }, fimAgendado: { gt: inicio },
          },
        });
        if (conflito) throw new Error('Este barbeiro já possui um atendimento neste horário');
        const agendamento = await tx.agendamento.create({
          data: {
            barbeariaId, usuarioId, barbeiroId, servicoId,
            inicioAgendado: inicio, fimAgendado: fim, status: 'PENDENTE',
            criadoPor: usuarioId,
          },
        });
        await tx.servicoAgendamento.create({
          data: { agendamentoId: agendamento.id, servicoId, preco: servico.preco, duracaoMinutos: servico.duracaoMinutos },
        });
        const comissao = new Prisma.Decimal(servico.preco.toString())
          .mul(new Prisma.Decimal(barbeiro.comissaoPorcent.toString()))
          .div(100)
          .toDecimalPlaces(2);
        const comanda = await tx.comanda.create({
          data: {
            barbeariaId, usuarioId, agendamentoId: agendamento.id, valorTotal: servico.preco,
            status: 'ABERTA',
            itens: { create: { servicoId, barbeiroId, preco: servico.preco, comissao } },
          },
        });
        return { agendamento, comanda };
      });
      return res.status(201).json(resultado);
    } catch (err) {
      return res.status(400).json({ error: err instanceof Error ? err.message : 'Erro ao criar agendamento' });
    }
  }
}
