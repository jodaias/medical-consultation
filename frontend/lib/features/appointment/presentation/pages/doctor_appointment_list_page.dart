import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/appointment/domain/stores/doctor_appointment_store.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class DoctorAppointmentListPage extends StatelessWidget {
  final appointmentStore = getIt<DoctorAppointmentStore>();

  DoctorAppointmentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Minhas Consultas")),
      body: Observer(
        builder: (_) {
          return appointmentStore.requestStatus == RequestStatusEnum.loading
              ? const Center(child: CircularProgressIndicator())
              : appointmentStore.appointments.isEmpty
                  ? const Center(child: Text("Nenhuma consulta encontrada."))
                  : ListView.builder(
                      itemCount: appointmentStore.appointments.length,
                      itemBuilder: (_, index) {
                        final appointment =
                            appointmentStore.appointments[index];
                        return Card(
                          margin: const EdgeInsets.all(12),
                          child: ListTile(
                            title: Text("Paciente: ${appointment.patientName}"),
                            subtitle: Text(
                              "Data: ${appointment.formattedScheduledDate}\nStatus: ${appointment.status}",
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'cancel') {
                                  appointmentStore
                                      .cancelAppointment(appointment.id);
                                } else if (value == 'edit') {
                                  // abrir modal para reagendar
                                }
                              },
                              itemBuilder: (_) => [
                                const PopupMenuItem(
                                    value: 'edit', child: Text('Alterar')),
                                const PopupMenuItem(
                                    value: 'cancel', child: Text('Cancelar')),
                              ],
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
    );
  }
}
