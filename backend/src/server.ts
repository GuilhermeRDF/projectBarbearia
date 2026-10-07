import 'dotenv/config';
import express, { Request, Response } from 'express';
import cors from 'cors';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import crypto from 'node:crypto';
import { z } from 'zod';
import { prisma } from './lib/prisma';
import { blindIndex, decrypt, encrypt, encryptionKeyVersion, hashToken } from './lib/crypto';
import { audit } from './lib/audit';

const app = express();
const PORT = Number(process.env.PORT ?? 3000);
const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET || JWT_SECRET.length < 32) throw new Error('JWT_SECRET deve possuir pelo menos 32 caracteres.');

app.disable('x-powered-by');
app.use(cors({ origin: false }));
app.use(express.json({ limit: '256kb' }));

const ROLES = ['ADMIN', 'CLIENTE'] as const;
type Role = typeof ROLES[number];

interface TokenPayload { id: string; role: Role; barbeariaId?: string; sessionId: string; }

declare global { namespace Express { interface Request { usuario?: TokenPayload } } }

const asyncHandler = (fn: (req: Request, res: Response, next: express.NextFunction) => Promise<void>) =>
  (req: Request, res: Response, next: express.NextFunction) => { fn(req, res, next).catch((error: any) => { next(error); }); };

function errorWithStatus(message: string, status: number): Error { const e: any = new Error(message); e.status = status; return e; }
function tenantId(req: Request): string { const id = req.usuario?.barbeariaId; if (!id) throw errorWithStatus('Usuário não está vinculado a uma barbearia', 400); return id; }
function requestId() { return crypto.randomUUID(); }
function maskEmail(email: string) { const [local, domain] = email.split('@'); if (!domain) return '***'; return `${local.slice(0, 2)}***@${domain}`; }
function maskPhone(phone?: string | null) { if (!phone) return null; const digits = phone.replace(/\D/g, ''); return `***${digits.slice(-4)}`; }

function gerarSenhaTemporaria() { return `TF-${crypto.randomBytes(12).toString('base64url').slice(0, 16)}`; }

const cadastroClienteSchema = z.object({ nome: z.string().trim().min(2).max(120), email: z.string().email().max(180), senha: z.string().min(8).max(128), telefone: z.string().max(30).optional() });
const cadastroAdminSchema = z.object({ nome: z.string().trim().min(2).max(120), email: z.string().email().max(180), senha: z.string().min(8).max(128), telefone: z.string().max(30).optional() });
const loginSchema = z.object({ email: z.string().email().max(180), senha: z.string().min(1).max(128) });
const clienteSchema = z.object({ nome: z.string().trim().min(2).max(120), email: z.string().email().max(180), telefone: z.string().max(30).optional() });
const alterarSenhaSchema = z.object({ senhaAtual: z.string().min(1).max(128), novaSenha: z.string().min(8).max(128) });
const solicitarResetSchema = z.object({ email: z.string().email().max(180) });
const barbeiroSchema = z.object({ nome: z.string().trim().min(2).max(120), especialidade: z.string().max(120).optional(), horarioInicio: z.string().regex(/^\d{2}:\d{2}$/).optional(), horarioFim: z.string().regex(/^\d{2}:\d{2}$/).optional(), inicioAlmoco: z.string().regex(/^\d{2}:\d{2}$/).optional(), fimAlmoco: z.string().regex(/^\d{2}:\d{2}$/).optional(), comissaoPorcent: z.number().min(0).max(100).optional() });
const servicoSchema = z.object({ nome: z.string().trim().min(2).max(100), descricao: z.string().max(500).optional(), preco: z.number().nonnegative().max(100000), duracaoMinutos: z.number().int().positive().max(600) });
const agendamentoSchema = z.object({ clienteId: z.string().uuid().optional(), barbeiroId: z.string().uuid(), servicoId: z.string().uuid(), dataHora: z.string().datetime(), observacao: z.string().max(1000).optional() });
const statusSchema = z.object({ status: z.enum(['PENDENTE', 'CONFIRMADO', 'EM_ANDAMENTO', 'CONCLUIDO', 'CANCELADO', 'NAO_COMPARECEU']) });
const comandaSchema = z.object({ status: z.enum(['ABERTA', 'PAGA', 'CANCELADA']).optional(), formaPagto: z.string().max(30).optional() });

