import 'package:flutter/material.dart';
import '../../../domain/entities/sport_section.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';

class CreateQuizScreen extends StatelessWidget {
  final SportSection? preselectedSection;

  const CreateQuizScreen({
    super.key,
    this.preselectedSection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Quiz',
          style: AppTypography.h3,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Create Quiz Coming Soon',
                style: AppTypography.h3.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create custom quiz sets with your own selection of questions.',
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              if (preselectedSection != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Preselected section: ${preselectedSection!.displayName}',
                  style: AppTypography.body.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
