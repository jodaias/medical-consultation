import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/features/scheduling/domain/stores/scheduling_store.dart';

class AppointmentFilters extends StatefulWidget {
  final SchedulingStore schedulingStore;
  final VoidCallback onApply;

  const AppointmentFilters({
    super.key,
    required this.schedulingStore,
    required this.onApply,
  });

  @override
  State<AppointmentFilters> createState() => _AppointmentFiltersState();
}

class _AppointmentFiltersState extends State<AppointmentFilters> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _startDate = widget.schedulingStore.selectedStartDate;
    _endDate = widget.schedulingStore.selectedEndDate;
    _selectedStatus = widget.schedulingStore.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Filtros',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  widget.schedulingStore.clearFilters();
                  context.pop();
                  widget.onApply();
                },
                child: const Text('Limpar'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Status
          Text(
            'Status',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildStatusChip('Todos', 'all'),
              _buildStatusChip('Pendentes', 'pending'),
              _buildStatusChip('Confirmadas', 'confirmed'),
              _buildStatusChip('Canceladas', 'cancelled'),
              _buildStatusChip('Concluídas', 'completed'),
            ],
          ),

          const SizedBox(height: 24),

          // Período
          Text(
            'Período',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Data Inicial',
                  value: _startDate,
                  onChanged: (date) => setState(() => _startDate = date),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateField(
                  label: 'Data Final',
                  value: _endDate,
                  onChanged: (date) => setState(() => _endDate = date),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Botões
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.schedulingStore.setSelectedStartDate(_startDate);
                    widget.schedulingStore.setSelectedEndDate(_endDate);
                    widget.schedulingStore.setSelectedStatus(_selectedStatus);
                    context.pop();
                    widget.onApply();
                  },
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    return Observer(
      builder: (_) {
        final isSelected = _selectedStatus == value;
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            setState(() => _selectedStatus = value);
          },
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
        );
      },
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              onChanged(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Text(
                  value != null
                      ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}'
                      : 'Selecionar data',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: value != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.outline,
                      ),
                ),
                const Spacer(),
                if (value != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 16),
                    onPressed: () => onChanged(null),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
