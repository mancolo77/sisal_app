import 'package:flutter/material.dart';
import '../../domain/entities/question_model.dart';
import '../../domain/entities/given_answer.dart';
import '../../domain/entities/answer_option.dart';
import '../../domain/entities/sport_section.dart';
import '../../core/colors/app_colors.dart';
import '../../core/typography/app_typography.dart';
import '../../core/utils/quiz_utils.dart';

class ReviewQuestionCard extends StatelessWidget {
  final QuestionModel question;
  final GivenAnswer givenAnswer;

  const ReviewQuestionCard({
    super.key,
    required this.question,
    required this.givenAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = QuizUtils.areListsEqual(
      givenAnswer.chosenOptionIds,
      question.correctOptionIds,
    );

    return Card(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            _buildQuestionHeader(isCorrect),
            const SizedBox(height: 20),
            
            // Question text
            _buildQuestionText(),
            const SizedBox(height: 24),
            
            // Answer options
            _buildAnswerOptions(),
            
            // Explanation (if available)
            if (question.explanation != null) ...[
              const SizedBox(height: 24),
              _buildExplanation(),
            ],
            
            // Stats
            const SizedBox(height: 20),
            _buildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader(bool isCorrect) {
    return Row(
      children: [
        // Section info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                question.section.emoji,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              Text(
                question.section.displayName,
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        
        // Result indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isCorrect 
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCorrect ? AppColors.success : AppColors.error,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: isCorrect ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 6),
              Text(
                isCorrect ? 'CORRECT' : 'INCORRECT',
                style: AppTypography.caption.copyWith(
                  color: isCorrect ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        question.text,
        style: AppTypography.bodyLarge.copyWith(
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildAnswerOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Answer Options',
          style: AppTypography.h4.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...question.options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOptionTile(option),
        )),
      ],
    );
  }

  Widget _buildOptionTile(AnswerOption option) {
    final isCorrect = question.correctOptionIds.contains(option.id);
    final wasSelected = givenAnswer.chosenOptionIds.contains(option.id);
    
    Color borderColor;
    Color backgroundColor;
    IconData? icon;
    
    if (isCorrect && wasSelected) {
      // Correct and selected
      borderColor = AppColors.success;
      backgroundColor = AppColors.success.withOpacity(0.1);
      icon = Icons.check_circle;
    } else if (isCorrect && !wasSelected) {
      // Correct but not selected
      borderColor = AppColors.success;
      backgroundColor = AppColors.success.withOpacity(0.05);
      icon = Icons.check_circle_outline;
    } else if (!isCorrect && wasSelected) {
      // Incorrect but selected
      borderColor = AppColors.error;
      backgroundColor = AppColors.error.withOpacity(0.1);
      icon = Icons.cancel;
    } else {
      // Not selected and not correct
      borderColor = AppColors.divider;
      backgroundColor = AppColors.cardBackground;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isCorrect || wasSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Status icon
          if (icon != null)
            Icon(
              icon,
              size: 20,
              color: isCorrect ? AppColors.success : AppColors.error,
            )
          else
            const SizedBox(width: 20),
          const SizedBox(width: 12),
          
          // Option text
          Expanded(
            child: Text(
              option.text,
              style: AppTypography.body.copyWith(
                color: (isCorrect || wasSelected) 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary,
                fontWeight: (isCorrect || wasSelected) 
                    ? FontWeight.w600 
                    : FontWeight.w500,
              ),
            ),
          ),
          
          // Status labels
          if (isCorrect && wasSelected)
            _buildStatusChip('Your Answer', AppColors.success)
          else if (isCorrect)
            _buildStatusChip('Correct Answer', AppColors.success)
          else if (wasSelected)
            _buildStatusChip('Your Answer', AppColors.error),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExplanation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'Explanation',
                style: AppTypography.h4.copyWith(
                  fontSize: 16,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation!,
            style: AppTypography.body.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            'Time spent: ${QuizUtils.formatTime(givenAnswer.timeSpentSec)}',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.bar_chart_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            'Difficulty: ${QuizUtils.getDifficultyLabel(question.difficulty)}',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
