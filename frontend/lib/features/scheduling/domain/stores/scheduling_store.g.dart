// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduling_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SchedulingStore on SchedulingStoreBase, Store {
  Computed<List<AppointmentModel>>? _$filteredAppointmentsComputed;

  @override
  List<AppointmentModel> get filteredAppointments =>
      (_$filteredAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.filteredAppointments,
              name: 'SchedulingStoreBase.filteredAppointments'))
          .value;
  Computed<List<AppointmentModel>>? _$pendingAppointmentsComputed;

  @override
  List<AppointmentModel> get pendingAppointments =>
      (_$pendingAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.pendingAppointments,
              name: 'SchedulingStoreBase.pendingAppointments'))
          .value;
  Computed<List<AppointmentModel>>? _$confirmedAppointmentsComputed;

  @override
  List<AppointmentModel> get confirmedAppointments =>
      (_$confirmedAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.confirmedAppointments,
              name: 'SchedulingStoreBase.confirmedAppointments'))
          .value;
  Computed<List<AppointmentModel>>? _$upcomingAppointmentsComputed;

  @override
  List<AppointmentModel> get upcomingAppointments =>
      (_$upcomingAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.upcomingAppointments,
              name: 'SchedulingStoreBase.upcomingAppointments'))
          .value;
  Computed<List<TimeSlotModel>>? _$availableSlotsComputed;

  @override
  List<TimeSlotModel> get availableSlots => (_$availableSlotsComputed ??=
          Computed<List<TimeSlotModel>>(() => super.availableSlots,
              name: 'SchedulingStoreBase.availableSlots'))
      .value;
  Computed<List<TimeSlotModel>>? _$todaySlotsComputed;

  @override
  List<TimeSlotModel> get todaySlots => (_$todaySlotsComputed ??=
          Computed<List<TimeSlotModel>>(() => super.todaySlots,
              name: 'SchedulingStoreBase.todaySlots'))
      .value;

  late final _$appointmentsAtom =
      Atom(name: 'SchedulingStoreBase.appointments', context: context);

  @override
  ObservableList<AppointmentModel> get appointments {
    _$appointmentsAtom.reportRead();
    return super.appointments;
  }

  @override
  set appointments(ObservableList<AppointmentModel> value) {
    _$appointmentsAtom.reportWrite(value, super.appointments, () {
      super.appointments = value;
    });
  }

  late final _$availableTimeSlotsAtom =
      Atom(name: 'SchedulingStoreBase.availableTimeSlots', context: context);

  @override
  ObservableList<TimeSlotModel> get availableTimeSlots {
    _$availableTimeSlotsAtom.reportRead();
    return super.availableTimeSlots;
  }

  @override
  set availableTimeSlots(ObservableList<TimeSlotModel> value) {
    _$availableTimeSlotsAtom.reportWrite(value, super.availableTimeSlots, () {
      super.availableTimeSlots = value;
    });
  }

  late final _$selectedAppointmentAtom =
      Atom(name: 'SchedulingStoreBase.selectedAppointment', context: context);

  @override
  AppointmentModel? get selectedAppointment {
    _$selectedAppointmentAtom.reportRead();
    return super.selectedAppointment;
  }

  @override
  set selectedAppointment(AppointmentModel? value) {
    _$selectedAppointmentAtom.reportWrite(value, super.selectedAppointment, () {
      super.selectedAppointment = value;
    });
  }

  late final _$selectedTimeSlotAtom =
      Atom(name: 'SchedulingStoreBase.selectedTimeSlot', context: context);

  @override
  TimeSlotModel? get selectedTimeSlot {
    _$selectedTimeSlotAtom.reportRead();
    return super.selectedTimeSlot;
  }

  @override
  set selectedTimeSlot(TimeSlotModel? value) {
    _$selectedTimeSlotAtom.reportWrite(value, super.selectedTimeSlot, () {
      super.selectedTimeSlot = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'SchedulingStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isLoadingTimeSlotsAtom =
      Atom(name: 'SchedulingStoreBase.isLoadingTimeSlots', context: context);

  @override
  bool get isLoadingTimeSlots {
    _$isLoadingTimeSlotsAtom.reportRead();
    return super.isLoadingTimeSlots;
  }

  @override
  set isLoadingTimeSlots(bool value) {
    _$isLoadingTimeSlotsAtom.reportWrite(value, super.isLoadingTimeSlots, () {
      super.isLoadingTimeSlots = value;
    });
  }

  late final _$errorAtom =
      Atom(name: 'SchedulingStoreBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$timeSlotsErrorAtom =
      Atom(name: 'SchedulingStoreBase.timeSlotsError', context: context);

  @override
  String? get timeSlotsError {
    _$timeSlotsErrorAtom.reportRead();
    return super.timeSlotsError;
  }

  @override
  set timeSlotsError(String? value) {
    _$timeSlotsErrorAtom.reportWrite(value, super.timeSlotsError, () {
      super.timeSlotsError = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: 'SchedulingStoreBase.searchQuery', context: context);

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$selectedStatusAtom =
      Atom(name: 'SchedulingStoreBase.selectedStatus', context: context);

  @override
  String get selectedStatus {
    _$selectedStatusAtom.reportRead();
    return super.selectedStatus;
  }

  @override
  set selectedStatus(String value) {
    _$selectedStatusAtom.reportWrite(value, super.selectedStatus, () {
      super.selectedStatus = value;
    });
  }

  late final _$selectedStartDateAtom =
      Atom(name: 'SchedulingStoreBase.selectedStartDate', context: context);

  @override
  DateTime? get selectedStartDate {
    _$selectedStartDateAtom.reportRead();
    return super.selectedStartDate;
  }

  @override
  set selectedStartDate(DateTime? value) {
    _$selectedStartDateAtom.reportWrite(value, super.selectedStartDate, () {
      super.selectedStartDate = value;
    });
  }

  late final _$selectedEndDateAtom =
      Atom(name: 'SchedulingStoreBase.selectedEndDate', context: context);

  @override
  DateTime? get selectedEndDate {
    _$selectedEndDateAtom.reportRead();
    return super.selectedEndDate;
  }

  @override
  set selectedEndDate(DateTime? value) {
    _$selectedEndDateAtom.reportWrite(value, super.selectedEndDate, () {
      super.selectedEndDate = value;
    });
  }

  late final _$selectedDoctorIdAtom =
      Atom(name: 'SchedulingStoreBase.selectedDoctorId', context: context);

  @override
  String get selectedDoctorId {
    _$selectedDoctorIdAtom.reportRead();
    return super.selectedDoctorId;
  }

  @override
  set selectedDoctorId(String value) {
    _$selectedDoctorIdAtom.reportWrite(value, super.selectedDoctorId, () {
      super.selectedDoctorId = value;
    });
  }

  late final _$loadUserAppointmentsAsyncAction =
      AsyncAction('SchedulingStoreBase.loadUserAppointments', context: context);

  @override
  Future<void> loadUserAppointments() {
    return _$loadUserAppointmentsAsyncAction
        .run(() => super.loadUserAppointments());
  }

  late final _$loadDoctorAppointmentsAsyncAction = AsyncAction(
      'SchedulingStoreBase.loadDoctorAppointments',
      context: context);

  @override
  Future<void> loadDoctorAppointments(String doctorId) {
    return _$loadDoctorAppointmentsAsyncAction
        .run(() => super.loadDoctorAppointments(doctorId));
  }

  late final _$loadAvailableTimeSlotsAsyncAction = AsyncAction(
      'SchedulingStoreBase.loadAvailableTimeSlots',
      context: context);

  @override
  Future<void> loadAvailableTimeSlots(
      {required String doctorId, DateTime? startDate, DateTime? endDate}) {
    return _$loadAvailableTimeSlotsAsyncAction.run(() => super
        .loadAvailableTimeSlots(
            doctorId: doctorId, startDate: startDate, endDate: endDate));
  }

  late final _$scheduleAppointmentAsyncAction =
      AsyncAction('SchedulingStoreBase.scheduleAppointment', context: context);

  @override
  Future<AppointmentModel?> scheduleAppointment(
      {required String doctorId,
      required DateTime scheduledAt,
      String? notes,
      String? symptoms}) {
    return _$scheduleAppointmentAsyncAction.run(() => super.scheduleAppointment(
        doctorId: doctorId,
        scheduledAt: scheduledAt,
        notes: notes,
        symptoms: symptoms));
  }

  late final _$confirmAppointmentAsyncAction =
      AsyncAction('SchedulingStoreBase.confirmAppointment', context: context);

  @override
  Future<bool> confirmAppointment(String appointmentId) {
    return _$confirmAppointmentAsyncAction
        .run(() => super.confirmAppointment(appointmentId));
  }

  late final _$cancelAppointmentAsyncAction =
      AsyncAction('SchedulingStoreBase.cancelAppointment', context: context);

  @override
  Future<bool> cancelAppointment(String appointmentId, {String? reason}) {
    return _$cancelAppointmentAsyncAction
        .run(() => super.cancelAppointment(appointmentId, reason: reason));
  }

  late final _$getAppointmentDetailsAsyncAction = AsyncAction(
      'SchedulingStoreBase.getAppointmentDetails',
      context: context);

  @override
  Future<AppointmentModel?> getAppointmentDetails(String appointmentId) {
    return _$getAppointmentDetailsAsyncAction
        .run(() => super.getAppointmentDetails(appointmentId));
  }

  late final _$checkTimeSlotAvailabilityAsyncAction = AsyncAction(
      'SchedulingStoreBase.checkTimeSlotAvailability',
      context: context);

  @override
  Future<bool> checkTimeSlotAvailability(
      {required String doctorId, required DateTime scheduledAt}) {
    return _$checkTimeSlotAvailabilityAsyncAction.run(() => super
        .checkTimeSlotAvailability(
            doctorId: doctorId, scheduledAt: scheduledAt));
  }

  late final _$getSchedulingStatsAsyncAction =
      AsyncAction('SchedulingStoreBase.getSchedulingStats', context: context);

  @override
  Future<Map<String, dynamic>?> getSchedulingStats(
      {DateTime? startDate, DateTime? endDate}) {
    return _$getSchedulingStatsAsyncAction.run(
        () => super.getSchedulingStats(startDate: startDate, endDate: endDate));
  }

  late final _$SchedulingStoreBaseActionController =
      ActionController(name: 'SchedulingStoreBase', context: context);

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedStatus(String status) {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.setSelectedStatus');
    try {
      return super.setSelectedStatus(status);
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedStartDate(DateTime? date) {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.setSelectedStartDate');
    try {
      return super.setSelectedStartDate(date);
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedEndDate(DateTime? date) {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.setSelectedEndDate');
    try {
      return super.setSelectedEndDate(date);
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDoctorId(String doctorId) {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.setSelectedDoctorId');
    try {
      return super.setSelectedDoctorId(doctorId);
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedAppointment(AppointmentModel? appointment) {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.setSelectedAppointment');
    try {
      return super.setSelectedAppointment(appointment);
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedTimeSlot(TimeSlotModel? timeSlot) {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.setSelectedTimeSlot');
    try {
      return super.setSelectedTimeSlot(timeSlot);
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$SchedulingStoreBaseActionController.startAction(
        name: 'SchedulingStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$SchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
appointments: ${appointments},
availableTimeSlots: ${availableTimeSlots},
selectedAppointment: ${selectedAppointment},
selectedTimeSlot: ${selectedTimeSlot},
isLoading: ${isLoading},
isLoadingTimeSlots: ${isLoadingTimeSlots},
error: ${error},
timeSlotsError: ${timeSlotsError},
searchQuery: ${searchQuery},
selectedStatus: ${selectedStatus},
selectedStartDate: ${selectedStartDate},
selectedEndDate: ${selectedEndDate},
selectedDoctorId: ${selectedDoctorId},
filteredAppointments: ${filteredAppointments},
pendingAppointments: ${pendingAppointments},
confirmedAppointments: ${confirmedAppointments},
upcomingAppointments: ${upcomingAppointments},
availableSlots: ${availableSlots},
todaySlots: ${todaySlots}
    ''';
  }
}