async function findUserByEmail(email: string) {
  const pii = await prisma.dadosPessoaisUsuario.findUnique({ where: { hashBuscaEmail: blindIndex(email) } });
  if (!pii) return null;
  return prisma.usuario.findUnique({ where: { id: pii.usuarioId }, include: { credencial: true, dadosPessoais: true } });
}

async function createUser(data: { barbeariaId?: string; nome: string; email: string; telefone?: string; senha: string; role: Role; eEquipe?: boolean; senhaTemporaria?: boolean }) {
  const exists = await findUserByEmail(data.email);
  if (exists) throw errorWithStatus('E-mail já cadastrado', 400);
  const now = new Date();
  const passwordHash = await bcrypt.hash(data.senha, 12);

  const user = await prisma.usuario.create({
    data: {
      barbeariaId: data.barbeariaId,
      role: data.role,
      eEquipe: data.eEquipe ?? data.role === 'ADMIN',
      senhaAlteradaEm: now,
      criadoEm: now,
      atualizadoEm: now,
      credencial: {
        create: { hashSenha: passwordHash, senhaTemporaria: data.senhaTemporaria ?? false, criadoEm: now, atualizadoEm: now },
      },
      dadosPessoais: {
        create: {
          nomeCompletoCriptografado: encrypt(data.nome),
          cpfCriptografado: encrypt(''),
          hashBuscaCpf: blindIndex(data.email + ':' + data.nome),
          emailCriptografado: encrypt(data.email),
          hashBuscaEmail: blindIndex(data.email),
          telefoneCriptografado: data.telefone ? encrypt(data.telefone) : null,
          hashBuscaTelefone: data.telefone ? blindIndex(data.telefone) : null,
          versaoChaveCriptografia: encryptionKeyVersion,
          criadoEm: now,
          atualizadoEm: now,
        },
      },
    },
  });

  const profileCode = data.role === 'CLIENTE' ? 'CLIENTE' : 'ADMIN';
  const profile = await prisma.perfilAcesso.findUnique({ where: { codigo: profileCode } });
  if (profile) await prisma.usuarioPerfil.create({ data: { usuarioId: user.id, perfilId: profile.id, atribuidoEm: now } });
  if (data.role === 'CLIENTE') await prisma.perfilCliente.create({ data: { usuarioId: user.id, criadoEm: now, atualizadoEm: now } });
  return user;
}

function publicUser(user: any) {
  const pii = user.dadosPessoais;
  const email = pii ? decrypt(pii.emailCriptografado) : undefined;
  const nome = pii ? decrypt(pii.nomeCompletoCriptografado) : 'Usuário';
  const telefone = pii?.telefoneCriptografado ? decrypt(pii.telefoneCriptografado) : null;
  return { id: user.id, nome, email, telefone, role: user.role ?? undefined, barbeariaId: user.barbeariaId ?? null };
}

async function registrarTentativa(email: string, sucesso: boolean, usuarioId: string | undefined, req: Request) {
  await prisma.tentativaLogin.create({ data: { usuarioId, hashBuscaIdentificador: blindIndex(email), foiBemSucedida: sucesso, enderecoIp: req.ip, agenteUsuario: req.get('user-agent') ?? undefined } });
}

const autenticar = asyncHandler(async (req, res, next) => {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) throw errorWithStatus('Token de autenticação não fornecido', 401);
  const rawToken = header.slice(7);
  let payload: TokenPayload;
  try { payload = jwt.verify(rawToken, JWT_SECRET) as TokenPayload; } catch { throw errorWithStatus('Token inválido ou expirado', 401); }
  const session = await prisma.sessaoAutenticacao.findFirst({ where: { id: payload.sessionId, usuarioId: payload.id, hashToken: hashToken(rawToken), revogadoEm: null, expiraEm: { gt: new Date() } } });
  if (!session) throw errorWithStatus('Sessão inválida ou expirada', 401);
  req.usuario = payload;
  next();
});

const autorizar = (...roles: Role[]) => (req: Request, _res: Response, next: express.NextFunction) => { if (!req.usuario || !roles.includes(req.usuario.role)) { next(errorWithStatus('Acesso negado para este perfil', 403)); return; } next(); };

app.get('/health', (_req, res) => res.json({ status: 'ok', sistema: 'Trato Fino API' }));

