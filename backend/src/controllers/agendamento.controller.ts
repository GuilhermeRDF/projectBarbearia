import { Request, Response } from 'express';
import { prisma } from '../lib/prisma';
import { AgendamentoService } from '../services/agendamento.service';

export class AgendamentoController {
  // Consulta de Horários Livres (Pública para o Cliente)
  static async obterHorariosDisponiveis(req: Request, res: Response) {
    try {
      const { barbeiroId, servicoId, data } = req.query;

      if (!barbeiroId || !servicoId || !data) {
        return res.status(400).json({ error: 'Informe barbeiroId, servicoId e data (YYYY-MM-DD)' });
      }

      const horarios = await AgendamentoService.calcularHorariosDisponiveis(
        String(barbeiroId),
        String(servicoId),
        String(data)
      );

      return res.json(horarios);
    } catch (err: any) {
      return res.status(400).json({ error: err.message });
    }
  }

  // Criar Agendamento + Abertura de Comanda Automática
  static async criarAgendamento(req: Request, res: Response) {
    try {
      const usuarioId = req.usuario!.id;
      const { barbeariaId, barbeiroId, servicoId, dataHora } = req.body;

      const servico = await prisma.servico.findUnique({ where: { id: servicoId } });
      if (!servico) return res.status(404).json({ error: 'Serviço não encontrado' });

      const barbeiro = await prisma.barbeiro.findUnique({ where: { id: barbeiroId } });
      if (!barbeiro) return res.status(404).json({ error: 'Barbeiro não encontrado' });

      // Transação do Prisma: Cria o Agendamento e abre a Comanda do Financeiro em uma única operação
      const resultado = await prisma.$transaction(async (tx) => {
        const agendamento = await tx.agendamento.create({
          data: {
            barbeariaId,
            usuarioId,
            barbeiroId,
            servicoId,
            dataHora: new Date(dataHora),
            status: 'PENDENTE'
          }
        });

        // Comissão base calculada sobre a taxa cadastrada no barbeiro
        const valorComissao = (servico.preco * barbeiro.comissaoPorcent) / 100;

        const comanda = await tx.comanda.create({
          data: {
            barbeariaId,
            usuarioId,
            agendamentoId: agendamento.id,
            valorTotal: servico.preco,
            status: 'ABERTA',
            itens: {
              create: {
                servicoId: servico.id,
                barbeiroId: barbeiro.id,
                preco: servico.preco,
                comissao: valorComissao
              }
            }
          }
        });

        return { agendamento, comanda };
      });

      return res.status(201).json(resultado);
    } catch (err: any) {
      return res.status(500).json({ error: err.message });
    }
  }
}