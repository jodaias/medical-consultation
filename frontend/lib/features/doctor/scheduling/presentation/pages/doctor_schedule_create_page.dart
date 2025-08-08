// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:go_router/go_router.dart';
// import 'package:medical_consultation_app/core/di/injection.dart';
// import 'package:medical_consultation_app/core/utils/constants.dart';
// import 'package:medical_consultation_app/core/utils/toast_utils.dart';
// import 'package:medical_consultation_app/features/doctor/scheduling/data/models/doctor_schedule_model.dart';
// import 'package:medical_consultation_app/features/doctor/scheduling/domain/stores/doctor_scheduling_store.dart';
// import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

// class DoctorScheduleCreatePage extends StatefulWidget {
//   final String doctorId;

//   const DoctorScheduleCreatePage({super.key, required this.doctorId});

//   @override
//   State<DoctorScheduleCreatePage> createState() =>
//       _DoctorScheduleCreatePageState();
// }

// class _DoctorScheduleCreatePageState extends State<DoctorScheduleCreatePage> {
//   final _doctorSchedulingStore = getIt<DoctorSchedulingStore>();

//   final List<int> selectedDays = [];
//   final Map<int, TimeOfDay?> startTimes = {};
//   final Map<int, TimeOfDay?> endTimes = {};
//   int consultationDuration = 30;

//   final List<String> daysOfWeek = AppConstants.daysOfWeek.keys.toList();
//   static const Map<String, String> daysOfWeekPt = AppConstants.daysOfWeek;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Minha Agenda')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Selecione os dias da semana:',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Wrap(
//                 spacing: 8,
//                 runSpacing: 12,
//                 children: List.generate(
//                     daysOfWeek.length,
//                     (i) => FilterChip(
//                           label: Text(daysOfWeekPt[daysOfWeek[i]]!),
//                           selected: selectedDays.contains(i),
//                           onSelected: (selected) {
//                             setState(() {
//                               if (selected) {
//                                 selectedDays.add(i);
//                                 startTimes[i] = null;
//                                 endTimes[i] = null;
//                               } else {
//                                 selectedDays.remove(i);
//                                 startTimes.remove(i);
//                                 endTimes.remove(i);
//                               }
//                             });
//                           },
//                         )),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 const Text('Duração da consulta:',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(width: 16),
//                 DropdownButton<int>(
//                   value: consultationDuration,
//                   items: [15, 20, 30, 45, 60]
//                       .map((d) => DropdownMenuItem(
//                             value: d,
//                             child: Text('$d min'),
//                           ))
//                       .toList(),
//                   onChanged: (v) => setState(() => consultationDuration = v!),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     ...selectedDays.map((day) => Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(daysOfWeekPt[daysOfWeek[day]]!,
//                                     style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold)),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: ListTile(
//                                         title: Text(
//                                             startTimes[day]?.format(context) ??
//                                                 'Início'),
//                                         leading: const Icon(Icons.access_time),
//                                         onTap: () async {
//                                           final picked = await showTimePicker(
//                                             context: context,
//                                             initialTime: startTimes[day] ??
//                                                 TimeOfDay(hour: 8, minute: 0),
//                                           );
//                                           if (picked != null) {
//                                             setState(
//                                                 () => startTimes[day] = picked);
//                                           }
//                                         },
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: ListTile(
//                                         title: Text(
//                                             endTimes[day]?.format(context) ??
//                                                 'Fim'),
//                                         leading: const Icon(Icons.access_time),
//                                         onTap: () async {
//                                           final picked = await showTimePicker(
//                                             context: context,
//                                             initialTime: endTimes[day] ??
//                                                 TimeOfDay(hour: 12, minute: 0),
//                                           );
//                                           if (picked != null) {
//                                             setState(
//                                                 () => endTimes[day] = picked);
//                                           }
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )),
//                     const SizedBox(height: 80), // Espaço para o botão
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SizedBox(
//             width: double.infinity,
//             child: Observer(builder: (_) {
//               return ElevatedButton(
//                 onPressed: _doctorSchedulingStore.requestStatus ==
//                         RequestStatusEnum.loading
//                     ? null
//                     : _saveSchedule,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: _doctorSchedulingStore.requestStatus ==
//                         RequestStatusEnum.loading
//                     ? const SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.5,
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.save),
//                           SizedBox(width: 8),
//                           Text('Salvar Agenda'),
//                         ],
//                       ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveSchedule() async {
//     if (selectedDays.isEmpty) {
//       ToastUtils.showWarningToast('Selecione pelo menos um dia.');
//       return;
//     }
//     for (final day in selectedDays) {
//       if (startTimes[day] == null || endTimes[day] == null) {
//         ToastUtils.showWarningToast(
//             'Defina horários para ${daysOfWeekPt[daysOfWeek[day]]!}.');
//         return;
//       }
//     }
//     if (consultationDuration <= 0) {
//       ToastUtils.showWarningToast(
//           'Duração da consulta deve ser maior que zero.');
//       return;
//     }

//     String formatTime(TimeOfDay t) =>
//         '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

//     final doctorId = widget.doctorId;

//     final schedules = selectedDays.map((day) {
//       final start = startTimes[day]!;
//       final end = endTimes[day]!;
//       return DoctorScheduleModel(
//         doctorId: doctorId,
//         dayOfWeek: day,
//         startTime: formatTime(start),
//         endTime: formatTime(end),
//         consultationDuration: consultationDuration,
//         isAvailable: true,
//       );
//     }).toList();

//     await _doctorSchedulingStore.saveSchedules(
//       doctorId: doctorId,
//       schedulesPayload: schedules,
//     );

//     if (_doctorSchedulingStore.requestStatus == RequestStatusEnum.success) {
//       ToastUtils.showSuccessToast('Agenda salva com sucesso!');
//       // ignore: use_build_context_synchronously
//       context.pop();
//     } else {
//       ToastUtils.showErrorToast('Erro ao salvar agenda.');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/data/models/doctor_schedule_model.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/domain/stores/doctor_scheduling_store.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class DoctorScheduleCreatePage extends StatefulWidget {
  final String doctorId;

  const DoctorScheduleCreatePage({super.key, required this.doctorId});

  @override
  State<DoctorScheduleCreatePage> createState() =>
      _DoctorScheduleCreatePageState();
}

class _DoctorScheduleCreatePageState extends State<DoctorScheduleCreatePage> {
  final _doctorSchedulingStore = getIt<DoctorSchedulingStore>();

  final List<int> selectedDays = [];
  final Map<int, TimeOfDay?> startTimes = {};
  final Map<int, TimeOfDay?> endTimes = {};
  int consultationDuration = 30;

  final List<String> daysOfWeek = AppConstants.daysOfWeek.keys.toList();
  static const Map<String, String> daysOfWeekPt = AppConstants.daysOfWeek;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExistingSchedules();
  }

  Future<void> _loadExistingSchedules() async {
    final schedules = _doctorSchedulingStore.schedules;

    for (final schedule in schedules) {
      final day = schedule.dayOfWeek!;
      selectedDays.add(day);
      startTimes[day] = _parseTime(schedule.startTime!);
      endTimes[day] = _parseTime(schedule.endTime!);
      consultationDuration = schedule.consultationDuration!;
    }

    setState(() => isLoading = false);
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Minha Agenda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selecione os dias da semana:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: List.generate(
                  daysOfWeek.length,
                  (i) => FilterChip(
                    label: Text(daysOfWeekPt[daysOfWeek[i]]!),
                    selected: selectedDays.contains(i),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedDays.add(i);
                          startTimes.putIfAbsent(i, () => null);
                          endTimes.putIfAbsent(i, () => null);
                        } else {
                          selectedDays.remove(i);
                          startTimes.remove(i);
                          endTimes.remove(i);
                        }
                      });
                    },
                  ),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...selectedDays.map((day) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(daysOfWeekPt[daysOfWeek[day]]!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                            startTimes[day]?.format(context) ??
                                                'Início'),
                                        leading: const Icon(Icons.access_time),
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: startTimes[day] ??
                                                TimeOfDay(hour: 8, minute: 0),
                                          );
                                          if (picked != null) {
                                            setState(
                                                () => startTimes[day] = picked);
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                            endTimes[day]?.format(context) ??
                                                'Fim'),
                                        leading: const Icon(Icons.access_time),
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: endTimes[day] ??
                                                TimeOfDay(hour: 12, minute: 0),
                                          );
                                          if (picked != null) {
                                            setState(
                                                () => endTimes[day] = picked);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 80), // Espaço para o botão
                  ],
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
                    : _saveSchedule,
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
                          Text('Salvar Agenda'),
                        ],
                      ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _saveSchedule() async {
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
    if (consultationDuration <= 0) {
      ToastUtils.showWarningToast(
          'Duração da consulta deve ser maior que zero.');
      return;
    }

    String formatTime(TimeOfDay t) =>
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    final doctorId = widget.doctorId;

    final schedules = selectedDays.map((day) {
      final start = startTimes[day]!;
      final end = endTimes[day]!;
      return DoctorScheduleModel(
        doctorId: doctorId,
        dayOfWeek: day,
        startTime: formatTime(start),
        endTime: formatTime(end),
        consultationDuration: consultationDuration,
        isAvailable: true,
      );
    }).toList();

    await _doctorSchedulingStore.saveSchedules(
      doctorId: doctorId,
      schedulesPayload: schedules,
    );

    if (_doctorSchedulingStore.requestStatus == RequestStatusEnum.success) {
      ToastUtils.showSuccessToast('Agenda salva com sucesso!');
      // ignore: use_build_context_synchronously
      context.pop();
    } else {
      ToastUtils.showErrorToast('Erro ao salvar agenda.');
    }
  }
}
