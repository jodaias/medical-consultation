const express = require('express');
const RatingController = require('../controllers/rating-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const ratingController = new RatingController();

/**
 * @swagger
 * components:
 *   schemas:
 *     Rating:
 *       type: object
 *       required:
 *         - patientId
 *         - doctorId
 *         - consultationId
 *         - rating
 *       properties:
 *         id:
 *           type: string
 *           description: ID único da avaliação
 *         patientId:
 *           type: string
 *           description: ID do paciente que fez a avaliação
 *         doctorId:
 *           type: string
 *           description: ID do médico avaliado
 *         consultationId:
 *           type: string
 *           description: ID da consulta relacionada
 *         rating:
 *           type: number
 *           format: float
 *           minimum: 1
 *           maximum: 5
 *           description: Nota da avaliação (1-5)
 *         comment:
 *           type: string
 *           description: Comentário opcional da avaliação
 *         isHelpful:
 *           type: boolean
 *           description: Indica se a avaliação foi marcada como útil
 *         helpfulCount:
 *           type: integer
 *           description: Contagem de quantas vezes a avaliação foi marcada como útil
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Data de criação da avaliação
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Data da última atualização da avaliação
 *       example:
 *         id: "5f8d0d55b54764421b7156c5"
 *         patientId: "5f8d0d55b54764421b7156c6"
 *         doctorId: "5f8d0d55b54764421b7156c7"
 *         consultationId: "5f8d0d55b54764421b7156c8"
 *         rating: 4.5
 *         comment: "Excelente atendimento, médico muito atencioso."
 *         isHelpful: true
 *         helpfulCount: 3
 *         createdAt: "2023-01-01T00:00:00.000Z"
 *         updatedAt: "2023-01-01T00:00:00.000Z"
 */

/**
 * @swagger
 * tags:
 *   name: Avaliações
 *   description: API para gerenciamento de avaliações de consultas médicas
 */

/**
 * @swagger
 * /api/ratings:
 *   post:
 *     summary: Cria uma nova avaliação
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - patientId
 *               - doctorId
 *               - consultationId
 *               - rating
 *             properties:
 *               patientId:
 *                 type: string
 *               doctorId:
 *                 type: string
 *               consultationId:
 *                 type: string
 *               rating:
 *                 type: number
 *                 format: float
 *                 minimum: 1
 *                 maximum: 5
 *               comment:
 *                 type: string
 *     responses:
 *       201:
 *         description: Avaliação criada com sucesso
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
 *                   $ref: '#/components/schemas/Rating'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/', authenticateToken, apiRateLimiter, ratingController.create);

/**
 * @swagger
 * /api/ratings:
 *   get:
 *     summary: Lista todas as avaliações
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: helpful
 *         schema:
 *           type: boolean
 *         description: Filtrar por avaliações úteis
 *       - in: query
 *         name: minRating
 *         schema:
 *           type: number
 *         description: Filtrar por avaliação mínima
 *     responses:
 *       200:
 *         description: Lista de avaliações
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
 *                     $ref: '#/components/schemas/Rating'
 *       401:
 *         description: Não autorizado
 */
router.get('/', authenticateToken, ratingController.findAll);

/**
 * @swagger
 * /api/ratings/{id}:
 *   get:
 *     summary: Busca avaliação por ID
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da avaliação
 *     responses:
 *       200:
 *         description: Dados da avaliação
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Rating'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Avaliação não encontrada
 */
router.get('/:id', authenticateToken, ratingController.findById);

/**
 * @swagger
 * /api/ratings/{id}:
 *   put:
 *     summary: Atualiza avaliação
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da avaliação
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               rating:
 *                 type: number
 *                 format: float
 *                 minimum: 1
 *                 maximum: 5
 *               comment:
 *                 type: string
 *     responses:
 *       200:
 *         description: Avaliação atualizada
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
 *                   $ref: '#/components/schemas/Rating'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Avaliação não encontrada
 */
router.put('/:id', authenticateToken, ratingController.update);

/**
 * @swagger
 * /api/ratings/{id}:
 *   delete:
 *     summary: Deleta avaliação
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da avaliação
 *     responses:
 *       200:
 *         description: Avaliação deletada
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
 *         description: Avaliação não encontrada
 */
router.delete('/:id', authenticateToken, ratingController.delete);

/**
 * @swagger
 * /api/ratings/consultation/{consultationId}:
 *   get:
 *     summary: Busca avaliação por consulta
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: consultationId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     responses:
 *       200:
 *         description: Avaliação da consulta
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Rating'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Avaliação não encontrada
 */
router.get('/consultation/:consultationId', authenticateToken, ratingController.findByConsultation);

/**
 * @swagger
 * /api/ratings/doctor/{doctorId}:
 *   get:
 *     summary: Busca avaliações por médico
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: doctorId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do médico
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *         description: Limite de resultados
 *       - in: query
 *         name: sort
 *         schema:
 *           type: string
 *           enum: [recent, helpful, highest, lowest]
 *         description: Ordenação dos resultados
 *     responses:
 *       200:
 *         description: Lista de avaliações do médico
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
 *                     $ref: '#/components/schemas/Rating'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctor/:doctorId', authenticateToken, ratingController.findByDoctor);

/**
 * @swagger
 * /api/ratings/patient/{patientId}:
 *   get:
 *     summary: Busca avaliações por paciente
 *     tags: [Avaliações]
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
 *         description: Lista de avaliações do paciente
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
 *                     $ref: '#/components/schemas/Rating'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patient/:patientId', authenticateToken, ratingController.findByPatient);

/**
 * @swagger
 * /api/ratings/{id}/mark-helpful:
 *   put:
 *     summary: Marca avaliação como útil
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da avaliação
 *     responses:
 *       200:
 *         description: Avaliação marcada como útil
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
 *                   $ref: '#/components/schemas/Rating'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Avaliação não encontrada
 */
router.put('/:id/mark-helpful', authenticateToken, ratingController.markAsHelpful);

/**
 * @swagger
 * /api/ratings/stats:
 *   get:
 *     summary: Obtém estatísticas de avaliações
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Estatísticas de avaliações
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *                   properties:
 *                     totalRatings:
 *                       type: integer
 *                     averageRating:
 *                       type: number
 *                     ratingDistribution:
 *                       type: object
 *                     helpfulRatings:
 *                       type: integer
 *       401:
 *         description: Não autorizado
 */
router.get('/stats', authenticateToken, ratingController.getStats);

/**
 * @swagger
 * /api/ratings/validate:
 *   post:
 *     summary: Validar dados de avaliação
 *     tags: [Avaliações]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               patientId:
 *                 type: string
 *               doctorId:
 *                 type: string
 *               consultationId:
 *                 type: string
 *               rating:
 *                 type: number
 *                 format: float
 *               comment:
 *                 type: string
 *     responses:
 *       200:
 *         description: Dados validados
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/validate', authenticateToken, ratingController.validate);

module.exports = router;