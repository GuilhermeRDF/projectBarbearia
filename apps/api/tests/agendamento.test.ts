import test from 'node:test';
import assert from 'node:assert/strict';
import { intervaloValido, intervalosSeSobrepoem } from '../src/domain/agendamento';

test('intervalos sobrepostos são detectados', () => {
  assert.equal(intervalosSeSobrepoem(540, 600, 570, 630), true);
});

test('intervalos adjacentes não são conflito', () => {
  assert.equal(intervalosSeSobrepoem(540, 600, 600, 660), false);
});

test('intervalos separados não são conflito', () => {
  assert.equal(intervalosSeSobrepoem(540, 570, 600, 630), false);
});

test('intervalo exige fim posterior ao início', () => {
  const inicio = new Date('2026-10-12T10:00:00.000Z');
  assert.equal(intervaloValido(inicio, new Date('2026-10-12T10:30:00.000Z')), true);
  assert.equal(intervaloValido(inicio, new Date('2026-10-12T10:00:00.000Z')), false);
  assert.equal(intervaloValido(inicio, new Date('invalid')), false);
});

test('cancelar agendamento cancela comanda aberta', () => {
  assert.equal(deveCancelarComanda('CANCELADO', 'ABERTA'), true);
});

test('cancelar agendamento preserva comanda paga', () => {
  assert.equal(deveCancelarComanda('CANCELADO', 'PAGA'), false);
});

test('cancelar agendamento preserva comanda já cancelada', () => {
  assert.equal(deveCancelarComanda('CANCELADO', 'CANCELADA'), false);
});

test('outros status não cancelam comanda aberta', () => {
  assert.equal(deveCancelarComanda('CONFIRMADO', 'ABERTA'), false);
  assert.equal(deveCancelarComanda('EM_ANDAMENTO', 'ABERTA'), false);
});

test('histórico corresponde ao status informado', () => {
  assert.equal(acaoHistoricoPorStatus('CANCELADO'), 'CANCELADO');
  assert.equal(acaoHistoricoPorStatus('EM_ANDAMENTO'), 'EM_ANDAMENTO');
  assert.equal(acaoHistoricoPorStatus('NAO_COMPARECEU'), 'NAO_COMPARECEU');
  assert.equal(acaoHistoricoPorStatus('PENDENTE'), 'STATUS_ALTERADO');
});

import {
  acaoHistoricoPorStatus,
  deveCancelarComanda,
} from '../src/domain/status-agendamento';
