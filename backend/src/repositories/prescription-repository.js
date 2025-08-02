const { PrismaClient } = require('@prisma/client');
const { NotFoundException, ConflictException } = require('../exceptions/app-exception');

class PrescriptionRepository {
  constructor() {
    this.prisma = new PrismaClient();
  }

  async create(data) {
    try {
      return await this.prisma.prescription.create({
        data: {
          consultationId: data.consultationId,
          medications: data.medications,
          diagnosis: data.diagnosis,
          instructions: data.instructions,
          validUntil: data.validUntil,
          isActive: data.isActive
        },
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        }
      });
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('Prescription already exists for this consultation');
      }
      if (error.code === 'P2003') {
        throw new ConflictException('Invalid consultation ID');
      }
      throw error;
    }
  }

  async findById(id) {
    try {
      const prescription = await this.prisma.prescription.findUnique({
        where: { id },
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        }
      });

      if (!prescription) {
        throw new NotFoundException('Prescription not found');
      }

      return prescription;
    } catch (error) {
      if (error instanceof NotFoundException) {
        throw error;
      }
      throw new Error('Error finding prescription');
    }
  }

  async findAll(filters = {}) {
    try {
      const where = {};

      if (filters.doctorId) {
        where.doctorId = filters.doctorId;
      }

      if (filters.patientId) {
        where.patientId = filters.patientId;
      }

      if (filters.consultationId) {
        where.consultationId = filters.consultationId;
      }

      if (filters.isActive !== undefined) {
        where.isActive = filters.isActive;
      }

      if (filters.validUntil) {
        where.validUntil = {
          gte: new Date(filters.validUntil)
        };
      }

      const page = filters.page || 1;
      const limit = filters.limit || 10;
      const skip = (page - 1) * limit;

      const [prescriptions, total] = await Promise.all([
        this.prisma.prescription.findMany({
          where,
          include: {
            consultation: {
              include: {
                doctor: true,
                patient: true
              }
            },
            doctor: true,
            patient: true
          },
          orderBy: { createdAt: 'desc' },
          skip,
          take: limit
        }),
        this.prisma.prescription.count({ where })
      ]);

      return {
        prescriptions,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      throw new Error('Error finding prescriptions');
    }
  }

  async update(id, data) {
    try {
      const prescription = await this.prisma.prescription.update({
        where: { id },
        data,
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        }
      });

      return prescription;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Prescription not found');
      }
      if (error.code === 'P2002') {
        throw new ConflictException('Prescription already exists for this consultation');
      }
      throw new Error('Error updating prescription');
    }
  }

  async delete(id) {
    try {
      await this.prisma.prescription.delete({
        where: { id }
      });
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Prescription not found');
      }
      throw new Error('Error deleting prescription');
    }
  }

  async exists(id) {
    try {
      const prescription = await this.prisma.prescription.findUnique({
        where: { id },
        select: { id: true }
      });
      return !!prescription;
    } catch (error) {
      throw new Error('Error checking prescription existence');
    }
  }

  async findByConsultation(consultationId) {
    try {
      return await this.prisma.prescription.findMany({
        where: { consultationId },
        include: {
          consultation: {
            include: {
              doctor: true,
              patient: true
            }
          },
          doctor: true,
          patient: true
        },
        orderBy: { createdAt: 'desc' }
      });
    } catch (error) {
      throw new Error('Error finding prescriptions by consultation');
    }
  }

  async findByDoctor(doctorId, filters = {}) {
    try {
      const where = { doctorId };

      if (filters.isActive !== undefined) {
        where.isActive = filters.isActive;
      }

      if (filters.validUntil) {
        where.validUntil = {
          gte: new Date(filters.validUntil)
        };
      }

      const page = filters.page || 1;
      const limit = filters.limit || 10;
      const skip = (page - 1) * limit;

      const [prescriptions, total] = await Promise.all([
        this.prisma.prescription.findMany({
          where,
          include: {
            consultation: {
              include: {
                doctor: true,
                patient: true
              }
            },
            doctor: true,
            patient: true
          },
          orderBy: { createdAt: 'desc' },
          skip,
          take: limit
        }),
        this.prisma.prescription.count({ where })
      ]);

      return {
        prescriptions,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      throw new Error('Error finding prescriptions by doctor');
    }
  }

  async findByPatient(patientId, filters = {}) {
    try {
      const where = { patientId };

      if (filters.isActive !== undefined) {
        where.isActive = filters.isActive;
      }

      if (filters.validUntil) {
        where.validUntil = {
          gte: new Date(filters.validUntil)
        };
      }

      const page = filters.page || 1;
      const limit = filters.limit || 10;
      const skip = (page - 1) * limit;

      const [prescriptions, total] = await Promise.all([
        this.prisma.prescription.findMany({
          where,
          include: {
            consultation: {
              include: {
                doctor: true,
                patient: true
              }
            },
            doctor: true,
            patient: true
          },
          orderBy: { createdAt: 'desc' },
          skip,
          take: limit
        }),
        this.prisma.prescription.count({ where })
      ]);

      return {
        prescriptions,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      throw new Error('Error finding prescriptions by patient');
    }
  }

  async getPrescriptionStats(doctorId = null, patientId = null) {
    try {
      const where = {};

      if (doctorId) {
        where.doctorId = doctorId;
      }

      if (patientId) {
        where.patientId = patientId;
      }

      const [
        totalPrescriptions,
        activePrescriptions,
        expiredPrescriptions,
        prescriptionsThisMonth,
        prescriptionsLastMonth
      ] = await Promise.all([
        this.prisma.prescription.count({ where }),
        this.prisma.prescription.count({ where: { ...where, isActive: true } }),
        this.prisma.prescription.count({
          where: {
            ...where,
            validUntil: {
              lt: new Date()
            }
          }
        }),
        this.prisma.prescription.count({
          where: {
            ...where,
            createdAt: {
              gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
            }
          }
        }),
        this.prisma.prescription.count({
          where: {
            ...where,
            createdAt: {
              gte: new Date(new Date().getFullYear(), new Date().getMonth() - 1, 1),
              lt: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
            }
          }
        })
      ]);

      return {
        totalPrescriptions,
        activePrescriptions,
        expiredPrescriptions,
        prescriptionsThisMonth,
        prescriptionsLastMonth,
        growthRate: prescriptionsLastMonth > 0
          ? ((prescriptionsThisMonth - prescriptionsLastMonth) / prescriptionsLastMonth) * 100
          : 0
      };
    } catch (error) {
      throw new Error('Error getting prescription statistics');
    }
  }

  async deactivateExpiredPrescriptions() {
    try {
      const result = await this.prisma.prescription.updateMany({
        where: {
          validUntil: {
            lt: new Date()
          },
          isActive: true
        },
        data: {
          isActive: false
        }
      });

      return result.count;
    } catch (error) {
      throw new Error('Error deactivating expired prescriptions');
    }
  }
}

module.exports = PrescriptionRepository;