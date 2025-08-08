import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/consultation/domain/stores/consultation_store.dart';
import 'package:medical_consultation_app/features/consultation/data/models/consultation_model.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class ConsultationListPage extends StatefulWidget {
  const ConsultationListPage({super.key});

  @override
  State<ConsultationListPage> createState() => _ConsultationListPageState();
}

class _ConsultationListPageState extends State<ConsultationListPage> {
  final ConsultationStore _consultationStore = getIt<ConsultationStore>();
  final AuthStore _authStore = getIt<AuthStore>();

  String _selectedFilter = AppConstants.allStatus;
  final List<String> _filters = [
    AppConstants.allStatus,
    AppConstants.scheduledStatus,
    AppConstants.inProgressStatus,
    AppConstants.completedStatus,
    AppConstants.cancelledStatus,
    AppConstants.noShowStatus,
  ];

  @override
  void initState() {
    super.initState();
    _loadConsultations();
  }

  Future<void> _loadConsultations() async {
    // Só busca do banco se não houver consultas carregadas
    // ou se o filtro for 'Todas'.
    if (_consultationStore.consultations.isEmpty &&
        _selectedFilter == AppConstants.allStatus) {
      await _consultationStore.loadConsultations(
        userId: _authStore.userId,
        userType: _authStore.userType,
        status:
            _selectedFilter == AppConstants.allStatus ? null : _selectedFilter,
      );
    }
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _loadConsultations();
  }

  void _onConsultationTap(ConsultationModel consultation) {
    context.push('/patient/consultation/${consultation.id}');
  }

  void _onScheduleNew() {
    context.push('/patient/schedule-consultation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Consultas'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConsultations,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          _buildFilterChips(),

          // Lista de consultas
          Expanded(
            child: Observer(
              builder: (_) {
                if (_consultationStore.requestStatus ==
                    RequestStatusEnum.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (_consultationStore.errorMessage != null) {
                  return _buildErrorWidget();
                }

                if (_consultationStore.consultations.isEmpty) {
                  return _buildEmptyWidget();
                }

                return _buildConsultationList();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onScheduleNew,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.smallPadding),
            child: FilterChip(
              label: Text(_getFilterLabel(filter)),
              selected: isSelected,
              onSelected: (_) => _onFilterChanged(filter),
              selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  String _getFilterLabel(String filter) {
    switch (filter) {
      case AppConstants.allStatus:
        return 'Todas';
      case AppConstants.scheduledStatus:
        return 'Agendadas';
      case AppConstants.inProgressStatus:
        return 'Em andamento';
      case AppConstants.completedStatus:
        return 'Concluídas';
      case AppConstants.cancelledStatus:
        return 'Canceladas';
      case AppConstants.noShowStatus:
        return 'Não compareceu';
      default:
        return 'Todas';
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Erro ao carregar consultas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _consultationStore.errorMessage ?? 'Tente novamente',
            style: TextStyle(color: AppTheme.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadConsultations,
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma consulta encontrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agende sua primeira consulta',
            style: TextStyle(color: AppTheme.textSecondaryColor),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onScheduleNew,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Agendar Consulta'),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationList() {
    // Aplica filtro localmente se não for 'Todas'
    final filteredConsultations = _selectedFilter == AppConstants.allStatus
        ? _consultationStore.consultations
        : _consultationStore.consultations
            .where((c) => c.status == _selectedFilter)
            .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: filteredConsultations.length,
      itemBuilder: (context, index) {
        final consultation = filteredConsultations[index];
        return _buildConsultationCard(consultation);
      },
    );
  }

  Widget _buildConsultationCard(ConsultationModel consultation) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      elevation: 2,
      child: InkWell(
        onTap: () => _onConsultationTap(consultation),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header com status
              Row(
                children: [
                  _buildStatusChip(consultation),
                  const Spacer(),
                  Text(
                    consultation.formattedScheduledDate,
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.smallPadding),

              // Informações da consulta
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      consultation.isPatient ? 'P' : 'M',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          consultation.isPatient
                              ? 'Dr. ${consultation.doctorName}'
                              : consultation.patientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          consultation.isPatient
                              ? consultation.doctorSpecialty
                              : 'Paciente',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        consultation.formattedScheduledTime,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        consultation.timeUntilConsultation,
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Ações rápidas
              if (consultation.canStart || consultation.canCancel)
                Padding(
                  padding:
                      const EdgeInsets.only(top: AppConstants.smallPadding),
                  child: Row(
                    children: [
                      if (consultation.canStart)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _startConsultation(consultation),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.successColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text('Iniciar'),
                          ),
                        ),
                      if (consultation.canStart && consultation.canCancel)
                        const SizedBox(width: AppConstants.smallPadding),
                      if (consultation.canCancel)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _cancelConsultation(consultation),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.errorColor,
                              side: BorderSide(color: AppTheme.errorColor),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ConsultationModel consultation) {
    Color chipColor;
    Color textColor;

    switch (consultation.status) {
      case AppConstants.scheduledStatus:
        chipColor = AppTheme.primaryColor.withValues(alpha: 0.1);
        textColor = AppTheme.primaryColor;
        break;
      case AppConstants.inProgressStatus:
        chipColor = AppTheme.warningColor.withValues(alpha: 0.1);
        textColor = AppTheme.warningColor;
        break;
      case AppConstants.completedStatus:
        chipColor = AppTheme.successColor.withValues(alpha: 0.1);
        textColor = AppTheme.successColor;
        break;
      case AppConstants.cancelledStatus:
        chipColor = AppTheme.errorColor.withValues(alpha: 0.1);
        textColor = AppTheme.errorColor;
        break;
      default:
        chipColor = AppTheme.textSecondaryColor.withValues(alpha: 0.1);
        textColor = AppTheme.textSecondaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        consultation.statusText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _startConsultation(ConsultationModel consultation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Iniciar Consulta'),
        content: const Text('Deseja iniciar esta consulta?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => context.pop(true),
            child: const Text('Iniciar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _consultationStore.startConsultation(consultation.id);
      if (_consultationStore.requestStatus == RequestStatusEnum.success) {
        ToastUtils.showSuccessToast(
          'Consulta iniciada com sucesso!',
        );
        // ignore: use_build_context_synchronously
        context.push('/chat/${consultation.id}');
      }
    }
  }

  Future<void> _cancelConsultation(ConsultationModel consultation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Consulta'),
        content: const Text('Tem certeza que deseja cancelar esta consulta?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            onPressed: () => context.pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sim, Cancelar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _consultationStore.cancelConsultation(consultation.id);
      if (_consultationStore.requestStatus == RequestStatusEnum.success) {
        ToastUtils.showSuccessToast(
          'Consulta cancelada com sucesso!',
        );
      }
    }
  }
}