app.post('/auth/registrar', asyncHandler(async (req, res) => {
  const data = cadastroClienteSchema.parse(req.body);
  const barbearia = await prisma.barbearia.findFirst({ orderBy: { criadoEm: 'asc' } });
  if (!barbearia) throw errorWithStatus('Nenhuma barbearia está configurada para novos cadastros.', 503);
  const user = await createUser({ barbeariaId: barbearia.id, nome: data.nome, email: data.email, telefone: data.telefone, senha: data.senha, role: 'CLIENTE' });
  await audit({ usuarioAtorId: user.id, tipoEvento: 'CLIENTE_AUTOCADASTRO', tipoEntidade: 'Usuario', entidadeId: user.id, resultado: 'SUCESSO', req });
  res.status(201).json({ mensagem: 'Cadastro realizado com sucesso. Sua conta foi criada como CLIENTE.', usuario: publicUser({ ...user, dadosPessoais: await prisma.dadosPessoaisUsuario.findUnique({ where: { usuarioId: user.id } }) }) });
}));

app.post('/auth/login', asyncHandler(async (req, res) => {
  const data = loginSchema.parse(req.body);
  const user = await findUserByEmail(data.email);
  const now = new Date();
  if (user?.bloqueadoAte && user.bloqueadoAte > now) { await registrarTentativa(data.email, false, user.id, req); throw errorWithStatus('Conta temporariamente bloqueada. Tente novamente mais tarde.', 429); }
  if (!user?.credencial || !user.dadosPessoais || !(await bcrypt.compare(data.senha, user.credencial.hashSenha))) {
    if (user) { const failures = user.quantidadeFalhasLogin + 1; const lock = failures >= 5 ? new Date(now.getTime() + 15 * 60 * 1000) : null; await prisma.usuario.update({ where: { id: user.id }, data: { quantidadeFalhasLogin: failures, bloqueadoAte: lock } }); }
    await registrarTentativa(data.email, false, user?.id, req);
    await audit({ tipoEvento: 'LOGIN_FALHOU', tipoEntidade: 'Usuario', entidadeId: user?.id, resultado: 'FALHA', req });
    throw errorWithStatus('Credenciais inválidas', 400);
  }
  const sessionId = crypto.randomUUID();
  const role = user.role as Role;
  const finalToken = jwt.sign({ id: user.id, role, barbeariaId: user.barbeariaId ?? undefined, sessionId }, JWT_SECRET, { expiresIn: '2h' });
  await prisma.$transaction([
    prisma.usuario.update({ where: { id: user.id }, data: { quantidadeFalhasLogin: 0, bloqueadoAte: null, ultimoLoginEm: now } }),
    prisma.sessaoAutenticacao.create({ data: { id: sessionId, usuarioId: user.id, hashToken: hashToken(finalToken), emitidoEm: now, expiraEm: new Date(now.getTime() + 2 * 60 * 60 * 1000), enderecoIp: req.ip, agenteUsuario: req.get('user-agent') ?? undefined } }),
    prisma.tentativaLogin.create({ data: { usuarioId: user.id, hashBuscaIdentificador: blindIndex(data.email), foiBemSucedida: true, enderecoIp: req.ip, agenteUsuario: req.get('user-agent') ?? undefined } }),
  ]);
  await audit({ usuarioAtorId: user.id, tipoEvento: 'LOGIN_SUCESSO', tipoEntidade: 'Usuario', entidadeId: user.id, resultado: 'SUCESSO', req });
  res.json({ token: finalToken, usuario: { ...publicUser(user), role, senhaTemporaria: Boolean(user.credencial?.senhaTemporaria) } });
}));

app.post('/auth/logout', autenticar, asyncHandler(async (req, res) => { await prisma.sessaoAutenticacao.update({ where: { id: req.usuario!.sessionId }, data: { revogadoEm: new Date(), motivoRevogacao: 'LOGOUT' } }); res.json({ mensagem: 'Sessão encerrada.' }); }));

