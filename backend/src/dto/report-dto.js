/**
 * DTOs para transferência de dados de relatórios
 * Seguindo o princípio de responsabilidade única (SRP)
 */
class CreateReportDTO {
  constructor(data) {
    this.reportType = data.reportType; // CONSULTATION, FINANCIAL, PATIENT, RATING, PRESCRIPTION
    this.startDate = data.startDate;
    this.endDate = data.endDate;
    this.filters = data.filters || {};
    this.format = data.format || 'PDF'; // PDF, CSV, EXCEL
    this.userId = data.userId;
  }

  validate() {
    const errors = [];

    if (!this.reportType) {
      errors.push('Report type is required');
    }

    if (!['CONSULTATION', 'FINANCIAL', 'PATIENT', 'RATING', 'PRESCRIPTION'].includes(this.reportType)) {
      errors.push('Invalid report type');
    }

    if (!this.startDate) {
      errors.push('Start date is required');
    }

    if (!this.endDate) {
      errors.push('End date is required');
    }

    if (new Date(this.startDate) > new Date(this.endDate)) {
      errors.push('Start date must be before end date');
    }

    if (!['PDF', 'CSV', 'EXCEL'].includes(this.format)) {
      errors.push('Invalid format');
    }

    return errors;
  }

  toEntity() {
    return {
      reportType: this.reportType,
      startDate: new Date(this.startDate),
      endDate: new Date(this.endDate),
      filters: this.filters,
      format: this.format,
      userId: this.userId
    };
  }
}

class ReportResponseDTO {
  constructor(report) {
    this.id = report.id;
    this.reportType = report.reportType;
    this.startDate = report.startDate;
    this.endDate = report.endDate;
    this.filters = report.filters;
    this.format = report.format;
    this.status = report.status;
    this.fileUrl = report.fileUrl;
    this.createdAt = report.createdAt;
    this.updatedAt = report.updatedAt;

    if (report.user) {
      this.user = {
        id: report.user.id,
        name: report.user.name,
        email: report.user.email
      };
    }
  }

  static fromEntity(report) {
    return new ReportResponseDTO(report);
  }

  static fromEntityList(reports) {
    return reports.map(report => new ReportResponseDTO(report));
  }
}

module.exports = {
  CreateReportDTO,
  ReportResponseDTO
};