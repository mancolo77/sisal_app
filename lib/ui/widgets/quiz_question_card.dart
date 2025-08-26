import 'package:flutter/material.dart';
import '../../domain/entities/question_model.dart';
import '../../domain/entities/answer_option.dart';
import '../../domain/entities/sport_section.dart';
import '../../core/colors/app_colors.dart';
import '../../core/typography/app_typography.dart';
import '../../core/utils/quiz_utils.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuestionModel question;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onOptionSelected;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.selectedOptions,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            _buildQuestionHeader(),
            const SizedBox(height: 20),
            
            // Question text
            _buildQuestionText(),
            const SizedBox(height: 24),
            
            // Answer options
            Expanded(
              child: _buildAnswerOptions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader() {
    return Row(
      children: [
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getDifficultyColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                QuizUtils.getDifficultyEmoji(question.difficulty),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 4),
              Text(
                QuizUtils.getDifficultyLabel(question.difficulty),
                style: AppTypography.caption.copyWith(
                  color: _getDifficultyColor(),
                  fontWeight: FontWeight.w600,
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
    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final option = question.options[index];
        final isSelected = selectedOptions.contains(option.id);
        
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == question.options.length - 1 ? 0 : 12,
          ),
          child: _buildOptionTile(option, isSelected),
        );
      },
    );
  }

  Widget _buildOptionTile(AnswerOption option, bool isSelected) {
    return InkWell(
      onTap: () => _handleOptionTap(option.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary 
                : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Selection indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: question.isMultipleChoice 
                    ? BoxShape.rectangle 
                    : BoxShape.circle,
                borderRadius: question.isMultipleChoice 
                    ? BorderRadius.circular(4) 
                    : null,
                border: Border.all(
                  color: isSelected 
                      ? AppColors.primary 
                      : AppColors.textSecondary,
                  width: 2,
                ),
                color: isSelected 
                    ? AppColors.primary 
                    : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      question.isMultipleChoice 
                          ? Icons.check 
                          : Icons.circle,
                      size: 14,
                      color: AppColors.background,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            
            // Option text
            Expanded(
              child: Text(
                option.text,
                style: AppTypography.body.copyWith(
                  color: isSelected 
                      ? AppColors.textPrimary 
                      : AppColors.textSecondary,
                  fontWeight: isSelected 
                      ? FontWeight.w600 
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOptionTap(String optionId) {
    List<String> newSelection;
    
    if (question.isMultipleChoice) {
      // Multiple choice: toggle selection
      if (selectedOptions.contains(optionId)) {
        newSelection = selectedOptions.where((id) => id != optionId).toList();
      } else {
        newSelection = [...selectedOptions, optionId];
      }
    } else {
      // Single choice: replace selection
      newSelection = [optionId];
    }
    
    onOptionSelected(newSelection);
  }

  Color _getDifficultyColor() {
    switch (question.difficulty) {
      case 1:
      case 2:
        return AppColors.success;
      case 3:
        return AppColors.warning;
      case 4:
      case 5:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
