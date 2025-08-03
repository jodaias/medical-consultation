import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/stores/base_store.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/features/patient/data/services/patient_dashboard_service.dart';

part 'patient_dashboard_store.g.dart';

@observable
class PatientDashboardStore = PatientDashboardStoreBase
    with _$PatientDashboardStore;

abstract class PatientDashboardStoreBase extends BaseStore with Store {
  final PatientDashboardService _dashboardService = PatientDashboardService();
  final AuthStore _authStore = getIt<AuthStore>();

  // Observables
  @observable
  int totalConsultations = 0;

  @observable
  int upcomingConsultations = 0;

  @observable
  double totalSpent = 0.0;

  @observable
  ObservableList<Map<String, dynamic>> recentConsultations =
      ObservableList<Map<String, dynamic>>();

  @observable
  ObservableList<Map<String, dynamic>> favoriteDoctors =
      ObservableList<Map<String, dynamic>>();

  @observable
  ObservableList<Map<String, dynamic>> recentPrescriptions =
      ObservableList<Map<String, dynamic>>();

  // Computed
  @computed
  bool get hasRecentConsultations => recentConsultations.isNotEmpty;

  @computed
  bool get hasFavoriteDoctors => favoriteDoctors.isNotEmpty;

  @computed
  bool get hasRecentPrescriptions => recentPrescriptions.isNotEmpty;

  // Actions
  @action
  Future<void> loadDashboardData() async {
    try {
      setLoading(true);
      clearError();

      final patientId = _authStore.userId;
      if (patientId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Carregar dados do dashboard
      final dashboardData =
          await _dashboardService.getPatientDashboard(patientId);

      // Atualizar observables com dados reais
      totalConsultations = dashboardData['totalConsultations'] ?? 0;
      upcomingConsultations = dashboardData['upcomingConsultations'] ?? 0;
      totalSpent = (dashboardData['totalSpent'] ?? 0.0).toDouble();

      // Carregar dados específicos
      await Future.wait([
        loadRecentConsultations(),
        loadFavoriteDoctors(),
        loadRecentPrescriptions(),
      ]);
    } catch (e) {
      setError('Erro ao carregar dashboard: $e');
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadRecentConsultations() async {
    try {
      final patientId = _authStore.userId;
      if (patientId == null) return;

      final consultations =
          await _dashboardService.getRecentConsultations(patientId);

      recentConsultations.clear();
      recentConsultations.addAll(consultations);
    } catch (e) {
      setError('Erro ao carregar consultas recentes: $e');
    }
  }

  @action
  Future<void> loadFavoriteDoctors() async {
    try {
      final patientId = _authStore.userId;
      if (patientId == null) return;

      final doctors = await _dashboardService.getFavoriteDoctors(patientId);

      favoriteDoctors.clear();
      favoriteDoctors.addAll(doctors);
    } catch (e) {
      setError('Erro ao carregar médicos favoritos: $e');
    }
  }

  @action
  Future<void> loadRecentPrescriptions() async {
    try {
      final patientId = _authStore.userId;
      if (patientId == null) return;

      final prescriptions =
          await _dashboardService.getRecentPrescriptions(patientId);

      recentPrescriptions.clear();
      recentPrescriptions.addAll(prescriptions);
    } catch (e) {
      setError('Erro ao carregar prescrições recentes: $e');
    }
  }

  @action
  Future<void> refreshData() async {
    await loadDashboardData();
  }

  @override
  @action
  void clearError() {
    super.clearError();
  }
}
