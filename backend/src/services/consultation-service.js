const ConsultationRepository = require('../repositories/consultation-repository');
const UserRepository = require('../repositories/user-repository');
const { CreateConsultationDTO, UpdateConsultationDTO, ConsultationResponseDTO } = require('../dto/consultation-dto');
const { ValidationException, NotFoundException, ForbiddenException } = require('../exceptions/app-exception');

/**
 * ConsultationService - Lógica de negócio para consultas médicas
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class ConsultationService {
  constructor() {
    this.repository = new ConsultationRepository();
    this.userRepository = new UserRepository();
  }

  async create(consultationData, userId) {
    // Validação com DTO
    const createConsultationDTO = new CreateConsultationDTO(consultationData);
    const validationErrors = createConsultationDTO.validate();

    if (validationErrors.length > 0) {
      throw new ValidationException(validationErrors.join(', '));
    }

    // Verificar se usuário é paciente
    const user = await this.userRepository.findById(userId);
    if (user.userType !== 'PATIENT') {
      throw new ForbiddenException('Only patients can create consultations');
    }

    // Verificar se médico existe e é médico
    const doctor = await this.userRepository.findById(consultationData.doctorId);
    if (doctor.userType !== 'DOCTOR') {
      throw new ValidationException('Invalid doctor ID');
    }

    // Verificar se paciente não está tentando agendar para outro paciente
    if (consultationData.patientId !== userId) {
      throw new ForbiddenException('You can only create consultations for yourself');
    }

    // Verificar conflito de horário para o médico
    const conflictingConsultation = await this.repository.findAll({
      doctorId: consultationData.doctorId,
      dateFrom: consultationData.scheduledAt,
      dateTo: new Date(new Date(consultationData.scheduledAt).getTime() + 30 * 60 * 1000) // 30 min
    });

    if (conflictingConsultation.consultations.length > 0) {
      throw new ValidationException('Doctor is not available at this time');
    }

    // Preparar dados para criação
    const consultationEntity = createConsultationDTO.toEntity();

    // Criar consulta
    const consultation = await this.repository.create(consultationEntity);

    return ConsultationResponseDTO.fromEntity(consultation);
  }

  async findById(id, userId, userType) {
    const consultation = await this.repository.findById(id);

    // Verificar permissões
    if (userType === 'PATIENT' && consultation.patientId !== userId) {
      throw new ForbiddenException('You can only view your own consultations');
    }

    if (userType === 'DOCTOR' && consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only view consultations you are assigned to');
    }

    return ConsultationResponseDTO.fromEntity(consultation);
  }

  async findAll(filters, userId, userType) {
    // Aplicar filtros baseados no tipo de usuário
    if (userType === 'PATIENT') {
      filters.patientId = userId;
    } else if (userType === 'DOCTOR') {
      filters.doctorId = userId;
    }

    const result = await this.repository.findAll(filters);
    return {
      consultations: ConsultationResponseDTO.fromEntities(result.consultations),
      pagination: result.pagination
    };
  }

  async update(id, consultationData, userId, userType) {
    // Validação com DTO
    const updateConsultationDTO = new UpdateConsultationDTO(consultationData);
    const validationErrors = updateConsultationDTO.validate();

    if (validationErrors.length > 0) {
      throw new ValidationException(validationErrors.join(', '));
    }

    // Verificar se consulta existe e usuário tem permissão
    const existingConsultation = await this.repository.findById(id);

    if (userType === 'PATIENT' && existingConsultation.patientId !== userId) {
      throw new ForbiddenException('You can only update your own consultations');
    }

    if (userType === 'DOCTOR' && existingConsultation.doctorId !== userId) {
      throw new ForbiddenException('You can only update consultations you are assigned to');
    }

    // Verificar se consulta pode ser atualizada
    if (existingConsultation.status === 'COMPLETED' || existingConsultation.status === 'CANCELLED') {
      throw new ValidationException('Cannot update completed or cancelled consultations');
    }

    // Preparar dados para atualização
    const consultationEntity = updateConsultationDTO.toEntity();

    // Atualizar consulta
    const consultation = await this.repository.update(id, consultationEntity);
    return ConsultationResponseDTO.fromEntity(consultation);
  }

  async delete(id, userId, userType) {
    // Verificar se consulta existe e usuário tem permissão
    const consultation = await this.repository.findById(id);

    if (userType === 'PATIENT' && consultation.patientId !== userId) {
      throw new ForbiddenException('You can only delete your own consultations');
    }

    if (userType === 'DOCTOR' && consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only delete consultations you are assigned to');
    }

    // Verificar se consulta pode ser deletada
    if (consultation.status === 'IN_PROGRESS' || consultation.status === 'COMPLETED') {
      throw new ValidationException('Cannot delete consultations in progress or completed');
    }

    return await this.repository.delete(id);
  }

  async startConsultation(id, userId, userType) {
    // Verificar se usuário é médico
    if (userType !== 'DOCTOR') {
      throw new ForbiddenException('Only doctors can start consultations');
    }

    // Verificar se consulta existe e médico tem permissão
    const consultation = await this.repository.findById(id);

    if (consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only start consultations you are assigned to');
    }

    // Verificar se consulta pode ser iniciada
    if (consultation.status !== 'SCHEDULED') {
      throw new ValidationException('Only scheduled consultations can be started');
    }

    const updatedConsultation = await this.repository.startConsultation(id);
    return ConsultationResponseDTO.fromEntity(updatedConsultation);
  }

  async endConsultation(id, userId, userType) {
    // Verificar se usuário é médico
    if (userType !== 'DOCTOR') {
      throw new ForbiddenException('Only doctors can end consultations');
    }

    // Verificar se consulta existe e médico tem permissão
    const consultation = await this.repository.findById(id);

    if (consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only end consultations you are assigned to');
    }

    // Verificar se consulta pode ser finalizada
    if (consultation.status !== 'IN_PROGRESS') {
      throw new ValidationException('Only consultations in progress can be ended');
    }

    const updatedConsultation = await this.repository.endConsultation(id);
    return ConsultationResponseDTO.fromEntity(updatedConsultation);
  }

  async cancelConsultation(id, userId, userType) {
    // Verificar se consulta existe e usuário tem permissão
    const consultation = await this.repository.findById(id);

    if (userType === 'PATIENT' && consultation.patientId !== userId) {
      throw new ForbiddenException('You can only cancel your own consultations');
    }

    if (userType === 'DOCTOR' && consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only cancel consultations you are assigned to');
    }

    // Verificar se consulta pode ser cancelada
    if (consultation.status === 'COMPLETED' || consultation.status === 'CANCELLED') {
      throw new ValidationException('Cannot cancel completed or already cancelled consultations');
    }

    const updatedConsultation = await this.repository.cancelConsultation(id);
    return ConsultationResponseDTO.fromEntity(updatedConsultation);
  }

  async findByPatient(patientId, filters, userId, userType) {
    // Verificar permissões
    if (userType === 'PATIENT' && patientId !== userId) {
      throw new ForbiddenException('You can only view your own consultations');
    }

    if (userType === 'DOCTOR') {
      // Médicos podem ver consultas de seus pacientes
      const consultation = await this.repository.findByDoctor(userId, { patientId });
      if (consultation.consultations.length === 0) {
        throw new ForbiddenException('You can only view consultations of your patients');
      }
    }

    const result = await this.repository.findByPatient(patientId, filters);
    return {
      consultations: ConsultationResponseDTO.fromEntities(result.consultations),
      pagination: result.pagination
    };
  }

  async findByDoctor(doctorId, filters, userId, userType) {
    // Verificar permissões
    if (userType === 'DOCTOR' && doctorId !== userId) {
      throw new ForbiddenException('You can only view your own consultations');
    }

    if (userType === 'PATIENT') {
      // Pacientes podem ver consultas com seus médicos
      const consultation = await this.repository.findByPatient(userId, { doctorId });
      if (consultation.consultations.length === 0) {
        throw new ForbiddenException('You can only view consultations with your doctors');
      }
    }

    const result = await this.repository.findByDoctor(doctorId, filters);
    return {
      consultations: ConsultationResponseDTO.fromEntities(result.consultations),
      pagination: result.pagination
    };
  }

  async getConsultationStats(userId, userType) {
    let doctorId = null;
    let patientId = null;

    if (userType === 'DOCTOR') {
      doctorId = userId;
    } else if (userType === 'PATIENT') {
      patientId = userId;
    }

    return await this.repository.getConsultationStats(doctorId, patientId);
  }

  async getUpcomingConsultations(userId, userType, limit = 5) {
    const consultations = await this.repository.getUpcomingConsultations(userId, userType, limit);
    return ConsultationResponseDTO.fromEntities(consultations);
  }

  async validate(data) {
    const createConsultationDTO = new CreateConsultationDTO(data);
    return createConsultationDTO.validate();
  }

  // Avaliar consulta
  async rateConsultation(id, rating, review, userId, userType) {
    // Verificar se consulta existe e usuário tem permissão
    const consultation = await this.repository.findById(id);

    if (userType === 'PATIENT' && consultation.patientId !== userId) {
      throw new ForbiddenException('You can only rate your own consultations');
    }

    if (userType === 'DOCTOR' && consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only rate consultations you are assigned to');
    }

    // Verificar se consulta foi finalizada
    if (consultation.status !== 'COMPLETED') {
      throw new ValidationException('Only completed consultations can be rated');
    }

    // Verificar se já foi avaliada
    const existingRating = await this.repository.findRatingByConsultation(id, userId);
    if (existingRating) {
      throw new ValidationException('Consultation already rated');
    }

    const result = await this.repository.rateConsultation(id, rating, review, userId);
    return result;
  }

  // Buscar médicos disponíveis
  async getAvailableDoctors(specialty, date, userId, userType) {
    const doctors = await this.userRepository.getAvailableDoctors(specialty, date);
    return doctors;
  }

  // Marcar como no-show
  async markAsNoShow(id, userId, userType) {
    // Verificar se consulta existe e usuário tem permissão
    const consultation = await this.repository.findById(id);

    if (userType === 'PATIENT' && consultation.patientId !== userId) {
      throw new ForbiddenException('You can only mark your own consultations as no-show');
    }

    if (userType === 'DOCTOR' && consultation.doctorId !== userId) {
      throw new ForbiddenException('You can only mark consultations you are assigned to as no-show');
    }

    // Verificar se consulta pode ser marcada como no-show
    if (consultation.status === 'COMPLETED' || consultation.status === 'CANCELLED') {
      throw new ValidationException('Cannot mark completed or cancelled consultations as no-show');
    }

    const result = await this.repository.markAsNoShow(id);
    return ConsultationResponseDTO.fromEntity(result);
  }

  // Reagendar consulta
  async rescheduleConsultation(id, newScheduledAt, userId, userType) {
    const consultation = await this.repository.rescheduleConsultation(id, newScheduledAt);
    return ConsultationResponseDTO.fromEntity(consultation);
  }

  // Consultas próximas do médico
  async getDoctorUpcomingConsultations(doctorId) {
    const consultations = await this.repository.getDoctorUpcomingConsultations(doctorId);
    return consultations.map(consultation => ConsultationResponseDTO.fromEntity(consultation));
  }

  // Consultas recentes do paciente
  async getPatientRecentConsultations(patientId) {
    const consultations = await this.repository.getPatientRecentConsultations(patientId);
    return consultations.map(consultation => ConsultationResponseDTO.fromEntity(consultation));
  }

  // Próximas consultas do paciente
  async getPatientUpcomingConsultations(patientId) {
    const consultations = await this.repository.getPatientUpcomingConsultations(patientId);
    return consultations.map(consultation => ConsultationResponseDTO.fromEntity(consultation));
  }
}

module.exports = ConsultationService;