app.post('/auth/alterar-senha', autenticar, asyncHandler(async (req, res) => {
  const data = alterarSenhaSchema.parse(req.body);
  const user = await prisma.usuario.findUnique({ where: { id: req.usuario!.id }, include: { credencial: true } });
  if (!user?.credencial || !(await bcrypt.compare(data.senhaAtual, user.credencial.hashSenha))) throw errorWithStatus('Senha atual inválida', 400);
  const now = new Date();
  const hashSenha = await bcrypt.hash(data.novaSenha, 12);
  await prisma.$transaction([
    prisma.credencialUsuario.update({ where: { usuarioId: user.id }, data: { hashSenha, senhaTemporaria: false, versaoSenha: { increment: 1 }, atualizadoEm: now } }),
    prisma.usuario.update({ where: { id: user.id }, data: { senhaAlteradaEm: now } }),
    prisma.sessaoAutenticacao.updateMany({ where: { usuarioId: user.id, id: { not: req.usuario!.sessionId }, revogadoEm: null }, data: { revogadoEm: now, motivoRevogacao: 'ALTERACAO_SENHA' } }),
  ]);
  await audit({ usuarioAtorId: user.id, tipoEvento: 'SENHA_ALTERADA', tipoEntidade: 'Usuario', entidadeId: user.id, resultado: 'SUCESSO', req });
  res.json({ mensagem: 'Senha alterada com sucesso.' });
}));

app.post('/auth/solicitar-redefinicao', asyncHandler(async (req, res) => {
  const data = solicitarResetSchema.parse(req.body);
  const user = await findUserByEmail(data.email);
  if (user) {
    await prisma.tokenRedefinicaoSenha.updateMany({ where: { usuarioId: user.id, usadoEm: null, expiraEm: { gt: new Date() } }, data: { usadoEm: new Date() } });
    const rawToken = crypto.randomBytes(32).toString('base64url');
    await prisma.tokenRedefinicaoSenha.create({ data: { usuarioId: user.id, hashToken: hashToken(rawToken), expiraEm: new Date(Date.now() + 30 * 60 * 1000), ipSolicitacao: req.ip } });
    await audit({ tipoEvento: 'REDEFINICAO_SOLICITADA', tipoEntidade: 'Usuario', entidadeId: user.id, resultado: 'SUCESSO', req });
  }
  res.json({ mensagem: 'Se o e-mail estiver cadastrado, a solicitação foi registrada. Um administrador deverá concluir a redefinição.' });
}));

app.get('/me', autenticar, asyncHandler(async (req, res) => { const user = await prisma.usuario.findUnique({ where: { id: req.usuario!.id, excluidoEm: null }, include: { dadosPessoais: true, credencial: true } }); if (!user) throw errorWithStatus('Usuário não encontrado',404); res.json({ ...publicUser(user), role: req.usuario!.role, senhaTemporaria: Boolean(user.credencial?.senhaTemporaria) }); }));

app.post('/admin/admins', autenticar, autorizar('ADMIN'), asyncHandler(async (req, res) => {
  const data = cadastroAdminSchema.parse(req.body);
  const admin = await createUser({ barbeariaId: tenantId(req), nome: data.nome, email: data.email, telefone: data.telefone, senha: data.senha, role: 'ADMIN' });
  await audit({ usuarioAtorId: req.usuario!.id, tipoEvento: 'ADMIN_CRIADO', tipoEntidade: 'Usuario', entidadeId: admin.id, resultado: 'SUCESSO', req });
  res.status(201).json({ mensagem: 'Administrador criado com sucesso.', usuario: publicUser({ ...admin, dadosPessoais: await prisma.dadosPessoaisUsuario.findUnique({ where: { usuarioId: admin.id } }) }) });
}));

app.get('/admin/redefinicoes', autenticar, autorizar('ADMIN'), asyncHandler(async (req, res) => {
  const rows = await prisma.tokenRedefinicaoSenha.findMany({ where: { usadoEm: null, expiraEm: { gt: new Date() }, usuario: { barbeariaId: tenantId(req), role: 'CLIENTE' } }, include: { usuario: { include: { dadosPessoais: true } } }, orderBy: { criadoEm: 'asc' } });
  res.json(rows.map(r => ({ id: r.id, clienteId: r.usuarioId, email: r.usuario.dadosPessoais ? maskEmail(decrypt(r.usuario.dadosPessoais.emailCriptografado)) : '***', solicitadoEm: r.criadoEm, expiraEm: r.expiraEm })));
}));

