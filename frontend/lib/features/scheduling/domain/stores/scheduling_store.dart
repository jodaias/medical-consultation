import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/features/scheduling/data/models/appointment_model.dart';
import 'package:medical_consultation_app/features/scheduling/data/models/time_slot_model.dart';
import 'package:medical_consultation_app/features/scheduling/data/services/scheduling_service.dart';

part 'scheduling_store.g.dart';

class SchedulingStore = SchedulingStoreBase with _$SchedulingStore;

abstract class SchedulingStoreBase with Store {
  final SchedulingService _schedulingService;

  SchedulingStoreBase(this._schedulingService);

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
  bool isLoading = false;

  @observable
  bool isLoadingTimeSlots = false;

  @observable
  String? error;

  @observable
  String? timeSlotsError;

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
    try {
      isLoading = true;
      error = null;

      final appointmentsList = await _schedulingService.getUserAppointments(
        status: selectedStatus == 'all' ? null : selectedStatus,
        startDate: selectedStartDate,
        endDate: selectedEndDate,
      );

      appointments.clear();
      appointments.addAll(appointmentsList);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadDoctorAppointments(String doctorId) async {
    try {
      isLoading = true;
      error = null;

      final appointmentsList = await _schedulingService.getDoctorAppointments(
        doctorId: doctorId,
        status: selectedStatus == 'all' ? null : selectedStatus,
        startDate: selectedStartDate,
        endDate: selectedEndDate,
      );

      appointments.clear();
      appointments.addAll(appointmentsList);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadAvailableTimeSlots({
    required String doctorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      isLoadingTimeSlots = true;
      timeSlotsError = null;

      final timeSlots = await _schedulingService.getAvailableTimeSlots(
        doctorId: doctorId,
        startDate: startDate,
        endDate: endDate,
      );

      availableTimeSlots.clear();
      availableTimeSlots.addAll(timeSlots);
    } catch (e) {
      timeSlotsError = e.toString();
    } finally {
      isLoadingTimeSlots = false;
    }
  }

  @action
  Future<AppointmentModel?> scheduleAppointment({
    required String doctorId,
    required DateTime scheduledAt,
    String? notes,
    String? symptoms,
  }) async {
    try {
      isLoading = true;
      error = null;

      final appointment = await _schedulingService.scheduleAppointment(
        doctorId: doctorId,
        scheduledAt: scheduledAt,
        notes: notes,
        symptoms: symptoms,
      );

      appointments.add(appointment);
      return appointment;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> confirmAppointment(String appointmentId) async {
    try {
      isLoading = true;
      error = null;

      final updatedAppointment =
          await _schedulingService.confirmAppointment(appointmentId);

      final index = appointments
          .indexWhere((appointment) => appointment.id == appointmentId);
      if (index != -1) {
        appointments[index] = updatedAppointment;
      }

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> cancelAppointment(String appointmentId, {String? reason}) async {
    try {
      isLoading = true;
      error = null;

      await _schedulingService.cancelAppointment(appointmentId, reason: reason);

      final index = appointments
          .indexWhere((appointment) => appointment.id == appointmentId);
      if (index != -1) {
        final appointment = appointments[index];
        appointments[index] = appointment.copyWith(status: 'cancelled');
      }

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<AppointmentModel?> getAppointmentDetails(String appointmentId) async {
    try {
      isLoading = true;
      error = null;

      final appointment =
          await _schedulingService.getAppointmentDetails(appointmentId);
      selectedAppointment = appointment;
      return appointment;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> checkTimeSlotAvailability({
    required String doctorId,
    required DateTime scheduledAt,
  }) async {
    try {
      return await _schedulingService.checkTimeSlotAvailability(
        doctorId: doctorId,
        scheduledAt: scheduledAt,
      );
    } catch (e) {
      error = e.toString();
      return false;
    }
  }

  @action
  Future<Map<String, dynamic>?> getSchedulingStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _schedulingService.getSchedulingStats(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      error = e.toString();
      return null;
    }
  }

  @action
  void clearError() {
    error = null;
    timeSlotsError = null;
  }
}
