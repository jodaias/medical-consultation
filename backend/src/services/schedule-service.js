const ScheduleRepository = require('../repositories/schedule-repository');
const UserRepository = require('../repositories/user-repository');
const { CreateScheduleDTO, UpdateScheduleDTO, ScheduleResponseDTO } = require('../dto/schedule-dto');
const { ValidationException, NotFoundException, ForbiddenException } = require('../exceptions/app-exception');

/**
 * ScheduleService - Lógica de negócio para agendamentos
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class ScheduleService {
  constructor() {
    this.repository = new ScheduleRepository();
    this.userRepository = new UserRepository();
  }

  async create(scheduleData, userId) {
    // Validação com DTO
    const createScheduleDTO = new CreateScheduleDTO(scheduleData);
    const validationErrors = createScheduleDTO.validate();

    if (validationErrors.length > 0) {
      throw new ValidationException(validationErrors.join(', '));
    }

    // Verificar se usuário é médico
    const user = await this.userRepository.findById(userId);
    if (user.userType !== 'DOCTOR') {
      throw new ForbiddenException('Only doctors can create schedules');
    }

    // Verificar se médico existe e é o mesmo usuário
    if (scheduleData.doctorId !== userId) {
      throw new ForbiddenException('You can only create schedules for yourself');
    }

    // Verificar se já existe horário para este dia
    const existingSchedule = await this.repository.findByDoctor(userId, {
      dayOfWeek: scheduleData.dayOfWeek
    });

    if (existingSchedule.schedules.length > 0) {
      throw new ValidationException('Schedule already exists for this day');
    }

    // Preparar dados para criação
    const scheduleEntity = createScheduleDTO.toEntity();

    // Criar agendamento
    const schedule = await this.repository.create(scheduleEntity);

    return ScheduleResponseDTO.fromEntity(schedule);
  }

  async findById(id, userId, userType) {
    const schedule = await this.repository.findById(id);

    // Verificar permissões
    if (userType === 'DOCTOR' && schedule.doctorId !== userId) {
      throw new ForbiddenException('You can only view your own schedules');
    }

    return ScheduleResponseDTO.fromEntity(schedule);
  }

  async findAll(filters, userId, userType) {
    // Aplicar filtros baseados no tipo de usuário
    if (userType === 'DOCTOR') {
      filters.doctorId = userId;
    }

    const result = await this.repository.findAll(filters);
    return {
      schedules: ScheduleResponseDTO.fromEntities(result.schedules),
      pagination: result.pagination
    };
  }

  async update(id, scheduleData, userId, userType) {
    // Validação com DTO
    const updateScheduleDTO = new UpdateScheduleDTO(scheduleData);
    const validationErrors = updateScheduleDTO.validate();

    if (validationErrors.length > 0) {
      throw new ValidationException(validationErrors.join(', '));
    }

    // Verificar se agendamento existe e usuário tem permissão
    const existingSchedule = await this.repository.findById(id);

    if (userType === 'DOCTOR' && existingSchedule.doctorId !== userId) {
      throw new ForbiddenException('You can only update your own schedules');
    }

    // Preparar dados para atualização
    const scheduleEntity = updateScheduleDTO.toEntity();

    // Atualizar agendamento
    const schedule = await this.repository.update(id, scheduleEntity);
    return ScheduleResponseDTO.fromEntity(schedule);
  }

  async delete(id, userId, userType) {
    // Verificar se agendamento existe e usuário tem permissão
    const schedule = await this.repository.findById(id);

    if (userType === 'DOCTOR' && schedule.doctorId !== userId) {
      throw new ForbiddenException('You can only delete your own schedules');
    }

    return await this.repository.delete(id);
  }

  async findByDoctor(doctorId, filters, userId, userType) {
    // Verificar permissões
    if (userType === 'DOCTOR' && doctorId !== userId) {
      throw new ForbiddenException('You can only view your own schedules');
    }

    const result = await this.repository.findByDoctor(doctorId, filters);
    return {
      schedules: ScheduleResponseDTO.fromEntities(result.schedules),
      pagination: result.pagination
    };
  }

  async findAvailableSlots(doctorId, date, userId, userType) {
    // Verificar se médico existe
    const doctor = await this.userRepository.findById(doctorId);
    if (doctor.userType !== 'DOCTOR') {
      throw new ValidationException('Invalid doctor ID');
    }

    // Verificar se data é no futuro
    const now = new Date();
    if (date <= now) {
      throw new ValidationException('Date must be in the future');
    }

    const slots = await this.repository.findAvailableSlots(doctorId, date);
    return slots;
  }

  async checkAvailability(doctorId, startTime, endTime, userId, userType) {
    // Verificar se médico existe
    const doctor = await this.userRepository.findById(doctorId);
    if (doctor.userType !== 'DOCTOR') {
      throw new ValidationException('Invalid doctor ID');
    }

    // Verificar se horário é no futuro
    const now = new Date();
    if (startTime <= now) {
      throw new ValidationException('Start time must be in the future');
    }

    // Verificar se endTime é depois de startTime
    if (endTime <= startTime) {
      throw new ValidationException('End time must be after start time');
    }

    return await this.repository.checkAvailability(doctorId, startTime, endTime);
  }

  async getScheduleStats(userId, userType) {
    if (userType !== 'DOCTOR') {
      throw new ForbiddenException('Only doctors can view schedule statistics');
    }

    return await this.repository.getScheduleStats(userId);
  }

  async getWeeklySchedule(doctorId, userId, userType) {
    // Verificar permissões
    if (userType === 'DOCTOR' && doctorId !== userId) {
      throw new ForbiddenException('You can only view your own weekly schedule');
    }

    const weeklySchedule = await this.repository.getWeeklySchedule(doctorId);

    // Converter para DTOs
    const result = {};
    for (const [day, schedule] of Object.entries(weeklySchedule)) {
      result[day] = schedule ? ScheduleResponseDTO.fromEntity(schedule) : null;
    }

    return result;
  }

  async bulkUpdate(doctorId, schedules, userId, userType) {
    // Verificar se usuário é médico
    if (userType !== 'DOCTOR') {
      throw new ForbiddenException('Only doctors can update schedules');
    }

    // Verificar se médico é o mesmo usuário
    if (doctorId !== userId) {
      throw new ForbiddenException('You can only update your own schedules');
    }

    // Validar todos os horários
    for (const scheduleData of schedules) {
      const createScheduleDTO = new CreateScheduleDTO(scheduleData);
      const validationErrors = createScheduleDTO.validate();

      if (validationErrors.length > 0) {
        throw new ValidationException(`Schedule validation error: ${validationErrors.join(', ')}`);
      }
    }

    // Atualizar em lote
    const updatedSchedules = await this.repository.bulkUpdate(doctorId, schedules);
    return ScheduleResponseDTO.fromEntities(updatedSchedules);
  }

  async validate(data) {
    const createScheduleDTO = new CreateScheduleDTO(data);
    return createScheduleDTO.validate();
  }

  async confirmSchedule(id, userId, userType) {
    // Verificar se agendamento existe
    const schedule = await this.repository.findById(id);
    if (!schedule) {
      throw new NotFoundException('Schedule not found');
    }

    // Verificar permissões
    if (userType === 'DOCTOR' && schedule.doctorId !== userId) {
      throw new ForbiddenException('You can only confirm your own schedules');
    }

    // Verificar se já está confirmado
    if (schedule.isConfirmed) {
      throw new ValidationException('Schedule is already confirmed');
    }

    // Confirmar agendamento
    const confirmedSchedule = await this.repository.confirmSchedule(id);
    return ScheduleResponseDTO.fromEntity(confirmedSchedule);
  }
}

module.exports = ScheduleService;