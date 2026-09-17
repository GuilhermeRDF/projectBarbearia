import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const db = prisma as any;

  const agendamento = db.agendamento || db.agendamentos;
  const servico = db.servico || db.servicos;
  const barbeiro = db.barbeiro || db.barbeiros;
  const cliente = db.cliente || db.clientes;

  // 1. Limpeza
  if (agendamento) await agendamento.deleteMany({});
  if (servico) await servico.deleteMany({});
  if (barbeiro) await barbeiro.deleteMany({});
  if (cliente) await cliente.deleteMany({});

  // 2. Barbeiro
  if (barbeiro) {
    await barbeiro.create({
      data: {
        nome: 'Carlos Navalha',
        especialidade: 'Corte Tradicional',
      },
    });
  }

  // 3. Serviço com a chave correta
  if (servico) {
    await servico.create({
      data: {
        nome: 'Corte Masculino',
        preco: 45.0,
        duracaoMinutos: 30,
      },
    });
  }

  // 4. Cliente
  if (cliente) {
    await cliente.create({
      data: {
        nome: 'Cliente Teste',
        email: 'cliente@email.com',
        telefone: '61999998888',
      },
    });
  }

  console.log('✅ Banco de dados povoado com sucesso!');
}

main()
  .catch((e) => {
    console.error('❌ Erro no seed:', e);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });