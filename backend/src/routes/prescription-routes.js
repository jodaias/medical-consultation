const express = require('express');
const PrescriptionController = require('../controllers/prescription-controller');
const { authenticateToken } = require('../middleware/auth');
const { apiRateLimiter } = require('../middleware/rate-limiter');

const router = express.Router();
const prescriptionController = new PrescriptionController();

/**
 * @swagger
 * components:
 *   schemas:
 *     Prescription:
 *       type: object
 *       required:
 *         - patientId
 *         - doctorId
 *         - consultationId
 *         - medications
 *       properties:
 *         id:
 *           type: string
 *           description: ID único da prescrição
 *         patientId:
 *           type: string
 *           description: ID do paciente
 *         doctorId:
 *           type: string
 *           description: ID do médico
 *         consultationId:
 *           type: string
 *           description: ID da consulta relacionada
 *         medications:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               dosage:
 *                 type: string
 *               frequency:
 *                 type: string
 *               duration:
 *                 type: string
 *           description: Lista de medicamentos prescritos
 *         instructions:
 *           type: string
 *           description: Instruções adicionais
 *         isActive:
 *           type: boolean
 *           description: Indica se a prescrição está ativa
 *         expirationDate:
 *           type: string
 *           format: date-time
 *           description: Data de expiração da prescrição
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Data de criação da prescrição
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Data da última atualização da prescrição
 *       example:
 *         id: "5f8d0d55b54764421b7156c5"
 *         patientId: "5f8d0d55b54764421b7156c6"
 *         doctorId: "5f8d0d55b54764421b7156c7"
 *         consultationId: "5f8d0d55b54764421b7156c8"
 *         medications: [
 *           {
 *             name: "Paracetamol",
 *             dosage: "500mg",
 *             frequency: "8/8h",
 *             duration: "5 dias"
 *           }
 *         ]
 *         instructions: "Tomar com água. Evitar bebidas alcoólicas."
 *         isActive: true
 *         expirationDate: "2023-02-01T00:00:00.000Z"
 *         createdAt: "2023-01-01T00:00:00.000Z"
 *         updatedAt: "2023-01-01T00:00:00.000Z"
 */

/**
 * @swagger
 * tags:
 *   name: Prescrições
 *   description: API para gerenciamento de prescrições médicas
 */

/**
 * @swagger
 * /api/prescriptions:
 *   post:
 *     summary: Cria uma nova prescrição
 *     tags: [Prescrições]
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
 *               - medications
 *             properties:
 *               patientId:
 *                 type: string
 *               doctorId:
 *                 type: string
 *               consultationId:
 *                 type: string
 *               medications:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     name:
 *                       type: string
 *                     dosage:
 *                       type: string
 *                     frequency:
 *                       type: string
 *                     duration:
 *                       type: string
 *               instructions:
 *                 type: string
 *               expirationDate:
 *                 type: string
 *                 format: date-time
 *     responses:
 *       201:
 *         description: Prescrição criada com sucesso
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
 *                   $ref: '#/components/schemas/Prescription'
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/', authenticateToken, apiRateLimiter, prescriptionController.create);

/**
 * @swagger
 * /api/prescriptions:
 *   get:
 *     summary: Lista todas as prescrições
 *     tags: [Prescrições]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: active
 *         schema:
 *           type: boolean
 *         description: Filtrar por prescrições ativas
 *     responses:
 *       200:
 *         description: Lista de prescrições
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
 *                     $ref: '#/components/schemas/Prescription'
 *       401:
 *         description: Não autorizado
 */
router.get('/', authenticateToken, prescriptionController.findAll);

/**
 * @swagger
 * /api/prescriptions/{id}:
 *   get:
 *     summary: Busca prescrição por ID
 *     tags: [Prescrições]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da prescrição
 *     responses:
 *       200:
 *         description: Dados da prescrição
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   $ref: '#/components/schemas/Prescription'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Prescrição não encontrada
 */
router.get('/:id', authenticateToken, prescriptionController.findById);

