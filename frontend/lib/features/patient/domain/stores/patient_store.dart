import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';

part 'patient_store.g.dart';

@observable
class PatientStore = PatientStoreBase with _$PatientStore;

abstract class PatientStoreBase with Store {
  final ApiService _apiService = getIt<ApiService>();
  final AuthStore _authStore = getIt<AuthStore>();

  // Observables
  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  ObservableList<Map<String, dynamic>> recentConsultations =
      ObservableList<Map<String, dynamic>>();

  @observable
  int totalConsultations = 0;

  @observable
  int completedConsultations = 0;

  @observable
  int pendingConsultations = 0;

  @observable
  double averageRating = 0.0;

  // Computed
  @computed
  bool get hasError => error != null;

  @computed
  bool get hasConsultations => recentConsultations.isNotEmpty;

  // Actions
  @action
  Future<void> loadDashboardData() async {
    try {
      isLoading = true;
      error = null;

      // Carregar dados do dashboard
      await Future.wait([
        loadRecentConsultations(),
        loadStatistics(),
      ]);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadRecentConsultations() async {
    try {
      // TODO: Implementar chamada real para API
      // Por enquanto, usando dados mock
      await Future.delayed(const Duration(milliseconds: 500));

      recentConsultations.clear();
      recentConsultations.addAll([
        {
          'id': '1',
          'doctorName': 'Dr. Maria Silva',
          'specialty': 'Cardiologia',
          'date': '15/01/2024',
          'time': '14:00',
          'status': 'Agendada',
          'statusColor': 'success',
        },
        {
          'id': '2',
          'doctorName': 'Dr. João Santos',
          'specialty': 'Dermatologia',
          'date': '10/01/2024',
          'time': '10:30',
          'status': 'Concluída',
          'statusColor': 'info',
        },
        {
          'id': '3',
          'doctorName': 'Dr. Ana Costa',
          'specialty': 'Ortopedia',
          'date': '08/01/2024',
          'time': '16:00',
          'status': 'Concluída',
          'statusColor': 'info',
        },
      ]);
    } catch (e) {
      error = 'Erro ao carregar consultas recentes: $e';
    }
  }

  @action
  Future<void> loadStatistics() async {
    try {
      // TODO: Implementar chamada real para API
      // Por enquanto, usando dados mock
      await Future.delayed(const Duration(milliseconds: 300));

      totalConsultations = 15;
      completedConsultations = 12;
      pendingConsultations = 3;
      averageRating = 4.8;
    } catch (e) {
      error = 'Erro ao carregar estatísticas: $e';
    }
  }

  @action
  Future<void> refreshData() async {
    await loadDashboardData();
  }

  @action
  void clearError() {
    error = null;
  }
}
