/**
 * DTOs para transferência de dados de avaliações
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class CreateRatingDTO {
  constructor(data) {
    this.consultationId = data.consultationId;
    this.rating = data.rating;
    this.comment = data.comment;
    this.ratingType = data.ratingType || 'CONSULTATION'; // CONSULTATION, DOCTOR, SERVICE
    this.isAnonymous = data.isAnonymous !== undefined ? data.isAnonymous : false;
  }

  validate() {
    const errors = [];

    if (!this.consultationId) {
      errors.push('Consultation ID is required');
    }

    if (!this.rating || this.rating < 1 || this.rating > 5) {
      errors.push('Rating must be between 1 and 5');
    }

    if (this.comment && this.comment.length > 500) {
      errors.push('Comment must be less than 500 characters');
    }

    if (this.ratingType && !['CONSULTATION', 'DOCTOR', 'SERVICE'].includes(this.ratingType)) {
      errors.push('Rating type must be CONSULTATION, DOCTOR, or SERVICE');
    }

    return errors;
  }

  toEntity() {
    return {
      consultationId: this.consultationId,
      rating: this.rating,
      comment: this.comment,
      ratingType: this.ratingType,
      isAnonymous: this.isAnonymous
    };
  }
}

class UpdateRatingDTO {
  constructor(data) {
    this.rating = data.rating;
    this.comment = data.comment;
    this.ratingType = data.ratingType;
    this.isAnonymous = data.isAnonymous;
  }

  validate() {
    const errors = [];

    if (this.rating !== undefined && (this.rating < 1 || this.rating > 5)) {
      errors.push('Rating must be between 1 and 5');
    }

    if (this.comment !== undefined && this.comment.length > 500) {
      errors.push('Comment must be less than 500 characters');
    }

    if (this.ratingType && !['CONSULTATION', 'DOCTOR', 'SERVICE'].includes(this.ratingType)) {
      errors.push('Rating type must be CONSULTATION, DOCTOR, or SERVICE');
    }

    return errors;
  }

  toEntity() {
    const entity = {};

    if (this.rating !== undefined) entity.rating = this.rating;
    if (this.comment !== undefined) entity.comment = this.comment;
    if (this.ratingType !== undefined) entity.ratingType = this.ratingType;
    if (this.isAnonymous !== undefined) entity.isAnonymous = this.isAnonymous;

    return entity;
  }
}

class RatingResponseDTO {
  constructor(rating) {
    this.id = rating.id;
    this.consultationId = rating.consultationId;
    this.patientId = rating.patientId;
    this.doctorId = rating.doctorId;
    this.rating = rating.rating;
    this.comment = rating.comment;
    this.ratingType = rating.ratingType;
    this.isAnonymous = rating.isAnonymous;
    this.isHelpful = rating.isHelpful;
    this.helpfulCount = rating.helpfulCount;
    this.createdAt = rating.createdAt;
    this.updatedAt = rating.updatedAt;

    // Include related data if available
    if (rating.consultation) {
      this.consultation = {
        id: rating.consultation.id,
        startTime: rating.consultation.startTime,
        endTime: rating.consultation.endTime,
        status: rating.consultation.status
      };
    }

    if (rating.doctor && !rating.isAnonymous) {
      this.doctor = {
        id: rating.doctor.id,
        name: rating.doctor.name,
        email: rating.doctor.email,
        specialty: rating.doctor.specialty
      };
    }

    if (rating.patient && !rating.isAnonymous) {
      this.patient = {
        id: rating.patient.id,
        name: rating.patient.name,
        email: rating.patient.email
      };
    }
  }

  static fromEntity(rating) {
    return new RatingResponseDTO(rating);
  }

  static fromEntityList(ratings) {
    return ratings.map(rating => new RatingResponseDTO(rating));
  }
}

module.exports = {
  CreateRatingDTO,
  UpdateRatingDTO,
  RatingResponseDTO
};