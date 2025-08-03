import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/stores/base_store.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/features/doctor/data/services/doctor_dashboard_service.dart';

part 'doctor_dashboard_store.g.dart';

@observable
class DoctorDashboardStore = DoctorDashboardStoreBase
    with _$DoctorDashboardStore;

abstract class DoctorDashboardStoreBase extends BaseStore with Store {
  final DoctorDashboardService _dashboardService = DoctorDashboardService();
  final AuthStore _authStore = getIt<AuthStore>();

  // Observables

  @observable
  String? doctorSpecialty;

  @observable
  int todayConsultations = 0;

  @observable
  int totalPatients = 0;

  @observable
  double averageRating = 0.0;

  @observable
  ObservableList<Map<String, dynamic>> upcomingConsultations =
      ObservableList<Map<String, dynamic>>();

  // Computed
  @computed
  bool get hasUpcomingConsultations => upcomingConsultations.isNotEmpty;

  // Actions
  @action
  Future<void> loadDashboardData() async {
    try {
      setLoading(true);
      clearError();

      final doctorId = _authStore.userId;
      if (doctorId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Carregar dados do dashboard
      final dashboardData =
          await _dashboardService.getDoctorDashboard(doctorId);

      // Atualizar observables com dados reais
      doctorSpecialty = dashboardData['specialty'] ?? 'Não informado';
      todayConsultations = dashboardData['todayConsultations'] ?? 0;
      totalPatients = dashboardData['totalPatients'] ?? 0;
      averageRating = (dashboardData['averageRating'] ?? 0.0).toDouble();

      // Carregar consultas próximas
      await loadUpcomingConsultations();
    } catch (e) {
      setError('Erro ao carregar dashboard: $e');
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> loadUpcomingConsultations() async {
    try {
      final doctorId = _authStore.userId;
      if (doctorId == null) return;

      final consultations =
          await _dashboardService.getUpcomingConsultations(doctorId);

      upcomingConsultations.clear();
      upcomingConsultations.addAll(consultations);
    } catch (e) {
      setError('Erro ao carregar próximas consultas: $e');
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
