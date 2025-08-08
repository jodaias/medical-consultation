import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/data/models/doctor_schedule_model.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/domain/stores/doctor_scheduling_store.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class DoctorScheduleEditPage extends StatefulWidget {
  final String doctorId;
  final DoctorScheduleModel schedule;

  const DoctorScheduleEditPage({
    super.key,
    required this.doctorId,
    required this.schedule,
  });

  @override
  State<DoctorScheduleEditPage> createState() => _DoctorScheduleEditPageState();
}

class _DoctorScheduleEditPageState extends State<DoctorScheduleEditPage> {
  final _doctorSchedulingStore = getIt<DoctorSchedulingStore>();

  final List<int> selectedDays = [];
  final Map<int, TimeOfDay?> startTimes = {};
  final Map<int, TimeOfDay?> endTimes = {};
  int consultationDuration = 30;

  final List<String> daysOfWeek = AppConstants.daysOfWeek.keys.toList();
  static const Map<String, String> daysOfWeekPt = AppConstants.daysOfWeek;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() {
      selectedDays.add(widget.schedule.dayOfWeek!);
      startTimes[widget.schedule.dayOfWeek!] =
          _parseTime(widget.schedule.startTime!);
      endTimes[widget.schedule.dayOfWeek!] =
          _parseTime(widget.schedule.endTime!);
      consultationDuration = widget.schedule.consultationDuration!;
    });
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Agenda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dia da semana:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(
                daysOfWeek.length,
                (i) => ChoiceChip(
                  label: Text(daysOfWeekPt[daysOfWeek[i]]!),
                  selected: selectedDays.contains(i),
                  onSelected: (selected) {
                    setState(() {
                      selectedDays.clear();
                      if (selected) {
                        selectedDays.add(i);
                        startTimes[i] ??= const TimeOfDay(hour: 8, minute: 0);
                        endTimes[i] ??= const TimeOfDay(hour: 12, minute: 0);
                      } else {
                        startTimes.remove(i);
                        endTimes.remove(i);
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Duração da consulta:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: consultationDuration,
                  items: [15, 20, 30, 45, 60]
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text('$d min'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => consultationDuration = v!),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedDays.isNotEmpty)
              ...selectedDays.map(
                (day) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          daysOfWeekPt[daysOfWeek[day]]!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  startTimes[day]?.format(context) ?? 'Início',
                                ),
                                leading: const Icon(Icons.access_time),
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: startTimes[day]!,
                                  );
                                  if (picked != null) {
                                    setState(() => startTimes[day] = picked);
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  endTimes[day]?.format(context) ?? 'Fim',
                                ),
                                leading: const Icon(Icons.access_time),
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: endTimes[day]!,
                                  );
                                  if (picked != null) {
                                    setState(() => endTimes[day] = picked);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Observer(builder: (_) {
              return ElevatedButton(
                onPressed: _doctorSchedulingStore.requestStatus ==
                        RequestStatusEnum.loading
                    ? null
                    : _updateSchedule,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _doctorSchedulingStore.requestStatus ==
                        RequestStatusEnum.loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text('Atualizar Agenda'),
                        ],
                      ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _updateSchedule() async {
    if (selectedDays.isEmpty) {
      ToastUtils.showWarningToast('Selecione pelo menos um dia.');
      return;
    }
    for (final day in selectedDays) {
      if (startTimes[day] == null || endTimes[day] == null) {
        ToastUtils.showWarningToast(
            'Defina horários para ${daysOfWeekPt[daysOfWeek[day]]!}.');
        return;
      }
    }

    final day = selectedDays.first;
    String formatTime(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    final payload = DoctorScheduleModel(
      id: widget.schedule.id,
      doctorId: widget.doctorId,
      dayOfWeek: day, // 0=Domingo, 6=Sábado
      startTime: formatTime(startTimes[day]!),
      endTime: formatTime(endTimes[day]!),
      consultationDuration: consultationDuration,
      isAvailable: true,
    );

    await _doctorSchedulingStore.updateSchedule(
        doctorId: widget.doctorId, schedulePayload: payload);

    if (_doctorSchedulingStore.requestStatus == RequestStatusEnum.success) {
      ToastUtils.showSuccessToast('Agenda atualizada com sucesso!');
      // ignore: use_build_context_synchronously
      context.pop();
    } else {
      ToastUtils.showErrorToast('Erro ao atualizar agenda.');
    }
  }
}
