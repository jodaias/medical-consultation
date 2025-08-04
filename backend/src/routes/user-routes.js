const express = require('express');
const UserController = require('../controllers/user-controller');
const { authenticateToken } = require('../middleware/auth');
const { authRateLimiter, registerRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const userController = new UserController();

/**
 * @swagger
 * components:
 *   schemas:
 *     User:
 *       type: object
 *       required:
 *         - name
 *         - email
 *         - password
 *       properties:
 *         id:
 *           type: string
 *           description: ID único do usuário
 *         name:
 *           type: string
 *           description: Nome completo do usuário
 *         email:
 *           type: string
 *           format: email
 *           description: Email do usuário
 *         password:
 *           type: string
 *           format: password
 *           description: Senha do usuário (nunca retornada nas respostas)
 *         userType:
 *           type: string
 *           enum: [patient, doctor, admin]
 *           description: Tipo de usuário
 *         specialty:
 *           type: string
 *           description: Especialidade médica (apenas para médicos)
 *         crm:
 *           type: string
 *           description: Número do CRM (apenas para médicos)
 *         profileImage:
 *           type: string
 *           description: URL da imagem de perfil
 *         isVerified:
 *           type: boolean
 *           description: Indica se o usuário foi verificado
 *         isOnline:
 *           type: boolean
 *           description: Indica se o usuário está online
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Data de criação do usuário
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Data da última atualização do usuário
 *       example:
 *         id: "5f8d0d55b54764421b7156c5"
 *         name: "Dr. João Silva"
 *         email: "joao.silva@example.com"
 *         userType: "doctor"
 *         specialty: "Cardiologia"
 *         crm: "12345-SP"
 *         profileImage: "https://example.com/profile.jpg"
 *         isVerified: true
 *         isOnline: false
 *         createdAt: "2023-01-01T00:00:00.000Z"
 *         updatedAt: "2023-01-02T00:00:00.000Z"
 *
 *     LoginRequest:
 *       type: object
 *       required:
 *         - email
 *         - password
 *       properties:
 *         email:
 *           type: string
 *           format: email
 *         password:
 *           type: string
 *           format: password
 *       example:
 *         email: "usuario@example.com"
 *         password: "senha123"
 *
 *     LoginResponse:
 *       type: object
 *       properties:
 *         success:
 *           type: boolean
 *         message:
 *           type: string
 *         data:
 *           type: object
 *           properties:
 *             user:
 *               $ref: '#/components/schemas/User'
 *             token:
 *               type: string
 *             refreshToken:
 *               type: string
 *       example:
 *         success: true
 *         message: "Login realizado com sucesso"
 *         data:
 *           user:
 *             id: "5f8d0d55b54764421b7156c5"
 *             name: "Dr. João Silva"
 *             email: "joao.silva@example.com"
 *             userType: "doctor"
 *           token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
 *           refreshToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
 */

/**
 * @swagger
 * tags:
 *   name: Usuários
 *   description: API para gerenciamento de usuários
 */

/**
 * @swagger
 * /api/users/register:
 *   post:
 *     summary: Registra um novo usuário
 *     tags: [Usuários]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *               - password
 *               - userType
 *             properties:
 *               name:
 *                 type: string
 *               email:
 *                 type: string
 *                 format: email
 *               password:
 *                 type: string
 *                 format: password
 *               userType:
 *                 type: string
 *                 enum: [patient, doctor]
 *               specialty:
 *                 type: string
 *               crm:
 *                 type: string
 *     responses:
 *       201:
 *         description: Usuário registrado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       400:
 *         description: Dados inválidos
 *       409:
 *         description: Email já cadastrado
 */
router.post('/register', registerRateLimiter, userController.register);

/**
 * @swagger
 * /api/users/login:
 *   post:
 *     summary: Autentica um usuário
 *     tags: [Usuários]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/LoginRequest'
 *     responses:
 *       200:
 *         description: Login realizado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/LoginResponse'
 *       401:
 *         description: Credenciais inválidas
 *       429:
 *         description: Muitas tentativas de login. Tente novamente mais tarde.
 */
router.post('/login', authRateLimiter, userController.login);

/**
 * @swagger
 * /api/users/refresh:
 *   post:
 *     summary: Renova o token de acesso
 *     tags: [Usuários]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - refreshToken
 *             properties:
 *               refreshToken:
 *                 type: string
 *     responses:
 *       200:
 *         description: Token renovado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   type: object
 *                   properties:
 *                     token:
 *                       type: string
 *                     refreshToken:
 *                       type: string
 *       401:
 *         description: Token inválido ou expirado
 */
router.post('/refresh', authRateLimiter, userController.refreshToken);

/**
 * @swagger
 * /api/users/validate:
 *   post:
 *     summary: Valida dados de usuário
 *     tags: [Usuários]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *               crm:
 *                 type: string
 *     responses:
 *       200:
 *         description: Dados validados
 *       400:
 *         description: Dados inválidos
 */
router.post('/validate', userController.validate);

/**
 * @swagger
 * /api/users/verify-token:
 *   post:
 *     summary: Verifica a validade de um token
 *     tags: [Usuários]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - token
 *             properties:
 *               token:
 *                 type: string
 *     responses:
 *       200:
 *         description: Token válido
 *       401:
 *         description: Token inválido ou expirado
 */
router.post('/verify-token', userController.verifyToken);

/**
 * @swagger
 * /api/users/specialty/{specialty}:
 *   get:
 *     summary: Busca médicos por especialidade
 *     tags: [Usuários]
 *     parameters:
 *       - in: path
 *         name: specialty
 *         schema:
 *           type: string
 *         required: true
 *         description: Especialidade médica
 *     responses:
 *       200:
 *         description: Lista de médicos
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/User'
 *       404:
 *         description: Nenhum médico encontrado
 */
router.get('/specialty/:specialty', userController.findBySpecialty);

/**
 * @swagger
 * /api/users/doctors/stats:
 *   get:
 *     summary: Busca médicos com estatísticas
 *     tags: [Usuários]
 *     responses:
 *       200:
 *         description: Lista de médicos com estatísticas
 */
router.get('/doctors/stats', userController.getDoctorsWithStats);

/**
 * @swagger
 * /api/users/specialties:
 *   get:
 *     summary: Lista todas as especialidades
 *     tags: [Usuários]
 *     responses:
 *       200:
 *         description: Lista de especialidades
 */
router.get('/specialties', userController.getSpecialties);

/**
 * @swagger
 * /api/users/doctors/online:
 *   get:
 *     summary: Busca médicos online
 *     tags: [Usuários]
 *     responses:
 *       200:
 *         description: Lista de médicos online
 */
router.get('/doctors/online', userController.getOnlineDoctors);

/**
 * @swagger
 * /api/users/doctors/favorites:
 *   get:
 *     summary: Busca médicos favoritos
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de médicos favoritos
 *       401:
 *         description: Não autorizado
 */
router.get('/doctors/favorites', authenticateToken, userController.getFavoriteDoctors);

/**
 * @swagger
 * /api/users/doctors/{doctorId}/favorite:
 *   post:
 *     summary: Adiciona/remove médico aos favoritos
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *     responses:
 *       200:
 *         description: Operação realizada com sucesso
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.post('/doctors/:doctorId/favorite', authenticateToken, userController.toggleFavorite);

/**
 * @swagger
 * /api/users/doctors/{doctorId}/dashboard:
 *   get:
 *     summary: Dashboard do médico
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *     responses:
 *       200:
 *         description: Dados do dashboard
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctors/:doctorId/dashboard', authenticateToken, userController.getDoctorDashboard);

/**
 * @swagger
 * /api/users/patients/{patientId}/dashboard:
 *   get:
 *     summary: Dashboard do paciente
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: patientId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do paciente
 *     responses:
 *       200:
 *         description: Dados do dashboard
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patients/:patientId/dashboard', authenticateToken, userController.getPatientDashboard);

/**
 * @swagger
 * /api/users/doctors/{doctorId}/stats:
 *   get:
 *     summary: Estatísticas do médico
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *     responses:
 *       200:
 *         description: Estatísticas do médico
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctors/:doctorId/stats', authenticateToken, userController.getDoctorStats);

/**
 * @swagger
 * /api/users/doctors/{doctorId}/recent-patients:
 *   get:
 *     summary: Pacientes recentes
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *     responses:
 *       200:
 *         description: Lista de pacientes recentes
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctors/:doctorId/recent-patients', authenticateToken, userController.getRecentPatients);

/**
 * @swagger
 * /api/users/doctors/{doctorId}/revenue:
 *   get:
 *     summary: Receita do médico
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *     responses:
 *       200:
 *         description: Dados de receita
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctors/:doctorId/revenue', authenticateToken, userController.getDoctorRevenue);

/**
 * @swagger
 * /api/users/patients/{patientId}/favorite-doctors:
 *   get:
 *     summary: Médicos favoritos do paciente
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: patientId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do paciente
 *     responses:
 *       200:
 *         description: Lista de médicos favoritos
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patients/:patientId/favorite-doctors', authenticateToken, userController.getPatientFavoriteDoctors);

/**
 * @swagger
 * /api/users/patients/{patientId}/medical-history:
 *   get:
 *     summary: Histórico médico
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: patientId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do paciente
 *     responses:
 *       200:
 *         description: Histórico médico
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patients/:patientId/medical-history', authenticateToken, userController.getPatientMedicalHistory);

/**
 * @swagger
 * /api/users/patients/{patientId}/expenses:
 *   get:
 *     summary: Gastos médicos
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: patientId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do paciente
 *     responses:
 *       200:
 *         description: Dados de gastos
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patients/:patientId/expenses', authenticateToken, userController.getPatientExpenses);

/**
 * @swagger
 * /api/users:
 *   get:
 *     summary: Lista todos os usuários
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de usuários
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/User'
 *       401:
 *         description: Não autorizado
 */
router.get('/', authenticateToken, userController.findAll);

/**
 * @swagger
 * /api/users/{id}:
 *   get:
 *     summary: Busca usuário por ID
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do usuário
 *     responses:
 *       200:
 *         description: Dados do usuário
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Usuário não encontrado
 */
router.get('/:id', authenticateToken, userController.findById);

/**
 * @swagger
 * /api/users/{id}:
 *   put:
 *     summary: Atualiza usuário
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do usuário
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               email:
 *                 type: string
 *                 format: email
 *               specialty:
 *                 type: string
 *               profileImage:
 *                 type: string
 *     responses:
 *       200:
 *         description: Usuário atualizado
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 data:
 *                   $ref: '#/components/schemas/User'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Usuário não encontrado
 */
router.put('/:id', authenticateToken, userController.update);

/**
 * @swagger
 * /api/users/{id}:
 *   delete:
 *     summary: Deleta usuário
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do usuário
 *     responses:
 *       200:
 *         description: Usuário deletado
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Usuário não encontrado
 */
router.delete('/:id', authenticateToken, userController.delete);

/**
 * @swagger
 * /api/users/{id}/change-password:
 *   put:
 *     summary: Altera senha
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do usuário
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - currentPassword
 *               - newPassword
 *             properties:
 *               currentPassword:
 *                 type: string
 *                 format: password
 *               newPassword:
 *                 type: string
 *                 format: password
 *     responses:
 *       200:
 *         description: Senha alterada
 *       401:
 *         description: Não autorizado ou senha atual incorreta
 *       404:
 *         description: Usuário não encontrado
 */
router.put('/:id/change-password', authenticateToken, userController.changePassword);

/**
 * @swagger
 * /api/users/{id}/verify:
 *   put:
 *     summary: Verifica usuário
 *     tags: [Usuários]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do usuário
 *     responses:
 *       200:
 *         description: Usuário verificado
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Usuário não encontrado
 */
router.put('/:id/verify', authenticateToken, userController.verifyUser);

module.exports = router;