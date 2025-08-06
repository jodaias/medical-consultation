import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';
import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/features/scheduling/data/models/appointment_model.dart';
import 'package:medical_consultation_app/features/scheduling/data/models/time_slot_model.dart';
import 'package:medical_consultation_app/features/scheduling/data/services/scheduling_service.dart';

part 'scheduling_store.g.dart';

class SchedulingStore = SchedulingStoreBase with _$SchedulingStore;

abstract class SchedulingStoreBase with Store {
  final _schedulingService = getIt<SchedulingService>();

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
  TimeSlotModel? selectedTimeSlot;

  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

  @observable
  RequestStatusEnum timeSlotsStatus = RequestStatusEnum.none;

  @observable
  String? error;

  @observable
  String? timeSlotsError;

  @observable
  bool timeSlotAvailability = false;

  @observable
  Map<String, dynamic>? schedulingStats;

  @observable
  String searchQuery = '';

  @observable
  String selectedStatus = 'all';

  @observable
  DateTime? selectedStartDate;

  @observable
  DateTime? selectedEndDate;

  @observable
  String selectedDoctorId = '';

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

  @computed
  List<TimeSlotModel> get availableSlots => availableTimeSlots
      .where((slot) => slot.hasAvailability && !slot.isPast)
      .toList();

  @computed
  List<TimeSlotModel> get todaySlots => availableTimeSlots
      .where((slot) => slot.isToday && slot.hasAvailability)
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
  void setSelectedDoctorId(String doctorId) {
    selectedDoctorId = doctorId;
  }

  @action
  void setSelectedAppointment(AppointmentModel? appointment) {
    selectedAppointment = appointment;
  }

  @action
  void setSelectedTimeSlot(TimeSlotModel? timeSlot) {
    selectedTimeSlot = timeSlot;
  }

  @action
  void clearFilters() {
    searchQuery = '';
    selectedStatus = 'all';
    selectedStartDate = null;
    selectedEndDate = null;
    selectedDoctorId = '';
  }

  @action
  Future<void> loadUserAppointments() async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _schedulingService.getUserAppointments(
      status: selectedStatus == 'all' ? null : selectedStatus,
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
  Future<void> loadDoctorAppointments(String doctorId) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _schedulingService.getDoctorAppointments(
      doctorId: doctorId,
      status: selectedStatus == 'all' ? null : selectedStatus,
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
  Future<void> loadAvailableTimeSlots({
    required String doctorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    timeSlotsStatus = RequestStatusEnum.loading;
    final result = await _schedulingService.getAvailableTimeSlots(
      doctorId: doctorId,
      startDate: startDate,
      endDate: endDate,
    );
    if (result.success) {
      availableTimeSlots.clear();
      availableTimeSlots.addAll(result.data);
      timeSlotsStatus = RequestStatusEnum.success;
    } else {
      timeSlotsError = result.error?.toString();
      timeSlotsStatus = RequestStatusEnum.fail;
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
    final result = await _schedulingService.scheduleAppointment(
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
  Future<bool> confirmAppointment(String appointmentId) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _schedulingService.confirmAppointment(appointmentId);
    if (result.success) {
      final index = appointments
          .indexWhere((appointment) => appointment.id == appointmentId);
      if (index != -1) {
        appointments[index] = result.data;
      }
      requestStatus = RequestStatusEnum.success;
      return true;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
      return false;
    }
  }

  @action
  Future<bool> cancelAppointment(String appointmentId, {String? reason}) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _schedulingService.cancelAppointment(appointmentId,
        reason: reason);
    if (result.success) {
      final index = appointments
          .indexWhere((appointment) => appointment.id == appointmentId);
      if (index != -1) {
        final appointment = appointments[index];
        appointments[index] = appointment.copyWith(status: 'cancelled');
      }
      requestStatus = RequestStatusEnum.success;
      return true;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
      return false;
    }
  }

  @action
  Future<void> getAppointmentDetails(String appointmentId) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result =
        await _schedulingService.getAppointmentDetails(appointmentId);
    if (result.success) {
      selectedAppointment = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> checkTimeSlotAvailability({
    required String doctorId,
    required DateTime scheduledAt,
  }) async {
    final result = await _schedulingService.checkTimeSlotAvailability(
      doctorId: doctorId,
      scheduledAt: scheduledAt,
    );
    if (result.success) {
      timeSlotAvailability = result.data;
    } else {
      timeSlotAvailability = false;
      error = result.error?.toString();
    }
  }

  @action
  Future<void> getSchedulingStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result = await _schedulingService.getSchedulingStats(
      startDate: startDate,
      endDate: endDate,
    );
    if (result.success) {
      schedulingStats = result.data;
    } else {
      error = result.error?.toString();
    }
  }

  @action
  void clearError() {
    error = null;
    timeSlotsError = null;
  }
}
