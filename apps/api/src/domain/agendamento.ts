/** Intervalos semiabertos [início, fim): um atendimento pode começar quando outro termina. */
export function intervalosSeSobrepoem(
  inicioA: number,
  fimA: number,
  inicioB: number,
  fimB: number,
): boolean {
  return inicioA < fimB && fimA > inicioB;
}

export function intervaloValido(inicio: Date, fim: Date): boolean {
  return Number.isFinite(inicio.getTime()) &&
    Number.isFinite(fim.getTime()) &&
    fim.getTime() > inicio.getTime();
}
