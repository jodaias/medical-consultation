import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/appointment/domain/stores/doctor_appointment_store.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class DoctorAppointmentDetailPage extends StatefulWidget {
  final String appointmentId;

  const DoctorAppointmentDetailPage({
    super.key,
    required this.appointmentId,
  });

  @override
  State<DoctorAppointmentDetailPage> createState() =>
      _DoctorAppointmentDetailPageState();
}

class _DoctorAppointmentDetailPageState
    extends State<DoctorAppointmentDetailPage> {
  final _doctorAppointmentStore = getIt<DoctorAppointmentStore>();

  @override
  void initState() {
    super.initState();
    _doctorAppointmentStore.getAppointmentDetails(widget.appointmentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Consulta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _doctorAppointmentStore
                .getAppointmentDetails(widget.appointmentId),
          )
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_doctorAppointmentStore.requestStatus ==
              RequestStatusEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final appointment = _doctorAppointmentStore.selectedAppointment;
          if (appointment == null) {
            return const Center(child: Text('Consulta não encontrada'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  title: 'Paciente',
                  icon: Icons.person,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patient.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // if (appointment.patientEmail != null)
                      //   Text(
                      //     appointment.patientEmail!,
                      //     style: Theme.of(context).textTheme.bodyMedium,
                      //   ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'Data e Hora',
                  icon: Icons.access_time,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appointment.formattedScheduledDate),
                      Text(appointment.formattedScheduledTime),
                    ],
                  ),
                ),
                if (appointment.notes != null) ...[
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Observações',
                    icon: Icons.notes,
                    child: Text(appointment.notes!),
                  ),
                ],
                if (appointment.symptoms != null) ...[
                  const SizedBox(height: 16),
                  _buildSection(
                    title: 'Sintomas',
                    icon: Icons.healing,
                    child: Text(appointment.symptoms!),
                  ),
                ],
                const SizedBox(height: 24),
                if (appointment.canCancel) //|| appointment.canConfirm)
                  Row(
                    children: [
                      if (appointment.canCancel)
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancelar'),
                            onPressed: () => _cancelAppointment(appointment.id),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      if (appointment.canCancel) //&& appointment.canConfirm)
                        const SizedBox(width: 12),
                      // if (appointment.canConfirm)
                      // Expanded(
                      //   child: ElevatedButton.icon(
                      //     icon: const Icon(Icons.check),
                      //     label: const Text('Confirmar'),
                      //     onPressed: () =>
                      //         _confirmAppointment(appointment.id),
                      //   ),
                      // ),
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              child,
            ],
          ),
        )
      ],
    );
  }

  Future<void> _cancelAppointment(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar Consulta'),
        content: const Text('Deseja realmente cancelar esta consulta?'),
        actions: [
          TextButton(
              onPressed: () => context.pop(false), child: const Text('Não')),
          TextButton(
              onPressed: () => context.pop(true), child: const Text('Sim')),
        ],
      ),
    );

    if (confirm == true) {
      await _doctorAppointmentStore.cancelAppointment(id);
      if (_doctorAppointmentStore.requestStatus == RequestStatusEnum.success) {
        ToastUtils.showSuccessToast('Consulta cancelada com sucesso');
        // ignore: use_build_context_synchronously
        context.pop();
      }
    }
  }

  Future<void> _confirmAppointment(String id) async {
    await _doctorAppointmentStore.confirmAppointment(id);
    if (_doctorAppointmentStore.requestStatus == RequestStatusEnum.success) {
      ToastUtils.showSuccessToast('Consulta confirmada com sucesso');
      // ignore: use_build_context_synchronously
      context.pop();
    }
  }
}
