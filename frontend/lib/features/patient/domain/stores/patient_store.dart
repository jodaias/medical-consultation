import 'package:medical_consultation_app/features/patient/data/services/patient_dashboard_service.dart';
import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/services/api_service.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';

part 'patient_store.g.dart';

@observable
class PatientStore = PatientStoreBase with _$PatientStore;

abstract class PatientStoreBase with Store {
  final _patientDashboardService = getIt<PatientDashboardService>();
  final _authStore = getIt<AuthStore>();

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
      final userId = _authStore.userId;
      if (userId == null) {
        error = 'Usuário não autenticado.';
        return;
      }
      final result =
          await _patientDashboardService.getRecentConsultations(userId);

      if (result.success) {
        recentConsultations.clear();
        recentConsultations.addAll(result.data);
      } else {
        error =
            result.error?.toString() ?? 'Erro ao carregar consultas recentes.';
      }
    } catch (e) {
      error = 'Erro ao carregar consultas recentes: $e';
    }
  }

  @action
  Future<void> loadStatistics() async {
    try {
      final userId = _authStore.userId;
      if (userId == null) {
        error = 'Usuário não autenticado.';
        return;
      }
      final result = await _patientDashboardService.getPatientDashboard(userId);
      if (result.success) {
        totalConsultations = result.data['totalConsultations'] ?? 0;
        completedConsultations = result.data['completedConsultations'] ?? 0;
        pendingConsultations = result.data['pendingConsultations'] ?? 0;
        averageRating = (result.data['averageRating'] ?? 0).toDouble();
      } else {
        error = result.error?.toString() ?? 'Erro ao carregar estatísticas.';
      }
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
