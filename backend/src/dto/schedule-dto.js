/**
 * DTOs para transferência de dados de agendamentos
 * Seguindo o princípio de responsabilidade única (SRP)
 */

class CreateScheduleDTO {
  constructor(data) {
    this.doctorId = data.doctorId;
    this.dayOfWeek = data.dayOfWeek;
    this.startTime = data.startTime;
    this.endTime = data.endTime;
    this.isAvailable = data.isAvailable;
    this.maxPatients = data.maxPatients;
    this.consultationDuration = data.consultationDuration;
  }

  validate() {
    const errors = [];

    // Validação de médico
    if (!this.doctorId || typeof this.doctorId !== 'string') {
      errors.push('Valid doctor ID is required');
    }

    // Validação de dia da semana
    if (!this.dayOfWeek || ![0, 1, 2, 3, 4, 5, 6].includes(this.dayOfWeek)) {
      errors.push('Valid day of week is required (0-6, where 0 is Sunday)');
    }

    // Validação de horário de início
    if (!this.startTime) {
      errors.push('Start time is required');
    } else {
      const timeRegex = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;
      if (!timeRegex.test(this.startTime)) {
        errors.push('Start time must be in HH:MM format');
      }
    }

    // Validação de horário de fim
    if (!this.endTime) {
      errors.push('End time is required');
    } else {
      const timeRegex = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;
      if (!timeRegex.test(this.endTime)) {
        errors.push('End time must be in HH:MM format');
      }
    }

    // Validação de horários
    if (this.startTime && this.endTime) {
      const start = new Date(`2000-01-01T${this.startTime}:00`);
      const end = new Date(`2000-01-01T${this.endTime}:00`);

      if (start >= end) {
        errors.push('End time must be after start time');
      }
    }

    // Validação de disponibilidade
    if (this.isAvailable !== undefined && typeof this.isAvailable !== 'boolean') {
      errors.push('isAvailable must be a boolean');
    }

    // Validação de pacientes máximos
    if (this.maxPatients !== undefined) {
      if (!Number.isInteger(this.maxPatients) || this.maxPatients < 1 || this.maxPatients > 50) {
        errors.push('Max patients must be between 1 and 50');
      }
    }

    // Validação de duração da consulta
    if (this.consultationDuration !== undefined) {
      if (!Number.isInteger(this.consultationDuration) || this.consultationDuration < 15 || this.consultationDuration > 120) {
        errors.push('Consultation duration must be between 15 and 120 minutes');
      }
    }

    return errors;
  }

  toEntity() {
    return {
      doctorId: this.doctorId,
      dayOfWeek: parseInt(this.dayOfWeek),
      startTime: this.startTime,
      endTime: this.endTime,
      isAvailable: this.isAvailable !== undefined ? this.isAvailable : true,
      maxPatients: this.maxPatients ? parseInt(this.maxPatients) : 10,
      consultationDuration: this.consultationDuration ? parseInt(this.consultationDuration) : 30
    };
  }
}

class UpdateScheduleDTO {
  constructor(data) {
    this.dayOfWeek = data.dayOfWeek;
    this.startTime = data.startTime;
    this.endTime = data.endTime;
    this.isAvailable = data.isAvailable;
    this.maxPatients = data.maxPatients;
    this.consultationDuration = data.consultationDuration;
  }

  validate() {
    const errors = [];

    // Validação de dia da semana
    if (this.dayOfWeek !== undefined && ![0, 1, 2, 3, 4, 5, 6].includes(this.dayOfWeek)) {
      errors.push('Valid day of week is required (0-6, where 0 is Sunday)');
    }

    // Validação de horário de início
    if (this.startTime) {
      const timeRegex = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;
      if (!timeRegex.test(this.startTime)) {
        errors.push('Start time must be in HH:MM format');
      }
    }

    // Validação de horário de fim
    if (this.endTime) {
      const timeRegex = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;
      if (!timeRegex.test(this.endTime)) {
        errors.push('End time must be in HH:MM format');
      }
    }

    // Validação de horários
    if (this.startTime && this.endTime) {
      const start = new Date(`2000-01-01T${this.startTime}:00`);
      const end = new Date(`2000-01-01T${this.endTime}:00`);

      if (start >= end) {
        errors.push('End time must be after start time');
      }
    }

    // Validação de disponibilidade
    if (this.isAvailable !== undefined && typeof this.isAvailable !== 'boolean') {
      errors.push('isAvailable must be a boolean');
    }

    // Validação de pacientes máximos
    if (this.maxPatients !== undefined) {
      if (!Number.isInteger(this.maxPatients) || this.maxPatients < 1 || this.maxPatients > 50) {
        errors.push('Max patients must be between 1 and 50');
      }
    }

    // Validação de duração da consulta
    if (this.consultationDuration !== undefined) {
      if (!Number.isInteger(this.consultationDuration) || this.consultationDuration < 15 || this.consultationDuration > 120) {
        errors.push('Consultation duration must be between 15 and 120 minutes');
      }
    }

    return errors;
  }

  toEntity() {
    const entity = {};

    if (this.dayOfWeek !== undefined) entity.dayOfWeek = parseInt(this.dayOfWeek);
    if (this.startTime) entity.startTime = this.startTime;
    if (this.endTime) entity.endTime = this.endTime;
    if (this.isAvailable !== undefined) entity.isAvailable = this.isAvailable;
    if (this.maxPatients !== undefined) entity.maxPatients = parseInt(this.maxPatients);
    if (this.consultationDuration !== undefined) entity.consultationDuration = parseInt(this.consultationDuration);

    return entity;
  }
}

class ScheduleResponseDTO {
  constructor(schedule) {
    this.id = schedule.id;
    this.doctorId = schedule.doctorId;
    this.dayOfWeek = schedule.dayOfWeek;
    this.startTime = schedule.startTime;
    this.endTime = schedule.endTime;
    this.isAvailable = schedule.isAvailable;
    this.maxPatients = schedule.maxPatients;
    this.consultationDuration = schedule.consultationDuration;
    this.createdAt = schedule.createdAt;
    this.updatedAt = schedule.updatedAt;

    // Relacionamentos
    this.doctor = schedule.doctor ? {
      id: schedule.doctor.id,
      name: schedule.doctor.name,
      email: schedule.doctor.email,
      specialty: schedule.doctor.doctorProfile.specialty,
      crm: schedule.doctor.doctorProfile.crm
    } : null;

    // Estatísticas
    this.dayName = this.getDayName(schedule.dayOfWeek);
    this.duration = this.calculateDuration(schedule.startTime, schedule.endTime);
  }

  getDayName(dayOfWeek) {
    const days = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
    return days[dayOfWeek];
  }

  calculateDuration(startTime, endTime) {
    if (!startTime || !endTime) return null;

    const start = new Date(`2000-01-01T${startTime}:00`);
    const end = new Date(`2000-01-01T${endTime}:00`);

    return Math.round((end - start) / (1000 * 60)); // em minutos
  }

  static fromEntity(schedule) {
    return new ScheduleResponseDTO(schedule);
  }

  static fromEntities(schedules) {
    return schedules.map(schedule => ScheduleResponseDTO.fromEntity(schedule));
  }
}

module.exports = {
  CreateScheduleDTO,
  UpdateScheduleDTO,
  ScheduleResponseDTO
};