import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../lib/prisma';

export class AuthController {
  // Cadastro de Barbearia Tenant + Dono
  static async registrarBarbearia(req: Request, res: Response) {
    try {
      const { nomeBarbearia, slug, nomeDono, email, senha, telefone } = req.body;

      const slugExiste = await prisma.barbearia.findUnique({ where: { slug } });
      if (slugExiste) {
        return res.status(400).json({ error: 'Slug/URL já está em uso por outra barbearia' });
      }

      const emailExiste = await prisma.usuario.findUnique({ where: { email } });
      if (emailExiste) {
        return res.status(400).json({ error: 'E-mail já cadastrado' });
      }

      const senhaHash = await bcrypt.hash(senha, 10);

      const novaBarbearia = await prisma.barbearia.create({
        data: {
          nome: nomeBarbearia,
          slug,
          telefone,
          usuarios: {
            create: {
              nome: nomeDono,
              email,
              senha: senhaHash,
              telefone,
              role: 'DONO_BARBEARIA'
            }
          }
        },
        include: { usuarios: true }
      });

      return res.status(201).json({
        mensagem: 'Barbearia criada com sucesso!',
        barbeariaId: novaBarbearia.id,
        slug: novaBarbearia.slug
      });
    } catch (err: any) {
      return res.status(500).json({ error: err.message || 'Erro no servidor' });
    }
  }

  // Login Unificado
  static async login(req: Request, res: Response) {
    try {
      const { email, senha } = req.body;

      const usuario = await prisma.usuario.findUnique({ where: { email } });
      if (!usuario) {
        return res.status(400).json({ error: 'Credenciais inválidas' });
      }

      const senhaValida = await bcrypt.compare(senha, usuario.senha);
      if (!senhaValida) {
        return res.status(400).json({ error: 'Credenciais inválidas' });
      }

      const secret = process.env.JWT_SECRET || 'fallback_secret';
      const token = jwt.sign(
        {
          id: usuario.id,
          email: usuario.email,
          role: usuario.role,
          barbeariaId: usuario.barbeariaId
        },
        secret,
        { expiresIn: '7d' }
      );

      return res.json({
        token,
        usuario: {
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
          role: usuario.role,
          barbeariaId: usuario.barbeariaId
        }
      });
    } catch (err: any) {
      return res.status(500).json({ error: err.message || 'Erro no servidor' });
    }
  }
}