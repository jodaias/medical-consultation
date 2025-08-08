import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/doctor/scheduling/domain/stores/doctor_scheduling_store.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class DoctorScheduleListPage extends StatefulWidget {
  final String doctorId;
  const DoctorScheduleListPage({super.key, required this.doctorId});

  @override
  State<DoctorScheduleListPage> createState() => _DoctorScheduleListPageState();
}

class _DoctorScheduleListPageState extends State<DoctorScheduleListPage> {
  final _doctorSchedulingStore = getIt<DoctorSchedulingStore>();

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    await _doctorSchedulingStore.loadSchedules(widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horários do Médico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSchedules,
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_doctorSchedulingStore.requestStatus ==
              RequestStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_doctorSchedulingStore.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar horários',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _doctorSchedulingStore.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadSchedules,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (_doctorSchedulingStore.schedules.isEmpty) {
            return Center(
              child: Text(
                'Nenhum horário encontrado',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadSchedules,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _doctorSchedulingStore.schedules.length,
              itemBuilder: (context, index) {
                final schedule = _doctorSchedulingStore.schedules[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(schedule.dayName ?? 'Dia desconhecido'),
                    subtitle: Text(schedule.timeSlot),
                    trailing: schedule.isAvailable == true
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.cancel, color: Colors.red),
                    onTap: () {
                      // Exemplo de navegação para detalhes ou edição
                      context.push(
                          '/doctor/schedules/edit?doctorId=${widget.doctorId}',
                          extra: schedule);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para tela de criação de horário
          context.push('/doctor/schedules/create?doctorId=${widget.doctorId}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
