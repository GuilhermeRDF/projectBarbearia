
import '../src/config/load-env';
import bcrypt from 'bcryptjs';
import { PrismaClient, RoleUsuario } from '@prisma/client';
import { encrypt, blindIndex } from '../src/lib/crypto';

const prisma = new PrismaClient();

const SENHA_DEMO = 'TratoFino@123';

const clientes = [
  'Lucas Ferreira',
  'Gabriel Oliveira',
  'Matheus Santos',
  'Pedro Henrique Costa',
  'Rafael Almeida',
  'Bruno Carvalho',
  'Felipe Rodrigues',
  'Gustavo Martins',
  'Thiago Ribeiro',
  'Leonardo Gomes',
  'André Lima',
  'Vinicius Rocha',
  'Eduardo Barros',
  'Caio Mendes',
  'Daniel Azevedo',
  'João Victor Souza',
  'Marcelo Nunes',
  'Rodrigo Freitas',
  'Diego Moreira',
  'Samuel Batista',
];

const barbeiros = [
  {
    nome: 'Carlos Eduardo Navalha',
    especialidade: 'Cortes clássicos e degradê',
    bio: 'Especialista em cortes masculinos clássicos e modernos.',
    inicio: '08:00',
    fim: '18:00',
    almocoInicio: '12:00',
    almocoFim: '13:00',
    comissao: 40,
  },
  {
    nome: 'Marcos Vinicius Silva',
    especialidade: 'Barba e visagismo',
    bio: 'Especialista em barba, acabamento e visagismo masculino.',
    inicio: '09:00',
    fim: '19:00',
    almocoInicio: '13:00',
    almocoFim: '14:00',
    comissao: 35,
  },
  {
    nome: 'Anderson Pereira',
    especialidade: 'Degradê e freestyle',
    bio: 'Profissional especializado em cortes modernos e freestyle.',
    inicio: '08:00',
    fim: '17:00',
    almocoInicio: '12:00',
    almocoFim: '13:00',
    comissao: 40,
  },
  {
    nome: 'Ricardo Mendes',
    especialidade: 'Cortes sociais e infantis',
    bio: 'Atendimento especializado em cortes sociais e infantis.',
    inicio: '10:00',
    fim: '19:00',
    almocoInicio: '13:00',
    almocoFim: '14:00',
    comissao: 35,
  },
  {
    nome: 'Felipe Augusto Costa',
    especialidade: 'Cortes modernos e barba',
    bio: 'Especialista em transformação visual e cuidados masculinos.',
    inicio: '08:00',
    fim: '18:00',
    almocoInicio: '12:00',
    almocoFim: '13:00',
    comissao: 40,
  },
];

const servicos = [
  {
    nome: 'Corte Masculino',
    descricao: 'Corte tradicional com acabamento.',
    preco: 45,
    duracao: 30,
  },
  {
    nome: 'Corte Degradê',
    descricao: 'Corte com degradê e acabamento profissional.',
    preco: 50,
    duracao: 40,
  },
  {
    nome: 'Barba Completa',
    descricao: 'Modelagem, navalha e acabamento da barba.',
    preco: 35,
    duracao: 30,
  },
  {
    nome: 'Corte + Barba',
    descricao: 'Corte masculino acompanhado de barba.',
    preco: 75,
    duracao: 60,
  },
  {
    nome: 'Sobrancelha',
    descricao: 'Design e limpeza de sobrancelhas.',
    preco: 15,
    duracao: 15,
  },
  {
    nome: 'Pigmentação',
    descricao: 'Pigmentação capilar para acabamento.',
    preco: 25,
    duracao: 20,
  },
  {
    nome: 'Hidratação Capilar',
    descricao: 'Tratamento hidratante para os cabelos.',
    preco: 40,
    duracao: 30,
  },
  {
    nome: 'Corte Infantil',
    descricao: 'Corte especializado para crianças.',
    preco: 40,
    duracao: 30,
  },
];