app.post('/admin/clientes/:id/resetar-senha', autenticar, autorizar('ADMIN'), asyncHandler(async (req, res) => {
  const cliente = await prisma.usuario.findFirst({ where: { id: String(req.params.id), barbeariaId: tenantId(req), role: 'CLIENTE', excluidoEm: null }, include: { credencial: true } });
  if (!cliente?.credencial) throw errorWithStatus('Cliente não encontrado', 404);
  const senhaTemporaria = gerarSenhaTemporaria();
  const hashSenha = await bcrypt.hash(senhaTemporaria, 12);
  const now = new Date();
  await prisma.$transaction([
    prisma.credencialUsuario.update({ where: { usuarioId: cliente.id }, data: { hashSenha, senhaTemporaria: true, versaoSenha: { increment: 1 }, atualizadoEm: now } }),
    prisma.usuario.update({ where: { id: cliente.id }, data: { senhaAlteradaEm: now, quantidadeFalhasLogin: 0, bloqueadoAte: null } }),
    prisma.tokenRedefinicaoSenha.updateMany({ where: { usuarioId: cliente.id, usadoEm: null }, data: { usadoEm: now } }),
    prisma.sessaoAutenticacao.updateMany({ where: { usuarioId: cliente.id, revogadoEm: null }, data: { revogadoEm: now, motivoRevogacao: 'REDEFINICAO_ADMIN' } }),
  ]);
  await audit({ usuarioAtorId: req.usuario!.id, tipoEvento: 'SENHA_TEMPORARIA_GERADA', tipoEntidade: 'Usuario', entidadeId: cliente.id, resultado: 'SUCESSO', req, metadados: { tipo: 'ADMIN_RESET' } });
  res.json({ mensagem: 'Senha temporária gerada. Ela será exibida somente nesta resposta.', senhaTemporaria });
}));

app.get('/admin/clientes/:id/dados-pessoais', autenticar, autorizar('ADMIN'), asyncHandler(async (req, res) => {
  const cliente = await prisma.usuario.findFirst({ where: { id: String(req.params.id), barbeariaId: tenantId(req), role: 'CLIENTE', excluidoEm: null }, include: { dadosPessoais: true } });
  if (!cliente?.dadosPessoais) throw errorWithStatus('Cliente não encontrado', 404);
  const p = cliente.dadosPessoais;
  await prisma.logAcessoDadoSensivel.create({ data: { usuarioAtorId: req.usuario!.id, usuarioTitularId: cliente.id, categoriaDado: 'PII', finalidade: 'Atendimento administrativo', acao: 'CONSULTA', requisicaoId: requestId() } });
  await audit({ usuarioAtorId: req.usuario!.id, tipoEvento: 'PII_CONSULTADA', tipoEntidade: 'Usuario', entidadeId: cliente.id, resultado: 'SUCESSO', req, metadados: { categoria: 'PII' } });
  res.json({ id: cliente.id, nome: decrypt(p.nomeCompletoCriptografado), email: decrypt(p.emailCriptografado), telefone: p.telefoneCriptografado ? decrypt(p.telefoneCriptografado) : null, cpf: decrypt(p.cpfCriptografado) || null });
}));

app.get('/clientes', autenticar, autorizar('ADMIN'), asyncHandler(async (req,res)=>{ const users=await prisma.usuario.findMany({where:{barbeariaId:tenantId(req),perfilCliente:{isNot:null},excluidoEm:null},include:{dadosPessoais:true},orderBy:{criadoEm:'asc'}}); res.json(users.map(u=>{const p=u.dadosPessoais!; return {id:u.id,nome:decrypt(p.nomeCompletoCriptografado),email:maskEmail(decrypt(p.emailCriptografado)),telefone:maskPhone(p.telefoneCriptografado?decrypt(p.telefoneCriptografado):null),criadoEm:u.criadoEm};})); }));

app.post('/clientes', autenticar, autorizar('ADMIN'), asyncHandler(async(req,res)=>{const data=clienteSchema.parse(req.body); const senhaTemporaria=gerarSenhaTemporaria(); const user=await createUser({barbeariaId:tenantId(req),nome:data.nome,email:data.email,telefone:data.telefone,senha:senhaTemporaria,senhaTemporaria:true,role:'CLIENTE'}); await audit({usuarioAtorId:req.usuario!.id,tipoEvento:'CLIENTE_CRIADO',tipoEntidade:'Usuario',entidadeId:user.id,resultado:'SUCESSO',req,metadados:{senhaTemporaria:true}}); res.status(201).json({cliente:{id:user.id,nome:data.nome,email:maskEmail(data.email),telefone:maskPhone(data.telefone),criadoEm:user.criadoEm},senhaTemporaria}); }));

