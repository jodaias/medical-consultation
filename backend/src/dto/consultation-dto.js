/**
 * DTOs para transferência de dados de consultas médicas
 * Seguindo o princípio de responsabilidade única (SRP)
 */

class CreateConsultationDTO {
  constructor(data) {
    this.patientId = data.patientId;
    this.doctorId = data.doctorId;
    this.scheduledAt = data.scheduledAt;
    this.notes = data.notes;
    this.diagnosis = data.diagnosis;
    this.prescription = data.prescription;
  }

  validate() {
    const errors = [];

    // Validação de IDs
    if (!this.patientId || typeof this.patientId !== 'string') {
      errors.push('Valid patient ID is required');
    }

    if (!this.doctorId || typeof this.doctorId !== 'string') {
      errors.push('Valid doctor ID is required');
    }

    // Validação de data
    if (!this.scheduledAt) {
      errors.push('Scheduled date is required');
    } else {
      const scheduledDate = new Date(this.scheduledAt);
      const now = new Date();

      if (isNaN(scheduledDate.getTime())) {
        errors.push('Invalid scheduled date format');
      } else if (scheduledDate <= now) {
        errors.push('Scheduled date must be in the future');
      }
    }

    // Validação de notas
    if (this.notes && this.notes.length > 1000) {
      errors.push('Notes cannot exceed 1000 characters');
    }

    // Validação de diagnóstico
    if (this.diagnosis && this.diagnosis.length > 500) {
      errors.push('Diagnosis cannot exceed 500 characters');
    }

    // Validação de prescrição
    if (this.prescription && this.prescription.length > 1000) {
      errors.push('Prescription cannot exceed 1000 characters');
    }

    return errors;
  }

  toEntity() {
    return {
      patientId: this.patientId,
      doctorId: this.doctorId,
      scheduledAt: new Date(this.scheduledAt),
      notes: this.notes?.trim(),
      diagnosis: this.diagnosis?.trim(),
      prescription: this.prescription?.trim()
    };
  }
}

class UpdateConsultationDTO {
  constructor(data) {
    this.scheduledAt = data.scheduledAt;
    this.notes = data.notes;
    this.diagnosis = data.diagnosis;
    this.prescription = data.prescription;
    this.status = data.status;
  }

  validate() {
    const errors = [];

    // Validação de data (se fornecida)
    if (this.scheduledAt) {
      const scheduledDate = new Date(this.scheduledAt);
      if (isNaN(scheduledDate.getTime())) {
        errors.push('Invalid scheduled date format');
      }
    }

    // Validação de status
    if (this.status && !['SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'].includes(this.status)) {
      errors.push('Invalid consultation status');
    }

    // Validação de notas
    if (this.notes && this.notes.length > 1000) {
      errors.push('Notes cannot exceed 1000 characters');
    }

    // Validação de diagnóstico
    if (this.diagnosis && this.diagnosis.length > 500) {
      errors.push('Diagnosis cannot exceed 500 characters');
    }

    // Validação de prescrição
    if (this.prescription && this.prescription.length > 1000) {
      errors.push('Prescription cannot exceed 1000 characters');
    }

    return errors;
  }

  toEntity() {
    const entity = {};

    if (this.scheduledAt) entity.scheduledAt = new Date(this.scheduledAt);
    if (this.notes !== undefined) entity.notes = this.notes?.trim();
    if (this.diagnosis !== undefined) entity.diagnosis = this.diagnosis?.trim();
    if (this.prescription !== undefined) entity.prescription = this.prescription?.trim();
    if (this.status) entity.status = this.status;

    return entity;
  }
}

class ConsultationResponseDTO {
  constructor(consultation) {
    this.id = consultation.id;
    this.patientId = consultation.patientId;
    this.doctorId = consultation.doctorId;
    this.status = consultation.status;
    this.scheduledAt = consultation.scheduledAt;
    this.startedAt = consultation.startedAt;
    this.endedAt = consultation.endedAt;
    this.notes = consultation.notes;
    this.diagnosis = consultation.diagnosis;
    this.prescription = consultation.prescription;
    this.createdAt = consultation.createdAt;
    this.updatedAt = consultation.updatedAt;

    // Relacionamentos
    this.patient = consultation.patient ? {
      id: consultation.patient.id,
      name: consultation.patient.name,
      email: consultation.patient.email,
      phone: consultation.patient.phone
    } : null;

    this.doctor = consultation.doctor ? {
      id: consultation.doctor.id,
      name: consultation.doctor.name,
      email: consultation.doctor.email,
      specialty: consultation.doctor.specialty,
      crm: consultation.doctor.crm
    } : null;

    // Estatísticas
    this.duration = consultation.startedAt && consultation.endedAt
      ? Math.round((new Date(consultation.endedAt) - new Date(consultation.startedAt)) / 1000 / 60)
      : null;
  }

  static fromEntity(consultation) {
    return new ConsultationResponseDTO(consultation);
  }

  static fromEntities(consultations) {
    return consultations.map(consultation => ConsultationResponseDTO.fromEntity(consultation));
  }
}

module.exports = {
  CreateConsultationDTO,
  UpdateConsultationDTO,
  ConsultationResponseDTO
};