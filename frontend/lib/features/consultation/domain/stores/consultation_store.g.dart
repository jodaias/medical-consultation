// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConsultationStore on ConsultationStoreBase, Store {
  Computed<List<ConsultationModel>>? _$scheduledConsultationsComputed;

  @override
  List<ConsultationModel> get scheduledConsultations =>
      (_$scheduledConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.scheduledConsultations,
              name: 'ConsultationStoreBase.scheduledConsultations'))
          .value;
  Computed<List<ConsultationModel>>? _$inProgressConsultationsComputed;

  @override
  List<ConsultationModel> get inProgressConsultations =>
      (_$inProgressConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.inProgressConsultations,
              name: 'ConsultationStoreBase.inProgressConsultations'))
          .value;
  Computed<List<ConsultationModel>>? _$completedConsultationsComputed;

  @override
  List<ConsultationModel> get completedConsultations =>
      (_$completedConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.completedConsultations,
              name: 'ConsultationStoreBase.completedConsultations'))
          .value;
  Computed<List<ConsultationModel>>? _$todayConsultationsComputed;

  @override
  List<ConsultationModel> get todayConsultations =>
      (_$todayConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.todayConsultations,
              name: 'ConsultationStoreBase.todayConsultations'))
          .value;
  Computed<List<ConsultationModel>>? _$upcomingConsultationsComputed;

  @override
  List<ConsultationModel> get upcomingConsultations =>
      (_$upcomingConsultationsComputed ??= Computed<List<ConsultationModel>>(
              () => super.upcomingConsultations,
              name: 'ConsultationStoreBase.upcomingConsultations'))
          .value;
  Computed<int>? _$totalConsultationsComputed;

  @override
  int get totalConsultations => (_$totalConsultationsComputed ??= Computed<int>(
          () => super.totalConsultations,
          name: 'ConsultationStoreBase.totalConsultations'))
      .value;
  Computed<int>? _$pendingConsultationsComputed;

  @override
  int get pendingConsultations => (_$pendingConsultationsComputed ??=
          Computed<int>(() => super.pendingConsultations,
              name: 'ConsultationStoreBase.pendingConsultations'))
      .value;

  late final _$consultationsAtom =
      Atom(name: 'ConsultationStoreBase.consultations', context: context);

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

  late final _$selectedConsultationAtom = Atom(
      name: 'ConsultationStoreBase.selectedConsultation', context: context);

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

  late final _$requestStatusAtom =
      Atom(name: 'ConsultationStoreBase.requestStatus', context: context);

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

  late final _$doctorsRequestStatusAtom = Atom(
      name: 'ConsultationStoreBase.doctorsRequestStatus', context: context);

  @override
  RequestStatusEnum get doctorsRequestStatus {
    _$doctorsRequestStatusAtom.reportRead();
    return super.doctorsRequestStatus;
  }

  @override
  set doctorsRequestStatus(RequestStatusEnum value) {
    _$doctorsRequestStatusAtom.reportWrite(value, super.doctorsRequestStatus,
        () {
      super.doctorsRequestStatus = value;
    });
  }

  late final _$slotsRequestStatusAtom =
      Atom(name: 'ConsultationStoreBase.slotsRequestStatus', context: context);

  @override
  RequestStatusEnum get slotsRequestStatus {
    _$slotsRequestStatusAtom.reportRead();
    return super.slotsRequestStatus;
  }

  @override
  set slotsRequestStatus(RequestStatusEnum value) {
    _$slotsRequestStatusAtom.reportWrite(value, super.slotsRequestStatus, () {
      super.slotsRequestStatus = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'ConsultationStoreBase.errorMessage', context: context);

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
      Atom(name: 'ConsultationStoreBase.selectedStatus', context: context);

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
      Atom(name: 'ConsultationStoreBase.selectedDate', context: context);

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
      Atom(name: 'ConsultationStoreBase.availableSlots', context: context);

  @override
  ObservableList<TimeSlotModel> get availableSlots {
    _$availableSlotsAtom.reportRead();
    return super.availableSlots;
  }

  @override
  set availableSlots(ObservableList<TimeSlotModel> value) {
    _$availableSlotsAtom.reportWrite(value, super.availableSlots, () {
      super.availableSlots = value;
    });
  }

  late final _$availableDoctorsAtom =
      Atom(name: 'ConsultationStoreBase.availableDoctors', context: context);

  @override
  ObservableList<Map<String, dynamic>> get availableDoctors {
    _$availableDoctorsAtom.reportRead();
    return super.availableDoctors;
  }

  @override
  set availableDoctors(ObservableList<Map<String, dynamic>> value) {
    _$availableDoctorsAtom.reportWrite(value, super.availableDoctors, () {
      super.availableDoctors = value;
    });
  }

  late final _$statsAtom =
      Atom(name: 'ConsultationStoreBase.stats', context: context);

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
      AsyncAction('ConsultationStoreBase.loadConsultations', context: context);

  @override
  Future<void> loadConsultations(
      {String? status, String? userId, String? userType}) {
    return _$loadConsultationsAsyncAction.run(() => super
        .loadConsultations(status: status, userId: userId, userType: userType));
  }

  late final _$loadConsultationAsyncAction =
      AsyncAction('ConsultationStoreBase.loadConsultation', context: context);

  @override
  Future<void> loadConsultation(String consultationId) {
    return _$loadConsultationAsyncAction
        .run(() => super.loadConsultation(consultationId));
  }

  late final _$scheduleConsultationAsyncAction = AsyncAction(
      'ConsultationStoreBase.scheduleConsultation',
      context: context);

  @override
  Future<void> scheduleConsultation(
      {required String patientId,
      required String doctorId,
      required DateTime scheduledAt,
      String? notes,
      String? symptoms}) {
    return _$scheduleConsultationAsyncAction.run(() => super
        .scheduleConsultation(
            patientId: patientId,
            doctorId: doctorId,
            scheduledAt: scheduledAt,
            notes: notes,
            symptoms: symptoms));
  }

  late final _$updateConsultationAsyncAction =
      AsyncAction('ConsultationStoreBase.updateConsultation', context: context);

  @override
  Future<void> updateConsultation(
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
      AsyncAction('ConsultationStoreBase.cancelConsultation', context: context);

  @override
  Future<void> cancelConsultation(String consultationId) {
    return _$cancelConsultationAsyncAction
        .run(() => super.cancelConsultation(consultationId));
  }

  late final _$startConsultationAsyncAction =
      AsyncAction('ConsultationStoreBase.startConsultation', context: context);

  @override
  Future<void> startConsultation(String consultationId) {
    return _$startConsultationAsyncAction
        .run(() => super.startConsultation(consultationId));
  }

  late final _$endConsultationAsyncAction =
      AsyncAction('ConsultationStoreBase.endConsultation', context: context);

  @override
  Future<void> endConsultation(String consultationId) {
    return _$endConsultationAsyncAction
        .run(() => super.endConsultation(consultationId));
  }

  late final _$rateConsultationAsyncAction =
      AsyncAction('ConsultationStoreBase.rateConsultation', context: context);

  @override
  Future<void> rateConsultation(
      {required String consultationId,
      required double rating,
      String? review}) {
    return _$rateConsultationAsyncAction.run(() => super.rateConsultation(
        consultationId: consultationId, rating: rating, review: review));
  }

  late final _$loadAvailableSlotsAsyncAction =
      AsyncAction('ConsultationStoreBase.loadAvailableSlots', context: context);

  @override
  Future<void> loadAvailableSlots(
      {required String doctorId, required DateTime date}) {
    return _$loadAvailableSlotsAsyncAction
        .run(() => super.loadAvailableSlots(doctorId: doctorId, date: date));
  }

  late final _$loadAvailableDoctorsAsyncAction = AsyncAction(
      'ConsultationStoreBase.loadAvailableDoctors',
      context: context);

  @override
  Future<void> loadAvailableDoctors({String? specialty, DateTime? date}) {
    return _$loadAvailableDoctorsAsyncAction.run(
        () => super.loadAvailableDoctors(specialty: specialty, date: date));
  }

  late final _$loadStatsAsyncAction =
      AsyncAction('ConsultationStoreBase.loadStats', context: context);

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

  late final _$ConsultationStoreBaseActionController =
      ActionController(name: 'ConsultationStoreBase', context: context);

  @override
  void setSelectedStatus(String status) {
    final _$actionInfo = _$ConsultationStoreBaseActionController.startAction(
        name: 'ConsultationStoreBase.setSelectedStatus');
    try {
      return super.setSelectedStatus(status);
    } finally {
      _$ConsultationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDate(DateTime date) {
    final _$actionInfo = _$ConsultationStoreBaseActionController.startAction(
        name: 'ConsultationStoreBase.setSelectedDate');
    try {
      return super.setSelectedDate(date);
    } finally {
      _$ConsultationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedConsultation(ConsultationModel? consultation) {
    final _$actionInfo = _$ConsultationStoreBaseActionController.startAction(
        name: 'ConsultationStoreBase.setSelectedConsultation');
    try {
      return super.setSelectedConsultation(consultation);
    } finally {
      _$ConsultationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$ConsultationStoreBaseActionController.startAction(
        name: 'ConsultationStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$ConsultationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearConsultations() {
    final _$actionInfo = _$ConsultationStoreBaseActionController.startAction(
        name: 'ConsultationStoreBase.clearConsultations');
    try {
      return super.clearConsultations();
    } finally {
      _$ConsultationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
consultations: ${consultations},
selectedConsultation: ${selectedConsultation},
requestStatus: ${requestStatus},
doctorsRequestStatus: ${doctorsRequestStatus},
slotsRequestStatus: ${slotsRequestStatus},
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
