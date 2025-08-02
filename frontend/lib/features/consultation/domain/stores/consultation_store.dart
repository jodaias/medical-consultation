import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/features/consultation/data/models/consultation_model.dart';
import 'package:medical_consultation_app/features/consultation/data/services/consultation_service.dart';

part 'consultation_store.g.dart';

@injectable
class ConsultationStore = _ConsultationStore with _$ConsultationStore;

abstract class _ConsultationStore with Store {
  final ConsultationService _consultationService = ConsultationService();

  @observable
  ObservableList<ConsultationModel> consultations =
      ObservableList<ConsultationModel>();

  @observable
  ConsultationModel? selectedConsultation;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String selectedStatus = '';

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  List<DateTime> availableSlots = [];

  @observable
  List<Map<String, dynamic>> availableDoctors = [];

  @observable
  Map<String, dynamic> stats = {};

  @computed
  List<ConsultationModel> get scheduledConsultations =>
      consultations.where((c) => c.isScheduled).toList();

  @computed
  List<ConsultationModel> get inProgressConsultations =>
      consultations.where((c) => c.isInProgress).toList();

  @computed
  List<ConsultationModel> get completedConsultations =>
      consultations.where((c) => c.isCompleted).toList();

  @computed
  List<ConsultationModel> get todayConsultations => consultations
      .where((c) =>
          c.scheduledAt.day == DateTime.now().day &&
          c.scheduledAt.month == DateTime.now().month &&
          c.scheduledAt.year == DateTime.now().year)
      .toList();

  @computed
  List<ConsultationModel> get upcomingConsultations => consultations
      .where((c) => c.scheduledAt.isAfter(DateTime.now()) && c.isScheduled)
      .toList();

  @computed
  int get totalConsultations => consultations.length;

  @computed
  int get pendingConsultations => scheduledConsultations.length;

  @action
  Future<void> loadConsultations({
    String? status,
    String? userId,
    String? userType,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final consultationsList = await _consultationService.getConsultations(
        status: status,
        userId: userId,
        userType: userType,
      );

      consultations.clear();
      consultations.addAll(consultationsList);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadConsultation(String consultationId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final consultation =
          await _consultationService.getConsultation(consultationId);
      selectedConsultation = consultation;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> scheduleConsultation({
    required String doctorId,
    required DateTime scheduledAt,
    String? notes,
    String? symptoms,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final consultation = await _consultationService.scheduleConsultation(
        doctorId: doctorId,
        scheduledAt: scheduledAt,
        notes: notes,
        symptoms: symptoms,
      );

      consultations.add(consultation);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateConsultation({
    required String consultationId,
    DateTime? scheduledAt,
    String? notes,
    String? symptoms,
    String? diagnosis,
    String? prescription,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final updatedConsultation = await _consultationService.updateConsultation(
        consultationId: consultationId,
        scheduledAt: scheduledAt,
        notes: notes,
        symptoms: symptoms,
        diagnosis: diagnosis,
        prescription: prescription,
      );

      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = updatedConsultation;
      }

      if (selectedConsultation?.id == consultationId) {
        selectedConsultation = updatedConsultation;
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> cancelConsultation(String consultationId) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _consultationService.cancelConsultation(consultationId);

      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = consultations[index].copyWith(
          status: 'CANCELLED',
        );
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> startConsultation(String consultationId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final consultation =
          await _consultationService.startConsultation(consultationId);

      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = consultation;
      }

      if (selectedConsultation?.id == consultationId) {
        selectedConsultation = consultation;
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> endConsultation(String consultationId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final consultation =
          await _consultationService.endConsultation(consultationId);

      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = consultation;
      }

      if (selectedConsultation?.id == consultationId) {
        selectedConsultation = consultation;
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> rateConsultation({
    required String consultationId,
    required double rating,
    String? review,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _consultationService.rateConsultation(
        consultationId: consultationId,
        rating: rating,
        review: review,
      );

      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = consultations[index].copyWith(
          rating: rating,
          review: review,
        );
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final slots = await _consultationService.getAvailableSlots(
        doctorId: doctorId,
        date: date,
      );

      availableSlots.clear();
      availableSlots.addAll(slots);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadAvailableDoctors({
    String? specialty,
    DateTime? date,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final doctors = await _consultationService.getAvailableDoctors(
        specialty: specialty,
        date: date,
      );

      availableDoctors.clear();
      availableDoctors.addAll(doctors);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadStats({
    String? userId,
    String? userType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final statsData = await _consultationService.getConsultationStats(
        userId: userId,
        userType: userType,
        startDate: startDate,
        endDate: endDate,
      );

      stats = statsData;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  void setSelectedStatus(String status) {
    selectedStatus = status;
  }

  @action
  void setSelectedDate(DateTime date) {
    selectedDate = date;
  }

  @action
  void setSelectedConsultation(ConsultationModel? consultation) {
    selectedConsultation = consultation;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @action
  void clearConsultations() {
    consultations.clear();
    selectedConsultation = null;
  }
}