app.get('/barbeiros', autenticar, asyncHandler(async(req,res)=>{const rows=await prisma.perfilFuncionario.findMany({where:{barbeariaId:tenantId(req),estaDisponivel:true},orderBy:{nomeExibicao:'asc'}}); res.json(rows.map(b=>({id:b.id,nome:b.nomeExibicao ?? 'Barbeiro',especialidade:b.especialidade,horarioInicio:b.horarioInicio,horarioFim:b.horarioFim,inicioAlmoco:b.inicioAlmoco,fimAlmoco:b.fimAlmoco,comissaoPorcent:b.comissaoPorcent})));}));

app.post('/barbeiros', autenticar, autorizar('ADMIN'), asyncHandler(async(req,res)=>{const data=barbeiroSchema.parse(req.body); const tempEmail=`barbeiro-${crypto.randomUUID()}@local.invalid`; const user=await createUser({barbeariaId:tenantId(req),nome:data.nome,email:tempEmail,senha:crypto.randomBytes(24).toString('base64url'),role:'ADMIN',eEquipe:true}); const b=await prisma.perfilFuncionario.create({data:{usuarioId:user.id,barbeariaId:tenantId(req),nomeExibicao:data.nome,especialidade:data.especialidade,horarioInicio:data.horarioInicio ?? '08:00',horarioFim:data.horarioFim ?? '18:00',inicioAlmoco:data.inicioAlmoco ?? '12:00',fimAlmoco:data.fimAlmoco ?? '13:00',comissaoPorcent:data.comissaoPorcent ?? 30,criadoEm:new Date(),atualizadoEm:new Date()}}); res.status(201).json({id:b.id,nome:b.nomeExibicao,especialidade:b.especialidade,horarioInicio:b.horarioInicio,horarioFim:b.horarioFim,inicioAlmoco:b.inicioAlmoco,fimAlmoco:b.fimAlmoco,comissaoPorcent:b.comissaoPorcent});}));

app.get('/servicos', autenticar, asyncHandler(async(req,res)=>{const rows=await prisma.servico.findMany({where:{barbeariaId:tenantId(req),estaAtivo:true},orderBy:{nome:'asc'}});res.json(rows);}));
app.post('/servicos', autenticar, autorizar('ADMIN'), asyncHandler(async(req,res)=>{const data=servicoSchema.parse(req.body);const s=await prisma.servico.create({data:{...data,barbeariaId:tenantId(req),estaAtivo:true,criadoEm:new Date(),atualizadoEm:new Date()}});res.status(201).json(s);}));

app.get('/horarios-disponiveis', autenticar, asyncHandler(async(req,res)=>{const barbeiroId=String(req.query.barbeiroId??'');const servicoId=String(req.query.servicoId??'');const data=String(req.query.data??'');if(!z.string().uuid().safeParse(barbeiroId).success||!z.string().uuid().safeParse(servicoId).success||!/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/.test(data))throw errorWithStatus('Informe barbeiroId, servicoId e data (YYYY-MM-DD)',400);const [b,s]=await Promise.all([prisma.perfilFuncionario.findFirst({where:{id:barbeiroId,barbeariaId:tenantId(req),estaDisponivel:true}}),prisma.servico.findFirst({where:{id:servicoId,barbeariaId:tenantId(req),estaAtivo:true}})]);if(!b||!s)throw errorWithStatus('Barbeiro ou serviço não encontrado',404);const inicioDia=new Date(`${data}T00:00:00.000Z`),fimDia=new Date(`${data}T23:59:59.999Z`);const existentes=await prisma.agendamento.findMany({where:{barbeariaId:tenantId(req),barbeiroId,status:{not:'CANCELADO'},inicioAgendado:{gte:inicioDia,lte:fimDia}}});const toMin=(v:string|null|undefined)=>{if(!v)return 0;const[a,m]=v.split(':').map(Number);return a*60+(m||0)};const toTime=(v:number)=>`${String(Math.floor(v/60)).padStart(2,'0')}:${String(v%60).padStart(2,'0')}`;const ocupados=existentes.map(a=>{const d=new Date(a.inicioAgendado);return{inicio:d.getUTCHours()*60+d.getUTCMinutes(),fim:new Date(a.fimAgendado).getUTCHours()*60+new Date(a.fimAgendado).getUTCMinutes()}});const inicio=toMin(b.horarioInicio),fim=toMin(b.horarioFim),ai=toMin(b.inicioAlmoco),af=toMin(b.fimAlmoco),horarios:string[]=[];for(let m=inicio;m+s.duracaoMinutos<=fim;m+=30){const sf=m+s.duracaoMinutos;if(m<af&&sf>ai)continue;if(ocupados.some(o=>m<o.fim&&sf>o.inicio))continue;horarios.push(toTime(m));}res.json(horarios);}));

