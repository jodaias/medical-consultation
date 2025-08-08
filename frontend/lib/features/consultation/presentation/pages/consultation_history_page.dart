import 'package:flutter/material.dart';

class ConsultationHistoryPage extends StatelessWidget {
  final String? patientId;
  final String? patientName;

  const ConsultationHistoryPage({super.key, this.patientId, this.patientName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock de consultas
    final List<Map<String, dynamic>> consultations = patientId == null
        ? []
        : [
            {
              'id': 'c1',
              'date': '2025-07-10',
              'doctor': 'Dr. Ana Paula',
              'status': 'completed',
              'notes': 'Consulta de rotina, tudo ok.'
            },
            {
              'id': 'c2',
              'date': '2025-05-22',
              'doctor': 'Dr. João Pedro',
              'status': 'completed',
              'notes': 'Acompanhamento de exames.'
            },
            {
              'id': 'c3',
              'date': '2025-03-15',
              'doctor': 'Dra. Carla Souza',
              'status': 'cancelled',
              'notes': 'Consulta cancelada pelo paciente.'
            },
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico de Consultas${patientName != null ? ' - $patientName' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 1,
      ),
      body: Container(
        color: colorScheme.surface,
        child: patientId == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline,
                        size: 64, color: colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Selecione um paciente para ver o histórico.',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : consultations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy,
                            size: 64, color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma consulta encontrada.',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: colorScheme.primary),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: consultations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final c = consultations[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    c['status'] == 'completed'
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: c['status'] == 'completed'
                                        ? Colors.green
                                        : Colors.red,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDate(c['date']),
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    c['status'] == 'completed'
                                        ? 'Concluída'
                                        : 'Cancelada',
                                    style: TextStyle(
                                      color: c['status'] == 'completed'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      size: 18, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    c['doctor'],
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                c['notes'],
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return dateString;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
