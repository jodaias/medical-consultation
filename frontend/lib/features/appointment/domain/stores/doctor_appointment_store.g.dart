// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_appointment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DoctorAppointmentStore on DoctorAppointmentStoreBase, Store {
  Computed<List<AppointmentModel>>? _$filteredAppointmentsComputed;

  @override
  List<AppointmentModel> get filteredAppointments =>
      (_$filteredAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.filteredAppointments,
              name: 'DoctorAppointmentStoreBase.filteredAppointments'))
          .value;
  Computed<List<AppointmentModel>>? _$pendingAppointmentsComputed;

  @override
  List<AppointmentModel> get pendingAppointments =>
      (_$pendingAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.pendingAppointments,
              name: 'DoctorAppointmentStoreBase.pendingAppointments'))
          .value;
  Computed<List<AppointmentModel>>? _$confirmedAppointmentsComputed;

  @override
  List<AppointmentModel> get confirmedAppointments =>
      (_$confirmedAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.confirmedAppointments,
              name: 'DoctorAppointmentStoreBase.confirmedAppointments'))
          .value;
  Computed<List<AppointmentModel>>? _$upcomingAppointmentsComputed;

  @override
  List<AppointmentModel> get upcomingAppointments =>
      (_$upcomingAppointmentsComputed ??= Computed<List<AppointmentModel>>(
              () => super.upcomingAppointments,
              name: 'DoctorAppointmentStoreBase.upcomingAppointments'))
          .value;

  late final _$appointmentsAtom =
      Atom(name: 'DoctorAppointmentStoreBase.appointments', context: context);

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

  late final _$selectedAppointmentAtom = Atom(
      name: 'DoctorAppointmentStoreBase.selectedAppointment', context: context);

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
      Atom(name: 'DoctorAppointmentStoreBase.requestStatus', context: context);

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

  late final _$errorAtom =
      Atom(name: 'DoctorAppointmentStoreBase.error', context: context);

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
      Atom(name: 'DoctorAppointmentStoreBase.searchQuery', context: context);

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
      Atom(name: 'DoctorAppointmentStoreBase.selectedStatus', context: context);

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

  late final _$selectedStartDateAtom = Atom(
      name: 'DoctorAppointmentStoreBase.selectedStartDate', context: context);

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

  late final _$selectedEndDateAtom = Atom(
      name: 'DoctorAppointmentStoreBase.selectedEndDate', context: context);

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
      'DoctorAppointmentStoreBase.loadUserAppointments',
      context: context);

  @override
  Future<void> loadUserAppointments(String doctorId) {
    return _$loadUserAppointmentsAsyncAction
        .run(() => super.loadUserAppointments(doctorId));
  }

  late final _$confirmAppointmentAsyncAction = AsyncAction(
      'DoctorAppointmentStoreBase.confirmAppointment',
      context: context);

  @override
  Future<void> confirmAppointment(String appointmentId) {
    return _$confirmAppointmentAsyncAction
        .run(() => super.confirmAppointment(appointmentId));
  }

  late final _$cancelAppointmentAsyncAction = AsyncAction(
      'DoctorAppointmentStoreBase.cancelAppointment',
      context: context);

  @override
  Future<void> cancelAppointment(String appointmentId, {String? reason}) {
    return _$cancelAppointmentAsyncAction
        .run(() => super.cancelAppointment(appointmentId, reason: reason));
  }

  late final _$getAppointmentDetailsAsyncAction = AsyncAction(
      'DoctorAppointmentStoreBase.getAppointmentDetails',
      context: context);

  @override
  Future<void> getAppointmentDetails(String appointmentId) {
    return _$getAppointmentDetailsAsyncAction
        .run(() => super.getAppointmentDetails(appointmentId));
  }

  late final _$DoctorAppointmentStoreBaseActionController =
      ActionController(name: 'DoctorAppointmentStoreBase', context: context);

  @override
  void setSearchQuery(String query) {
    final _$actionInfo = _$DoctorAppointmentStoreBaseActionController
        .startAction(name: 'DoctorAppointmentStoreBase.setSearchQuery');
    try {
      return super.setSearchQuery(query);
    } finally {
      _$DoctorAppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedStatus(String status) {
    final _$actionInfo = _$DoctorAppointmentStoreBaseActionController
        .startAction(name: 'DoctorAppointmentStoreBase.setSelectedStatus');
    try {
      return super.setSelectedStatus(status);
    } finally {
      _$DoctorAppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedStartDate(DateTime? date) {
    final _$actionInfo = _$DoctorAppointmentStoreBaseActionController
        .startAction(name: 'DoctorAppointmentStoreBase.setSelectedStartDate');
    try {
      return super.setSelectedStartDate(date);
    } finally {
      _$DoctorAppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedEndDate(DateTime? date) {
    final _$actionInfo = _$DoctorAppointmentStoreBaseActionController
        .startAction(name: 'DoctorAppointmentStoreBase.setSelectedEndDate');
    try {
      return super.setSelectedEndDate(date);
    } finally {
      _$DoctorAppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedAppointment(AppointmentModel? appointment) {
    final _$actionInfo = _$DoctorAppointmentStoreBaseActionController
        .startAction(name: 'DoctorAppointmentStoreBase.setSelectedAppointment');
    try {
      return super.setSelectedAppointment(appointment);
    } finally {
      _$DoctorAppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$DoctorAppointmentStoreBaseActionController
        .startAction(name: 'DoctorAppointmentStoreBase.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$DoctorAppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$DoctorAppointmentStoreBaseActionController
        .startAction(name: 'DoctorAppointmentStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$DoctorAppointmentStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
appointments: ${appointments},
selectedAppointment: ${selectedAppointment},
requestStatus: ${requestStatus},
error: ${error},
searchQuery: ${searchQuery},
selectedStatus: ${selectedStatus},
selectedStartDate: ${selectedStartDate},
selectedEndDate: ${selectedEndDate},
filteredAppointments: ${filteredAppointments},
pendingAppointments: ${pendingAppointments},
confirmedAppointments: ${confirmedAppointments},
upcomingAppointments: ${upcomingAppointments}
    ''';
  }
}
