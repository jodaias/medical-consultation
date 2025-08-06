import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/custom_dio/rest.dart';

@injectable
class ReportService {
  final Rest _rest;

  ReportService(this._rest);

  // Dashboard do médico
  Future<RestResult<Map<String, dynamic>>> getDoctorDashboard({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _rest.getModel<Map<String, dynamic>>(
      '/reports/doctor/dashboard',
      (data) => data as Map<String, dynamic>,
      query: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );
  }

  // Relatório de consultas
  Future<RestResult<Map<String, dynamic>>> getConsultationsReport({
    required DateTime startDate,
    required DateTime endDate,
    String? status,
    String? specialty,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      if (status != null) 'status': status,
      if (specialty != null) 'specialty': specialty,
    };

    return await _rest.getModel<Map<String, dynamic>>(
      '/reports/consultations',
      (data) => data as Map<String, dynamic>,
      query: queryParams,
    );
  }

  // Relatório financeiro
  Future<RestResult<Map<String, dynamic>>> getFinancialReport({
    required DateTime startDate,
    required DateTime endDate,
    String? paymentStatus,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      if (paymentStatus != null) 'paymentStatus': paymentStatus,
    };

    return await _rest.getModel<Map<String, dynamic>>(
      '/reports/financial',
      (data) => data as Map<String, dynamic>,
      query: queryParams,
    );
  }

  // Relatório de pacientes
  Future<RestResult<Map<String, dynamic>>> getPatientsReport({
    required DateTime startDate,
    required DateTime endDate,
    String? ageGroup,
    String? gender,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      if (ageGroup != null) 'ageGroup': ageGroup,
      if (gender != null) 'gender': gender,
    };

    return await _rest.getModel<Map<String, dynamic>>(
      '/reports/patients',
      (data) => data as Map<String, dynamic>,
      query: queryParams,
    );
  }

  // Relatório de avaliações
  Future<RestResult<Map<String, dynamic>>> getRatingsReport({
    required DateTime startDate,
    required DateTime endDate,
    double? minRating,
    double? maxRating,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      if (minRating != null) 'minRating': minRating,
      if (maxRating != null) 'maxRating': maxRating,
    };

    return await _rest.getModel<Map<String, dynamic>>(
      '/reports/ratings',
      (data) => data as Map<String, dynamic>,
      query: queryParams,
    );
  }

  // Relatório de prescrições
  Future<RestResult<Map<String, dynamic>>> getPrescriptionsReport({
    required DateTime startDate,
    required DateTime endDate,
    String? medicationType,
  }) async {
    final queryParams = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      if (medicationType != null) 'medicationType': medicationType,
    };

    return await _rest.getModel<Map<String, dynamic>>(
      '/reports/prescriptions',
      (data) => data as Map<String, dynamic>,
      query: queryParams,
    );
  }

  // Estatísticas gerais
  Future<RestResult<Map<String, dynamic>>> getGeneralStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await _rest.getModel<Map<String, dynamic>>(
      '/reports/stats',
      (data) => data as Map<String, dynamic>,
      query: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );
  }

  // Exportar relatório em PDF
  Future<RestResult<Map<String, dynamic>>> exportReportToPDF({
    required String reportType,
    required Map<String, dynamic> reportData,
    String? fileName,
  }) async {
    return await _rest.postModel<Map<String, dynamic>>(
      '/reports/export-pdf',
      {
        'reportType': reportType,
        'reportData': reportData,
        'fileName':
            fileName ?? 'relatorio_${DateTime.now().millisecondsSinceEpoch}',
      },
      parse: (data) => data as Map<String, dynamic>,
    );
  }

  // Exportar relatório em Excel
  Future<RestResult<Map<String, dynamic>>> exportReportToExcel({
    required String reportType,
    required Map<String, dynamic> reportData,
    String? fileName,
  }) async {
    return await _rest.postModel<Map<String, dynamic>>(
      '/reports/export-excel',
      {
        'reportType': reportType,
        'reportData': reportData,
        'fileName':
            fileName ?? 'relatorio_${DateTime.now().millisecondsSinceEpoch}',
      },
      parse: (data) => data as Map<String, dynamic>,
    );
  }

  // Agendar relatório recorrente
  Future<RestResult<void>> scheduleRecurringReport({
    required String reportType,
    required String frequency, // daily, weekly, monthly
    required List<String> recipients,
    required Map<String, dynamic> parameters,
  }) async {
    return await _rest.postModel<void>(
      '/reports/schedule',
      {
        'reportType': reportType,
        'frequency': frequency,
        'recipients': recipients,
        'parameters': parameters,
      },
    );
  }

  // Calcular métricas de performance
  Map<String, dynamic> calculatePerformanceMetrics({
    required int totalConsultations,
    required int completedConsultations,
    required int cancelledConsultations,
    required double averageRating,
    required double totalRevenue,
    required int totalPatients,
  }) {
    final completionRate = totalConsultations > 0
        ? (completedConsultations / totalConsultations) * 100
        : 0.0;

    final cancellationRate = totalConsultations > 0
        ? (cancelledConsultations / totalConsultations) * 100
        : 0.0;

    final averageRevenuePerConsultation = completedConsultations > 0
        ? totalRevenue / completedConsultations
        : 0.0;

    return {
      'completionRate': completionRate,
      'cancellationRate': cancellationRate,
      'averageRating': averageRating,
      'totalRevenue': totalRevenue,
      'averageRevenuePerConsultation': averageRevenuePerConsultation,
      'totalPatients': totalPatients,
      'consultationsPerPatient':
          totalPatients > 0 ? totalConsultations / totalPatients : 0.0,
    };
  }

  // Formatar dados para gráficos
  List<Map<String, dynamic>> formatChartData(
      List<Map<String, dynamic>> rawData, String xAxis, String yAxis) {
    return rawData
        .map((item) => {
              'x': item[xAxis],
              'y': item[yAxis],
            })
        .toList();
  }

  // Gerar cores para gráficos
  List<String> generateChartColors(int count) {
    final colors = [
      '#FF6B6B',
      '#4ECDC4',
      '#45B7D1',
      '#96CEB4',
      '#FFEAA7',
      '#DDA0DD',
      '#98D8C8',
      '#F7DC6F',
      '#BB8FCE',
      '#85C1E9',
    ];

    final result = <String>[];
    for (int i = 0; i < count; i++) {
      result.add(colors[i % colors.length]);
    }

    return result;
  }
}
