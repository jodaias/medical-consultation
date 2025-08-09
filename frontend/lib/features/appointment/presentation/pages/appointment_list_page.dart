import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/appointment/domain/stores/appointment_store.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/features/appointment/presentation/widgets/appointment_card.dart';
import 'package:medical_consultation_app/features/appointment/presentation/widgets/appointment_filters.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final _appointmentStore = getIt<AppointmentStore>();
  final TextEditingController _searchController = TextEditingController();
  final _authStore = getIt<AuthStore>();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    await _appointmentStore.loadUserAppointments(_authStore.userId!);
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
          return _appointmentStore.requestStatus == RequestStatusEnum.loading
              ? const Center(child: CircularProgressIndicator())
              : _appointmentStore.error != null
                  ? Center(
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
                            _appointmentStore.error!,
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
                    )
                  : _appointmentStore.filteredAppointments.isEmpty
                      ? Center(
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
                                onPressed: () {
                                  final isDoctor = _authStore.isDoctor;
                                  if (isDoctor) {
                                    context
                                        .go('/schedule/${_authStore.userId}');
                                  } else {
                                    context.go('/schedule-consultation');
                                  }
                                },
                                child: const Text('Agendar Consulta'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
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
                                    suffixIcon:
                                        _searchController.text.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () {
                                                  _searchController.clear();
                                                  _appointmentStore
                                                      .setSearchQuery('');
                                                },
                                              )
                                            : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onChanged: _appointmentStore.setSearchQuery,
                                ),
                              ),

                              // Filtros rápidos
                              _buildQuickFilters(),

                              // Lista de agendamentos
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(16.0),
                                  itemCount: _appointmentStore
                                      .filteredAppointments.length,
                                  itemBuilder: (context, index) {
                                    final appointment = _appointmentStore
                                        .filteredAppointments[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: AppointmentCard(
                                        appointment: appointment,
                                        onTap: () => _showAppointmentDetails(
                                            appointment.id),
                                        onCancel: () =>
                                            _cancelAppointment(appointment.id),
                                        // onConfirm: () =>
                                        //     _confirmAppointment(appointment.id),
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
        onPressed: () {
          final isDoctor = _authStore.isDoctor;
          if (isDoctor) {
            context.go('/schedule/${_authStore.userId}');
          } else {
            context.go('/schedule-consultation');
          }
        },
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
        final isSelected = _appointmentStore.selectedStatus == value;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (selected) {
              _appointmentStore.setSelectedStatus(value);
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
        schedulingStore: _appointmentStore,
        onApply: () {
          context.pop();
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
            onPressed: () => context.pop(false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _appointmentStore.cancelAppointment(appointmentId);
      if (_appointmentStore.requestStatus == RequestStatusEnum.success) {
        ToastUtils.showSuccessToast(
          'Agendamento cancelado com sucesso!',
        );
      }
    }
  }

  Future<void> _confirmAppointment(String appointmentId) async {
    await _appointmentStore.confirmAppointment(appointmentId);
    if (_appointmentStore.requestStatus == RequestStatusEnum.success) {
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
