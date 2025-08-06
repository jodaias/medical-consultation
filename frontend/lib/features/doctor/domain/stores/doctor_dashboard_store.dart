import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';
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
  final _dashboardService = getIt<DoctorDashboardService>();
  final _authStore = getIt<AuthStore>();

  // Observables
  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

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
    requestStatus = RequestStatusEnum.loading;
    clearError();

    final doctorId = _authStore.userId;
    if (doctorId == null) {
      setError('Usuário não autenticado');
      requestStatus = RequestStatusEnum.fail;
      return;
    }

    final result = await _dashboardService.getDoctorDashboard(doctorId);
    if (result.success) {
      final dashboardData = result.data;
      doctorSpecialty = dashboardData['specialty'] ?? 'Não informado';
      todayConsultations = dashboardData['todayConsultations'] ?? 0;
      totalPatients = dashboardData['totalPatients'] ?? 0;
      averageRating = (dashboardData['averageRating'] ?? 0.0).toDouble();
      await loadUpcomingConsultations();
      requestStatus = RequestStatusEnum.success;
    } else {
      setError(result.error?.toString() ?? 'Erro ao carregar dashboard');
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadUpcomingConsultations() async {
    final doctorId = _authStore.userId;
    if (doctorId == null) return;

    final result = await _dashboardService.getUpcomingConsultations(doctorId);
    if (result.success) {
      upcomingConsultations.clear();
      upcomingConsultations.addAll(result.data);
      // Não altera o requestStatus aqui, pois é controlado pelo loadDashboardData
    } else {
      setError(
          result.error?.toString() ?? 'Erro ao carregar próximas consultas');
      requestStatus = RequestStatusEnum.fail;
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
    requestStatus = RequestStatusEnum.none;
  }
}
