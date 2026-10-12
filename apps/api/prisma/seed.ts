import '../src/config/load-env';
import crypto from 'node:crypto';
import bcrypt from 'bcryptjs';
import { PrismaClient } from '@prisma/client';
import { encrypt, blindIndex } from '../src/lib/crypto';

const prisma = new PrismaClient();

const now = new Date();

function gerarSenhaTemporaria(): string {
  return `TF-${crypto.randomBytes(12).toString('base64url')}`;
}

async function main() {
  console.log('🌱 Inicializando banco do Trato Fino...');

  // ============================================================
  // BARBEARIA
  // ============================================================

  const barbearia = await prisma.barbearia.upsert({
    where: {
      slug: 'trato-fino',
    },
    update: {
      nome: 'Trato Fino',
    },
    create: {
      nome: 'Trato Fino',
      slug: 'trato-fino',
      telefone: '61999999999',
      endereco: 'Brasília - DF',
    },
  });

  console.log(`✅ Barbearia: ${barbearia.nome}`);

  // ============================================================
  // PERFIS DE ACESSO
  // ============================================================

  const perfilCliente = await prisma.perfilAcesso.upsert({
    where: {
      codigo: 'CLIENTE',
    },
    update: {
      nome: 'Cliente',
      descricao: 'Acesso destinado aos clientes da barbearia.',
    },
    create: {
      codigo: 'CLIENTE',
      nome: 'Cliente',
      descricao: 'Acesso destinado aos clientes da barbearia.',
      eSistema: true,
    },
  });

  const perfilAdmin = await prisma.perfilAcesso.upsert({
    where: {
      codigo: 'ADMIN',
    },
    update: {
      nome: 'Administrador',
      descricao: 'Acesso administrativo da barbearia.',
    },
    create: {
      codigo: 'ADMIN',
      nome: 'Administrador',
      descricao: 'Acesso administrativo da barbearia.',
      eSistema: true,
    },
  });

  console.log('✅ Perfis: ADMIN e CLIENTE');

  // ============================================================
  // PERMISSÕES
  // ============================================================

  const permissoes = [
    ['VER_PROPRIO_CADASTRO', 'Visualizar o próprio cadastro'],
    ['CRIAR_PROPRIO_AGENDAMENTO', 'Criar o próprio agendamento'],
    ['GERENCIAR_AGENDA', 'Gerenciar agenda'],
    ['GERENCIAR_SERVICOS', 'Gerenciar serviços'],
    ['GERENCIAR_CLIENTES', 'Gerenciar clientes'],
    ['GERENCIAR_USUARIOS', 'Gerenciar usuários'],
    ['GERENCIAR_ADMINISTRADORES', 'Gerenciar administradores'],
    ['CONSULTAR_RELATORIOS', 'Consultar relatórios'],
  ] as const;

  const permissoesCriadas = [];

  for (const [codigo, descricao] of permissoes) {
    const permissao = await prisma.permissao.upsert({
      where: {
        codigo,
      },
      update: {
        descricao,
      },
      create: {
        codigo,
        descricao,
      },
    });

    permissoesCriadas.push(permissao);
  }

  // Cliente: somente permissões próprias.
  const permissoesCliente = [
    'VER_PROPRIO_CADASTRO',
    'CRIAR_PROPRIO_AGENDAMENTO',
  ];

  for (const permissao of permissoesCriadas) {
    if (!permissoesCliente.includes(permissao.codigo)) {
      continue;
    }

    await prisma.perfilPermissao.upsert({
      where: {
        perfilId_permissaoId: {
          perfilId: perfilCliente.id,
          permissaoId: permissao.id,
        },
      },
      update: {},
      create: {
        perfilId: perfilCliente.id,
        permissaoId: permissao.id,
      },
    });
  }

  // Admin: todas as permissões.
  for (const permissao of permissoesCriadas) {
    await prisma.perfilPermissao.upsert({
      where: {
        perfilId_permissaoId: {
          perfilId: perfilAdmin.id,
          permissaoId: permissao.id,
        },
      },
      update: {},
      create: {
        perfilId: perfilAdmin.id,
        permissaoId: permissao.id,
      },
    });
  }

  console.log('✅ Permissões configuradas');

  // ============================================================
  // ADMIN
  // ============================================================

  const emailAdmin = 'admin@tratofino.com';
  const hashEmailAdmin = blindIndex(emailAdmin);

  let admin = await prisma.usuario.findFirst({
    where: {
      barbeariaId: barbearia.id,
      dadosPessoais: {
        hashBuscaEmail: hashEmailAdmin,
      },
    },
  });

  let senhaAdmin: string | null = null;

  if (!admin) {
    senhaAdmin = gerarSenhaTemporaria();

    const hashSenha = await bcrypt.hash(senhaAdmin, 12);

    admin = await prisma.usuario.create({
      data: {
        barbeariaId: barbearia.id,
        role: 'ADMIN',
        estaAtivo: true,
        eEquipe: true,
        eSuperusuario: true,

        credencial: {
          create: {
            hashSenha,
            versaoSenha: 1,
            mfaHabilitado: false,
            senhaTemporaria: true,
          },
        },

        dadosPessoais: {
          create: {
            nomeCompletoCriptografado: encrypt(
              'Administrador Trato Fino',
            ),
            cpfCriptografado: encrypt(
              '00000000001',
            ),
            hashBuscaCpf: blindIndex(
              '00000000001',
            ),
            emailCriptografado: encrypt(
              emailAdmin,
            ),
            hashBuscaEmail: hashEmailAdmin,
            telefoneCriptografado: encrypt(
              '61999999999',
            ),
            hashBuscaTelefone: blindIndex(
              '61999999999',
            ),
            versaoChaveCriptografia: 1,
          },
        },
      },
    });

    console.log('');
    console.log('🔐 ADMIN criado');
    console.log(`   E-mail: ${emailAdmin}`);
    console.log(`   Senha temporária: ${senhaAdmin}`);
    console.log('');
  } else {
    console.log('ℹ️ ADMIN já existe. Nenhuma credencial foi alterada.');
  }

  // Perfil ADMIN
  await prisma.usuarioPerfil.upsert({
    where: {
      usuarioId_perfilId: {
        usuarioId: admin.id,
        perfilId: perfilAdmin.id,
      },
    },
    update: {},
    create: {
      usuarioId: admin.id,
      perfilId: perfilAdmin.id,
    },
  });

  // Perfil de funcionário do ADMIN
  await prisma.perfilFuncionario.upsert({
    where: {
      usuarioId: admin.id,
    },
    update: {
      barbeariaId: barbearia.id,
      nomeExibicao: 'Administrador',
      estaDisponivel: true,
    },
    create: {
      usuarioId: admin.id,
      barbeariaId: barbearia.id,
      nomeExibicao: 'Administrador',
      especialidade: 'Administração',
      estaDisponivel: true,
      horarioInicio: '08:00',
      horarioFim: '18:00',
      comissaoPorcent: 0,
    },
  });

  // ============================================================
  // CLIENTE DE TESTE
  // ============================================================

  const emailCliente = 'cliente@tratofino.com';
  const hashEmailCliente = blindIndex(emailCliente);

  let cliente = await prisma.usuario.findFirst({
    where: {
      barbeariaId: barbearia.id,
      dadosPessoais: {
        hashBuscaEmail: hashEmailCliente,
      },
    },
  });

  let senhaCliente: string | null = null;

  if (!cliente) {
    senhaCliente = gerarSenhaTemporaria();

    const hashSenha = await bcrypt.hash(senhaCliente, 12);

    cliente = await prisma.usuario.create({
      data: {
        barbeariaId: barbearia.id,
        role: 'CLIENTE',
        estaAtivo: true,
        eEquipe: false,
        eSuperusuario: false,

        credencial: {
          create: {
            hashSenha,
            versaoSenha: 1,
            mfaHabilitado: false,
            senhaTemporaria: true,
          },
        },

        dadosPessoais: {
          create: {
            nomeCompletoCriptografado: encrypt(
              'Cliente Teste',
            ),
            cpfCriptografado: encrypt(
              '00000000002',
            ),
            hashBuscaCpf: blindIndex(
              '00000000002',
            ),
            emailCriptografado: encrypt(
              emailCliente,
            ),
            hashBuscaEmail: hashEmailCliente,
            telefoneCriptografado: encrypt(
              '61999998888',
            ),
            hashBuscaTelefone: blindIndex(
              '61999998888',
            ),
            versaoChaveCriptografia: 1,
          },
        },
      },
    });

    console.log('🔐 CLIENTE criado');
    console.log(`   E-mail: ${emailCliente}`);
    console.log(`   Senha temporária: ${senhaCliente}`);
    console.log('');
  } else {
    console.log('ℹ️ CLIENTE já existe. Nenhuma credencial foi alterada.');
  }

  // Perfil CLIENTE
  await prisma.usuarioPerfil.upsert({
    where: {
      usuarioId_perfilId: {
        usuarioId: cliente.id,
        perfilId: perfilCliente.id,
      },
    },
    update: {},
    create: {
      usuarioId: cliente.id,
      perfilId: perfilCliente.id,
    },
  });

  // Perfil específico do cliente
  await prisma.perfilCliente.upsert({
    where: {
      usuarioId: cliente.id,
    },
    update: {},
    create: {
      usuarioId: cliente.id,
    },
  });

  // ============================================================
  // SERVIÇOS
  // ============================================================

  const servicoCorte = await prisma.servico.upsert({
    where: {
      id: 'a7e2b512-c292-4d05-b9c7-365e4e0ae37c',
    },
    update: {
      nome: 'Corte Masculino',
      preco: 45,
      duracaoMinutos: 30,
      estaAtivo: true,
    },
    create: {
      id: 'a7e2b512-c292-4d05-b9c7-365e4e0ae37c',
      barbeariaId: barbearia.id,
      nome: 'Corte Masculino',
      descricao: 'Corte masculino tradicional.',
      preco: 45,
      duracaoMinutos: 30,
      estaAtivo: true,
    },
  });

  const servicoCorteBarba = await prisma.servico.upsert({
    where: {
      id: '16d571b6-6f74-4fad-8982-fd5caeafd0e4',
    },
    update: {
      nome: 'Corte + Barba',
      preco: 75,
      duracaoMinutos: 60,
      estaAtivo: true,
    },
    create: {
      id: '16d571b6-6f74-4fad-8982-fd5caeafd0e4',
      barbeariaId: barbearia.id,
      nome: 'Corte + Barba',
      descricao: 'Corte masculino acompanhado de barba.',
      preco: 75,
      duracaoMinutos: 60,
      estaAtivo: true,
    },
  });

  console.log(
    `✅ Serviços verificados: ${servicoCorte.nome}, ${servicoCorteBarba.nome}`,
  );

  // Associar serviços ao administrador/barbeiro
  const funcionario = await prisma.perfilFuncionario.findUnique({
    where: {
      usuarioId: admin.id,
    },
  });

  if (funcionario) {
    await prisma.servicoBarbeiro.upsert({
      where: {
        barbeiroId_servicoId: {
          barbeiroId: funcionario.id,
          servicoId: servicoCorte.id,
        },
      },
      update: {
        estaAtivo: true,
      },
      create: {
        barbeiroId: funcionario.id,
        servicoId: servicoCorte.id,
        estaAtivo: true,
      },
    });

    await prisma.servicoBarbeiro.upsert({
      where: {
        barbeiroId_servicoId: {
          barbeiroId: funcionario.id,
          servicoId: servicoCorteBarba.id,
        },
      },
      update: {
        estaAtivo: true,
      },
      create: {
        barbeiroId: funcionario.id,
        servicoId: servicoCorteBarba.id,
        estaAtivo: true,
      },
    });

    // Horário padrão do administrador/barbeiro
    const horarioExistente = await prisma.horarioTrabalho.findFirst({
      where: {
        barbeiroId: funcionario.id,
        diaSemana: 1,
        horaInicio: '08:00',
        horaFim: '18:00',
      },
    });

    if (!horarioExistente) {
      await prisma.horarioTrabalho.create({
        data: {
          barbeiroId: funcionario.id,
          diaSemana: 1,
          horaInicio: '08:00',
          horaFim: '18:00',
          estaAtivo: true,
        },
      });
    }
  }

  // ============================================================
  // POLÍTICAS DE RETENÇÃO
  // ============================================================

  const politicas = [
    {
      categoriaDado: 'PII',
      baseLegal: 'LGPD',
      descricao: 'Dados pessoais armazenados de forma cifrada.',
    },
    {
      categoriaDado: 'CREDENCIAIS',
      baseLegal: 'Segurança',
      descricao: 'Credenciais armazenadas somente como hash.',
    },
    {
      categoriaDado: 'AUDITORIA',
      baseLegal: 'Segurança',
      descricao: 'Registros de auditoria e rastreabilidade.',
    },
  ];

  for (const politica of politicas) {
    await prisma.politicaRetencaoDados.upsert({
      where: {
        categoriaDado: politica.categoriaDado,
      },
      update: {
        baseLegal: politica.baseLegal,
        descricao: politica.descricao,
        anonimizarAposExpiracao: true,
      },
      create: {
        categoriaDado: politica.categoriaDado,
        baseLegal: politica.baseLegal,
        descricao: politica.descricao,
        anonimizarAposExpiracao: true,
      },
    });
  }

  console.log('✅ Políticas de retenção verificadas.');
  console.log('');
  console.log('🎉 Banco inicializado sem apagar dados existentes.');
}

main()
  .catch((error) => {
    console.error('❌ Erro no seed:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });