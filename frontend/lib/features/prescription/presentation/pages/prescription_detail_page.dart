import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrescriptionDetailPage extends StatelessWidget {
  final String prescriptionId;
  const PrescriptionDetailPage({super.key, required this.prescriptionId});

  @override
  Widget build(BuildContext context) {
    // TODO: Substituir por busca real da prescrição usando prescriptionId
    // Layout profissional para detalhes da prescrição
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Prescrição'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Exportar PDF',
            onPressed: () {
              // TODO: Implementar exportação
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
                        Icon(Icons.medical_services,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text('Prescrição Médica',
                            style: Theme.of(context).textTheme.titleLarge),
                        const Spacer(),
                        Chip(
                          label: Text('ATIVA',
                              style: const TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, size: 20),
                        const SizedBox(width: 6),
                        Text('Data: ',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 4),
                        const Text('01/08/2025'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 20),
                        const SizedBox(width: 6),
                        Text('Paciente: ',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 4),
                        const Text(
                            'Nome do Paciente'), // TODO: Substituir por nome real
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 20),
                        const SizedBox(width: 6),
                        Text('Médico: ',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(width: 4),
                        const Text(
                            'Dr. João Silva'), // TODO: Substituir por nome real
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Card de medicamentos
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medicamentos',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...[
                      'Amoxicilina 500mg - 1 comprimido 8/8h por 7 dias',
                      'Dipirona 1g - 1 comprimido se dor',
                    ].map((med) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.blue, size: 18),
                              const SizedBox(width: 8),
                              Expanded(child: Text(med)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Card de instruções
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
                    Text('Instruções',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                        'Tomar os medicamentos conforme prescrito. Retornar em caso de sintomas persistentes.'),
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
