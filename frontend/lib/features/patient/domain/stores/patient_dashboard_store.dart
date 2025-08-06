import 'package:medical_consultation_app/features/shared/dashboard/models/dashboard_stats_model.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';
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
  final PatientDashboardService _dashboardService =
      getIt<PatientDashboardService>();
  final AuthStore _authStore = getIt<AuthStore>();

  // Observables
  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

  @observable
  String selectedPeriod = 'month';

  @observable
  DashboardStatsModel? stats;

  @observable
  int totalConsultations = 0;

  @observable
  int upcomingConsultations = 0;

  @observable
  double totalSpent = 0.0;

  @observable
  Map<String, dynamic> realTimeMetrics = {};

  @observable
  List<Map<String, dynamic>> alertsAndInsights = [];

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
    requestStatus = RequestStatusEnum.loading;
    setRefreshing(true);
    clearError();
    final patientId = _authStore.userId;
    if (patientId == null) {
      setError('Usuário não autenticado');
      requestStatus = RequestStatusEnum.fail;
      setRefreshing(false);
      return;
    }
    final dashboardResult =
        await _dashboardService.getPatientDashboard(patientId);
    if (dashboardResult.success) {
      final dashboardData = dashboardResult.data;
      totalConsultations = dashboardData['totalConsultations'] ?? 0;
      upcomingConsultations = dashboardData['upcomingConsultations'] ?? 0;
      totalSpent = (dashboardData['totalSpent'] ?? 0.0).toDouble();
      await Future.wait([
        loadRecentConsultations(),
        loadFavoriteDoctors(),
        loadRecentPrescriptions(),
      ]);
      requestStatus = RequestStatusEnum.success;
    } else {
      setError(
          'Erro ao carregar dashboard: ${dashboardResult.error?.toString() ?? ''}');
      requestStatus = RequestStatusEnum.fail;
    }
    setRefreshing(false);
  }

  @action
  Future<void> loadDashboardStats({String? period}) async {
    requestStatus = RequestStatusEnum.loading;
    setRefreshing(true);
    errorMessage = null;
    if (period != null) selectedPeriod = period;
    final result =
        await _dashboardService.getDashboardStats(period: selectedPeriod);
    if (result.success) {
      stats = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          'Erro ao carregar estatísticas: ${result.error?.toString() ?? ''}';
      requestStatus = RequestStatusEnum.fail;
    }
    setRefreshing(false);
  }

  @action
  Future<void> loadRecentConsultations() async {
    final patientId = _authStore.userId;
    if (patientId == null) return;
    final result = await _dashboardService.getRecentConsultations(patientId);
    if (result.success) {
      recentConsultations.clear();
      recentConsultations.addAll(result.data);
    } else {
      setError(
          'Erro ao carregar consultas recentes: ${result.error?.toString() ?? ''}');
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadFavoriteDoctors() async {
    final patientId = _authStore.userId;
    if (patientId == null) return;
    final result = await _dashboardService.getFavoriteDoctors(patientId);
    if (result.success) {
      favoriteDoctors.clear();
      favoriteDoctors.addAll(result.data);
    } else {
      setError(
          'Erro ao carregar médicos favoritos: ${result.error?.toString() ?? ''}');
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadRealTimeMetrics() async {
    final result = await _dashboardService.getRealTimeMetrics();
    if (result.success) {
      realTimeMetrics = result.data;
    } else {
      errorMessage =
          'Erro ao carregar métricas em tempo real: ${result.error?.toString() ?? ''}';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadAlertsAndInsights() async {
    final result = await _dashboardService.getAlertsAndInsights();
    if (result.success) {
      alertsAndInsights = result.data;
    } else {
      errorMessage =
          'Erro ao carregar alertas e insights: ${result.error?.toString() ?? ''}';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadRecentPrescriptions() async {
    final patientId = _authStore.userId;
    if (patientId == null) return;
    final result = await _dashboardService.getRecentPrescriptions(patientId);
    if (result.success) {
      recentPrescriptions.clear();
      recentPrescriptions.addAll(result.data);
    } else {
      setError(
          'Erro ao carregar prescrições recentes: ${result.error?.toString() ?? ''}');
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> refreshData() async {
    await loadDashboardData();
  }

  @action
  void setPeriod(String period) {
    selectedPeriod = period;
    loadDashboardStats();
  }

  @override
  @action
  void clearError() {
    super.clearError();
    requestStatus = RequestStatusEnum.none;
  }
}
