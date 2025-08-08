import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/data/models/doctor_schedule_model.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';
import 'package:mobx/mobx.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/data/services/doctor_scheduling_service.dart';

part 'doctor_scheduling_store.g.dart';

class DoctorSchedulingStore = DoctorSchedulingStoreBase
    with _$DoctorSchedulingStore;

abstract class DoctorSchedulingStoreBase with Store {
  final _schedulingService = getIt<DoctorSchedulingService>();

  // Observables
  @observable
  ObservableList<DoctorScheduleModel> schedules =
      ObservableList<DoctorScheduleModel>();

  @observable
  RequestStatusEnum requestStatus = RequestStatusEnum.none;

  @observable
  String? error;

  // Computed

  // Actions
  @action
  void clearFilters() {
    // Clear all filters
  }

  @action
  Future<void> loadSchedules(String doctorId) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _schedulingService.getSchedules(
      doctorId: doctorId,
    );
    if (result.success) {
      schedules.clear();
      schedules.addAll(result.data);
      requestStatus = RequestStatusEnum.success;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> saveSchedules({
    required String doctorId,
    required List<DoctorScheduleModel> schedulesPayload,
  }) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _schedulingService.saveSchedules(
      doctorId: doctorId,
      schedulesPayload: schedulesPayload,
    );
    if (result.success) {
      schedules.clear();
      schedules.addAll(result.data);
      requestStatus = RequestStatusEnum.success;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  Future<void> updateSchedule({
    required String doctorId,
    required DoctorScheduleModel schedulePayload,
  }) async {
    requestStatus = RequestStatusEnum.loading;
    error = null;
    final result = await _schedulingService.updateSchedule(
      doctorId: doctorId,
      schedulePayload: schedulePayload,
    );
    if (result.success) {
      final index = schedules.indexWhere((s) => s.id == schedulePayload.id);
      if (index != -1) {
        schedules[index] = result.data;
      }
      requestStatus = RequestStatusEnum.success;
    } else {
      error = result.error?.toString();
      requestStatus = RequestStatusEnum.fail;
    }
  }

  @action
  void clearError() {
    error = null;
  }
}
