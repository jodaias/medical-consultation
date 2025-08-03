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

// POST /api/users/refresh - Renovar token
router.post('/refresh', authRateLimiter, userController.refreshToken);

// POST /api/users/validate - Validar dados de usuário
router.post('/validate', userController.validate);

// POST /api/users/verify-token - Verificar token
router.post('/verify-token', userController.verifyToken);

// GET /api/users/specialty/:specialty - Buscar médicos por especialidade
router.get('/specialty/:specialty', userController.findBySpecialty);

// GET /api/users/doctors/stats - Buscar médicos com estatísticas
router.get('/doctors/stats', userController.getDoctorsWithStats);

// GET /api/users/specialties - Listar todas as especialidades
router.get('/specialties', userController.getSpecialties);

// GET /api/users/doctors/online - Buscar médicos online
router.get('/doctors/online', userController.getOnlineDoctors);

// GET /api/users/doctors/favorites - Buscar médicos favoritos
router.get('/doctors/favorites', authenticateToken, userController.getFavoriteDoctors);

// POST /api/users/doctors/:doctorId/favorite - Adicionar médico aos favoritos
router.post('/doctors/:doctorId/favorite', authenticateToken, userController.toggleFavorite);

// GET /api/users/doctors/:doctorId/dashboard - Dashboard do médico
router.get('/doctors/:doctorId/dashboard', authenticateToken, userController.getDoctorDashboard);

// GET /api/users/patients/:patientId/dashboard - Dashboard do paciente
router.get('/patients/:patientId/dashboard', authenticateToken, userController.getPatientDashboard);

// GET /api/users/doctors/:doctorId/stats - Estatísticas do médico
router.get('/doctors/:doctorId/stats', authenticateToken, userController.getDoctorStats);

// GET /api/users/doctors/:doctorId/recent-patients - Pacientes recentes
router.get('/doctors/:doctorId/recent-patients', authenticateToken, userController.getRecentPatients);

// GET /api/users/doctors/:doctorId/revenue - Receita do médico
router.get('/doctors/:doctorId/revenue', authenticateToken, userController.getDoctorRevenue);

// GET /api/users/patients/:patientId/favorite-doctors - Médicos favoritos do paciente
router.get('/patients/:patientId/favorite-doctors', authenticateToken, userController.getPatientFavoriteDoctors);

// GET /api/users/patients/:patientId/medical-history - Histórico médico
router.get('/patients/:patientId/medical-history', authenticateToken, userController.getPatientMedicalHistory);

// GET /api/users/patients/:patientId/expenses - Gastos médicos
router.get('/patients/:patientId/expenses', authenticateToken, userController.getPatientExpenses);

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