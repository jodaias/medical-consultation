// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_dashboard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PatientDashboardStore on PatientDashboardStoreBase, Store {
  Computed<bool>? _$hasRecentConsultationsComputed;

  @override
  bool get hasRecentConsultations => (_$hasRecentConsultationsComputed ??=
          Computed<bool>(() => super.hasRecentConsultations,
              name: 'PatientDashboardStoreBase.hasRecentConsultations'))
      .value;
  Computed<bool>? _$hasFavoriteDoctorsComputed;

  @override
  bool get hasFavoriteDoctors => (_$hasFavoriteDoctorsComputed ??=
          Computed<bool>(() => super.hasFavoriteDoctors,
              name: 'PatientDashboardStoreBase.hasFavoriteDoctors'))
      .value;
  Computed<bool>? _$hasRecentPrescriptionsComputed;

  @override
  bool get hasRecentPrescriptions => (_$hasRecentPrescriptionsComputed ??=
          Computed<bool>(() => super.hasRecentPrescriptions,
              name: 'PatientDashboardStoreBase.hasRecentPrescriptions'))
      .value;

  late final _$totalConsultationsAtom = Atom(
      name: 'PatientDashboardStoreBase.totalConsultations', context: context);

  @override
  int get totalConsultations {
    _$totalConsultationsAtom.reportRead();
    return super.totalConsultations;
  }

  @override
  set totalConsultations(int value) {
    _$totalConsultationsAtom.reportWrite(value, super.totalConsultations, () {
      super.totalConsultations = value;
    });
  }

  late final _$upcomingConsultationsAtom = Atom(
      name: 'PatientDashboardStoreBase.upcomingConsultations',
      context: context);

  @override
  int get upcomingConsultations {
    _$upcomingConsultationsAtom.reportRead();
    return super.upcomingConsultations;
  }

  @override
  set upcomingConsultations(int value) {
    _$upcomingConsultationsAtom.reportWrite(value, super.upcomingConsultations,
        () {
      super.upcomingConsultations = value;
    });
  }

  late final _$totalSpentAtom =
      Atom(name: 'PatientDashboardStoreBase.totalSpent', context: context);

  @override
  double get totalSpent {
    _$totalSpentAtom.reportRead();
    return super.totalSpent;
  }

  @override
  set totalSpent(double value) {
    _$totalSpentAtom.reportWrite(value, super.totalSpent, () {
      super.totalSpent = value;
    });
  }

  late final _$recentConsultationsAtom = Atom(
      name: 'PatientDashboardStoreBase.recentConsultations', context: context);

  @override
  ObservableList<Map<String, dynamic>> get recentConsultations {
    _$recentConsultationsAtom.reportRead();
    return super.recentConsultations;
  }

  @override
  set recentConsultations(ObservableList<Map<String, dynamic>> value) {
    _$recentConsultationsAtom.reportWrite(value, super.recentConsultations, () {
      super.recentConsultations = value;
    });
  }

  late final _$favoriteDoctorsAtom =
      Atom(name: 'PatientDashboardStoreBase.favoriteDoctors', context: context);

  @override
  ObservableList<Map<String, dynamic>> get favoriteDoctors {
    _$favoriteDoctorsAtom.reportRead();
    return super.favoriteDoctors;
  }

  @override
  set favoriteDoctors(ObservableList<Map<String, dynamic>> value) {
    _$favoriteDoctorsAtom.reportWrite(value, super.favoriteDoctors, () {
      super.favoriteDoctors = value;
    });
  }

  late final _$recentPrescriptionsAtom = Atom(
      name: 'PatientDashboardStoreBase.recentPrescriptions', context: context);

  @override
  ObservableList<Map<String, dynamic>> get recentPrescriptions {
    _$recentPrescriptionsAtom.reportRead();
    return super.recentPrescriptions;
  }

  @override
  set recentPrescriptions(ObservableList<Map<String, dynamic>> value) {
    _$recentPrescriptionsAtom.reportWrite(value, super.recentPrescriptions, () {
      super.recentPrescriptions = value;
    });
  }

  late final _$loadDashboardDataAsyncAction = AsyncAction(
      'PatientDashboardStoreBase.loadDashboardData',
      context: context);

  @override
  Future<void> loadDashboardData() {
    return _$loadDashboardDataAsyncAction.run(() => super.loadDashboardData());
  }

  late final _$loadRecentConsultationsAsyncAction = AsyncAction(
      'PatientDashboardStoreBase.loadRecentConsultations',
      context: context);

  @override
  Future<void> loadRecentConsultations() {
    return _$loadRecentConsultationsAsyncAction
        .run(() => super.loadRecentConsultations());
  }

  late final _$loadFavoriteDoctorsAsyncAction = AsyncAction(
      'PatientDashboardStoreBase.loadFavoriteDoctors',
      context: context);

  @override
  Future<void> loadFavoriteDoctors() {
    return _$loadFavoriteDoctorsAsyncAction
        .run(() => super.loadFavoriteDoctors());
  }

  late final _$loadRecentPrescriptionsAsyncAction = AsyncAction(
      'PatientDashboardStoreBase.loadRecentPrescriptions',
      context: context);

  @override
  Future<void> loadRecentPrescriptions() {
    return _$loadRecentPrescriptionsAsyncAction
        .run(() => super.loadRecentPrescriptions());
  }

  late final _$refreshDataAsyncAction =
      AsyncAction('PatientDashboardStoreBase.refreshData', context: context);

  @override
  Future<void> refreshData() {
    return _$refreshDataAsyncAction.run(() => super.refreshData());
  }

  late final _$PatientDashboardStoreBaseActionController =
      ActionController(name: 'PatientDashboardStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$PatientDashboardStoreBaseActionController
        .startAction(name: 'PatientDashboardStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$PatientDashboardStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalConsultations: ${totalConsultations},
upcomingConsultations: ${upcomingConsultations},
totalSpent: ${totalSpent},
recentConsultations: ${recentConsultations},
favoriteDoctors: ${favoriteDoctors},
recentPrescriptions: ${recentPrescriptions},
hasRecentConsultations: ${hasRecentConsultations},
hasFavoriteDoctors: ${hasFavoriteDoctors},
hasRecentPrescriptions: ${hasRecentPrescriptions}
    ''';
  }
}
