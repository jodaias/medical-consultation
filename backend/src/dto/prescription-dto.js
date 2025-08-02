/**
 * DTOs para transferência de dados de prescrições
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class CreatePrescriptionDTO {
  constructor(data) {
    this.consultationId = data.consultationId;
    this.medications = data.medications || [];
    this.diagnosis = data.diagnosis;
    this.instructions = data.instructions;
    this.validUntil = data.validUntil;
    this.isActive = data.isActive !== undefined ? data.isActive : true;
  }

  validate() {
    const errors = [];

    if (!this.consultationId) {
      errors.push('Consultation ID is required');
    }

    if (!this.diagnosis || this.diagnosis.trim().length < 3) {
      errors.push('Diagnosis must be at least 3 characters long');
    }

    if (this.medications && !Array.isArray(this.medications)) {
      errors.push('Medications must be an array');
    }

    if (this.medications && this.medications.length > 0) {
      for (let i = 0; i < this.medications.length; i++) {
        const med = this.medications[i];
        if (!med.name || !med.dosage || !med.frequency) {
          errors.push(`Medication ${i + 1} must have name, dosage, and frequency`);
        }
      }
    }

    if (this.validUntil && new Date(this.validUntil) <= new Date()) {
      errors.push('Valid until date must be in the future');
    }

    return errors;
  }

  toEntity() {
    return {
      consultationId: this.consultationId,
      medications: this.medications,
      diagnosis: this.diagnosis,
      instructions: this.instructions,
      validUntil: this.validUntil ? new Date(this.validUntil) : null,
      isActive: this.isActive
    };
  }
}

class UpdatePrescriptionDTO {
  constructor(data) {
    this.medications = data.medications;
    this.diagnosis = data.diagnosis;
    this.instructions = data.instructions;
    this.validUntil = data.validUntil;
    this.isActive = data.isActive;
  }

  validate() {
    const errors = [];

    if (this.diagnosis !== undefined && (!this.diagnosis || this.diagnosis.trim().length < 3)) {
      errors.push('Diagnosis must be at least 3 characters long');
    }

    if (this.medications !== undefined && !Array.isArray(this.medications)) {
      errors.push('Medications must be an array');
    }

    if (this.medications && this.medications.length > 0) {
      for (let i = 0; i < this.medications.length; i++) {
        const med = this.medications[i];
        if (!med.name || !med.dosage || !med.frequency) {
          errors.push(`Medication ${i + 1} must have name, dosage, and frequency`);
        }
      }
    }

    if (this.validUntil && new Date(this.validUntil) <= new Date()) {
      errors.push('Valid until date must be in the future');
    }

    return errors;
  }

  toEntity() {
    const entity = {};

    if (this.medications !== undefined) entity.medications = this.medications;
    if (this.diagnosis !== undefined) entity.diagnosis = this.diagnosis;
    if (this.instructions !== undefined) entity.instructions = this.instructions;
    if (this.validUntil !== undefined) entity.validUntil = this.validUntil ? new Date(this.validUntil) : null;
    if (this.isActive !== undefined) entity.isActive = this.isActive;

    return entity;
  }
}

class PrescriptionResponseDTO {
  constructor(prescription) {
    this.id = prescription.id;
    this.consultationId = prescription.consultationId;
    this.doctorId = prescription.doctorId;
    this.patientId = prescription.patientId;
    this.medications = prescription.medications;
    this.diagnosis = prescription.diagnosis;
    this.instructions = prescription.instructions;
    this.validUntil = prescription.validUntil;
    this.isActive = prescription.isActive;
    this.createdAt = prescription.createdAt;
    this.updatedAt = prescription.updatedAt;

    // Include related data if available
    if (prescription.consultation) {
      this.consultation = {
        id: prescription.consultation.id,
        startTime: prescription.consultation.startTime,
        endTime: prescription.consultation.endTime,
        status: prescription.consultation.status
      };
    }

    if (prescription.doctor) {
      this.doctor = {
        id: prescription.doctor.id,
        name: prescription.doctor.name,
        email: prescription.doctor.email,
        specialty: prescription.doctor.specialty
      };
    }

    if (prescription.patient) {
      this.patient = {
        id: prescription.patient.id,
        name: prescription.patient.name,
        email: prescription.patient.email
      };
    }
  }

  static fromEntity(prescription) {
    return new PrescriptionResponseDTO(prescription);
  }

  static fromEntityList(prescriptions) {
    return prescriptions.map(prescription => new PrescriptionResponseDTO(prescription));
  }
}

module.exports = {
  CreatePrescriptionDTO,
  UpdatePrescriptionDTO,
  PrescriptionResponseDTO
};