async function criarUsuario({
  nome,
  email,
  telefone,
  cpf,
  barbeariaId,
  role = 'CLIENTE',
  eEquipe = false,
}: {
  nome: string;
  email: string;
  telefone: string;
  cpf: string;
  barbeariaId: string;
  role?: RoleUsuario;
  eEquipe?: boolean;
}) {
  const emailNormalizado = email.toLowerCase().trim();

  const emailHash = blindIndex(emailNormalizado);

  let usuario = await prisma.usuario.findFirst({
    where: {
      dadosPessoais: {
        hashBuscaEmail: emailHash,
      },
    },
  });

  if (!usuario) {
    const hashSenha = await bcrypt.hash(SENHA_DEMO, 12);

    usuario = await prisma.usuario.create({
      data: {
        barbeariaId,
        role,
        estaAtivo: true,
        eEquipe,
        eSuperusuario: false,

        credencial: {
          create: {
            hashSenha,
            versaoSenha: 1,
            mfaHabilitado: false,
            senhaTemporaria: false,
          },
        },

        dadosPessoais: {
          create: {
            nomeCompletoCriptografado: encrypt(nome),
            cpfCriptografado: encrypt(cpf),
            hashBuscaCpf: blindIndex(cpf),
            emailCriptografado: encrypt(emailNormalizado),
            hashBuscaEmail: emailHash,
            telefoneCriptografado: encrypt(telefone),
            hashBuscaTelefone: blindIndex(telefone),
            versaoChaveCriptografia: 1,
          },
        },
      },
    });
  }

  return usuario;
}

