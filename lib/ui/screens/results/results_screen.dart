import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/quiz_attempt.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';
import '../../../core/utils/quiz_utils.dart';
import '../../../app/routes/app_router.dart';
import '../../widgets/score_display.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/gradient_button.dart';

class ResultsScreen extends StatelessWidget {
  final QuizAttempt attempt;

  const ResultsScreen({super.key, required this.attempt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results', style: AppTypography.h3),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score display
            ScoreDisplay(
              score: attempt.scorePercent,
              grade: attempt.scoreGrade,
            ),
            const SizedBox(height: 32),

            // Stats cards
            _buildStatsSection(),
            const SizedBox(height: 32),

            // Achievement/Feedback
            _buildFeedbackSection(),
            const SizedBox(height: 32),

            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Performance Summary', style: AppTypography.h4),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                icon: Icons.check_circle_outline,
                title: 'Correct',
                value: '${attempt.correctCount}',
                subtitle: 'out of ${attempt.totalCount}',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                icon: Icons.cancel_outlined,
                title: 'Incorrect',
                value: '${attempt.totalCount - attempt.correctCount}',
                subtitle: 'questions',
                color: AppColors.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                icon: Icons.access_time_outlined,
                title: 'Total Time',
                value: QuizUtils.formatDuration(attempt.duration),
                subtitle: 'spent on quiz',
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                icon: Icons.speed_outlined,
                title: 'Avg. Time',
                value: QuizUtils.formatTime(
                  (attempt.totalTimeSpent / attempt.totalCount).round(),
                ),
                subtitle: 'per question',
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getScoreColor().withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(_getScoreIcon(), size: 48, color: _getScoreColor()),
          const SizedBox(height: 12),
          Text(
            _getFeedbackTitle(),
            style: AppTypography.h4.copyWith(color: _getScoreColor()),
          ),
          const SizedBox(height: 8),
          Text(
            _getFeedbackMessage(),
            style: AppTypography.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientButton(
          onPressed: () => context.push(AppRouter.review, extra: attempt),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.rate_review_outlined, size: 20),
              const SizedBox(width: 8),
              Text('Review Answers', style: AppTypography.button),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _retryQuiz(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.refresh_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'Retry Quiz',
                style: AppTypography.button.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go(AppRouter.home),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'Back to Home',
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

  Color _getScoreColor() {
    if (attempt.scorePercent >= 90) return AppColors.success;
    if (attempt.scorePercent >= 70) return AppColors.primary;
    if (attempt.scorePercent >= 60) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getScoreIcon() {
    if (attempt.scorePercent >= 90) return Icons.emoji_events_outlined;
    if (attempt.scorePercent >= 70) return Icons.thumb_up_outlined;
    if (attempt.scorePercent >= 60) return Icons.trending_up_outlined;
    return Icons.trending_down_outlined;
  }

  String _getFeedbackTitle() {
    if (attempt.scorePercent >= 90) return 'Outstanding!';
    if (attempt.scorePercent >= 80) return 'Great Job!';
    if (attempt.scorePercent >= 70) return 'Well Done!';
    if (attempt.scorePercent >= 60) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  String _getFeedbackMessage() {
    if (attempt.scorePercent >= 90) {
      return 'Excellent performance! You have mastered this topic.';
    } else if (attempt.scorePercent >= 80) {
      return 'Great work! You have a strong understanding of this topic.';
    } else if (attempt.scorePercent >= 70) {
      return 'Good job! You have a solid grasp of the fundamentals.';
    } else if (attempt.scorePercent >= 60) {
      return 'You\'re on the right track. Review the explanations to improve.';
    } else {
      return 'Don\'t give up! Practice more and review the explanations.';
    }
  }

  void _retryQuiz(BuildContext context) {
    // Navigate back to the quiz player with the same quiz set
    context.pushReplacement(AppRouter.player, extra: attempt.quizSetSafe);
  }
}
