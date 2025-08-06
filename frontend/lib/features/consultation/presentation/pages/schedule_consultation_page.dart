import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/consultation/domain/stores/consultation_store.dart';
import 'package:medical_consultation_app/features/auth/domain/stores/auth_store.dart';
import 'package:medical_consultation_app/core/di/injection.dart';
import 'package:medical_consultation_app/core/utils/toast_utils.dart';
import 'package:medical_consultation_app/features/shared/enums/request_status_enum.dart';

class ScheduleConsultationPage extends StatefulWidget {
  const ScheduleConsultationPage({super.key});

  @override
  State<ScheduleConsultationPage> createState() =>
      _ScheduleConsultationPageState();
}

class _ScheduleConsultationPageState extends State<ScheduleConsultationPage> {
  final ConsultationStore _consultationStore = getIt<ConsultationStore>();
  final AuthStore _authStore = getIt<AuthStore>();

  String? selectedSpecialty;
  String? selectedDoctorId;
  DateTime? selectedDate;
  String? selectedTime;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAvailableDoctors();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableDoctors() async {
    await _consultationStore.loadAvailableDoctors(
      specialty: selectedSpecialty,
      date: selectedDate,
    );
  }

  Future<void> _loadAvailableSlots() async {
    if (selectedDoctorId != null && selectedDate != null) {
      await _consultationStore.loadAvailableSlots(
        doctorId: selectedDoctorId!,
        date: selectedDate!,
      );
    }
  }

  Future<void> _scheduleConsultation() async {
    if (selectedDoctorId == null ||
        selectedDate == null ||
        selectedTime == null) {
      ToastUtils.showErrorToast(
          'Por favor, preencha todos os campos obrigatórios');
      return;
    }

    // Combinar data e hora selecionada
    final scheduledAt = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      int.parse(selectedTime!.split(':')[0]),
      int.parse(selectedTime!.split(':')[1]),
    );

    await _consultationStore.scheduleConsultation(
      doctorId: selectedDoctorId!,
      scheduledAt: scheduledAt,
      notes: _notesController.text.trim(),
      symptoms: _symptomsController.text.trim(),
    );

    if (_consultationStore.requestStatus == RequestStatusEnum.success) {
      ToastUtils.showSuccessToast('Consulta agendada com sucesso!');
      // ignore: use_build_context_synchronously
      context.go('/patient');
    } else {
      ToastUtils.showErrorToast(
          _consultationStore.errorMessage ?? 'Erro ao agendar consulta');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Consulta'),
        elevation: 0,
      ),
      body: Observer(
        builder: (_) {
          if (_consultationStore.requestStatus == RequestStatusEnum.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status de erro
                if (_consultationStore.errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.smallPadding),
                    margin: const EdgeInsets.only(
                        bottom: AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: Text(
                      _consultationStore.errorMessage!,
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  ),

                // Especialidade
                _buildSectionTitle('Especialidade'),
                _buildSpecialtyDropdown(),

                const SizedBox(height: AppConstants.defaultPadding),

                // Médico
                _buildSectionTitle('Médico'),
                _buildDoctorDropdown(),

                const SizedBox(height: AppConstants.defaultPadding),

                // Data
                _buildSectionTitle('Data'),
                _buildDatePicker(),

                const SizedBox(height: AppConstants.defaultPadding),

                // Horário
                if (selectedDate != null) ...[
                  _buildSectionTitle('Horário'),
                  _buildTimeSlots(),
                  const SizedBox(height: AppConstants.defaultPadding),
                ],

                // Sintomas
                _buildSectionTitle('Sintomas (opcional)'),
                _buildSymptomsField(),

                const SizedBox(height: AppConstants.defaultPadding),

                // Observações
                _buildSectionTitle('Observações (opcional)'),
                _buildNotesField(),

                const SizedBox(height: AppConstants.largePadding),

                // Botão de agendar
                _buildScheduleButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildSpecialtyDropdown() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSpecialty,
          hint: const Text('Selecione uma especialidade'),
          isExpanded: true,
          items: AppConstants.specialties.map((specialty) {
            return DropdownMenuItem(
              value: specialty,
              child: Text(specialty),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedSpecialty = value;
              selectedDoctorId = null;
              selectedDate = null;
              selectedTime = null;
            });
            _loadAvailableDoctors();
          },
        ),
      ),
    );
  }

  Widget _buildDoctorDropdown() {
    return Observer(
      builder: (context) {
        final doctorsRequestStatus = _consultationStore.doctorsRequestStatus;
        final availableDoctors = _consultationStore.availableDoctors;
        return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          child: doctorsRequestStatus == RequestStatusEnum.loading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Carregando médicos...'),
                  ],
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedDoctorId,
                    hint: const Text('Selecione um médico'),
                    isExpanded: true,
                    items: availableDoctors.map((doctor) {
                      return DropdownMenuItem<String>(
                        value: doctor['id'] as String,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Dr. ${doctor['name']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              doctor['specialty'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDoctorId = value;
                        selectedDate = null;
                        selectedTime = null;
                      });
                    },
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );

        if (date != null) {
          setState(() {
            selectedDate = date;
            selectedTime = null;
          });
          _loadAvailableSlots();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderColor),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
            const SizedBox(width: AppConstants.smallPadding),
            Text(
              selectedDate != null
                  ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
                  : 'Selecione uma data',
              style: TextStyle(
                color: selectedDate != null
                    ? AppTheme.textPrimaryColor
                    : AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    if (_consultationStore.availableSlots.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: const Text(
          'Nenhum horário disponível para esta data',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
      );
    }

    return Wrap(
      spacing: AppConstants.smallPadding,
      runSpacing: AppConstants.smallPadding,
      children: _consultationStore.availableSlots.map((slot) {
        final timeString =
            '${slot.hour.toString().padLeft(2, '0')}:${slot.minute.toString().padLeft(2, '0')}';
        final isSelected = selectedTime == timeString;

        return InkWell(
          onTap: () {
            setState(() {
              selectedTime = timeString;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: AppConstants.smallPadding,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected ? AppTheme.primaryColor : AppTheme.backgroundColor,
              border: Border.all(
                color:
                    isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
              ),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Text(
              timeString,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSymptomsField() {
    return TextField(
      controller: _symptomsController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Descreva seus sintomas...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.smallPadding),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Adicione observações...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.smallPadding),
      ),
    );
  }

  Widget _buildScheduleButton() {
    final canSchedule = selectedDoctorId != null &&
        selectedDate != null &&
        selectedTime != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSchedule ? _scheduleConsultation : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: const Text(
          'Agendar Consulta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
