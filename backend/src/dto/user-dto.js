/**
 * DTOs para transferência de dados de usuário
 * Seguindo o princípio de responsabilidade única (SRP)
 */

class CreateUserDTO {
  constructor(data) {
    this.name = data.name;
    this.email = data.email;
    this.phone = data.phone;
    this.password = data.password;
    this.userType = data.userType;
    this.specialty = data.specialty;
    this.crm = data.crm;
    this.bio = data.bio;
    this.hourlyRate = data.hourlyRate;
  }

  validate() {
    const errors = [];

    // Validação de nome
    if (!this.name || this.name.trim().length < 2) {
      errors.push('Name must be at least 2 characters long');
    } else if (this.name.trim().length > 100) {
      errors.push('Name must be less than 100 characters');
    } else if (!/^[a-zA-ZÀ-ÿ\s]+$/.test(this.name.trim())) {
      errors.push('Name can only contain letters and spaces');
    }

    // Validação de email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!this.email || !emailRegex.test(this.email)) {
      errors.push('Valid email is required');
    } else if (this.email.length > 254) {
      errors.push('Email is too long');
    }

    // Validação de telefone
    const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
    if (!this.phone || !phoneRegex.test(this.phone.replace(/\D/g, ''))) {
      errors.push('Valid phone number is required');
    }

    // Validação de senha (muito mais rigorosa)
    if (!this.password) {
      errors.push('Password is required');
    } else {
      if (this.password.length < 8) {
        errors.push('Password must be at least 8 characters long');
      }
      if (!/[A-Z]/.test(this.password)) {
        errors.push('Password must contain at least one uppercase letter');
      }
      if (!/[a-z]/.test(this.password)) {
        errors.push('Password must contain at least one lowercase letter');
      }
      if (!/\d/.test(this.password)) {
        errors.push('Password must contain at least one number');
      }
      if (!/[!@#$%^&*(),.?":{}|<>]/.test(this.password)) {
        errors.push('Password must contain at least one special character');
      }
      if (this.password.length > 128) {
        errors.push('Password is too long');
      }
    }

    if (!this.userType || !['patient', 'doctor'].includes(this.userType)) {
      errors.push('User type must be either patient or doctor');
    }

    if (this.userType === 'doctor') {
      if (!this.specialty) {
        errors.push('Specialty is required for doctors');
      }
      if (!this.crm) {
        errors.push('CRM is required for doctors');
      }
    }

    return errors;
  }

  toEntity() {
    return {
      name: this.name.trim(),
      email: this.email.toLowerCase().trim(),
      phone: this.phone.replace(/\D/g, ''),
      password: this.password,
      userType: this.userType,
      specialty: this.specialty,
      crm: this.crm,
      bio: this.bio,
      hourlyRate: this.hourlyRate
    };
  }
}

class UpdateUserDTO {
  constructor(data) {
    this.name = data.name;
    this.phone = data.phone;
    this.specialty = data.specialty;
    this.crm = data.crm;
    this.bio = data.bio;
    this.hourlyRate = data.hourlyRate;
    this.avatar = data.avatar;
  }

  validate() {
    const errors = [];

    if (this.name && this.name.trim().length < 2) {
      errors.push('Name must be at least 2 characters long');
    }

    if (this.phone && this.phone.length < 10) {
      errors.push('Valid phone number is required');
    }

    return errors;
  }

  toEntity() {
    const entity = {};

    if (this.name) entity.name = this.name.trim();
    if (this.phone) entity.phone = this.phone.replace(/\D/g, '');
    if (this.specialty) entity.specialty = this.specialty;
    if (this.crm) entity.crm = this.crm;
    if (this.bio) entity.bio = this.bio;
    if (this.hourlyRate) entity.hourlyRate = this.hourlyRate;
    if (this.avatar) entity.avatar = this.avatar;

    return entity;
  }
}

class UserResponseDTO {
  constructor(user) {
    this.id = user.id;
    this.name = user.name;
    this.email = user.email;
    this.phone = user.phone;
    this.userType = user.userType;
    this.specialty = user.specialty;
    this.crm = user.crm;
    this.bio = user.bio;
    this.hourlyRate = user.hourlyRate;
    this.avatar = user.avatar;
    this.isVerified = user.isVerified;
    this.createdAt = user.createdAt;
    this.updatedAt = user.updatedAt;
  }

  static fromEntity(user) {
    return new UserResponseDTO(user);
  }

  static fromEntities(users) {
    return users.map(user => UserResponseDTO.fromEntity(user));
  }
}

module.exports = {
  CreateUserDTO,
  UpdateUserDTO,
  UserResponseDTO
};