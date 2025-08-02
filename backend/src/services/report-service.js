const ReportRepository = require('../repositories/report-repository');
const { CreateReportDTO, ReportResponseDTO } = require('../dto/report-dto');
const { ValidationException, NotFoundException } = require('../exceptions/app-exception');

/**
 * ReportService - Implementa a lógica de negócio para relatórios
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class ReportService {
  constructor() {
    this.reportRepository = new ReportRepository();
  }

  async create(data) {
    const dto = new CreateReportDTO(data);
    const errors = dto.validate();

    if (errors.length > 0) {
      throw new ValidationException(errors.join(', '));
    }

    const reportData = dto.toEntity();
    const report = await this.reportRepository.create(reportData);

    return ReportResponseDTO.fromEntity(report);
  }

  async findById(id) {
    const report = await this.reportRepository.findById(id);
    return ReportResponseDTO.fromEntity(report);
  }

  async findAll(filters = {}) {
    const result = await this.reportRepository.findAll(filters);
    return {
      reports: ReportResponseDTO.fromEntityList(result.reports),
      pagination: result.pagination
    };
  }

  async update(id, data) {
    const report = await this.reportRepository.update(id, data);
    return ReportResponseDTO.fromEntity(report);
  }

  async delete(id) {
    return await this.reportRepository.delete(id);
  }

  async exists(id) {
    return await this.reportRepository.exists(id);
  }

  async generateConsultationReport(userId, startDate, endDate) {
    const stats = await this.reportRepository.getConsultationStats(userId, startDate, endDate);

    return {
      type: 'CONSULTATION',
      period: { startDate, endDate },
      stats: {
        total: stats.reduce((sum, stat) => sum + stat._count.id, 0),
        byStatus: stats.map(stat => ({
          status: stat.status,
          count: stat._count.id
        }))
      }
    };
  }

  async generateFinancialReport(userId, startDate, endDate) {
    const stats = await this.reportRepository.getFinancialStats(userId, startDate, endDate);

    return {
      type: 'FINANCIAL',
      period: { startDate, endDate },
      stats: {
        totalConsultations: stats.totalConsultations,
        totalRevenue: stats.totalRevenue,
        averageRating: stats.averageRating,
        completedConsultations: stats.completedConsultations,
        averageRevenuePerConsultation: stats.totalConsultations > 0 ?
          stats.totalRevenue / stats.totalConsultations : 0
      }
    };
  }

  async generatePatientReport(userId, startDate, endDate) {
    const consultations = await this.reportRepository.getPatientStats(userId, startDate, endDate);

    return {
      type: 'PATIENT',
      period: { startDate, endDate },
      stats: {
        totalConsultations: consultations.length,
        uniqueDoctors: [...new Set(consultations.map(c => c.doctorId))].length,
        totalPrescriptions: consultations.reduce((sum, c) => sum + c.prescriptions.length, 0),
        consultations: consultations.map(c => ({
          id: c.id,
          doctorName: c.doctor.name,
          scheduledAt: c.scheduledAt,
          status: c.status,
          prescriptionsCount: c.prescriptions.length
        }))
      }
    };
  }

  async generateRatingReport(userId, startDate, endDate) {
    const stats = await this.reportRepository.getRatingStats(userId, startDate, endDate);

    const totalRatings = stats.reduce((sum, stat) => sum + stat._count.id, 0);
    const averageRating = stats.reduce((sum, stat) => sum + (stat.rating * stat._count.id), 0) / totalRatings;

    return {
      type: 'RATING',
      period: { startDate, endDate },
      stats: {
        totalRatings,
        averageRating: totalRatings > 0 ? averageRating : 0,
        ratingDistribution: stats.map(stat => ({
          rating: stat.rating,
          count: stat._count.id,
          percentage: totalRatings > 0 ? (stat._count.id / totalRatings) * 100 : 0
        }))
      }
    };
  }

  async generatePrescriptionReport(userId, startDate, endDate) {
    const prescriptions = await this.reportRepository.getPrescriptionStats(userId, startDate, endDate);

    return {
      type: 'PRESCRIPTION',
      period: { startDate, endDate },
      stats: {
        totalPrescriptions: prescriptions.length,
        uniquePatients: [...new Set(prescriptions.map(p => p.patientId))].length,
        prescriptions: prescriptions.map(p => ({
          id: p.id,
          patientName: p.patient.name,
          consultationDate: p.consultation.scheduledAt,
          medicationsCount: Array.isArray(p.medications) ? p.medications.length : 0
        }))
      }
    };
  }

  async generateDashboardStats(userId, period = 'month') {
    const now = new Date();
    let startDate, endDate;

    switch (period) {
      case 'week':
        startDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        break;
      case 'month':
        startDate = new Date(now.getFullYear(), now.getMonth(), 1);
        break;
      case 'quarter':
        startDate = new Date(now.getFullYear(), Math.floor(now.getMonth() / 3) * 3, 1);
        break;
      case 'year':
        startDate = new Date(now.getFullYear(), 0, 1);
        break;
      default:
        startDate = new Date(now.getFullYear(), now.getMonth(), 1);
    }

    endDate = now;

    const [consultationStats, financialStats, ratingStats] = await Promise.all([
      this.generateConsultationReport(userId, startDate, endDate),
      this.generateFinancialReport(userId, startDate, endDate),
      this.generateRatingReport(userId, startDate, endDate)
    ]);

    return {
      period,
      consultationStats,
      financialStats,
      ratingStats,
      generatedAt: new Date()
    };
  }

  async exportReport(reportId, format = 'PDF') {
    const report = await this.findById(reportId);

    // Simular geração de arquivo
    const fileUrl = `/reports/${reportId}.${format.toLowerCase()}`;

    // Atualizar status do relatório
    await this.update(reportId, {
      status: 'COMPLETED',
      fileUrl
    });

    return {
      reportId,
      fileUrl,
      format,
      downloadUrl: `${process.env.API_URL}${fileUrl}`
    };
  }
}

module.exports = ReportService;