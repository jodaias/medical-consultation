import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportDetailPage extends StatelessWidget {
  final String reportId;
  const ReportDetailPage({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    // TODO: Substituir por busca real do relatório usando reportId
    // Layout profissional para médicos
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Relatório'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Baixar PDF',
            onPressed: () {
              // TODO: Implementar download
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card principal
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text('Relatório Médico',
                            style: Theme.of(context).textTheme.titleLarge),
                        const Spacer(),
                        Chip(
                          label: Text('PENDENTE',
                              style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.folder_open, size: 20),
                        const SizedBox(width: 6),
                        Text('Tipo: ',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 4),
                        const Text('Exames Laboratoriais'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 20),
                        const SizedBox(width: 6),
                        Text('Período: ',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 4),
                        const Text('01/01/2025 - 31/01/2025'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.picture_as_pdf, size: 20),
                        const SizedBox(width: 6),
                        Text('Formato: ',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 4),
                        const Text('PDF'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.link, size: 20),
                        const SizedBox(width: 6),
                        Text('Arquivo: ',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 4),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text('Baixar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Card de paciente
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('Paciente'),
                subtitle: const Text(
                    'Nome do Paciente'), // TODO: Substituir por nome real
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navegar para perfil do paciente
                },
              ),
            ),
            const SizedBox(height: 24),
            // Observações ou filtros
            Card(
              elevation: 0,
              color: Colors.grey[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Observações',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text('Nenhuma observação adicional.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
