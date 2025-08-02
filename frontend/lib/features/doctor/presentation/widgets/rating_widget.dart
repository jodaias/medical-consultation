import 'package:flutter/material.dart';
import 'package:medical_consultation_app/core/theme/app_theme.dart';
import 'package:medical_consultation_app/core/utils/constants.dart';
import 'package:medical_consultation_app/features/doctor/data/models/rating_model.dart';

class RatingWidget extends StatelessWidget {
  final RatingModel rating;

  const RatingWidget({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryColor,
                  backgroundImage: rating.patientAvatar != null
                      ? NetworkImage(rating.patientAvatar!)
                      : null,
                  child: rating.patientAvatar == null
                      ? Text(
                          rating.patientName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rating.patientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (index) => Icon(
                            index < rating.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: AppTheme.accentColor,
                            size: 16,
                          )),
                          const SizedBox(width: 8),
                          Text(
                            rating.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (rating.isVerified)
                  Icon(
                    Icons.verified,
                    color: AppTheme.successColor,
                    size: 16,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              rating.comment,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(rating.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'há ${difference.inMinutes} minutos';
      }
      return 'há ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'ontem';
    } else if (difference.inDays < 7) {
      return 'há ${difference.inDays} dias';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 