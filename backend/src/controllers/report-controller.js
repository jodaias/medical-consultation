const ReportService = require('../services/report-service');
const BaseController = require('../interfaces/base-controller');

/**
 * ReportController - Implementa o padrão Controller
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class ReportController extends BaseController {
  constructor() {
    const reportService = new ReportService();
    super(reportService);
    this.reportService = reportService;
  }

  async create(req, res) {
    return this.handleAsync(async () => {
      const reportData = {
        ...req.body,
        userId: req.user.id
      };

      const report = await this.reportService.create(reportData);
      return this.sendSuccess(res, report, 'Report created successfully', 201);
    });
  }

  async findById(req, res) {
    return this.handleAsync(async () => {
      const { id } = req.params;
      const report = await this.reportService.findById(id);
      return this.sendSuccess(res, report, 'Report retrieved successfully');
    });
  }

  async findAll(req, res) {
    return this.handleAsync(async () => {
      const filters = {
        userId: req.user.id,
        ...req.query
      };

      const result = await this.reportService.findAll(filters);
      return this.sendSuccess(res, result, 'Reports retrieved successfully');
    });
  }

  async update(req, res) {
    return this.handleAsync(async () => {
      const { id } = req.params;
      const report = await this.reportService.update(id, req.body);
      return this.sendSuccess(res, report, 'Report updated successfully');
    });
  }

  async delete(req, res) {
    return this.handleAsync(async () => {
      const { id } = req.params;
      await this.reportService.delete(id);
      return this.sendSuccess(res, null, 'Report deleted successfully');
    });
  }

  async generateConsultationReport(req, res) {
    return this.handleAsync(async () => {
      const { startDate, endDate } = req.query;
      const report = await this.reportService.generateConsultationReport(
        req.user.id,
        new Date(startDate),
        new Date(endDate)
      );
      return this.sendSuccess(res, report, 'Consultation report generated successfully');
    });
  }

  async generateFinancialReport(req, res) {
    return this.handleAsync(async () => {
      const { startDate, endDate } = req.query;
      const report = await this.reportService.generateFinancialReport(
        req.user.id,
        new Date(startDate),
        new Date(endDate)
      );
      return this.sendSuccess(res, report, 'Financial report generated successfully');
    });
  }

  async generatePatientReport(req, res) {
    return this.handleAsync(async () => {
      const { startDate, endDate } = req.query;
      const report = await this.reportService.generatePatientReport(
        req.user.id,
        new Date(startDate),
        new Date(endDate)
      );
      return this.sendSuccess(res, report, 'Patient report generated successfully');
    });
  }

  async generateRatingReport(req, res) {
    return this.handleAsync(async () => {
      const { startDate, endDate } = req.query;
      const report = await this.reportService.generateRatingReport(
        req.user.id,
        new Date(startDate),
        new Date(endDate)
      );
      return this.sendSuccess(res, report, 'Rating report generated successfully');
    });
  }

  async generatePrescriptionReport(req, res) {
    return this.handleAsync(async () => {
      const { startDate, endDate } = req.query;
      const report = await this.reportService.generatePrescriptionReport(
        req.user.id,
        new Date(startDate),
        new Date(endDate)
      );
      return this.sendSuccess(res, report, 'Prescription report generated successfully');
    });
  }

  async generateDashboardStats(req, res) {
    return this.handleAsync(async () => {
      const { period = 'month' } = req.query;
      const stats = await this.reportService.generateDashboardStats(req.user.id, period);
      return this.sendSuccess(res, stats, 'Dashboard stats generated successfully');
    });
  }

  async exportReport(req, res) {
    return this.handleAsync(async () => {
      const { id } = req.params;
      const { format = 'PDF' } = req.query;
      const result = await this.reportService.exportReport(id, format);
      return this.sendSuccess(res, result, 'Report exported successfully');
    });
  }
}

module.exports = ReportController;