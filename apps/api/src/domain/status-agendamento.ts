export type StatusComanda = 'ABERTA' | 'PAGA' | 'CANCELADA';

export type StatusAgendamento =
  | 'PENDENTE'
  | 'CONFIRMADO'
  | 'EM_ANDAMENTO'
  | 'CONCLUIDO'
  | 'CANCELADO'
  | 'NAO_COMPARECEU';

export function deveCancelarComanda(
  statusAgendamento: StatusAgendamento,
  statusComanda: StatusComanda,
): boolean {
  return (
    statusAgendamento === 'CANCELADO' &&
    statusComanda === 'ABERTA'
  );
}

export function acaoHistoricoPorStatus(
  status: StatusAgendamento,
): string {
  return status === 'PENDENTE' ? 'STATUS_ALTERADO' : status;
}