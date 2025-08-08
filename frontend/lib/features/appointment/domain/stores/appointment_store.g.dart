// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppointmentStore on AppointmentStoreBase, Store {
  Computed<List<AppointmentModel>>? _$filteredAppointmentsComputed;

  @override
  List<AppointmentModel> get filteredAppointments =>
      (_$filteredAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.filteredAppointments,
              name: 'AppointmentStoreBase.filteredAppointments'))
          .value;

  late final _$appointmentsAtom =
      Atom(name: 'AppointmentStoreBase.appointments', context: context);

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
      Atom(name: 'AppointmentStoreBase.availableTimeSlots', context: context);

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
      Atom(name: 'AppointmentStoreBase.selectedAppointment', context: context);

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

  late final _$requestStatusAtom =
      Atom(name: 'AppointmentStoreBase.requestStatus', context: context);

  @override
  RequestStatusEnum get requestStatus {
    _$requestStatusAtom.reportRead();
    return super.requestStatus;
  }

  @override
  set requestStatus(RequestStatusEnum value) {
    _$requestStatusAtom.reportWrite(value, super.requestStatus, () {
      super.requestStatus = value;
    });
  }

  late final _$timeSlotsStatusAtom =
      Atom(name: 'AppointmentStoreBase.timeSlotsStatus', context: context);

  @override
  RequestStatusEnum get timeSlotsStatus {
    _$timeSlotsStatusAtom.reportRead();
    return super.timeSlotsStatus;
  }

  @override
  set timeSlotsStatus(RequestStatusEnum value) {
    _$timeSlotsStatusAtom.reportWrite(value, super.timeSlotsStatus, () {
      super.timeSlotsStatus = value;
    });
  }

  late final _$errorAtom =
      Atom(name: 'AppointmentStoreBase.error', context: context);

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

  late final _$searchQueryAtom =
      Atom(name: 'AppointmentStoreBase.searchQuery', context: context);

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
      Atom(name: 'AppointmentStoreBase.selectedStatus', context: context);

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
      Atom(name: 'AppointmentStoreBase.selectedStartDate', context: context);

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
      Atom(name: 'AppointmentStoreBase.selectedEndDate', context: context);

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

  late final _$loadUserAppointmentsAsyncAction = AsyncAction(
      'AppointmentStoreBase.loadUserAppointments',
      context: context);

  @override
  Future<void> loadUserAppointments(String userId) {
    return _$loadUserAppointmentsAsyncAction
        .run(() => super.loadUserAppointments(userId));
  }

  late final _$scheduleAppointmentAsyncAction =
      AsyncAction('AppointmentStoreBase.scheduleAppointment', context: context);

  @override
  Future<void> scheduleAppointment(
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
      AsyncAction('AppointmentStoreBase.confirmAppointment', context: context);

  @override
  Future<void> confirmAppointment(String appointmentId) {
    return _$confirmAppointmentAsyncAction
        .run(() => super.confirmAppointment(appointmentId));
  }

  late final _$cancelAppointmentAsyncAction =
      AsyncAction('AppointmentStoreBase.cancelAppointment', context: context);

  @override
  Future<void> cancelAppointment(String appointmentId, {String? reason}) {
    return _$cancelAppointmentAsyncAction
        .run(() => super.cancelAppointment(appointmentId, reason: reason));
  }

  late final _$getAppointmentDetailsAsyncAction = AsyncAction(
      'AppointmentStoreBase.getAppointmentDetails',
      context: context);

  @override
  Future<void> getAppointmentDetails(String appointmentId) {
    return _$getAppointmentDetailsAsyncAction
        .run(() => super.getAppointmentDetails(appointmentId));
  }

  late final _$AppointmentStoreBaseActionController =
      ActionController(name: 'AppointmentStoreBase', context: context);

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$AppointmentStoreBaseActionController.startAction(
        name: 'AppointmentStoreBase.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedStatus(String status) {
    final _$actionInfo = _$AppointmentStoreBaseActionController.startAction(
        name: 'AppointmentStoreBase.setSelectedStatus');
    try {
      return super.setSelectedStatus(status);
    } finally {
      _$AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedStartDate(DateTime? date) {
    final _$actionInfo = _$AppointmentStoreBaseActionController.startAction(
        name: 'AppointmentStoreBase.setSelectedStartDate');
    try {
      return super.setSelectedStartDate(date);
    } finally {
      _$AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedEndDate(DateTime? date) {
    final _$actionInfo = _$AppointmentStoreBaseActionController.startAction(
        name: 'AppointmentStoreBase.setSelectedEndDate');
    try {
      return super.setSelectedEndDate(date);
    } finally {
      _$AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedAppointment(AppointmentModel? appointment) {
    final _$actionInfo = _$AppointmentStoreBaseActionController.startAction(
        name: 'AppointmentStoreBase.setSelectedAppointment');
    try {
      return super.setSelectedAppointment(appointment);
    } finally {
      _$AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$AppointmentStoreBaseActionController.startAction(
        name: 'AppointmentStoreBase.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$AppointmentStoreBaseActionController.startAction(
        name: 'AppointmentStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$AppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
appointments: ${appointments},
availableTimeSlots: ${availableTimeSlots},
selectedAppointment: ${selectedAppointment},
requestStatus: ${requestStatus},
timeSlotsStatus: ${timeSlotsStatus},
error: ${error},
searchQuery: ${searchQuery},
selectedStatus: ${selectedStatus},
selectedStartDate: ${selectedStartDate},
selectedEndDate: ${selectedEndDate},
filteredAppointments: ${filteredAppointments}
    ''';
  }
}
