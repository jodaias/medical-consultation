import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrescriptionListPage extends StatelessWidget {
  const PrescriptionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplo de lista de prescrições (mock)
    final prescriptions = [
      {
        'id': '1',
        'title': 'Amoxicilina 500mg',
        'date': '2025-08-01',
        'doctor': 'Dr. João Silva',
        'status': 'ATIVA',
      },
      {
        'id': '2',
        'title': 'Ibuprofeno 400mg',
        'date': '2025-07-20',
        'doctor': 'Dra. Maria Souza',
        'status': 'EXPIRADA',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Prescrições Médicas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: prescriptions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final prescription = prescriptions[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: IntrinsicHeight(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child:
                        const Icon(Icons.medical_services, color: Colors.blue),
                  ),
                  title: Text(
                    prescription['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 4),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14),
                            const SizedBox(width: 4),
                            Text('Data: ${prescription['date']}'),
                            const SizedBox(width: 12),
                            const Icon(Icons.person, size: 14),
                            const SizedBox(width: 4),
                            Text('Médico: ${prescription['doctor']}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              prescription['status']!,
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            backgroundColor: prescription['status'] == 'ATIVA'
                                ? Colors.green
                                : Colors.grey,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      context.push('/prescriptions/${prescription['id']}');
                    },
                  ),
                  onTap: () {
                    context.push('/prescriptions/${prescription['id']}');
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
