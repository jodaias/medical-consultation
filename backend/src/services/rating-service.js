const RatingRepository = require('../repositories/rating-repository');
const ConsultationRepository = require('../repositories/consultation-repository');
const UserRepository = require('../repositories/user-repository');
const { CreateRatingDTO, UpdateRatingDTO, RatingResponseDTO } = require('../dto/rating-dto');
const { ValidationException, NotFoundException, ForbiddenException } = require('../exceptions/app-exception');

class RatingService {
  constructor() {
    this.ratingRepository = new RatingRepository();
    this.consultationRepository = new ConsultationRepository();
    this.userRepository = new UserRepository();
  }

  async create(ratingData, userId, userType) {
    try {
      // Validate input data
      const createDTO = new CreateRatingDTO(ratingData);
      const validationErrors = createDTO.validate();

      if (validationErrors.length > 0) {
        throw new ValidationException(validationErrors.join(', '));
      }

      // Check if consultation exists and user has permission
      const consultation = await this.consultationRepository.findById(ratingData.consultationId);

      if (!consultation) {
        throw new NotFoundException('Consultation not found');
      }

      // Only patients can create ratings
      if (userType !== 'PATIENT') {
        throw new ForbiddenException('Only patients can create ratings');
      }

      // Check if patient is the one who had the consultation
      if (consultation.patientId !== userId) {
        throw new ForbiddenException('You can only rate consultations you participated in');
      }

      // Check if consultation is completed
      if (consultation.status !== 'COMPLETED') {
        throw new ValidationException('Can only rate completed consultations');
      }

      // Check if rating already exists for this consultation
      const existingRatings = await this.ratingRepository.findByConsultation(ratingData.consultationId);
      const userRating = existingRatings.find(rating => rating.patientId === userId);

      if (userRating) {
        throw new ValidationException('You have already rated this consultation');
      }

      // Create rating
      const rating = await this.ratingRepository.create({
        ...createDTO.toEntity(),
        patientId: userId,
        doctorId: consultation.doctorId
      });

      return RatingResponseDTO.fromEntity(rating);
    } catch (error) {
      if (error instanceof ValidationException ||
          error instanceof NotFoundException ||
          error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error creating rating');
    }
  }

  async findById(id, userId, userType) {
    try {
      const rating = await this.ratingRepository.findById(id);

      // Check permissions
      if (userType === 'PATIENT' && rating.patientId !== userId) {
        throw new ForbiddenException('You can only view your own ratings');
      }

      if (userType === 'DOCTOR' && rating.doctorId !== userId) {
        throw new ForbiddenException('You can only view ratings for your consultations');
      }

      return RatingResponseDTO.fromEntity(rating);
    } catch (error) {
      if (error instanceof NotFoundException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error finding rating');
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

      const result = await this.ratingRepository.findAll(filters);

      return {
        ratings: RatingResponseDTO.fromEntityList(result.ratings),
        pagination: result.pagination
      };
    } catch (error) {
      throw new Error('Error finding ratings');
    }
  }

  async update(id, updateData, userId, userType) {
    try {
      // Validate input data
      const updateDTO = new UpdateRatingDTO(updateData);
      const validationErrors = updateDTO.validate();

      if (validationErrors.length > 0) {
        throw new ValidationException(validationErrors.join(', '));
      }

      // Check if rating exists and user has permission
      const existingRating = await this.ratingRepository.findById(id);

      if (userType === 'PATIENT' && existingRating.patientId !== userId) {
        throw new ForbiddenException('You can only update your own ratings');
      }

      if (userType === 'DOCTOR') {
        throw new ForbiddenException('Doctors cannot update ratings');
      }

      // Update rating
      const rating = await this.ratingRepository.update(id, updateDTO.toEntity());

      return RatingResponseDTO.fromEntity(rating);
    } catch (error) {
      if (error instanceof ValidationException ||
          error instanceof NotFoundException ||
          error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error updating rating');
    }
  }

  async delete(id, userId, userType) {
    try {
      // Check if rating exists and user has permission
      const rating = await this.ratingRepository.findById(id);

      if (userType === 'PATIENT' && rating.patientId !== userId) {
        throw new ForbiddenException('You can only delete your own ratings');
      }

      if (userType === 'DOCTOR') {
        throw new ForbiddenException('Doctors cannot delete ratings');
      }

      await this.ratingRepository.delete(id);
    } catch (error) {
      if (error instanceof NotFoundException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error deleting rating');
    }
  }

  async findByConsultation(consultationId, userId, userType) {
    try {
      // Check if consultation exists and user has permission
      const consultation = await this.consultationRepository.findById(consultationId);

      if (userType === 'DOCTOR' && consultation.doctorId !== userId) {
        throw new ForbiddenException('You can only view ratings for your consultations');
      }

      if (userType === 'PATIENT' && consultation.patientId !== userId) {
        throw new ForbiddenException('You can only view ratings for your consultations');
      }

      const ratings = await this.ratingRepository.findByConsultation(consultationId);

      return RatingResponseDTO.fromEntityList(ratings);
    } catch (error) {
      if (error instanceof NotFoundException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error finding ratings by consultation');
    }
  }

  async findByDoctor(doctorId, filters, userId, userType) {
    try {
      // Check permissions
      if (userType === 'DOCTOR' && doctorId !== userId) {
        throw new ForbiddenException('You can only view ratings for your consultations');
      }

      if (userType === 'PATIENT') {
        // Patients can only view ratings from doctors they had consultations with
        const consultation = await this.consultationRepository.findAll({
          doctorId,
          patientId: userId
        });

        if (consultation.consultations.length === 0) {
          throw new ForbiddenException('You can only view ratings from doctors you had consultations with');
        }
      }

      const result = await this.ratingRepository.findByDoctor(doctorId, filters);

      return {
        ratings: RatingResponseDTO.fromEntityList(result.ratings),
        pagination: result.pagination
      };
    } catch (error) {
      if (error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error finding ratings by doctor');
    }
  }

  async findByPatient(patientId, filters, userId, userType) {
    try {
      // Check permissions
      if (userType === 'PATIENT' && patientId !== userId) {
        throw new ForbiddenException('You can only view your own ratings');
      }

      if (userType === 'DOCTOR') {
        // Doctors can only view ratings from patients they had consultations with
        const consultation = await this.consultationRepository.findAll({
          doctorId: userId,
          patientId
        });

        if (consultation.consultations.length === 0) {
          throw new ForbiddenException('You can only view ratings from patients you had consultations with');
        }
      }

      const result = await this.ratingRepository.findByPatient(patientId, filters);

      return {
        ratings: RatingResponseDTO.fromEntityList(result.ratings),
        pagination: result.pagination
      };
    } catch (error) {
      if (error instanceof ForbiddenException) {
        throw error;
      }
      throw new Error('Error finding ratings by patient');
    }
  }

  async markAsHelpful(id, userId, userType) {
    try {
      // Check if rating exists
      const rating = await this.ratingRepository.findById(id);

      // Any authenticated user can mark ratings as helpful
      const updatedRating = await this.ratingRepository.markAsHelpful(id);

      return RatingResponseDTO.fromEntity(updatedRating);
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new Error('Error marking rating as helpful');
    }
  }

  async getRatingStats(userId, userType) {
    try {
      let doctorId = null;
      let patientId = null;

      if (userType === 'DOCTOR') {
        doctorId = userId;
      } else if (userType === 'PATIENT') {
        patientId = userId;
      }

      return await this.ratingRepository.getRatingStats(doctorId, patientId);
    } catch (error) {
      throw new Error('Error getting rating statistics');
    }
  }

  async validate(ratingData) {
    try {
      const createDTO = new CreateRatingDTO(ratingData);
      return createDTO.validate();
    } catch (error) {
      return ['Invalid rating data'];
    }
  }
}

module.exports = RatingService;