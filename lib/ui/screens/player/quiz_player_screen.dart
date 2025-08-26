import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/quiz_set.dart';
import '../../../app/blocs/quiz_player/quiz_player_bloc.dart';
import '../../../app/blocs/quiz_player/quiz_player_event.dart';
import '../../../app/blocs/quiz_player/quiz_player_state.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/quiz_question_card.dart';
import '../../widgets/quiz_progress_bar.dart';
import '../../widgets/quiz_timer.dart';

class QuizPlayerScreen extends StatefulWidget {
  final QuizSet quizSet;

  const QuizPlayerScreen({super.key, required this.quizSet});

  @override
  State<QuizPlayerScreen> createState() => _QuizPlayerScreenState();
}

class _QuizPlayerScreenState extends State<QuizPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizPlayerBloc>().add(StartQuiz(widget.quizSet));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizSet.title, style: AppTypography.h4),
        actions: [
          BlocBuilder<QuizPlayerBloc, QuizPlayerState>(
            builder: (context, state) {
              if (state is QuizPlayerReady) {
                return IconButton(
                  onPressed: () => _showPauseDialog(context),
                  icon: Icon(state.isPaused ? Icons.play_arrow : Icons.pause),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<QuizPlayerBloc, QuizPlayerState>(
        listener: (context, state) {
          if (state is QuizPlayerCompleted) {
            context.pushReplacement(AppRouter.results, extra: state.attempt);
          } else if (state is QuizPlayerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<QuizPlayerBloc, QuizPlayerState>(
          builder: (context, state) {
            if (state is QuizPlayerLoading) {
              return const LoadingIndicator(message: 'Loading quiz...');
            } else if (state is QuizPlayerReady) {
              return _buildQuizContent(context, state);
            } else if (state is QuizPlayerError) {
              return _buildErrorState(state.message);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildQuizContent(BuildContext context, QuizPlayerReady state) {
    return Column(
      children: [
        // Progress and timer
        _buildHeader(context, state),

        // Question content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: QuizQuestionCard(
              question: state.currentQuestion,
              selectedOptions: state.currentAnswer?.chosenOptionIds ?? [],
              onOptionSelected: (optionIds) {
                context.read<QuizPlayerBloc>().add(
                  AnswerQuestion(
                    questionId: state.currentQuestion.id,
                    selectedOptionIds: optionIds,
                  ),
                );
              },
            ),
          ),
        ),

        // Navigation buttons
        _buildNavigationButtons(context, state),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, QuizPlayerReady state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        children: [
          // Progress bar
          QuizProgressBar(
            current: state.currentQuestionIndex + 1,
            total: state.questions.length,
            progress: state.progress,
          ),
          const SizedBox(height: 12),

          // Question counter and timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${state.currentQuestionIndex + 1} of ${state.questions.length}',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (state.quizSet.isTimed && state.remainingSeconds != null)
                QuizTimer(
                  remainingSeconds: state.remainingSeconds!,
                  totalSeconds: state.quizSet.timePerQuestionSec!,
                  isPaused: state.isPaused,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, QuizPlayerReady state) {
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
              onPressed: state.isFirstQuestion
                  ? null
                  : () =>
                        context.read<QuizPlayerBloc>().add(PreviousQuestion()),
              icon: const Icon(Icons.arrow_back_outlined),
              label: const Text('Previous'),
            ),
          ),
          const SizedBox(width: 16),

          // Next/Submit button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _canProceed(state)
                  ? () {
                      if (state.isLastQuestion) {
                        _showSubmitDialog(context, state);
                      } else {
                        context.read<QuizPlayerBloc>().add(NextQuestion());
                      }
                    }
                  : null,
              icon: Icon(
                state.isLastQuestion
                    ? Icons.check_outlined
                    : Icons.arrow_forward_outlined,
              ),
              label: Text(state.isLastQuestion ? 'Submit' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Quiz Error',
              style: AppTypography.h3.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Text(
              message,
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

  void _showPauseDialog(BuildContext context) {
    final bloc = context.read<QuizPlayerBloc>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Paused'),
        content: const Text('The quiz is paused. You can resume or quit.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(); // Go back to quiz sets
            },
            child: const Text('Quit Quiz'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              bloc.add(ResumeQuiz());
            },
            child: const Text('Resume'),
          ),
        ],
      ),
    );

    bloc.add(PauseQuiz());
  }

  bool _canProceed(QuizPlayerReady state) {
    // Check if current question has been answered
    return state.currentAnswer != null &&
        state.currentAnswer!.chosenOptionIds.isNotEmpty;
  }

  void _showSubmitDialog(BuildContext context, QuizPlayerReady state) {
    final unansweredCount =
        state.questions.length - state.answeredQuestionsCount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to submit your quiz?'),
            const SizedBox(height: 8),
            Text(
              'Answered: ${state.answeredQuestionsCount}/${state.questions.length}',
              style: AppTypography.body,
            ),
            if (unansweredCount > 0)
              Text(
                'Unanswered: $unansweredCount questions will be marked as incorrect.',
                style: AppTypography.body.copyWith(color: AppColors.warning),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<QuizPlayerBloc>().add(SubmitQuiz());
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
