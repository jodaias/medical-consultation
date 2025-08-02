// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConsultationStore on _ConsultationStore, Store {
  Computed<List<ConsultationModel>>? _$scheduledConsultationsComputed;

  @override
  List<ConsultationModel> get scheduledConsultations =>
      (_$scheduledConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.scheduledConsultations,
              name: '_ConsultationStore.scheduledConsultations'))
          .value;
  Computed<List<ConsultationModel>>? _$inProgressConsultationsComputed;

  @override
  List<ConsultationModel> get inProgressConsultations =>
      (_$inProgressConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.inProgressConsultations,
              name: '_ConsultationStore.inProgressConsultations'))
          .value;
  Computed<List<ConsultationModel>>? _$completedConsultationsComputed;

  @override
  List<ConsultationModel> get completedConsultations =>
      (_$completedConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.completedConsultations,
              name: '_ConsultationStore.completedConsultations'))
          .value;
  Computed<List<ConsultationModel>>? _$todayConsultationsComputed;

  @override
  List<ConsultationModel> get todayConsultations =>
      (_$todayConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.todayConsultations,
              name: '_ConsultationStore.todayConsultations'))
          .value;
  Computed<List<ConsultationModel>>? _$upcomingConsultationsComputed;

  @override
  List<ConsultationModel> get upcomingConsultations =>
      (_$upcomingConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.upcomingConsultations,
              name: '_ConsultationStore.upcomingConsultations'))
          .value;
  Computed<int>? _$totalConsultationsComputed;

  @override
  int get totalConsultations => (_$totalConsultationsComputed ??= Computed<int>(
          () => super.totalConsultations,
          name: '_ConsultationStore.totalConsultations'))
      .value;
  Computed<int>? _$pendingConsultationsComputed;

  @override
  int get pendingConsultations => (_$pendingConsultationsComputed ??=
          Computed<int>(() => super.pendingConsultations,
              name: '_ConsultationStore.pendingConsultations'))
      .value;

  late final _$consultationsAtom =
      Atom(name: '_ConsultationStore.consultations', context: context);

  @override
  ObservableList<ConsultationModel> get consultations {
    _$consultationsAtom.reportRead();
    return super.consultations;
  }

  @override
  set consultations(ObservableList<ConsultationModel> value) {
    _$consultationsAtom.reportWrite(value, super.consultations, () {
      super.consultations = value;
    });
  }

  late final _$selectedConsultationAtom =
      Atom(name: '_ConsultationStore.selectedConsultation', context: context);

  @override
  ConsultationModel? get selectedConsultation {
    _$selectedConsultationAtom.reportRead();
    return super.selectedConsultation;
  }

  @override
  set selectedConsultation(ConsultationModel? value) {
    _$selectedConsultationAtom.reportWrite(value, super.selectedConsultation,
        () {
      super.selectedConsultation = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ConsultationStore.isLoading', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_ConsultationStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$selectedStatusAtom =
      Atom(name: '_ConsultationStore.selectedStatus', context: context);

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

  late final _$selectedDateAtom =
      Atom(name: '_ConsultationStore.selectedDate', context: context);

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$availableSlotsAtom =
      Atom(name: '_ConsultationStore.availableSlots', context: context);

  @override
  List<DateTime> get availableSlots {
    _$availableSlotsAtom.reportRead();
    return super.availableSlots;
  }

  @override
  set availableSlots(List<DateTime> value) {
    _$availableSlotsAtom.reportWrite(value, super.availableSlots, () {
      super.availableSlots = value;
    });
  }

  late final _$availableDoctorsAtom =
      Atom(name: '_ConsultationStore.availableDoctors', context: context);

  @override
  List<Map<String, dynamic>> get availableDoctors {
    _$availableDoctorsAtom.reportRead();
    return super.availableDoctors;
  }

  @override
  set availableDoctors(List<Map<String, dynamic>> value) {
    _$availableDoctorsAtom.reportWrite(value, super.availableDoctors, () {
      super.availableDoctors = value;
    });
  }

  late final _$statsAtom =
      Atom(name: '_ConsultationStore.stats', context: context);

  @override
  Map<String, dynamic> get stats {
    _$statsAtom.reportRead();
    return super.stats;
  }

  @override
  set stats(Map<String, dynamic> value) {
    _$statsAtom.reportWrite(value, super.stats, () {
      super.stats = value;
    });
  }

  late final _$loadConsultationsAsyncAction =
      AsyncAction('_ConsultationStore.loadConsultations', context: context);

  @override
  Future<void> loadConsultations(
      {String? status, String? userId, String? userType}) {
    return _$loadConsultationsAsyncAction.run(() => super
        .loadConsultations(status: status, userId: userId, userType: userType));
  }

  late final _$loadConsultationAsyncAction =
      AsyncAction('_ConsultationStore.loadConsultation', context: context);

  @override
  Future<void> loadConsultation(String consultationId) {
    return _$loadConsultationAsyncAction
        .run(() => super.loadConsultation(consultationId));
  }

  late final _$scheduleConsultationAsyncAction =
      AsyncAction('_ConsultationStore.scheduleConsultation', context: context);

  @override
  Future<bool> scheduleConsultation(
      {required String doctorId,
      required DateTime scheduledAt,
      String? notes,
      String? symptoms}) {
    return _$scheduleConsultationAsyncAction.run(() => super
        .scheduleConsultation(
            doctorId: doctorId,
            scheduledAt: scheduledAt,
            notes: notes,
            symptoms: symptoms));
  }

  late final _$updateConsultationAsyncAction =
      AsyncAction('_ConsultationStore.updateConsultation', context: context);

  @override
  Future<bool> updateConsultation(
      {required String consultationId,
      DateTime? scheduledAt,
      String? notes,
      String? symptoms,
      String? diagnosis,
      String? prescription}) {
    return _$updateConsultationAsyncAction.run(() => super.updateConsultation(
        consultationId: consultationId,
        scheduledAt: scheduledAt,
        notes: notes,
        symptoms: symptoms,
        diagnosis: diagnosis,
        prescription: prescription));
  }

  late final _$cancelConsultationAsyncAction =
      AsyncAction('_ConsultationStore.cancelConsultation', context: context);

  @override
  Future<bool> cancelConsultation(String consultationId) {
    return _$cancelConsultationAsyncAction
        .run(() => super.cancelConsultation(consultationId));
  }

  late final _$startConsultationAsyncAction =
      AsyncAction('_ConsultationStore.startConsultation', context: context);

  @override
  Future<bool> startConsultation(String consultationId) {
    return _$startConsultationAsyncAction
        .run(() => super.startConsultation(consultationId));
  }

  late final _$endConsultationAsyncAction =
      AsyncAction('_ConsultationStore.endConsultation', context: context);

  @override
  Future<bool> endConsultation(String consultationId) {
    return _$endConsultationAsyncAction
        .run(() => super.endConsultation(consultationId));
  }

  late final _$rateConsultationAsyncAction =
      AsyncAction('_ConsultationStore.rateConsultation', context: context);

  @override
  Future<bool> rateConsultation(
      {required String consultationId,
      required double rating,
      String? review}) {
    return _$rateConsultationAsyncAction.run(() => super.rateConsultation(
        consultationId: consultationId, rating: rating, review: review));
  }

  late final _$loadAvailableSlotsAsyncAction =
      AsyncAction('_ConsultationStore.loadAvailableSlots', context: context);

  @override
  Future<void> loadAvailableSlots(
      {required String doctorId, required DateTime date}) {
    return _$loadAvailableSlotsAsyncAction
        .run(() => super.loadAvailableSlots(doctorId: doctorId, date: date));
  }

  late final _$loadAvailableDoctorsAsyncAction =
      AsyncAction('_ConsultationStore.loadAvailableDoctors', context: context);

  @override
  Future<void> loadAvailableDoctors({String? specialty, DateTime? date}) {
    return _$loadAvailableDoctorsAsyncAction.run(
        () => super.loadAvailableDoctors(specialty: specialty, date: date));
  }

  late final _$loadStatsAsyncAction =
      AsyncAction('_ConsultationStore.loadStats', context: context);

  @override
  Future<void> loadStats(
      {String? userId,
      String? userType,
      DateTime? startDate,
      DateTime? endDate}) {
    return _$loadStatsAsyncAction.run(() => super.loadStats(
        userId: userId,
        userType: userType,
        startDate: startDate,
        endDate: endDate));
  }

  late final _$_ConsultationStoreActionController =
      ActionController(name: '_ConsultationStore', context: context);

  @override
  void setSelectedStatus(String status) {
    final _$actionInfo = _$_ConsultationStoreActionController.startAction(
        name: '_ConsultationStore.setSelectedStatus');
    try {
      return super.setSelectedStatus(status);
    } finally {
      _$_ConsultationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDate(DateTime date) {
    final _$actionInfo = _$_ConsultationStoreActionController.startAction(
        name: '_ConsultationStore.setSelectedDate');
    try {
      return super.setSelectedDate(date);
    } finally {
      _$_ConsultationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedConsultation(ConsultationModel? consultation) {
    final _$actionInfo = _$_ConsultationStoreActionController.startAction(
        name: '_ConsultationStore.setSelectedConsultation');
    try {
      return super.setSelectedConsultation(consultation);
    } finally {
      _$_ConsultationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_ConsultationStoreActionController.startAction(
        name: '_ConsultationStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ConsultationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearConsultations() {
    final _$actionInfo = _$_ConsultationStoreActionController.startAction(
        name: '_ConsultationStore.clearConsultations');
    try {
      return super.clearConsultations();
    } finally {
      _$_ConsultationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
consultations: ${consultations},
selectedConsultation: ${selectedConsultation},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
selectedStatus: ${selectedStatus},
selectedDate: ${selectedDate},
availableSlots: ${availableSlots},
availableDoctors: ${availableDoctors},
stats: ${stats},
scheduledConsultations: ${scheduledConsultations},
inProgressConsultations: ${inProgressConsultations},
completedConsultations: ${completedConsultations},
todayConsultations: ${todayConsultations},
upcomingConsultations: ${upcomingConsultations},
totalConsultations: ${totalConsultations},
pendingConsultations: ${pendingConsultations}
    ''';
  }
}
