const { AppException } = require('../exceptions/app-exception');

/**
 * Middleware de tratamento de erros
 * Seguindo boas práticas de tratamento de exceções
 */
const errorHandler = (err, req, res, next) => {
  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    body: req.body,
    params: req.params,
    query: req.query,
    user: req.user?.id
  });

  // Se é uma exceção customizada da aplicação
  if (err instanceof AppException) {
    return res.status(err.statusCode).json({
      success: false,
      message: err.message,
      error: process.env.NODE_ENV === 'development' ? err.stack : undefined
    });
  }

  // Erros do Prisma
  if (err.code) {
    switch (err.code) {
      case 'P2002':
        return res.status(409).json({
          success: false,
          message: 'Resource already exists',
          error: process.env.NODE_ENV === 'development' ? err.message : undefined
        });
      case 'P2025':
        return res.status(404).json({
          success: false,
          message: 'Resource not found',
          error: process.env.NODE_ENV === 'development' ? err.message : undefined
        });
      case 'P2003':
        return res.status(400).json({
          success: false,
          message: 'Invalid foreign key reference',
          error: process.env.NODE_ENV === 'development' ? err.message : undefined
        });
      default:
        return res.status(500).json({
          success: false,
          message: 'Database error',
          error: process.env.NODE_ENV === 'development' ? err.message : undefined
        });
    }
  }

  // Erros de validação do Joi ou similar
  if (err.isJoi) {
    return res.status(400).json({
      success: false,
      message: 'Validation error',
      details: err.details.map(detail => detail.message),
      error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }

  // Erros de JWT
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({
      success: false,
      message: 'Invalid token',
      error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }

  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({
      success: false,
      message: 'Token expired',
      error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }

  // Erros de sintaxe JSON
  if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
    return res.status(400).json({
      success: false,
      message: 'Invalid JSON',
      error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }

  // Erro genérico
  return res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
};

module.exports = errorHandler;