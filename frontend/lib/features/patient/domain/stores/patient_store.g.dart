// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PatientStore on PatientStoreBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError =>
      (_$hasErrorComputed ??= Computed<bool>(() => super.hasError,
              name: 'PatientStoreBase.hasError'))
          .value;
  Computed<bool>? _$hasConsultationsComputed;

  @override
  bool get hasConsultations => (_$hasConsultationsComputed ??= Computed<bool>(
          () => super.hasConsultations,
          name: 'PatientStoreBase.hasConsultations'))
      .value;

  late final _$isLoadingAtom =
      Atom(name: 'PatientStoreBase.isLoading', context: context);

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

  late final _$errorAtom =
      Atom(name: 'PatientStoreBase.error', context: context);

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

  late final _$recentConsultationsAtom =
      Atom(name: 'PatientStoreBase.recentConsultations', context: context);

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

  late final _$totalConsultationsAtom =
      Atom(name: 'PatientStoreBase.totalConsultations', context: context);

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

  late final _$completedConsultationsAtom =
      Atom(name: 'PatientStoreBase.completedConsultations', context: context);

  @override
  int get completedConsultations {
    _$completedConsultationsAtom.reportRead();
    return super.completedConsultations;
  }

  @override
  set completedConsultations(int value) {
    _$completedConsultationsAtom
        .reportWrite(value, super.completedConsultations, () {
      super.completedConsultations = value;
    });
  }

  late final _$pendingConsultationsAtom =
      Atom(name: 'PatientStoreBase.pendingConsultations', context: context);

  @override
  int get pendingConsultations {
    _$pendingConsultationsAtom.reportRead();
    return super.pendingConsultations;
  }

  @override
  set pendingConsultations(int value) {
    _$pendingConsultationsAtom.reportWrite(value, super.pendingConsultations,
        () {
      super.pendingConsultations = value;
    });
  }

  late final _$averageRatingAtom =
      Atom(name: 'PatientStoreBase.averageRating', context: context);

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

  late final _$loadDashboardDataAsyncAction =
      AsyncAction('PatientStoreBase.loadDashboardData', context: context);

  @override
  Future<void> loadDashboardData() {
    return _$loadDashboardDataAsyncAction.run(() => super.loadDashboardData());
  }

  late final _$loadRecentConsultationsAsyncAction =
      AsyncAction('PatientStoreBase.loadRecentConsultations', context: context);

  @override
  Future<void> loadRecentConsultations() {
    return _$loadRecentConsultationsAsyncAction
        .run(() => super.loadRecentConsultations());
  }

  late final _$loadStatisticsAsyncAction =
      AsyncAction('PatientStoreBase.loadStatistics', context: context);

  @override
  Future<void> loadStatistics() {
    return _$loadStatisticsAsyncAction.run(() => super.loadStatistics());
  }

  late final _$refreshDataAsyncAction =
      AsyncAction('PatientStoreBase.refreshData', context: context);

  @override
  Future<void> refreshData() {
    return _$refreshDataAsyncAction.run(() => super.refreshData());
  }

  late final _$PatientStoreBaseActionController =
      ActionController(name: 'PatientStoreBase', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$PatientStoreBaseActionController.startAction(
        name: 'PatientStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$PatientStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
error: ${error},
recentConsultations: ${recentConsultations},
totalConsultations: ${totalConsultations},
completedConsultations: ${completedConsultations},
pendingConsultations: ${pendingConsultations},
averageRating: ${averageRating},
hasError: ${hasError},
hasConsultations: ${hasConsultations}
    ''';
  }
}