/**
 * @swagger
 * /api/prescriptions/{id}:
 *   put:
 *     summary: Atualiza prescrição
 *     tags: [Prescrições]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da prescrição
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               medications:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     name:
 *                       type: string
 *                     dosage:
 *                       type: string
 *                     frequency:
 *                       type: string
 *                     duration:
 *                       type: string
 *               instructions:
 *                 type: string
 *               isActive:
 *                 type: boolean
 *               expirationDate:
 *                 type: string
 *                 format: date-time
 *     responses:
 *       200:
 *         description: Prescrição atualizada
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
 *                   $ref: '#/components/schemas/Prescription'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Prescrição não encontrada
 */
router.put('/:id', authenticateToken, prescriptionController.update);

/**
 * @swagger
 * /api/prescriptions/{id}:
 *   delete:
 *     summary: Deleta prescrição
 *     tags: [Prescrições]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID da prescrição
 *     responses:
 *       200:
 *         description: Prescrição deletada
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
 *         description: Prescrição não encontrada
 */
router.delete('/:id', authenticateToken, prescriptionController.delete);

/**
 * @swagger
 * /api/prescriptions/consultation/{consultationId}:
 *   get:
 *     summary: Busca prescrições por consulta
 *     tags: [Prescrições]
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
 *         description: Lista de prescrições da consulta
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
 *                     $ref: '#/components/schemas/Prescription'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Consulta não encontrada
 */
router.get('/consultation/:consultationId', authenticateToken, prescriptionController.findByConsultation);

/**
 * @swagger
 * /api/prescriptions/doctor/{doctorId}:
 *   get:
 *     summary: Busca prescrições por médico
 *     tags: [Prescrições]
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
 *         description: Lista de prescrições do médico
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
 *                     $ref: '#/components/schemas/Prescription'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Médico não encontrado
 */
router.get('/doctor/:doctorId', authenticateToken, prescriptionController.findByDoctor);

/**
 * @swagger
 * /api/prescriptions/patient/{patientId}:
 *   get:
 *     summary: Busca prescrições por paciente
 *     tags: [Prescrições]
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
 *         name: active
 *         schema:
 *           type: boolean
 *         description: Filtrar por prescrições ativas
 *     responses:
 *       200:
 *         description: Lista de prescrições do paciente
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
 *                     $ref: '#/components/schemas/Prescription'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patient/:patientId', authenticateToken, prescriptionController.findByPatient);

/**
 * @swagger
 * /api/prescriptions/patient/{patientId}/recent:
 *   get:
 *     summary: Busca prescrições recentes do paciente
 *     tags: [Prescrições]
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
 *         name: limit
 *         schema:
 *           type: integer
 *         description: 'Limite de resultados (padrão: 5)'
 *     responses:
 *       200:
 *         description: Lista de prescrições recentes do paciente
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
 *                     $ref: '#/components/schemas/Prescription'
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Paciente não encontrado
 */
router.get('/patient/:patientId/recent', authenticateToken, prescriptionController.getPatientRecentPrescriptions);

/**
 * @swagger
 * /api/prescriptions/stats:
 *   get:
 *     summary: Obtém estatísticas de prescrições
 *     tags: [Prescrições]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Estatísticas de prescrições
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
 *                     totalPrescriptions:
 *                       type: integer
 *                     activePrescriptions:
 *                       type: integer
 *                     expiredPrescriptions:
 *                       type: integer
 *                     prescriptionsPerMonth:
 *                       type: object
 *       401:
 *         description: Não autorizado
 */
router.get('/stats', authenticateToken, prescriptionController.getStats);

/**
 * @swagger
 * /api/prescriptions/deactivate-expired:
 *   put:
 *     summary: Desativa prescrições expiradas
 *     tags: [Prescrições]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Prescrições expiradas desativadas
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 message:
 *                   type: string
 *                 count:
 *                   type: integer
 *       401:
 *         description: Não autorizado
 */
router.put('/deactivate-expired', authenticateToken, prescriptionController.deactivateExpired);

/**
 * @swagger
 * /api/prescriptions/validate:
 *   post:
 *     summary: Validar dados de prescrição
 *     tags: [Prescrições]
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
 *               medications:
 *                 type: array
 *                 items:
 *                   type: object
 *     responses:
 *       200:
 *         description: Dados validados
 *       400:
 *         description: Dados inválidos
 *       401:
 *         description: Não autorizado
 */
router.post('/validate', authenticateToken, prescriptionController.validate);

module.exports = router;