const express = require('express');
const ConsultationController = require('../controllers/consultation-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const consultationController = new ConsultationController();

/**
 * @swagger
 * components:
 *   schemas:
 *     Consultation:
 *       type: object
 *       required:
 *         - patientId
 *         - doctorId
 *         - date
 *         - status
 *       properties:
 *         id:
 *           type: string
 *           description: ID único da consulta
 *         patientId:
 *           type: string
 *           description: ID do paciente
 *         doctorId:
 *           type: string
 *           description: ID do médico
 *         date:
 *           type: string
 *           format: date-time
 *           description: Data e hora da consulta
 *         duration:
 *           type: integer
 *           description: Duração da consulta em minutos
 *         status:
 *           type: string
 *           enum: [scheduled, in_progress, completed, cancelled, no_show]
 *           description: Status da consulta
 *         notes:
 *           type: string
 *           description: Anotações da consulta
 *         symptoms:
 *           type: string
 *           description: Sintomas relatados pelo paciente
 *         diagnosis:
 *           type: string
 *           description: Diagnóstico do médico
 *         price:
 *           type: number
 *           format: float
 *           description: Preço da consulta
 *         paymentStatus:
 *           type: string
 *           enum: [pending, paid, refunded]
 *           description: Status do pagamento
 *         rating:
 *           type: integer
 *           minimum: 1
 *           maximum: 5
 *           description: Avaliação da consulta
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Data de criação do registro
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Data da última atualização do registro
 *       example:
 *         id: "5f8d0d55b54764421b7156c5"
 *         patientId: "5f8d0d55b54764421b7156c6"
 *         doctorId: "5f8d0d55b54764421b7156c7"
 *         date: "2023-01-15T14:00:00.000Z"
 *         duration: 30
 *         status: "scheduled"
 *         notes: "Primeira consulta"
 *         symptoms: "Dor de cabeça, febre"
 *         diagnosis: ""
 *         price: 150.00
 *         paymentStatus: "pending"
 *         rating: null
 *         createdAt: "2023-01-01T00:00:00.000Z"
 *         updatedAt: "2023-01-01T00:00:00.000Z"
 */

/**
 * @swagger
 * tags:
 *   name: Consultas
 *   description: API para gerenciamento de consultas médicas
 */

/**
 * @swagger
 * /api/consultations:
 *   post:
 *     summary: Cria uma nova consulta
 *     tags: [Consultas]
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
 *               - date
 *             properties:
 *               patientId:
 *                 type: string
 *               doctorId:
 *                 type: string
 *               date:
 *                 type: string
 *                 format: date-time
 *               duration:
 *                 type: integer
 *               notes:
 *                 type: string
 *               symptoms:
 *                 type: string
 *               price:
 *                 type: number
 *     responses:
 *       201:
 *         description: Consulta criada com sucesso
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
 *                   $ref: '#/components/schemas/Consultation'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/', authenticateToken, apiRateLimiter, consultationController.create);

/**
 * @swagger
 * /api/consultations:
 *   get:
 *     summary: Lista todas as consultas
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *         description: Filtrar por status
 *       - in: query
 *         name: from
 *         schema:
 *           type: string
 *           format: date
 *         description: Data inicial
 *       - in: query
 *         name: to
 *         schema:
 *           type: string
 *           format: date
 *         description: Data final
 *     responses:
 *       200:
 *         description: Lista de consultas
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
 *                     $ref: '#/components/schemas/Consultation'
 *       401:
 *         description: Não autorizado
 */
router.get('/', authenticateToken, consultationController.findAll);

/**
 * @swagger
 * /api/consultations/{id}:
 *   get:
 *     summary: Busca consulta por ID
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     responses:
 *       200:
 *         description: Dados da consulta
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Consultation'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.get('/:id', authenticateToken, consultationController.findById);

/**
 * @swagger
 * /api/consultations/{id}:
 *   put:
 *     summary: Atualiza consulta
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               date:
 *                 type: string
 *                 format: date-time
 *               duration:
 *                 type: integer
 *               notes:
 *                 type: string
 *               symptoms:
 *                 type: string
 *               diagnosis:
 *                 type: string
 *               price:
 *                 type: number
 *     responses:
 *       200:
 *         description: Consulta atualizada
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
 *                   $ref: '#/components/schemas/Consultation'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.put('/:id', authenticateToken, consultationController.update);

/**
 * @swagger
 * /api/consultations/{id}:
 *   delete:
 *     summary: Deleta consulta
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     responses:
 *       200:
 *         description: Consulta deletada
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
 *         description: Consulta não encontrada
 */
router.delete('/:id', authenticateToken, consultationController.delete);

/**
 * @swagger
 * /api/consultations/{id}/start:
 *   post:
 *     summary: Inicia consulta
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     responses:
 *       200:
 *         description: Consulta iniciada
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
 *                   $ref: '#/components/schemas/Consultation'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.post('/:id/start', authenticateToken, consultationController.startConsultation);

/**
 * @swagger
 * /api/consultations/{id}/end:
 *   post:
 *     summary: Finaliza consulta
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               notes:
 *                 type: string
 *               diagnosis:
 *                 type: string
 *     responses:
 *       200:
 *         description: Consulta finalizada
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
 *                   $ref: '#/components/schemas/Consultation'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.post('/:id/end', authenticateToken, consultationController.endConsultation);

/**
 * @swagger
 * /api/consultations/{id}/cancel:
 *   put:
 *     summary: Cancela consulta
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               reason:
 *                 type: string
 *     responses:
 *       200:
 *         description: Consulta cancelada
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
 *                   $ref: '#/components/schemas/Consultation'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.put('/:id/cancel', authenticateToken, consultationController.cancelConsultation);

/**
 * @swagger
 * /api/consultations/patient/{patientId}:
 *   get:
 *     summary: Busca consultas por paciente
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: patientId
 *         schema:
 *           type: string
 *         required: true
 *         description: ID do paciente
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *         description: Filtrar por status
 *     responses:
 *       200:
 *         description: Lista de consultas
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
 *                     $ref: '#/components/schemas/Consultation'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patient/:patientId', authenticateToken, consultationController.findByPatient);

/**
 * @swagger
 * /api/consultations/doctors/available:
 *   get:
 *     summary: Busca médicos disponíveis
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: date
 *         schema:
 *           type: string
 *           format: date
 *         description: Data para verificar disponibilidade
 *       - in: query
 *         name: specialty
 *         schema:
 *           type: string
 *         description: Filtrar por especialidade
 *     responses:
 *       200:
 *         description: Lista de médicos disponíveis
 *       401:
 *         description: Não autorizado
 */
router.get('/doctors/available', authenticateToken, consultationController.getAvailableDoctors);

/**
 * @swagger
 * /api/consultations/doctors/{doctorId}:
 *   get:
 *     summary: Busca consultas por médico
 *     tags: [Consultas]
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
 *         name: status
 *         schema:
 *           type: string
 *         description: Filtrar por status
 *     responses:
 *       200:
 *         description: Lista de consultas
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
 *                     $ref: '#/components/schemas/Consultation'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctors/:doctorId', authenticateToken, consultationController.findByDoctor);

/**
 * @swagger
 * /api/consultations/stats:
 *   get:
 *     summary: Obter estatísticas de consultas
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Estatísticas de consultas
 *       401:
 *         description: Não autorizado
 */
router.get('/stats', authenticateToken, consultationController.getStats);

/**
 * @swagger
 * /api/consultations/upcoming:
 *   get:
 *     summary: Obter próximas consultas
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de próximas consultas
 *       401:
 *         description: Não autorizado
 */
router.get('/upcoming', authenticateToken, consultationController.getUpcoming);

/**
 * @swagger
 * /api/consultations/validate:
 *   post:
 *     summary: Validar dados de consulta
 *     tags: [Consultas]
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
 *               date:
 *                 type: string
 *                 format: date-time
 *     responses:
 *       200:
 *         description: Dados validados
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/validate', authenticateToken, consultationController.validate);

/**
 * @swagger
 * /api/consultations/{id}/rate:
 *   post:
 *     summary: Avaliar consulta
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - rating
 *             properties:
 *               rating:
 *                 type: integer
 *                 minimum: 1
 *                 maximum: 5
 *               comment:
 *                 type: string
 *     responses:
 *       200:
 *         description: Consulta avaliada
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.post('/:id/rate', authenticateToken, consultationController.rateConsultation);

/**
 * @swagger
 * /api/consultations/{id}/no-show:
 *   post:
 *     summary: Marcar como no-show
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     responses:
 *       200:
 *         description: Consulta marcada como no-show
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.post('/:id/no-show', authenticateToken, consultationController.markAsNoShow);

/**
 * @swagger
 * /api/consultations/{id}/reschedule:
 *   put:
 *     summary: Reagendar consulta
 *     tags: [Consultas]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da consulta
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - date
 *             properties:
 *               date:
 *                 type: string
 *                 format: date-time
 *               reason:
 *                 type: string
 *     responses:
 *       200:
 *         description: Consulta reagendada
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.put('/:id/reschedule', authenticateToken, consultationController.rescheduleConsultation);

/**
 * @swagger
 * /api/consultations/doctors/{doctorId}/upcoming:
 *   get:
 *     summary: Consultas próximas do médico
 *     tags: [Consultas]
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
 *         description: Lista de consultas próximas
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctors/:doctorId/upcoming', authenticateToken, consultationController.getDoctorUpcomingConsultations);

/**
 * @swagger
 * /api/consultations/patients/{patientId}/recent:
 *   get:
 *     summary: Consultas recentes do paciente
 *     tags: [Consultas]
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
 *         description: Lista de consultas recentes
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patients/:patientId/recent', authenticateToken, consultationController.getPatientRecentConsultations);

/**
 * @swagger
 * /api/consultations/patients/{patientId}/upcoming:
 *   get:
 *     summary: Próximas consultas do paciente
 *     tags: [Consultas]
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
 *         description: Lista de próximas consultas
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patients/:patientId/upcoming', authenticateToken, consultationController.getPatientUpcomingConsultations);

module.exports = router;