app.get('/agendamentos', autenticar, asyncHandler(async(req,res)=>{const where:any={barbeariaId:tenantId(req)};if(req.usuario!.role==='CLIENTE')where.usuarioId=req.usuario!.id;if(typeof req.query.data==='string'){where.inicioAgendado={gte:new Date(`${req.query.data}T00:00:00.000Z`),lte:new Date(`${req.query.data}T23:59:59.999Z`)}}const rows=await prisma.agendamento.findMany({where,include:{usuario:{include:{dadosPessoais:true}},barbeiro:true,servico:true,comanda:true},orderBy:{inicioAgendado:'asc'}});res.json(rows.map(a=>({id:a.id,dataHora:a.inicioAgendado,status:a.status,observacao:null,usuario:{id:a.usuario.id,nome:a.usuario.dadosPessoais?decrypt(a.usuario.dadosPessoais.nomeCompletoCriptografado):'Usuário',email:a.usuario.dadosPessoais?maskEmail(decrypt(a.usuario.dadosPessoais.emailCriptografado)):null,telefone:null,criadoEm:a.usuario.criadoEm},barbeiro:{id:a.barbeiro.id,nome:a.barbeiro.nomeExibicao??'Barbeiro'},servico:{id:a.servico.id,nome:a.servico.nome,preco:a.servico.preco,duracaoMinutos:a.servico.duracaoMinutos},comanda:a.comanda})));}));

app.post('/agendamentos', autenticar, asyncHandler(async(req,res)=>{const data=agendamentoSchema.parse(req.body);const barbeariaId=tenantId(req);const clienteId=req.usuario!.role==='CLIENTE'?req.usuario!.id:data.clienteId;if(!clienteId)throw errorWithStatus('Informe clienteId',400);const [cliente,barbeiro,servico]=await Promise.all([prisma.usuario.findFirst({where:{id:clienteId,barbeariaId,perfilCliente:{isNot:null},excluidoEm:null}}),prisma.perfilFuncionario.findFirst({where:{id:data.barbeiroId,barbeariaId,estaDisponivel:true}}),prisma.servico.findFirst({where:{id:data.servicoId,barbeariaId,estaAtivo:true}})]);if(!cliente||!barbeiro||!servico)throw errorWithStatus('Cliente, barbeiro ou serviço não encontrado',404);const inicio=new Date(data.dataHora),fim=new Date(inicio.getTime()+servico.duracaoMinutos*60000);const resultado=await prisma.$transaction(async tx=>{const conflito=await tx.agendamento.findFirst({where:{barbeariaId,barbeiroId:barbeiro.id,status:{not:'CANCELADO'},inicioAgendado:{lt:fim},fimAgendado:{gt:inicio}}});if(conflito)throw errorWithStatus('Este barbeiro já possui um atendimento sobreposto neste horário',409);const agendamento=await tx.agendamento.create({data:{barbeariaId,codigoConfirmacao:crypto.randomBytes(5).toString('hex').toUpperCase(),usuarioId:clienteId,barbeiroId:barbeiro.id,servicoId:servico.id,inicioAgendado:inicio,fimAgendado:fim,dataHora:inicio,status:'PENDENTE',origem:'CLI',criadoPor:req.usuario!.id,versaoRegistro:1,criadoEm:new Date(),atualizadoEm:new Date()}});await tx.servicoAgendamento.create({data:{agendamentoId:agendamento.id,servicoId:servico.id,preco:servico.preco,duracaoMinutos:servico.duracaoMinutos}});await tx.historicoAgendamento.create({data:{agendamentoId:agendamento.id,alteradoPor:req.usuario!.id,acao:'CRIADO',novoInicio:inicio,novoStatus:'PENDENTE'}});if(data.observacao)await tx.observacaoAgendamento.create({data:{agendamentoId:agendamento.id,autorId:req.usuario!.id,observacaoCriptografada:encrypt(data.observacao),versaoChaveCriptografia:encryptionKeyVersion}});const comissao=servico.preco*barbeiro.comissaoPorcent/100;const comanda=await tx.comanda.create({data:{barbeariaId,usuarioId:clienteId,agendamentoId:agendamento.id,valorTotal:servico.preco,status:'ABERTA',itens:{create:{servicoId:servico.id,barbeiroId:barbeiro.id,preco:servico.preco,comissao}}}});return{agendamento,comanda};});await audit({usuarioAtorId:req.usuario!.id,tipoEvento:'AGENDAMENTO_CRIADO',tipoEntidade:'Agendamento',entidadeId:resultado.agendamento.id,resultado:'SUCESSO',req});res.status(201).json(resultado);}));

