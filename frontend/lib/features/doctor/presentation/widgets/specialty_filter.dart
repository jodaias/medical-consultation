import 'package:flutter/material.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/features/doctor/data/models/specialty_model.dart';

class SpecialtyFilter extends StatelessWidget {
  final List<SpecialtyModel> specialties;
  final String? selectedSpecialty;
  final Function(String?) onSpecialtyChanged;

  const SpecialtyFilter({
    super.key,
    required this.specialties,
    required this.selectedSpecialty,
    required this.onSpecialtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Opção "Todas"
        FilterChip(
          label: const Text('Todas'),
          selected: selectedSpecialty == null,
          onSelected: (selected) {
            onSpecialtyChanged(null);
          },
          selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.primaryColor,
        ),
        // Especialidades
        ...specialties.map((specialty) => FilterChip(
              label: Text(specialty.name),
              selected: selectedSpecialty == specialty.id,
              onSelected: (selected) {
                onSpecialtyChanged(selected ? specialty.id : null);
              },
              selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              checkmarkColor: AppTheme.primaryColor,
            )),
      ],
    );
  }
}
