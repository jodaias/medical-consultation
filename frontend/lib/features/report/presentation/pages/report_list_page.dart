import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportListPage extends StatelessWidget {
  const ReportListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplo de lista de relatórios (mock)
    final reports = [
      {
        'id': '1',
        'title': 'Exame de Sangue',
        'date': '2025-08-01',
        'type': 'Laboratorial',
        'status': 'PENDENTE',
      },
      {
        'id': '2',
        'title': 'Raio-X do Tórax',
        'date': '2025-07-20',
        'type': 'Imagem',
        'status': 'CONCLUÍDO',
      },
      {
        'id': '3',
        'title': 'Ressonância Magnética',
        'date': '2025-06-15',
        'type': 'Imagem',
        'status': 'CONCLUÍDO',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios e Exames')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: reports.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final report = reports[index];
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
                    child: Icon(
                      report['type'] == 'Imagem' ? Icons.image : Icons.science,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    report['title']!,
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
                            Text('Data: ${report['date']}'),
                            const SizedBox(width: 12),
                            const Icon(Icons.folder_open, size: 14),
                            const SizedBox(width: 4),
                            Text('Tipo: ${report['type']}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              report['status']!,
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            backgroundColor: report['status'] == 'PENDENTE'
                                ? Colors.orange
                                : Colors.green,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      context.push('/reports/${report['id']}');
                    },
                  ),
                  onTap: () {
                    context.push('/reports/${report['id']}');
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
