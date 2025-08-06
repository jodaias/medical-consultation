// backend/src/utils/fcm.js
// Utilitário para enviar notificações push FCM via Firebase Cloud Messaging

const fetch = require('node-fetch');

const FCM_SERVER_KEY = process.env.FCM_SERVER_KEY; // Defina sua chave do servidor FCM no .env
const FCM_URL = 'https://fcm.googleapis.com/fcm/send';

/**
 * Envia uma notificação push FCM para um ou mais tokens de dispositivo.
 * @param {string|string[]} tokens - Token(s) do dispositivo de destino.
 * @param {Object} notification - Objeto de notificação { title, body, ... }.
 * @param {Object} data - Dados customizados (opcional).
 * @returns {Promise<Object>} - Resposta do FCM.
 */
async function sendFcmNotification(tokens, notification, data = {}) {
  if (!FCM_SERVER_KEY) throw new Error('FCM_SERVER_KEY não definido no ambiente');
  const payload = {
    notification,
    data,
    to: typeof tokens === 'string' ? tokens : undefined,
    registration_ids: Array.isArray(tokens) ? tokens : undefined,
    priority: 'high',
  };
  const response = await fetch(FCM_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `key=${FCM_SERVER_KEY}`,
    },
    body: JSON.stringify(payload),
  });
  const result = await response.json();
  if (!response.ok) throw new Error(result.error || 'Erro ao enviar FCM');
  return result;
}

module.exports = { sendFcmNotification };
