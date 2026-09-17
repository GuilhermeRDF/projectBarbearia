import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export interface TokenPayload {
  id: string;
  email: string;
  role: 'SUPER_ADMIN' | 'DONO_BARBEARIA' | 'BARBEIRO' | 'CLIENTE';
  barbeariaId?: string;
}

declare global {
  namespace Express {
    interface Request {
      usuario?: TokenPayload;
    }
  }
}

export const autenticar = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ error: 'Token de autenticação não fornecido' });
  }

  const [, token] = authHeader.split(' ');
  const secret = process.env.JWT_SECRET || 'fallback_secret';

  try {
    const decoded = jwt.verify(token, secret) as TokenPayload;
    req.usuario = decoded;
    return next();
  } catch {
    return res.status(401).json({ error: 'Token inválido ou expirado' });
  }
};

export const autorizarRoles = (...rolesPermitidas: string[]) => {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.usuario || !rolesPermitidas.includes(req.usuario.role)) {
      return res.status(403).json({ error: 'Acesso negado para este perfil' });
    }
    return next();
  };
};