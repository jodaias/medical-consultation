import 'package:flutter/material.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';

class SortFilter extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortFilter({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSortChip('Melhor avaliados', 'rating', Icons.star),
        _buildSortChip('Menor preço', 'price_low', Icons.attach_money),
        _buildSortChip('Maior preço', 'price_high', Icons.attach_money),
        _buildSortChip('Mais experientes', 'experience', Icons.work),
        _buildSortChip('Ordem alfabética', 'name', Icons.sort_by_alpha),
      ],
    );
  }

  Widget _buildSortChip(String label, String value, IconData icon) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: currentSort == value,
      onSelected: (selected) {
        if (selected) {
          onSortChanged(value);
        }
      },
      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }
} 