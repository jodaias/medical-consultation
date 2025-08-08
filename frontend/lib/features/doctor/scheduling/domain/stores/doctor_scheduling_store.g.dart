// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_scheduling_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DoctorSchedulingStore on DoctorSchedulingStoreBase, Store {
  late final _$schedulesAtom =
      Atom(name: 'DoctorSchedulingStoreBase.schedules', context: context);

  @override
  ObservableList<DoctorScheduleModel> get schedules {
    _$schedulesAtom.reportRead();
    return super.schedules;
  }

  @override
  set schedules(ObservableList<DoctorScheduleModel> value) {
    _$schedulesAtom.reportWrite(value, super.schedules, () {
      super.schedules = value;
    });
  }

  late final _$requestStatusAtom =
      Atom(name: 'DoctorSchedulingStoreBase.requestStatus', context: context);

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
      Atom(name: 'DoctorSchedulingStoreBase.error', context: context);

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

  late final _$loadSchedulesAsyncAction =
      AsyncAction('DoctorSchedulingStoreBase.loadSchedules', context: context);

  @override
  Future<void> loadSchedules(String doctorId) {
    return _$loadSchedulesAsyncAction.run(() => super.loadSchedules(doctorId));
  }

  late final _$saveSchedulesAsyncAction =
      AsyncAction('DoctorSchedulingStoreBase.saveSchedules', context: context);

  @override
  Future<void> saveSchedules(
      {required String doctorId,
      required List<DoctorScheduleModel> schedulesPayload}) {
    return _$saveSchedulesAsyncAction.run(() => super
        .saveSchedules(doctorId: doctorId, schedulesPayload: schedulesPayload));
  }

  late final _$updateScheduleAsyncAction =
      AsyncAction('DoctorSchedulingStoreBase.updateSchedule', context: context);

  @override
  Future<void> updateSchedule(
      {required String doctorId,
      required DoctorScheduleModel schedulePayload}) {
    return _$updateScheduleAsyncAction.run(() => super
        .updateSchedule(doctorId: doctorId, schedulePayload: schedulePayload));
  }

  late final _$DoctorSchedulingStoreBaseActionController =
      ActionController(name: 'DoctorSchedulingStoreBase', context: context);

  @override
  void clearFilters() {
    final _$actionInfo = _$DoctorSchedulingStoreBaseActionController
        .startAction(name: 'DoctorSchedulingStoreBase.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$DoctorSchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$DoctorSchedulingStoreBaseActionController
        .startAction(name: 'DoctorSchedulingStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$DoctorSchedulingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
schedules: ${schedules},
requestStatus: ${requestStatus},
error: ${error}
    ''';
  }
}
