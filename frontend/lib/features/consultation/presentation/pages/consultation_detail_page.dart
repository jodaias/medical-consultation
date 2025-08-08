import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/consultation/domain/stores/consultation_store.dart';
import 'package:medical_consultation_app/features/consultation/data/models/consultation_model.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class ConsultationDetailPage extends StatefulWidget {
  final String consultationId;

  const ConsultationDetailPage({super.key, required this.consultationId});

  @override
  State<ConsultationDetailPage> createState() => _ConsultationDetailPageState();
}

class _ConsultationDetailPageState extends State<ConsultationDetailPage> {
  final ConsultationStore _consultationStore = getIt<ConsultationStore>();
  final AuthStore _authStore = getIt<AuthStore>();

  @override
  void initState() {
    super.initState();
    _loadConsultation();
  }

  Future<void> _loadConsultation() async {
    await _consultationStore.loadConsultation(widget.consultationId);
  }

  void _onStartConsultation() async {
    await _consultationStore.startConsultation(widget.consultationId);
    if (_consultationStore.requestStatus == RequestStatusEnum.success) {
      ToastUtils.showSuccessToast(
        'Consulta iniciada com sucesso!',
      );
      // ignore: use_build_context_synchronously
      context.push('/chat/${widget.consultationId}');
    }
  }

  void _onEndConsultation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Consulta'),
        content: const Text('Deseja finalizar esta consulta?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => context.pop(true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _consultationStore.endConsultation(widget.consultationId);
      if (_consultationStore.requestStatus == RequestStatusEnum.success) {
        ToastUtils.showSuccessToast(
          'Consulta finalizada com sucesso!',
        );
        _loadConsultation();
      }
    }
  }

  void _onCancelConsultation() async {
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
      await _consultationStore.cancelConsultation(widget.consultationId);
      if (_consultationStore.requestStatus == RequestStatusEnum.success) {
        ToastUtils.showSuccessToast(
          'Consulta cancelada com sucesso!',
        );
        // ignore: use_build_context_synchronously
        context.pop();
      }
    }
  }

  void _onRateConsultation() {
    _showRatingDialog();
  }

  void _showRatingDialog() {
    double rating = 0;
    final reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Avaliar Consulta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Deixe um comentário (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: rating > 0
                  ? () async {
                      context.pop();
                      await _consultationStore.rateConsultation(
                        consultationId: widget.consultationId,
                        rating: rating,
                        review: reviewController.text.trim(),
                      );
                      ToastUtils.showSuccessToast(
                        'Avaliação enviada com sucesso!',
                      );
                      _loadConsultation();
                    }
                  : null,
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Consulta'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConsultation,
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_consultationStore.requestStatus == RequestStatusEnum.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_consultationStore.errorMessage != null) {
            return _buildErrorWidget();
          }

          final consultation = _consultationStore.selectedConsultation;
          if (consultation == null) {
            return const Center(
              child: Text('Consulta não encontrada'),
            );
          }

          return _buildConsultationDetails(consultation);
        },
      ),
    );
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
            'Erro ao carregar consulta',
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
            onPressed: _loadConsultation,
            child: const Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationDetails(ConsultationModel consultation) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status da consulta
          _buildStatusSection(consultation),

          const SizedBox(height: AppConstants.defaultPadding),

          // Informações básicas
          _buildBasicInfoSection(consultation),

          const SizedBox(height: AppConstants.defaultPadding),

          // Detalhes da consulta
          _buildConsultationDetailsSection(consultation),

          const SizedBox(height: AppConstants.defaultPadding),

          // Avaliação (se concluída)
          if (consultation.isCompleted) _buildRatingSection(consultation),

          const SizedBox(height: AppConstants.largePadding),

          // Ações
          _buildActionButtons(consultation),
        ],
      ),
    );
  }

  Widget _buildStatusSection(ConsultationModel consultation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusChip(consultation),
                const Spacer(),
                Text(
                  consultation.formattedScheduledDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Horário: ${consultation.formattedScheduledTime}',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
            Text(
              'Tempo restante: ${consultation.timeUntilConsultation}',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(ConsultationModel consultation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informações da Consulta',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            _buildInfoRow('Paciente', consultation.patient.name),
            _buildInfoRow('Médico', 'Dr. ${consultation.doctor.name}'),
            _buildInfoRow('Especialidade', consultation.doctor.specialty),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationDetailsSection(ConsultationModel consultation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalhes',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            if (consultation.symptoms?.isNotEmpty == true)
              _buildInfoRow('Sintomas', consultation.symptoms!),
            if (consultation.notes?.isNotEmpty == true)
              _buildInfoRow('Observações', consultation.notes!),
            if (consultation.diagnosis?.isNotEmpty == true)
              _buildInfoRow('Diagnóstico', consultation.diagnosis!),
            if (consultation.prescription?.isNotEmpty == true)
              _buildInfoRow('Prescrição', consultation.prescription!),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(ConsultationModel consultation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avaliação',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            if (consultation.rating != null) ...[
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < consultation.rating!
                          ? Icons.star
                          : Icons.star_border,
                      color: AppTheme.primaryColor,
                      size: 20,
                    );
                  }),
                  const SizedBox(width: AppConstants.smallPadding),
                  Text(
                    '${consultation.rating!.toStringAsFixed(1)}/5.0',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              if (consultation.review?.isNotEmpty == true) ...[
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  consultation.review!,
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ] else ...[
              Text(
                'Nenhuma avaliação ainda',
                style: TextStyle(color: AppTheme.textSecondaryColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ConsultationModel consultation) {
    return Column(
      children: [
        if (consultation.canStart)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onStartConsultation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
              ),
              child: const Text(
                'Iniciar Consulta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        if (consultation.isInProgress)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onEndConsultation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
              ),
              child: const Text(
                'Finalizar Consulta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        if (consultation.canCancel)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _onCancelConsultation,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: BorderSide(color: AppTheme.errorColor),
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
              ),
              child: const Text(
                'Cancelar Consulta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        if (consultation.canRate)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _onRateConsultation,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
              ),
              child: const Text(
                'Avaliar Consulta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        if (consultation.isInProgress || consultation.isCompleted)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/chat/${consultation.id}'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
              ),
              child: const Text(
                'Ver Conversa',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
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
}
