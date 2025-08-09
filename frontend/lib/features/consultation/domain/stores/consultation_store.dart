import 'package:medical_consultation_app/features/consultation/data/models/time_slot_model.dart';
import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import 'package:medical_consultation_app/features/consultation/data/models/consultation_model.dart';
import 'package:medical_consultation_app/features/consultation/data/services/consultation_service.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

part 'consultation_store.g.dart';

@injectable
class ConsultationStore = ConsultationStoreBase with _$ConsultationStore;

abstract class ConsultationStoreBase with Store {
  final _consultationService = getIt<ConsultationService>();

  @observable
  ObservableList<ConsultationModel> consultations =
      ObservableList<ConsultationModel>();

  @observable
  ConsultationModel? selectedConsultation;

  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

  @observable
  RequestStatusEnum doctorsRequestStatus = RequestStatusEnum.none;

  @observable
  RequestStatusEnum slotsRequestStatus = RequestStatusEnum.none;

  @observable
  String? errorMessage;

  @observable
  String selectedStatus = '';

  @observable
  DateTime selectedDate = DateTime.now();

  @observable
  ObservableList<TimeSlotModel> availableSlots =
      ObservableList<TimeSlotModel>();

  @observable
  ObservableList<Map<String, dynamic>> availableDoctors =
      ObservableList<Map<String, dynamic>>();

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
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;
    final result = await _consultationService.getConsultations(
      status: status,
      userId: userId,
      userType: userType,
    );
    if (result.success) {
      consultations.clear();
      consultations.addAll(result.data);
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao buscar consultas';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadConsultation(String consultationId) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.getConsultation(consultationId);
    if (result.success) {
      selectedConsultation = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao buscar consulta';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> scheduleConsultation({
    required String patientId,
    required String doctorId,
    required DateTime scheduledAt,
    String? notes,
    String? symptoms,
  }) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.scheduleConsultation(
      patientId: patientId,
      doctorId: doctorId,
      scheduledAt: scheduledAt,
      notes: notes,
      symptoms: symptoms,
    );
    if (result.success) {
      consultations.add(result.data);
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao agendar consulta';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> updateConsultation({
    required String consultationId,
    DateTime? scheduledAt,
    String? notes,
    String? symptoms,
    String? diagnosis,
    String? prescription,
  }) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.updateConsultation(
      consultationId: consultationId,
      scheduledAt: scheduledAt,
      notes: notes,
      symptoms: symptoms,
      diagnosis: diagnosis,
      prescription: prescription,
    );
    if (result.success) {
      final updatedConsultation = result.data;
      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = updatedConsultation;
      }
      if (selectedConsultation?.id == consultationId) {
        selectedConsultation = updatedConsultation;
      }
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao atualizar consulta';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> cancelConsultation(String consultationId) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result =
        await _consultationService.cancelConsultation(consultationId);
    if (result.success) {
      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = consultations[index].copyWith(
          status: 'CANCELLED',
        );
      }
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao cancelar consulta';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> startConsultation(String consultationId) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.startConsultation(consultationId);
    if (result.success) {
      final consultation = result.data;
      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = consultation;
      }
      if (selectedConsultation?.id == consultationId) {
        selectedConsultation = consultation;
      }
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao iniciar consulta';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> endConsultation(String consultationId) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.endConsultation(consultationId);
    if (result.success) {
      final consultation = result.data;
      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = consultation;
      }
      if (selectedConsultation?.id == consultationId) {
        selectedConsultation = consultation;
      }
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao finalizar consulta';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> rateConsultation({
    required String consultationId,
    required double rating,
    String? review,
  }) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.rateConsultation(
      consultationId: consultationId,
      rating: rating,
      review: review,
    );
    if (result.success) {
      final index = consultations.indexWhere((c) => c.id == consultationId);
      if (index != -1) {
        consultations[index] = consultations[index].copyWith(
          rating: rating,
          review: review,
        );
      }
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao avaliar consulta';
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadAvailableSlots({
    required String doctorId,
    required DateTime date,
  }) async {
    slotsRequestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.getAvailableSlots(
      doctorId: doctorId,
      date: date,
    );
    if (result.success) {
      availableSlots.clear();
      availableSlots.addAll(result.data);
      slotsRequestStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          (result.error as String?) ?? 'Erro ao buscar horários disponíveis';
      slotsRequestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadAvailableDoctors({
    String? specialty,
    DateTime? date,
  }) async {
    doctorsRequestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.getAvailableDoctors(
      specialty: specialty,
      date: date,
    );
    if (result.success) {
      availableDoctors.clear();
      availableDoctors.addAll(result.data);
      doctorsRequestStatus = RequestStatusEnum.success;
    } else {
      errorMessage =
          (result.error as String?) ?? 'Erro ao buscar médicos disponíveis';
      doctorsRequestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> loadStats({
    String? userId,
    String? userType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    requestStatus = RequestStatusEnum.loading;
    errorMessage = null;

    final result = await _consultationService.getConsultationStats(
      userId: userId,
      userType: userType,
      startDate: startDate,
      endDate: endDate,
    );
    if (result.success) {
      stats = result.data;
      requestStatus = RequestStatusEnum.success;
    } else {
      errorMessage = (result.error as String?) ?? 'Erro ao buscar estatísticas';
      requestStatus = RequestStatusEnum.fail;
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
