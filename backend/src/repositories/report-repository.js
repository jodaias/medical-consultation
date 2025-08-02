const { PrismaClient } = require('@prisma/client');
const { NotFoundException, ConflictException } = require('../exceptions/app-exception');

/**
 * ReportRepository - Implementa o padrão Repository
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class ReportRepository {
  constructor() {
    this.prisma = new PrismaClient();
  }

  async create(reportData) {
    try {
      const report = await this.prisma.report.create({
        data: reportData,
        include: {
          user: true
        }
      });
      return report;
    } catch (error) {
      if (error.code === 'P2002') {
        throw new ConflictException('Report already exists');
      }
      throw error;
    }
  }

  async findById(id) {
    const report = await this.prisma.report.findUnique({
      where: { id },
      include: {
        user: true
      }
    });

    if (!report) {
      throw new NotFoundException('Report not found');
    }

    return report;
  }

  async findAll(filters = {}) {
    const {
      userId,
      reportType,
      status,
      page = 1,
      limit = 10,
      orderBy = 'createdAt',
      order = 'desc'
    } = filters;

    const skip = (page - 1) * limit;
    const where = {};

    if (userId) {
      where.userId = userId;
    }

    if (reportType) {
      where.reportType = reportType;
    }

    if (status) {
      where.status = status;
    }

    const [reports, total] = await Promise.all([
      this.prisma.report.findMany({
        where,
        skip,
        take: limit,
        orderBy: { [orderBy]: order },
        include: {
          user: true
        }
      }),
      this.prisma.report.count({ where })
    ]);

    return {
      reports,
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
      const report = await this.prisma.report.update({
        where: { id },
        data,
        include: {
          user: true
        }
      });
      return report;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Report not found');
      }
      throw error;
    }
  }

  async delete(id) {
    try {
      await this.prisma.report.delete({
        where: { id }
      });
      return true;
    } catch (error) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Report not found');
      }
      throw error;
    }
  }

  async exists(id) {
    const report = await this.prisma.report.findUnique({
      where: { id },
      select: { id: true }
    });
    return !!report;
  }

  async getConsultationStats(userId, startDate, endDate) {
    return await this.prisma.consultation.groupBy({
      by: ['status'],
      where: {
        OR: [
          { patientId: userId },
          { doctorId: userId }
        ],
        scheduledAt: {
          gte: startDate,
          lte: endDate
        }
      },
      _count: {
        id: true
      }
    });
  }

  async getFinancialStats(userId, startDate, endDate) {
    // Para médicos - estatísticas financeiras
    const consultations = await this.prisma.consultation.findMany({
      where: {
        doctorId: userId,
        scheduledAt: {
          gte: startDate,
          lte: endDate
        },
        status: 'COMPLETED'
      },
      include: {
        patient: true
      }
    });

    return {
      totalConsultations: consultations.length,
      totalRevenue: consultations.length * 150, // Valor fake por consulta
      averageRating: 4.5, // Rating fake
      completedConsultations: consultations.filter(c => c.status === 'COMPLETED').length
    };
  }

  async getPatientStats(userId, startDate, endDate) {
    return await this.prisma.consultation.findMany({
      where: {
        patientId: userId,
        scheduledAt: {
          gte: startDate,
          lte: endDate
        }
      },
      include: {
        doctor: true,
        prescriptions: true
      }
    });
  }

  async getRatingStats(userId, startDate, endDate) {
    return await this.prisma.rating.groupBy({
      by: ['rating'],
      where: {
        doctorId: userId,
        createdAt: {
          gte: startDate,
          lte: endDate
        }
      },
      _count: {
        id: true
      },
      _avg: {
        rating: true
      }
    });
  }

  async getPrescriptionStats(userId, startDate, endDate) {
    return await this.prisma.prescription.findMany({
      where: {
        doctorId: userId,
        createdAt: {
          gte: startDate,
          lte: endDate
        }
      },
      include: {
        patient: true,
        consultation: true
      }
    });
  }
}

module.exports = ReportRepository;