import 'package:flutter/material.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';

class AvailabilityWidget extends StatelessWidget {
  final Map<String, dynamic> availability;

  const AvailabilityWidget({
    super.key,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Horários de Atendimento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...days.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final dayKey = (index + 1).toString();
            final dayAvailability = availability[dayKey];
            
            return _buildDayAvailability(day, dayAvailability);
          }),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: AppTheme.infoColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: AppTheme.infoColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.infoColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Os horários podem variar. Entre em contato para confirmar disponibilidade.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.infoColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayAvailability(String day, dynamic dayAvailability) {
    final isAvailable = dayAvailability != null && dayAvailability['available'] == true;
    final startTime = dayAvailability?['start'] ?? '';
    final endTime = dayAvailability?['end'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.white : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: isAvailable ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isAvailable ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              isAvailable ? '$startTime - $endTime' : 'Fechado',
              style: TextStyle(
                color: isAvailable ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                fontWeight: isAvailable ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            color: isAvailable ? AppTheme.successColor : AppTheme.errorColor,
            size: 20,
          ),
        ],
      ),
    );
  }
} 