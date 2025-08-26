import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/sport_section.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';
import '../../../app/routes/app_router.dart';
import '../../widgets/section_card.dart';
import '../../widgets/gradient_button.dart';

class HomeSectionsScreen extends StatelessWidget {
  const HomeSectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App header
              _buildHeader(context),
              const SizedBox(height: 32),

              // Sports sections grid
              _buildSectionsGrid(context),
              const SizedBox(height: 32),

              // Action buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sisal', style: AppTypography.h1),
                const SizedBox(height: 4),
                Text(
                  'Sports Sections Quiz',
                  style: AppTypography.body.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            IconButton(
              onPressed: () => context.push(AppRouter.settings),
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Learn across sports sections, answer fast, review smarter — fully offline.',
          style: AppTypography.body,
        ),
      ],
    );
  }

  Widget _buildSectionsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Your Sport', style: AppTypography.h3),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: SportSection.values.length,
          itemBuilder: (context, index) {
            final section = SportSection.values[index];
            return SectionCard(
              section: section,
              onTap: () => _navigateToQuizSets(context, section),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientButton(
          onPressed: () => context.push(AppRouter.quizSets),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.quiz_outlined, size: 20),
              const SizedBox(width: 8),
              Text('Browse All Quizzes', style: AppTypography.button),
            ],
          ),
        ),

        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.push(AppRouter.history),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.history_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'View History',
                style: AppTypography.button.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToQuizSets(BuildContext context, SportSection section) {
    context.push('${AppRouter.quizSets}?section=${section.name}');
  }
}