app.patch('/agendamentos/:id/status', autenticar, autorizar('ADMIN'), asyncHandler(async(req,res)=>{const{id}=req.params;const{status}=statusSchema.parse(req.body);const a=await prisma.agendamento.findFirst({where:{id,barbeariaId:tenantId(req)}});if(!a)throw errorWithStatus('Agendamento não encontrado',404);const atualizado=await prisma.$transaction(async tx=>{const u=await tx.agendamento.update({where:{id},data:{status,versaoRegistro:{increment:1},confirmadoEm:status==='CONFIRMADO'?new Date():a.confirmadoEm,canceladoEm:status==='CANCELADO'?new Date():a.canceladoEm}});await tx.historicoAgendamento.create({data:{agendamentoId:id,alteradoPor:req.usuario!.id,acao:status==='CANCELADO'?'CANCELADO':status==='CONCLUIDO'?'CONCLUIDO':'CONFIRMADO',statusAnterior:a.status,novoStatus:status}});return u;});await audit({usuarioAtorId:req.usuario!.id,tipoEvento:'AGENDAMENTO_STATUS_ALTERADO',tipoEntidade:'Agendamento',entidadeId:id,resultado:'SUCESSO',req,metadados:{status}});res.json({id:atualizado.id,status:atualizado.status});}));

app.get('/comandas', autenticar, asyncHandler(async(req,res)=>{const rows=await prisma.comanda.findMany({where:{barbeariaId:tenantId(req), ...(req.usuario!.role==='CLIENTE'?{usuarioId:req.usuario!.id}: {})},include:{usuario:{include:{dadosPessoais:true}},agendamento:{include:{barbeiro:true,servico:true}},itens:true},orderBy:{criadoEm:'desc'}});res.json(rows.map(c=>({id:c.id,usuario:{id:c.usuario.id,nome:c.usuario.dadosPessoais?decrypt(c.usuario.dadosPessoais.nomeCompletoCriptografado):'Usuário'},valorTotal:c.valorTotal,status:c.status,formaPagto:c.formaPagto,agendamento:c.agendamento?{barbeiro:{nome:c.agendamento.barbeiro.nomeExibicao},servico:{nome:c.agendamento.servico.nome}}:null,itens:c.itens})));}));
app.patch('/comandas/:id', autenticar, autorizar('ADMIN'), asyncHandler(async(req,res)=>{const data=comandaSchema.parse(req.body);const id=String(req.params.id);const c=await prisma.comanda.findFirst({where:{id,barbeariaId:tenantId(req)}});if(!c)throw errorWithStatus('Comanda não encontrada',404);const updated=await prisma.comanda.update({where:{id},data});await audit({usuarioAtorId:req.usuario!.id,tipoEvento:'COMANDA_ATUALIZADA',tipoEntidade:'Comanda',entidadeId:id,resultado:'SUCESSO',req});res.json({id:updated.id,status:updated.status,formaPagto:updated.formaPagto,valorTotal:updated.valorTotal});}));

app.use((_req,res)=>res.status(404).json({error:'Rota não encontrada'}));
app.use((err:any,_req:Request,res:Response,_next:express.NextFunction)=>{console.error(err);res.status(err?.status??500).json({error:err?.message??'Erro interno do servidor'});});
app.listen(PORT,()=>console.log(`🚀 Trato Fino API rodando em http://localhost:${PORT}`));
