import crypto from 'node:crypto';
import { prisma } from './prisma';

let lastHash = '';

export async function audit(input: {
  usuarioAtorId?: string;
  tipoEvento: string;
  tipoEntidade: string;
  entidadeId?: string;
  resultado: string;
  req?: { ip?: string; headers?: { [key: string]: unknown } };
  metadados?: Record<string, unknown>;
}) {
  const criadoEm = new Date();
  const metadados = input.metadados ? JSON.stringify(input.metadados) : undefined;
  const material = JSON.stringify({
    anterior: lastHash || null,
    usuarioAtorId: input.usuarioAtorId ?? null,
    tipoEvento: input.tipoEvento,
    tipoEntidade: input.tipoEntidade,
    entidadeId: input.entidadeId ?? null,
    resultado: input.resultado,
    metadados,
    criadoEm: criadoEm.toISOString(),
  });
  const hashEventoAnterior = lastHash || undefined;
  const hashEvento = crypto.createHash('sha256').update(material).digest('hex');
  lastHash = hashEvento;

  await prisma.logAuditoria.create({
    data: {
      usuarioAtorId: input.usuarioAtorId,
      tipoEvento: input.tipoEvento,
      tipoEntidade: input.tipoEntidade,
      entidadeId: input.entidadeId,
      resultado: input.resultado,
      enderecoIp: input.req?.ip,
      agenteUsuario: typeof input.req?.headers?.['user-agent'] === 'string' ? input.req.headers['user-agent'] : undefined,
      metadados,
      hashEventoAnterior,
      hashEvento,
      criadoEm,
    },
  });
}
