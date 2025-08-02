const express = require('express');
const UserController = require('../controllers/user-controller');
const { authenticateToken } = require('../middleware/auth');
const { authRateLimiter, registerRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const userController = new UserController();

/**
 * Rotas públicas
 */
// POST /api/users/register - Registro de usuário
router.post('/register', registerRateLimiter, userController.register);

// POST /api/users/login - Login de usuário
router.post('/login', authRateLimiter, userController.login);

// POST /api/users/validate - Validar dados de usuário
router.post('/validate', userController.validate);

// POST /api/users/verify-token - Verificar token
router.post('/verify-token', userController.verifyToken);

// GET /api/users/specialty/:specialty - Buscar médicos por especialidade
router.get('/specialty/:specialty', userController.findBySpecialty);

// GET /api/users/doctors/stats - Buscar médicos com estatísticas
router.get('/doctors/stats', userController.getDoctorsWithStats);

/**
 * Rotas protegidas (requerem autenticação)
 */
// GET /api/users - Listar todos os usuários
router.get('/', authenticateToken, userController.findAll);

// GET /api/users/:id - Buscar usuário por ID
router.get('/:id', authenticateToken, userController.findById);

// PUT /api/users/:id - Atualizar usuário
router.put('/:id', authenticateToken, userController.update);

// DELETE /api/users/:id - Deletar usuário
router.delete('/:id', authenticateToken, userController.delete);

// PUT /api/users/:id/change-password - Alterar senha
router.put('/:id/change-password', authenticateToken, userController.changePassword);

// PUT /api/users/:id/verify - Verificar usuário
router.put('/:id/verify', authenticateToken, userController.verifyUser);

module.exports = router;