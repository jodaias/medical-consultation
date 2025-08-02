/**
 * Exceções customizadas para melhor tratamento de erros
 */

class AppException extends Error {
  constructor(message, statusCode = 500) {
    super(message);
    this.statusCode = statusCode;
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

class ValidationException extends AppException {
  constructor(message = 'Validation failed') {
    super(message, 400);
  }
}

class NotFoundException extends AppException {
  constructor(message = 'Resource not found') {
    super(message, 404);
  }
}

class UnauthorizedException extends AppException {
  constructor(message = 'Unauthorized') {
    super(message, 401);
  }
}

class ForbiddenException extends AppException {
  constructor(message = 'Forbidden') {
    super(message, 403);
  }
}

class ConflictException extends AppException {
  constructor(message = 'Conflict') {
    super(message, 409);
  }
}

class BadRequestException extends AppException {
  constructor(message = 'Bad request') {
    super(message, 400);
  }
}

module.exports = {
  AppException,
  ValidationException,
  NotFoundException,
  UnauthorizedException,
  ForbiddenException,
  ConflictException,
  BadRequestException
};