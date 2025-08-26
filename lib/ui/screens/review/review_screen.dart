import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/quiz_attempt.dart';
import '../../../domain/entities/question_model.dart';
import '../../../data/repositories/quiz_repository_impl.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';
import '../../../core/utils/quiz_utils.dart';
import '../../widgets/review_question_card.dart';
import '../../widgets/loading_indicator.dart';

class ReviewScreen extends StatefulWidget {
  final QuizAttempt attempt;

  const ReviewScreen({super.key, required this.attempt});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  List<QuestionModel>? _questions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      final repository = context.read<QuizRepositoryImpl>();
      final questionIds = widget.attempt.answers
          .map((a) => a.questionId)
          .toList();
      final questions = repository.getQuestionsByIds(questionIds);

      if (questions.isEmpty) {
        // Try to get all questions and filter
        final allQuestions = repository.getAllQuestions();
        final filteredQuestions = allQuestions
            .where((q) => questionIds.contains(q.id))
            .toList();

        setState(() {
          _questions = filteredQuestions;
          _isLoading = false;
        });
      } else {
        setState(() {
          _questions = questions;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading questions for review: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load questions: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Answers', style: AppTypography.h3),
        actions: [
          if (_questions != null)
            IconButton(
              onPressed: _showQuestionNavigation,
              icon: const Icon(Icons.list_outlined),
            ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator(message: 'Loading questions...')
          : _questions == null || _questions!.isEmpty
          ? _buildErrorState()
          : _buildReviewContent(),
    );
  }

  Widget _buildReviewContent() {
    return Column(
      children: [
        // Progress indicator
        _buildProgressHeader(),

        // Question pages
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _questions!.length,
            itemBuilder: (context, index) {
              final question = _questions![index];
              final answer = widget.attempt.answers.firstWhere(
                (a) => a.questionId == question.id,
              );
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ReviewQuestionCard(
                  question: question,
                  givenAnswer: answer,
                ),
              );
            },
          ),
        ),

        // Navigation buttons
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions!.length,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 12),

          // Question counter and result
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentIndex + 1} of ${_questions!.length}',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              _buildQuestionResult(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionResult() {
    final question = _questions![_currentIndex];
    final answer = widget.attempt.answers.firstWhere(
      (a) => a.questionId == question.id,
    );

    final isCorrect = QuizUtils.areListsEqual(
      answer.chosenOptionIds,
      question.correctOptionIds,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isCorrect ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 4),
          Text(
            isCorrect ? 'Correct' : 'Incorrect',
            style: AppTypography.caption.copyWith(
              color: isCorrect ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          // Previous button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _currentIndex > 0
                  ? () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    )
                  : null,
              icon: const Icon(Icons.arrow_back_outlined),
              label: const Text('Previous'),
            ),
          ),
          const SizedBox(width: 16),

          // Next/Done button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                if (_currentIndex < _questions!.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  context.pop();
                }
              },
              icon: Icon(
                _currentIndex < _questions!.length - 1
                    ? Icons.arrow_forward_outlined
                    : Icons.done_outlined,
              ),
              label: Text(
                _currentIndex < _questions!.length - 1 ? 'Next' : 'Done',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'No Questions Found',
              style: AppTypography.h3.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load the questions for this quiz attempt.',
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuestionNavigation() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jump to Question', style: AppTypography.h4),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _questions!.length,
                itemBuilder: (context, index) {
                  final question = _questions![index];
                  final answer = widget.attempt.answers.firstWhere(
                    (a) => a.questionId == question.id,
                  );

                  final isCorrect = QuizUtils.areListsEqual(
                    answer.chosenOptionIds,
                    question.correctOptionIds,
                  );

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? AppColors.primary
                            : isCorrect
                            ? AppColors.success.withOpacity(0.2)
                            : AppColors.error.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCorrect
                              ? AppColors.success
                              : AppColors.error,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTypography.button.copyWith(
                            color: index == _currentIndex
                                ? AppColors.background
                                : isCorrect
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
