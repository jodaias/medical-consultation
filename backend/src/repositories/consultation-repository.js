const { PrismaClient } = require('@prisma/client');
const { NotFoundException, ConflictException } = require('../exceptions/app-exception');

/**
 * ConsultationRepository - Implementa o padrão Repository
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class ConsultationRepository {
  constructor() {
    this.prisma = new PrismaClient();
  }

  async create(consultationData) {
    try {
      const consultation = await this.prisma.consultation.create({
        data: consultationData,
        include: {
          patient: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          },
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              },
            }
          },
          messages: {
            orderBy: { createdAt: 'asc' }
          }
        }
      });
      return consultation;
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('Consultation already exists');
      }
      throw error;
    }
  }

  async findById(id) {
    const consultation = await this.prisma.consultation.findUnique({
      where: { id },
      include: {
        patient: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        },
        doctor: {
          select: {
            id: true,
            name: true,
            email: true,
            doctorProfile: {
              select: {
                specialty: true,
                crm: true
              }
            }
          }
        },
        messages: {
          orderBy: { createdAt: 'asc' }
        }
      }
    });

    if (!consultation) {
      throw new NotFoundException('Consultation not found');
    }

    return consultation;
  }

  async findAll(filters = {}) {
    const {
      patientId,
      doctorId,
      status,
      dateFrom,
      dateTo,
      page = 1,
      limit = 10,
      orderBy = 'scheduledAt',
      order = 'desc'
    } = filters;

    const skip = (page - 1) * limit;
    const where = {};

    if (patientId) {
      where.patientId = patientId;
    }

    if (doctorId) {
      where.doctorId = doctorId;
    }

    if (status) {
      where.status = status;
    }

    if (dateFrom || dateTo) {
      where.scheduledAt = {};
      if (dateFrom) {
        where.scheduledAt.gte = new Date(dateFrom);
      }
      if (dateTo) {
        where.scheduledAt.lte = new Date(dateTo);
      }
    }

    const [consultations, total] = await Promise.all([
      this.prisma.consultation.findMany({
        where,
        skip,
        take: limit,
        orderBy: { [orderBy]: order },
        include: {
          patient: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          },
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              }
            }
          },
          _count: {
            select: {
              messages: true
            }
          }
        }
      }),
      this.prisma.consultation.count({ where })
    ]);

    return {
      consultations,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    };
  }

  async update(id, data) {
    try {
      const consultation = await this.prisma.consultation.update({
        where: { id },
        data,
        include: {
          patient: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          },
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              }
            }
          },
          messages: {
            orderBy: { createdAt: 'asc' }
          }
        }
      });
      return consultation;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Consultation not found');
      }
      throw error;
    }
  }

  async delete(id) {
    try {
      await this.prisma.consultation.delete({
        where: { id }
      });
      return true;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Consultation not found');
      }
      throw error;
    }
  }

  async exists(id) {
    const consultation = await this.prisma.consultation.findUnique({
      where: { id },
      select: { id: true }
    });
    return !!consultation;
  }

  async findByPatient(patientId, filters = {}) {
    const {
      status,
      dateFrom,
      dateTo,
      page = 1,
      limit = 10
    } = filters;

    const skip = (page - 1) * limit;
    const where = { patientId };

    if (status) {
      where.status = status;
    }

    if (dateFrom || dateTo) {
      where.scheduledAt = {};
      if (dateFrom) {
        where.scheduledAt.gte = new Date(dateFrom);
      }
      if (dateTo) {
        where.scheduledAt.lte = new Date(dateTo);
      }
    }

    const [consultations, total] = await Promise.all([
      this.prisma.consultation.findMany({
        where,
        skip,
        take: limit,
        orderBy: { scheduledAt: 'desc' },
        include: {
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              }
            }
          },
          _count: {
            select: {
              messages: true
            }
          }
        }
      }),
      this.prisma.consultation.count({ where })
    ]);

    return {
      consultations,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    };
  }

  async findByDoctor(doctorId, filters = {}) {
    const {
      status,
      dateFrom,
      dateTo,
      page = 1,
      limit = 10
    } = filters;

    const skip = (page - 1) * limit;
    const where = { doctorId };

    if (status) {
      where.status = status;
    }

    if (dateFrom || dateTo) {
      where.scheduledAt = {};
      if (dateFrom) {
        where.scheduledAt.gte = new Date(dateFrom);
      }
      if (dateTo) {
        where.scheduledAt.lte = new Date(dateTo);
      }
    }

    const [consultations, total] = await Promise.all([
      this.prisma.consultation.findMany({
        where,
        skip,
        take: limit,
        orderBy: { scheduledAt: 'desc' },
        include: {
          patient: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          },
          _count: {
            select: {
              messages: true
            }
          }
        }
      }),
      this.prisma.consultation.count({ where })
    ]);

    return {
      consultations,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    };
  }

  async startConsultation(id) {
    return await this.prisma.consultation.update({
      where: { id },
      data: {
        status: 'IN_PROGRESS',
        startedAt: new Date()
      },
      include: {
        patient: true,
        doctor: true
      }
    });
  }

  async endConsultation(id) {
    return await this.prisma.consultation.update({
      where: { id },
      data: {
        status: 'COMPLETED',
        endedAt: new Date()
      },
      include: {
        patient: true,
        doctor: true
      }
    });
  }

  async cancelConsultation(id) {
    return await this.prisma.consultation.update({
      where: { id },
      data: {
        status: 'CANCELLED'
      },
      include: {
        patient: true,
        doctor: true
      }
    });
  }

  async getConsultationStats(doctorId = null, patientId = null) {
    const where = {};
    if (doctorId) where.doctorId = doctorId;
    if (patientId) where.patientId = patientId;

    const [
      total,
      scheduled,
      inProgress,
      completed,
      cancelled
    ] = await Promise.all([
      this.prisma.consultation.count({ where }),
      this.prisma.consultation.count({ where: { ...where, status: 'SCHEDULED' } }),
      this.prisma.consultation.count({ where: { ...where, status: 'IN_PROGRESS' } }),
      this.prisma.consultation.count({ where: { ...where, status: 'COMPLETED' } }),
      this.prisma.consultation.count({ where: { ...where, status: 'CANCELLED' } })
    ]);

    return {
      total,
      scheduled,
      inProgress,
      completed,
      cancelled,
      completionRate: total > 0 ? (completed / total) * 100 : 0
    };
  }

  async getUpcomingConsultations(userId, userType, limit = 5) {
    const where = {
      scheduledAt: {
        gte: new Date()
      },
      status: 'SCHEDULED'
    };

    if (userType === 'doctor') {
      where.doctorId = userId;
    } else {
      where.patientId = userId;
    }

    return await this.prisma.consultation.findMany({
      where,
      take: limit,
      orderBy: { scheduledAt: 'asc' },
      include: {
        patient: {
          select: {
            id: true,
            name: true,
            email: true
          }
        },
        doctor: {
          select: {
            id: true,
            name: true,
            email: true,
            doctorProfile: {
              select: {
                specialty: true,
                crm: true
              }
            }
          }
        }
      }
    });
  }

  // Avaliar consulta
  async rateConsultation(id, rating, review, userId) {
    // Criar avaliação
    const ratingRecord = await this.prisma.rating.create({
      data: {
        consultationId: id,
        raterId: userId,
        rating: rating,
        comment: review,
        type: 'CONSULTATION'
      }
    });

    // Atualizar consulta com a avaliação
    return await this.prisma.consultation.update({
      where: { id },
      data: {
        rating: rating,
        review: review
      },
      include: {
        patient: true,
        doctor: true
      }
    });
  }

  // Buscar avaliação existente
  async findRatingByConsultation(consultationId, userId) {
    return await this.prisma.rating.findFirst({
      where: {
        consultationId: consultationId,
        raterId: userId,
        type: 'CONSULTATION'
      }
    });
  }

  // Marcar como no-show
  async markAsNoShow(id) {
    return await this.prisma.consultation.update({
      where: { id },
      data: {
        status: 'NO_SHOW'
      },
      include: {
        patient: true,
        doctor: true
      }
    });
  }

  // Reagendar consulta
  async rescheduleConsultation(id, newScheduledAt) {
    const consultation = await this.prisma.consultation.update({
      where: { id },
      data: { scheduledAt: newScheduledAt },
              include: {
          doctor: {
            select: {
              id: true,
              name: true,
              email: true,
              doctorProfile: {
                select: {
                  specialty: true,
                  crm: true
                }
              }
            }
          },
          patient: {
            select: {
              id: true,
              name: true,
              email: true,
              phone: true
            }
          }
        }
    });
    return consultation;
  }

  // Consultas próximas do médico
  async getDoctorUpcomingConsultations(doctorId) {
    const consultations = await this.prisma.consultation.findMany({
      where: {
        doctorId: doctorId,
        status: 'SCHEDULED',
        scheduledAt: { gte: new Date() }
      },
      orderBy: { scheduledAt: 'asc' },
      take: 10,
      include: {
        patient: {
          select: {
            id: true,
            name: true,
            email: true,
            phone: true
          }
        }
      }
    });
    return consultations;
  }

  // Consultas recentes do paciente
  async getPatientRecentConsultations(patientId) {
    const consultations = await this.prisma.consultation.findMany({
      where: {
        patientId: patientId,
        status: { in: ['COMPLETED', 'CANCELLED'] }
      },
      orderBy: { scheduledAt: 'desc' },
      take: 10,
      include: {
        doctor: {
          select: {
            id: true,
            name: true,
            email: true,
            doctorProfile: {
              select: {
                specialty: true,
                crm: true
              }
            }
          }
        }
      }
    });
    return consultations;
  }

  // Próximas consultas do paciente
  async getPatientUpcomingConsultations(patientId) {
    const consultations = await this.prisma.consultation.findMany({
      where: {
        patientId: patientId,
        status: 'SCHEDULED',
        scheduledAt: { gte: new Date() }
      },
      orderBy: { scheduledAt: 'asc' },
      take: 10,
      include: {
        doctor: {
          select: {
            id: true,
            name: true,
            email: true,
            doctorProfile: {
              select: {
                specialty: true,
                crm: true
              }
            }
          }
        }
      }
    });
    return consultations;
  }
}

module.exports = ConsultationRepository;