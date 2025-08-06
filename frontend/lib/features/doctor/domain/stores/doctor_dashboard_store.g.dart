// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_dashboard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DoctorDashboardStore on DoctorDashboardStoreBase, Store {
  Computed<bool>? _$hasUpcomingConsultationsComputed;

  @override
  bool get hasUpcomingConsultations => (_$hasUpcomingConsultationsComputed ??=
          Computed<bool>(() => super.hasUpcomingConsultations,
              name: 'DoctorDashboardStoreBase.hasUpcomingConsultations'))
      .value;

  late final _$requestStatusAtom =
      Atom(name: 'DoctorDashboardStoreBase.requestStatus', context: context);

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

  late final _$doctorSpecialtyAtom =
      Atom(name: 'DoctorDashboardStoreBase.doctorSpecialty', context: context);

  @override
  String? get doctorSpecialty {
    _$doctorSpecialtyAtom.reportRead();
    return super.doctorSpecialty;
  }

  @override
  set doctorSpecialty(String? value) {
    _$doctorSpecialtyAtom.reportWrite(value, super.doctorSpecialty, () {
      super.doctorSpecialty = value;
    });
  }

  late final _$todayConsultationsAtom = Atom(
      name: 'DoctorDashboardStoreBase.todayConsultations', context: context);

  @override
  int get todayConsultations {
    _$todayConsultationsAtom.reportRead();
    return super.todayConsultations;
  }

  @override
  set todayConsultations(int value) {
    _$todayConsultationsAtom.reportWrite(value, super.todayConsultations, () {
      super.todayConsultations = value;
    });
  }

  late final _$totalPatientsAtom =
      Atom(name: 'DoctorDashboardStoreBase.totalPatients', context: context);

  @override
  int get totalPatients {
    _$totalPatientsAtom.reportRead();
    return super.totalPatients;
  }

  @override
  set totalPatients(int value) {
    _$totalPatientsAtom.reportWrite(value, super.totalPatients, () {
      super.totalPatients = value;
    });
  }

  late final _$averageRatingAtom =
      Atom(name: 'DoctorDashboardStoreBase.averageRating', context: context);

  @override
  double get averageRating {
    _$averageRatingAtom.reportRead();
    return super.averageRating;
  }

  @override
  set averageRating(double value) {
    _$averageRatingAtom.reportWrite(value, super.averageRating, () {
      super.averageRating = value;
    });
  }

  late final _$upcomingConsultationsAtom = Atom(
      name: 'DoctorDashboardStoreBase.upcomingConsultations', context: context);

  @override
  ObservableList<Map<String, dynamic>> get upcomingConsultations {
    _$upcomingConsultationsAtom.reportRead();
    return super.upcomingConsultations;
  }

  @override
  set upcomingConsultations(ObservableList<Map<String, dynamic>> value) {
    _$upcomingConsultationsAtom.reportWrite(value, super.upcomingConsultations,
        () {
      super.upcomingConsultations = value;
    });
  }

  late final _$loadDashboardDataAsyncAction = AsyncAction(
      'DoctorDashboardStoreBase.loadDashboardData',
      context: context);

  @override
  Future<void> loadDashboardData() {
    return _$loadDashboardDataAsyncAction.run(() => super.loadDashboardData());
  }

  late final _$loadUpcomingConsultationsAsyncAction = AsyncAction(
      'DoctorDashboardStoreBase.loadUpcomingConsultations',
      context: context);

  @override
  Future<void> loadUpcomingConsultations() {
    return _$loadUpcomingConsultationsAsyncAction
        .run(() => super.loadUpcomingConsultations());
  }

  late final _$refreshDataAsyncAction =
      AsyncAction('DoctorDashboardStoreBase.refreshData', context: context);

  @override
  Future<void> refreshData() {
    return _$refreshDataAsyncAction.run(() => super.refreshData());
  }

  late final _$DoctorDashboardStoreBaseActionController =
      ActionController(name: 'DoctorDashboardStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$DoctorDashboardStoreBaseActionController.startAction(
        name: 'DoctorDashboardStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$DoctorDashboardStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
requestStatus: ${requestStatus},
doctorSpecialty: ${doctorSpecialty},
todayConsultations: ${todayConsultations},
totalPatients: ${totalPatients},
averageRating: ${averageRating},
upcomingConsultations: ${upcomingConsultations},
hasUpcomingConsultations: ${hasUpcomingConsultations}
    ''';
  }
}
