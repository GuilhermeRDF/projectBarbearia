import express, { Request, Response } from 'express';
import cors from 'cors';
import { PrismaClient } from '@prisma/client';
import { z } from 'zod';

const app = express();
const prisma = new PrismaClient();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Esquemas de Validação com Zod
const criarAgendamentoSchema = z.object({
  barbeiroId: z.number(),
  clienteId: z.number(),
  servicoId: z.number(),
  dataHora: z.string().datetime(),
});

const atualizarStatusSchema = z.object({
  status: z.enum(['PENDENTE', 'CONFIRMADO', 'CONCLUIDO', 'CANCELADO']),
});

// GET - Listar Barbeiros
app.get('/barbeiros', async (_req: Request, res: Response) => {
  try {
    const db = prisma as any;
    const model = db.barbeiro || db.barbeiros;
    const barbeiros = await model.findMany();
    res.json(barbeiros);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar barbeiros' });
  }
});

// GET - Listar Serviços
app.get('/servicos', async (_req: Request, res: Response) => {
  try {
    const db = prisma as any;
    const model = db.servico || db.servicos;
    const servicos = await model.findMany();
    res.json(servicos);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar serviços' });
  }
});

// GET - Listar Clientes
app.get('/clientes', async (_req: Request, res: Response) => {
  try {
    const db = prisma as any;
    const model = db.cliente || db.clientes;
    const clientes = await model.findMany();
    res.json(clientes);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar clientes' });
  }
});

// GET - Listar Agendamentos
app.get('/agendamentos', async (_req: Request, res: Response) => {
  try {
    const db = prisma as any;
    const model = db.agendamento || db.agendamentos;
    const agendamentos = await model.findMany({
      include: {
        barbeiro: true,
        cliente: true,
        servico: true,
      },
    });
    res.json(agendamentos);
  } catch (error) {
    res.status(500).json({ error: 'Erro ao buscar agendamentos' });
  }
});

// POST - Criar Agendamento
app.post('/agendamentos', async (req: Request, res: Response) => {
  const validacao = criarAgendamentoSchema.safeParse(req.body);

  if (!validacao.success) {
    res.status(400).json({
      error: 'Dados inválidos',
      detalhes: validacao.error.issues.map((issue) => issue.message),
    });
    return;
  }

  const { barbeiroId, clienteId, servicoId, dataHora } = validacao.data;

  try {
    const db = prisma as any;
    const model = db.agendamento || db.agendamentos;

    const agendamentoData = new Date(dataHora);

    const conflito = await model.findFirst({
      where: {
        barbeiroId,
        dataHorario: agendamentoData,
        status: { not: 'CANCELADO' },
      },
    });

    if (conflito) {
      res.status(409).json({ error: 'Este barbeiro já possui um agendamento para este horário.' });
      return;
    }

    const novoAgendamento = await model.create({
      data: {
        barbeiroId,
        clienteId,
        servicoId,
        dataHorario: agendamentoData,
        status: 'PENDENTE',
      },
    });

    res.status(201).json(novoAgendamento);
  } catch (error: any) {
    console.error('Erro:', error);
    res.status(500).json({ error: 'Erro ao processar o agendamento', detalhes: error.message });
  }
});

// PATCH - Atualizar Status
app.patch('/agendamentos/:id/status', async (req: Request, res: Response) => {
  const { id } = req.params;
  const validacao = atualizarStatusSchema.safeParse(req.body);

  if (!validacao.success) {
    res.status(400).json({
      error: 'Dados inválidos',
      detalhes: validacao.error.issues.map((issue) => issue.message),
    });
    return;
  }

  try {
    const db = prisma as any;
    const model = db.agendamento || db.agendamentos;

    const agendamentoAtualizado = await model.update({
      where: { id: Number(id) },
      data: { status: validacao.data.status },
    });

    res.json(agendamentoAtualizado);
  } catch (error: any) {
    res.status(500).json({ error: 'Erro ao atualizar status', detalhes: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando na porta ${PORT}`);
});