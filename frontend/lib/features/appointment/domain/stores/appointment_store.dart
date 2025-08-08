import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/appointment/data/services/appointment_service.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';
import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/features/appointment/data/models/appointment_model.dart';
import 'package:medical_consultation_app/features/appointment/data/models/time_slot_model.dart';

part 'appointment_store.g.dart';

class AppointmentStore = AppointmentStoreBase with _$AppointmentStore;

abstract class AppointmentStoreBase with Store {
  final _appointmentService = getIt<AppointmentService>();

  // Observables
  @observable
  ObservableList<AppointmentModel> appointments =
      ObservableList<AppointmentModel>();

  @observable
  ObservableList<TimeSlotModel> availableTimeSlots =
      ObservableList<TimeSlotModel>();

  @observable
  AppointmentModel? selectedAppointment;

  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

  @observable
  RequestStatusEnum timeSlotsStatus = RequestStatusEnum.none;

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
    if (selectedStatus != 'ALL') {
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
  Future<void> loadUserAppointments(String userId) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _appointmentService.getUserAppointments(
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
  Future<void> scheduleAppointment({
    required String doctorId,
    required DateTime scheduledAt,
    String? notes,
    String? symptoms,
  }) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _appointmentService.scheduleAppointment(
      doctorId: doctorId,
      scheduledAt: scheduledAt,
      notes: notes,
      symptoms: symptoms,
    );
    if (result.success) {
      appointments.add(result.data);
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
    final result = await _appointmentService.confirmAppointment(appointmentId);
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
    final result = await _appointmentService.cancelAppointment(appointmentId,
        reason: reason);
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
        await _appointmentService.getAppointmentDetails(appointmentId);
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
