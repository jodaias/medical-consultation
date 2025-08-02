import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/scheduling/domain/stores/scheduling_store.dart';
import 'package:medical_consultation_app/features/scheduling/presentation/widgets/appointment_card.dart';
import 'package:medical_consultation_app/features/scheduling/presentation/widgets/appointment_filters.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final SchedulingStore _schedulingStore = getIt<SchedulingStore>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    await _schedulingStore.loadUserAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Agendamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_schedulingStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_schedulingStore.error != null) {
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
                    'Erro ao carregar agendamentos',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _schedulingStore.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadAppointments,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (_schedulingStore.filteredAppointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum agendamento encontrado',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Você ainda não possui agendamentos ou os filtros aplicados não retornaram resultados.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/schedule'),
                    child: const Text('Agendar Consulta'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadAppointments,
            child: Column(
              children: [
                // Barra de busca
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar agendamentos...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _schedulingStore.setSearchQuery('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: _schedulingStore.setSearchQuery,
                  ),
                ),

                // Filtros rápidos
                _buildQuickFilters(),

                // Lista de agendamentos
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _schedulingStore.filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment =
                          _schedulingStore.filteredAppointments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: AppointmentCard(
                          appointment: appointment,
                          onTap: () => _showAppointmentDetails(appointment.id),
                          onCancel: () => _cancelAppointment(appointment.id),
                          onConfirm: () => _confirmAppointment(appointment.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/schedule'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Todos', 'all'),
          _buildFilterChip('Pendentes', 'pending'),
          _buildFilterChip('Confirmadas', 'confirmed'),
          _buildFilterChip('Canceladas', 'cancelled'),
          _buildFilterChip('Concluídas', 'completed'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Observer(
      builder: (_) {
        final isSelected = _schedulingStore.selectedStatus == value;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (selected) {
              _schedulingStore.setSelectedStatus(value);
              _loadAppointments();
            },
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        );
      },
    );
  }

  void _showFiltersDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AppointmentFilters(
        schedulingStore: _schedulingStore,
        onApply: () {
          Navigator.pop(context);
          _loadAppointments();
        },
      ),
    );
  }

  void _showAppointmentDetails(String appointmentId) {
    context.push('/appointments/$appointmentId');
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content:
            const Text('Tem certeza que deseja cancelar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _schedulingStore.cancelAppointment(appointmentId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agendamento cancelado com sucesso')),
        );
      }
    }
  }

  Future<void> _confirmAppointment(String appointmentId) async {
    final success = await _schedulingStore.confirmAppointment(appointmentId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento confirmado com sucesso')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
