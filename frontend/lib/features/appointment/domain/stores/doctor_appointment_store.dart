import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/appointment/data/services/doctor_appointment_service.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';
import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/features/appointment/data/models/appointment_model.dart';
import 'package:medical_consultation_app/features/appointment/data/models/time_slot_model.dart';

part 'doctor_appointment_store.g.dart';

class DoctorAppointmentStore = DoctorAppointmentStoreBase
    with _$DoctorAppointmentStore;

abstract class DoctorAppointmentStoreBase with Store {
  final _doctorAppointmentService = getIt<DoctorAppointmentService>();

  // Observables
  @observable
  ObservableList<AppointmentModel> appointments =
      ObservableList<AppointmentModel>();

  @observable
  AppointmentModel? selectedAppointment;

  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

  @observable
  String? error;

  @observable
  String searchQuery = '';

  @observable
  String selectedStatus = 'ALL';

  @observable
  DateTime? selectedStartDate;

  @observable
  DateTime? selectedEndDate;

  // Computed
  @computed
  List<AppointmentModel> get filteredAppointments {
    List<AppointmentModel> filtered = appointments.toList();

    // Filtrar por status
    if (selectedStatus != 'all') {
      filtered = filtered
          .where((appointment) => appointment.status == selectedStatus)
          .toList();
    }

    // Filtrar por data
    if (selectedStartDate != null) {
      filtered = filtered
          .where((appointment) =>
              appointment.scheduledAt.isAfter(selectedStartDate!))
          .toList();
    }

    if (selectedEndDate != null) {
      filtered = filtered
          .where((appointment) =>
              appointment.scheduledAt.isBefore(selectedEndDate!))
          .toList();
    }

    // Filtrar por busca
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((appointment) =>
              appointment.doctorName
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              appointment.doctorSpecialty
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              appointment.patientName
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @computed
  List<AppointmentModel> get pendingAppointments =>
      appointments.where((appointment) => appointment.isPending).toList();

  @computed
  List<AppointmentModel> get confirmedAppointments =>
      appointments.where((appointment) => appointment.isConfirmed).toList();

  @computed
  List<AppointmentModel> get upcomingAppointments => appointments
      .where((appointment) =>
          appointment.isConfirmed &&
          appointment.scheduledAt.isAfter(DateTime.now()))
      .toList();

  // Actions
  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  @action
  void setSelectedStatus(String status) {
    selectedStatus = status;
  }

  @action
  void setSelectedStartDate(DateTime? date) {
    selectedStartDate = date;
  }

  @action
  void setSelectedEndDate(DateTime? date) {
    selectedEndDate = date;
  }

  @action
  void setSelectedAppointment(AppointmentModel? appointment) {
    selectedAppointment = appointment;
  }

  @action
  void clearFilters() {
    searchQuery = '';
    selectedStatus = 'ALL';
    selectedStartDate = null;
    selectedEndDate = null;
  }

  @action
  Future<void> loadUserAppointments(String doctorId) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _doctorAppointmentService.getUserAppointments(
      status: selectedStatus == 'ALL' ? null : selectedStatus,
      startDate: selectedStartDate,
      endDate: selectedEndDate,
    );
    if (result.success) {
      appointments.clear();
      appointments.addAll(result.data);
      requestStatus = RequestStatusEnum.success;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> confirmAppointment(String appointmentId) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result =
        await _doctorAppointmentService.confirmAppointment(appointmentId);
    if (result.success) {
      final index = appointments
          .indexWhere((appointment) => appointment.id == appointmentId);
      if (index != -1) {
        appointments[index] = result.data;
      }
      requestStatus = RequestStatusEnum.success;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> cancelAppointment(String appointmentId, {String? reason}) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _doctorAppointmentService
        .cancelAppointment(appointmentId, reason: reason);
    if (result.success) {
      final index = appointments
          .indexWhere((appointment) => appointment.id == appointmentId);
      if (index != -1) {
        final appointment = appointments[index];
        appointments[index] = appointment.copyWith(status: 'cancelled');
      }
      requestStatus = RequestStatusEnum.success;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> getAppointmentDetails(String appointmentId) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result =
        await _doctorAppointmentService.getAppointmentDetails(appointmentId);
    if (result.success) {
      selectedAppointment = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  void clearError() {
    error = null;
  }
}
