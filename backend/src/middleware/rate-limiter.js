const rateLimit = require('express-rate-limit');

/**
 * Middleware de Rate Limiting
 * Protege contra ataques de força bruta e DDoS
 */

// Configurações de rate limiting
const createRateLimiter = (options = {}) => {
  const {
    windowMs = 15 * 60 * 1000, // 15 minutos
    max = 100, // máximo de requisições por janela
    message = 'Too many requests from this IP, please try again later.',
    statusCode = 429,
    skipSuccessfulRequests = false,
    skipFailedRequests = false,
    keyGenerator = (req) => req.ip, // Usar IP como chave
    handler = (req, res) => {
      res.status(statusCode).json({
        success: false,
        message,
        retryAfter: Math.ceil(windowMs / 1000)
      });
    }
  } = options;

  return rateLimit({
    windowMs,
    max,
    message,
    statusCode,
    skipSuccessfulRequests,
    skipFailedRequests,
    keyGenerator,
    handler,
    standardHeaders: true,
    legacyHeaders: false
  });
};

// Rate limiter para autenticação (mais restritivo)
const authRateLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // máximo 5 tentativas de login
  message: 'Too many login attempts. Please try again later.',
  keyGenerator: (req) => {
    // Usar email + IP para identificar tentativas de login
    const email = req.body?.email || 'unknown';
    return `${req.ip}-${email}`;
  }
});

// Rate limiter para registro (prevenir spam)
const registerRateLimiter = createRateLimiter({
  windowMs: 60 * 60 * 1000, // 1 hora
  max: 3, // máximo 3 registros por hora
  message: 'Too many registration attempts. Please try again later.',
  keyGenerator: (req) => {
    // Usar IP para identificar tentativas de registro
    return `${req.ip}-register`;
  }
});

// Rate limiter para API geral
const apiRateLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 1000, // máximo 1000 requisições por 15 minutos
  message: 'Too many API requests. Please try again later.'
});

// Rate limiter para uploads
const uploadRateLimiter = createRateLimiter({
  windowMs: 60 * 60 * 1000, // 1 hora
  max: 10, // máximo 10 uploads por hora
  message: 'Too many file uploads. Please try again later.',
  keyGenerator: (req) => `${req.ip}-upload`
});

// Rate limiter para consultas de banco (prevenir queries maliciosas)
const queryRateLimiter = createRateLimiter({
  windowMs: 5 * 60 * 1000, // 5 minutos
  max: 50, // máximo 50 consultas por 5 minutos
  message: 'Too many database queries. Please try again later.',
  keyGenerator: (req) => `${req.ip}-query`
});

module.exports = {
  createRateLimiter,
  authRateLimiter,
  registerRateLimiter,
  apiRateLimiter,
  uploadRateLimiter,
  queryRateLimiter
};