async function main() {
  console.log('\n========================================');
  console.log('   CARGA DE DADOS - TRATO FINO');
  console.log('========================================\n');

  const barbearia = await prisma.barbearia.findUnique({
    where: { slug: 'trato-fino' },
  });

  if (!barbearia) {
    throw new Error(
      'Barbearia Trato Fino não encontrada. Execute primeiro o seed.ts.',
    );
  }

  // ==================================================
  // 1. SERVIÇOS
  // ==================================================

  console.log('💈 Cadastrando serviços...');

  const servicosCriados = [];

  for (const item of servicos) {
    let servico = await prisma.servico.findFirst({
      where: {
        barbeariaId: barbearia.id,
        nome: item.nome,
      },
    });

    if (servico) {
      servico = await prisma.servico.update({
        where: { id: servico.id },
        data: {
          descricao: item.descricao,
          preco: item.preco,
          duracaoMinutos: item.duracao,
          estaAtivo: true,
        },
      });
    } else {
      servico = await prisma.servico.create({
        data: {
          barbeariaId: barbearia.id,
          nome: item.nome,
          descricao: item.descricao,
          preco: item.preco,
          duracaoMinutos: item.duracao,
          estaAtivo: true,
        },
      });
    }

    servicosCriados.push(servico);
    console.log(`  ✔ ${servico.nome}`);
  }

  // ==================================================
  // 2. BARBEIROS
  // ==================================================

  console.log('\n✂️ Cadastrando barbeiros...');

  const barbeirosCriados = [];

  for (let i = 0; i < barbeiros.length; i++) {
    const item = barbeiros[i];

    const email = `barbeiro${i + 1}@tratofino.com`;
    const telefone = `6199000000${String(i + 1).padStart(2, '0')}`;
    const cpf = String(20000000001 + i);

    const usuario = await criarUsuario({
      nome: item.nome,
      email,
      telefone,
      cpf,
      barbeariaId: barbearia.id,
      role: 'CLIENTE',
      eEquipe: true,
    });

    const funcionario = await prisma.perfilFuncionario.upsert({
      where: {
        usuarioId: usuario.id,
      },
      update: {
        barbeariaId: barbearia.id,
        nomeExibicao: item.nome,
        bio: item.bio,
        especialidade: item.especialidade,
        estaDisponivel: true,
        horarioInicio: item.inicio,
        horarioFim: item.fim,
        inicioAlmoco: item.almocoInicio,
        fimAlmoco: item.almocoFim,
        comissaoPorcent: item.comissao,
      },
      create: {
        usuarioId: usuario.id,
        barbeariaId: barbearia.id,
        nomeExibicao: item.nome,
        bio: item.bio,
        especialidade: item.especialidade,
        estaDisponivel: true,
        horarioInicio: item.inicio,
        horarioFim: item.fim,
        inicioAlmoco: item.almocoInicio,
        fimAlmoco: item.almocoFim,
        comissaoPorcent: item.comissao,
      },
    });

    barbeirosCriados.push(funcionario);

    // Associar todos os serviços a cada barbeiro.
    for (const servico of servicosCriados) {
      await prisma.servicoBarbeiro.upsert({
        where: {
          barbeiroId_servicoId: {
            barbeiroId: funcionario.id,
            servicoId: servico.id,
          },
        },
        update: {
          estaAtivo: true,
        },
        create: {
          barbeiroId: funcionario.id,
          servicoId: servico.id,
          estaAtivo: true,
        },
      });
    }

    // Horários: segunda a sábado.
    for (let dia = 1; dia <= 6; dia++) {
      const horarioExistente = await prisma.horarioTrabalho.findFirst({
        where: {
          barbeiroId: funcionario.id,
          diaSemana: dia,
          horaInicio: item.inicio,
          horaFim: item.fim,
        },
      });

      if (!horarioExistente) {
        await prisma.horarioTrabalho.create({
          data: {
            barbeiroId: funcionario.id,
            diaSemana: dia,
            horaInicio: item.inicio,
            horaFim: item.fim,
            estaAtivo: true,
          },
        });
      }
    }

    console.log(`  ✔ ${item.nome} (${email})`);
  }

  // ==================================================
  // 3. CLIENTES
  // ==================================================

  console.log('\n👥 Cadastrando clientes...');

  for (let i = 0; i < clientes.length; i++) {
    const nome = clientes[i];

    const email = `cliente${i + 1}@teste.tratofino.com`;
    const telefone = `6199100000${String(i + 1).padStart(2, '0')}`;
    const cpf = String(30000000001 + i);

    const usuario = await criarUsuario({
      nome,
      email,
      telefone,
      cpf,
      barbeariaId: barbearia.id,
    });

    await prisma.perfilCliente.upsert({
      where: {
        usuarioId: usuario.id,
      },
      update: {},
      create: {
        usuarioId: usuario.id,
      },
    });

    console.log(`  ✔ ${nome}`);
  }

  // ==================================================
  // 4. RESUMO
  // ==================================================

  const totalClientes = await prisma.perfilCliente.count({
    where: {
      usuario: {
        barbeariaId: barbearia.id,
      },
    },
  });

  const totalBarbeiros = await prisma.perfilFuncionario.count({
    where: {
      barbeariaId: barbearia.id,
    },
  });

  const totalServicos = await prisma.servico.count({
    where: {
      barbeariaId: barbearia.id,
      estaAtivo: true,
    },
  });

  console.log('\n========================================');
  console.log('        CARGA CONCLUÍDA!');
  console.log('========================================');
  console.log(`👥 Clientes: ${totalClientes}`);
  console.log(`✂️ Barbeiros/equipe: ${totalBarbeiros}`);
  console.log(`💈 Serviços ativos: ${totalServicos}`);
  console.log('========================================');
  console.log(`\n🔑 Senha dos usuários de demonstração: ${SENHA_DEMO}`);
  console.log('📧 Barbeiros: barbeiro1@tratofino.com até barbeiro5@tratofino.com');
  console.log('📧 Clientes: cliente1@teste.tratofino.com até cliente20@teste.tratofino.com');
}

main()
  .catch((error) => {
    console.error('\n❌ Erro durante a carga:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
