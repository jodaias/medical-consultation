import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/core/services/storage_service.dart';

@injectable
class ReportService {
  final ApiService _apiService;
  final StorageService _storageService;

  ReportService(this._apiService, this._storageService);

  // Dashboard do médico
  Future<Map<String, dynamic>?> getDoctorDashboard({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response =
          await _apiService.get('/reports/doctor/dashboard', queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      return response.data;
    } catch (e) {
      print('Erro ao obter dashboard: $e');
      return null;
    }
  }

  // Relatório de consultas
  Future<Map<String, dynamic>?> getConsultationsReport({
    required DateTime startDate,
    required DateTime endDate,
    String? status,
    String? specialty,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      if (status != null) queryParams['status'] = status;
      if (specialty != null) queryParams['specialty'] = specialty;

      final response = await _apiService.get('/reports/consultations',
          queryParameters: queryParams);
      return response.data;
    } catch (e) {
      print('Erro ao obter relatório de consultas: $e');
      return null;
    }
  }

  // Relatório financeiro
  Future<Map<String, dynamic>?> getFinancialReport({
    required DateTime startDate,
    required DateTime endDate,
    String? paymentStatus,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      if (paymentStatus != null) queryParams['paymentStatus'] = paymentStatus;

      final response = await _apiService.get('/reports/financial',
          queryParameters: queryParams);
      return response.data;
    } catch (e) {
      print('Erro ao obter relatório financeiro: $e');
      return null;
    }
  }

  // Relatório de pacientes
  Future<Map<String, dynamic>?> getPatientsReport({
    required DateTime startDate,
    required DateTime endDate,
    String? ageGroup,
    String? gender,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      if (ageGroup != null) queryParams['ageGroup'] = ageGroup;
      if (gender != null) queryParams['gender'] = gender;

      final response = await _apiService.get('/reports/patients',
          queryParameters: queryParams);
      return response.data;
    } catch (e) {
      print('Erro ao obter relatório de pacientes: $e');
      return null;
    }
  }

  // Relatório de avaliações
  Future<Map<String, dynamic>?> getRatingsReport({
    required DateTime startDate,
    required DateTime endDate,
    double? minRating,
    double? maxRating,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      if (minRating != null) queryParams['minRating'] = minRating;
      if (maxRating != null) queryParams['maxRating'] = maxRating;

      final response = await _apiService.get('/reports/ratings',
          queryParameters: queryParams);
      return response.data;
    } catch (e) {
      print('Erro ao obter relatório de avaliações: $e');
      return null;
    }
  }

  // Relatório de prescrições
  Future<Map<String, dynamic>?> getPrescriptionsReport({
    required DateTime startDate,
    required DateTime endDate,
    String? medicationType,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

      if (medicationType != null)
        queryParams['medicationType'] = medicationType;

      final response = await _apiService.get('/reports/prescriptions',
          queryParameters: queryParams);
      return response.data;
    } catch (e) {
      print('Erro ao obter relatório de prescrições: $e');
      return null;
    }
  }

  // Estatísticas gerais
  Future<Map<String, dynamic>?> getGeneralStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response =
          await _apiService.get('/reports/stats', queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      return response.data;
    } catch (e) {
      print('Erro ao obter estatísticas: $e');
      return null;
    }
  }

  // Exportar relatório em PDF
  Future<String?> exportReportToPDF({
    required String reportType,
    required Map<String, dynamic> reportData,
    String? fileName,
  }) async {
    try {
      final response = await _apiService.post('/reports/export-pdf', data: {
        'reportType': reportType,
        'reportData': reportData,
        'fileName':
            fileName ?? 'relatorio_${DateTime.now().millisecondsSinceEpoch}',
      });

      return response.data['pdfUrl'];
    } catch (e) {
      print('Erro ao exportar relatório: $e');
      return null;
    }
  }

  // Exportar relatório em Excel
  Future<String?> exportReportToExcel({
    required String reportType,
    required Map<String, dynamic> reportData,
    String? fileName,
  }) async {
    try {
      final response = await _apiService.post('/reports/export-excel', data: {
        'reportType': reportType,
        'reportData': reportData,
        'fileName':
            fileName ?? 'relatorio_${DateTime.now().millisecondsSinceEpoch}',
      });

      return response.data['excelUrl'];
    } catch (e) {
      print('Erro ao exportar relatório: $e');
      return null;
    }
  }

  // Agendar relatório recorrente
  Future<bool> scheduleRecurringReport({
    required String reportType,
    required String frequency, // daily, weekly, monthly
    required List<String> recipients,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      await _apiService.post('/reports/schedule', data: {
        'reportType': reportType,
        'frequency': frequency,
        'recipients': recipients,
        'parameters': parameters,
      });

      return true;
    } catch (e) {
      print('Erro ao agendar relatório: $e');
      return false;
    }
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
