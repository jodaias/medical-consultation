const PrescriptionRepository = require('../repositories/prescription-repository');
const ConsultationRepository = require('../repositories/consultation-repository');
const UserRepository = require('../repositories/user-repository');
const { CreatePrescriptionDTO, UpdatePrescriptionDTO, PrescriptionResponseDTO } = require('../dto/prescription-dto');
const { ValidationException, NotFoundException, ForbiddenException } = require('../exceptions/app-exception');

class PrescriptionService {
  constructor() {
    this.prescriptionRepository = new PrescriptionRepository();
    this.consultationRepository = new ConsultationRepository();
    this.userRepository = new UserRepository();
  }

  async create(prescriptionData, userId, userType) {
    try {
      // Validate input data
      const createDTO = new CreatePrescriptionDTO(prescriptionData);
      const validationErrors = createDTO.validate();

      if (validationErrors.length > 0) {
        throw new ValidationException(validationErrors.join(', '));
      }

      // Check if consultation exists and user has permission
      const consultation = await this.consultationRepository.findById(prescriptionData.consultationId);

      if (!consultation) {
        throw new NotFoundException('Consultation not found');
      }

      // Only doctors can create prescriptions
      if (userType !== 'DOCTOR') {
        throw new ForbiddenException('Only doctors can create prescriptions');
      }

      // Check if doctor is the one who conducted the consultation
      if (consultation.doctorId !== userId) {
        throw new ForbiddenException('You can only create prescriptions for your own consultations');
      }

      // Check if consultation is completed
      if (consultation.status !== 'COMPLETED') {
        throw new ValidationException('Can only create prescriptions for completed consultations');
      }

      // Check if prescription already exists for this consultation
      const existingPrescriptions = await this.prescriptionRepository.findByConsultation(prescriptionData.consultationId);
      if (existingPrescriptions.length > 0) {
        throw new ValidationException('Prescription already exists for this consultation');
      }

      // Create prescription
      const prescription = await this.prescriptionRepository.create({
        ...createDTO.toEntity(),
        doctorId: userId,
        patientId: consultation.patientId
      });

      return PrescriptionResponseDTO.fromEntity(prescription);
    } catch (error) {
      if (error instanceof ValidationException ||
          error instanceof NotFoundException ||
          error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error creating prescription');
    }
  }

  async findById(id, userId, userType) {
    try {
      const prescription = await this.prescriptionRepository.findById(id);

      // Check permissions
      if (userType === 'DOCTOR' && prescription.doctorId !== userId) {
        throw new ForbiddenException('You can only view your own prescriptions');
      }

      if (userType === 'PATIENT' && prescription.patientId !== userId) {
        throw new ForbiddenException('You can only view prescriptions for your consultations');
      }

      return PrescriptionResponseDTO.fromEntity(prescription);
    } catch (error) {
      if (error instanceof NotFoundException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error finding prescription');
    }
  }

  async findAll(filters, userId, userType) {
    try {
      // Apply user-specific filters
      if (userType === 'DOCTOR') {
        filters.doctorId = userId;
      } else if (userType === 'PATIENT') {
        filters.patientId = userId;
      }

      const result = await this.prescriptionRepository.findAll(filters);

      return {
        prescriptions: PrescriptionResponseDTO.fromEntityList(result.prescriptions),
        pagination: result.pagination
      };
    } catch (error) {
      throw new Error('Error finding prescriptions');
    }
  }

  async update(id, updateData, userId, userType) {
    try {
      // Validate input data
      const updateDTO = new UpdatePrescriptionDTO(updateData);
      const validationErrors = updateDTO.validate();

      if (validationErrors.length > 0) {
        throw new ValidationException(validationErrors.join(', '));
      }

      // Check if prescription exists and user has permission
      const existingPrescription = await this.prescriptionRepository.findById(id);

      if (userType === 'DOCTOR' && existingPrescription.doctorId !== userId) {
        throw new ForbiddenException('You can only update your own prescriptions');
      }

      if (userType === 'PATIENT') {
        throw new ForbiddenException('Patients cannot update prescriptions');
      }

      // Update prescription
      const prescription = await this.prescriptionRepository.update(id, updateDTO.toEntity());

      return PrescriptionResponseDTO.fromEntity(prescription);
    } catch (error) {
      if (error instanceof ValidationException ||
          error instanceof NotFoundException ||
          error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error updating prescription');
    }
  }

  async delete(id, userId, userType) {
    try {
      // Check if prescription exists and user has permission
      const prescription = await this.prescriptionRepository.findById(id);

      if (userType === 'DOCTOR' && prescription.doctorId !== userId) {
        throw new ForbiddenException('You can only delete your own prescriptions');
      }

      if (userType === 'PATIENT') {
        throw new ForbiddenException('Patients cannot delete prescriptions');
      }

      await this.prescriptionRepository.delete(id);
    } catch (error) {
      if (error instanceof NotFoundException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error deleting prescription');
    }
  }

  async findByConsultation(consultationId, userId, userType) {
    try {
      // Check if consultation exists and user has permission
      const consultation = await this.consultationRepository.findById(consultationId);

      if (userType === 'DOCTOR' && consultation.doctorId !== userId) {
        throw new ForbiddenException('You can only view prescriptions for your consultations');
      }

      if (userType === 'PATIENT' && consultation.patientId !== userId) {
        throw new ForbiddenException('You can only view prescriptions for your consultations');
      }

      const prescriptions = await this.prescriptionRepository.findByConsultation(consultationId);

      return PrescriptionResponseDTO.fromEntityList(prescriptions);
    } catch (error) {
      if (error instanceof NotFoundException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error finding prescriptions by consultation');
    }
  }

  async findByDoctor(doctorId, filters, userId, userType) {
    try {
      // Check permissions
      if (userType === 'DOCTOR' && doctorId !== userId) {
        throw new ForbiddenException('You can only view your own prescriptions');
      }

      if (userType === 'PATIENT') {
        // Patients can only view prescriptions from doctors they had consultations with
        const consultation = await this.consultationRepository.findAll({
          doctorId,
          patientId: userId
        });

        if (consultation.consultations.length === 0) {
          throw new ForbiddenException('You can only view prescriptions from doctors you had consultations with');
        }
      }

      const result = await this.prescriptionRepository.findByDoctor(doctorId, filters);

      return {
        prescriptions: PrescriptionResponseDTO.fromEntityList(result.prescriptions),
        pagination: result.pagination
      };
    } catch (error) {
      if (error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error finding prescriptions by doctor');
    }
  }

  async findByPatient(patientId, filters, userId, userType) {
    try {
      // Check permissions
      if (userType === 'PATIENT' && patientId !== userId) {
        throw new ForbiddenException('You can only view your own prescriptions');
      }

      if (userType === 'DOCTOR') {
        // Doctors can only view prescriptions for patients they had consultations with
        const consultation = await this.consultationRepository.findAll({
          doctorId: userId,
          patientId
        });

        if (consultation.consultations.length === 0) {
          throw new ForbiddenException('You can only view prescriptions for patients you had consultations with');
        }
      }

      const result = await this.prescriptionRepository.findByPatient(patientId, filters);

      return {
        prescriptions: PrescriptionResponseDTO.fromEntityList(result.prescriptions),
        pagination: result.pagination
      };
    } catch (error) {
      if (error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error finding prescriptions by patient');
    }
  }

  async getPrescriptionStats(userId, userType) {
    try {
      let doctorId = null;
      let patientId = null;

      if (userType === 'DOCTOR') {
        doctorId = userId;
      } else if (userType === 'PATIENT') {
        patientId = userId;
      }

      return await this.prescriptionRepository.getPrescriptionStats(doctorId, patientId);
    } catch (error) {
      throw new Error('Error getting prescription statistics');
    }
  }

  async deactivateExpiredPrescriptions(userId, userType) {
    try {
      // Only doctors can deactivate expired prescriptions
      if (userType !== 'DOCTOR') {
        throw new ForbiddenException('Only doctors can deactivate expired prescriptions');
      }

      return await this.prescriptionRepository.deactivateExpiredPrescriptions();
    } catch (error) {
      if (error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error deactivating expired prescriptions');
    }
  }

  async validate(prescriptionData) {
    try {
      const createDTO = new CreatePrescriptionDTO(prescriptionData);
      return createDTO.validate();
    } catch (error) {
      return ['Invalid prescription data'];
    }
  }

  // Prescrições recentes do paciente
  async getPatientRecentPrescriptions(patientId) {
    const prescriptions = await this.prescriptionRepository.getPatientRecentPrescriptions(patientId);
    return prescriptions.map(prescription => PrescriptionResponseDTO.fromEntity(prescription));
  }
}

module.exports = PrescriptionService;