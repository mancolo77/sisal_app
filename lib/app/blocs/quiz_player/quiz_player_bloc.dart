import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/given_answer.dart';
import '../../../domain/entities/quiz_attempt.dart';
import '../../../domain/repositories/quiz_repository.dart';
import '../../../core/utils/quiz_utils.dart';
import 'quiz_player_event.dart';
import 'quiz_player_state.dart';

class QuizPlayerBloc extends Bloc<QuizPlayerEvent, QuizPlayerState> {
  final QuizRepository _repository;
  final Uuid _uuid = const Uuid();
  Timer? _timer;

  QuizPlayerBloc({required QuizRepository repository})
    : _repository = repository,
      super(QuizPlayerInitial()) {
    on<StartQuiz>(_onStartQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<GoToQuestion>(_onGoToQuestion);
    on<SubmitQuiz>(_onSubmitQuiz);
    on<TimerTick>(_onTimerTick);
    on<TimerExpired>(_onTimerExpired);
    on<PauseQuiz>(_onPauseQuiz);
    on<ResumeQuiz>(_onResumeQuiz);
    on<RestartQuiz>(_onRestartQuiz);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onStartQuiz(
    StartQuiz event,
    Emitter<QuizPlayerState> emit,
  ) async {
    emit(QuizPlayerLoading());

    try {
      final questions = _repository.getQuestionsByIds(
        event.quizSet.questionIds,
      );

      if (questions.isEmpty) {
        emit(const QuizPlayerError('No questions found for this quiz'));
        return;
      }

      // Shuffle questions if needed
      final shuffledQuestions = event.quizSet.shuffleQuestions
          ? QuizUtils.shuffleList(questions)
          : questions;

      // Shuffle options if needed
      final processedQuestions = shuffledQuestions.map((question) {
        if (event.quizSet.shuffleOptions) {
          final shuffledOptions = QuizUtils.shuffleList(question.options);
          return question.copyWith(options: shuffledOptions);
        }
        return question;
      }).toList();

      final startTime = DateTime.now();
      final answers = processedQuestions
          .map(
            (q) => GivenAnswer(
              questionId: q.id,
              chosenOptionIds: [],
              timeSpentSec: 0,
            ),
          )
          .toList();

      emit(
        QuizPlayerReady(
          quizSet: event.quizSet,
          questions: processedQuestions,
          currentQuestionIndex: 0,
          answers: answers,
          startTime: startTime,
          remainingSeconds: event.quizSet.timePerQuestionSec,
        ),
      );

      // Start timer if quiz is timed
      if (event.quizSet.isTimed) {
        _startTimer();
      }
    } catch (e) {
      emit(QuizPlayerError('Failed to start quiz: $e'));
    }
  }

  Future<void> _onAnswerQuestion(
    AnswerQuestion event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;

      final updatedAnswers = currentState.answers.map((answer) {
        if (answer.questionId == event.questionId) {
          return answer.copyWith(chosenOptionIds: event.selectedOptionIds);
        }
        return answer;
      }).toList();

      emit(currentState.copyWith(answers: updatedAnswers));
    }
  }

  Future<void> _onNextQuestion(
    NextQuestion event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;

      if (!currentState.isLastQuestion) {
        final newIndex = currentState.currentQuestionIndex + 1;
        emit(
          currentState.copyWith(
            currentQuestionIndex: newIndex,
            remainingSeconds: currentState.quizSet.timePerQuestionSec,
          ),
        );

        // Restart timer for new question if quiz is timed
        if (currentState.quizSet.isTimed) {
          _startTimer();
        }
      }
    }
  }

  Future<void> _onPreviousQuestion(
    PreviousQuestion event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;

      if (!currentState.isFirstQuestion) {
        final newIndex = currentState.currentQuestionIndex - 1;
        emit(
          currentState.copyWith(
            currentQuestionIndex: newIndex,
            remainingSeconds: currentState.quizSet.timePerQuestionSec,
          ),
        );

        // Restart timer for new question if quiz is timed
        if (currentState.quizSet.isTimed) {
          _startTimer();
        }
      }
    }
  }

  Future<void> _onGoToQuestion(
    GoToQuestion event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;

      if (event.questionIndex >= 0 &&
          event.questionIndex < currentState.questions.length) {
        emit(
          currentState.copyWith(
            currentQuestionIndex: event.questionIndex,
            remainingSeconds: currentState.quizSet.timePerQuestionSec,
          ),
        );

        // Restart timer for new question if quiz is timed
        if (currentState.quizSet.isTimed) {
          _startTimer();
        }
      }
    }
  }

  Future<void> _onSubmitQuiz(
    SubmitQuiz event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;
      _timer?.cancel();

      try {
        final finishTime = DateTime.now();
        int correctCount = 0;

        // Calculate correct answers
        for (final answer in currentState.answers) {
          final question = currentState.questions.firstWhere(
            (q) => q.id == answer.questionId,
          );

          if (QuizUtils.areListsEqual(
            answer.chosenOptionIds,
            question.correctOptionIds,
          )) {
            correctCount++;
          }
        }

        final scorePercent = QuizUtils.calculateScore(
          correctCount,
          currentState.questions.length,
        );

        final attempt = QuizAttempt(
          id: _uuid.v4(),
          quizSetId: currentState.quizSet.id,
          startedAt: currentState.startTime,
          finishedAt: finishTime,
          answers: currentState.answers,
          correctCount: correctCount,
          totalCount: currentState.questions.length,
          scorePercent: scorePercent,
          quizSet: currentState.quizSet,
        );

        await _repository.saveAttempt(attempt);

        emit(
          QuizPlayerCompleted(
            attempt: attempt,
            questions: currentState.questions,
          ),
        );
      } catch (e) {
        emit(QuizPlayerError('Failed to submit quiz: $e'));
      }
    }
  }

  Future<void> _onTimerTick(
    TimerTick event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;

      if (!currentState.isPaused) {
        emit(currentState.copyWith(remainingSeconds: event.remainingSeconds));
      }
    }
  }

  Future<void> _onTimerExpired(
    TimerExpired event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;

      // Auto-submit wrong answer and move to next question
      if (!currentState.isLastQuestion) {
        add(NextQuestion());
      } else {
        add(SubmitQuiz());
      }
    }
  }

  Future<void> _onPauseQuiz(
    PauseQuiz event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;
      _timer?.cancel();
      emit(currentState.copyWith(isPaused: true));
    }
  }

  Future<void> _onResumeQuiz(
    ResumeQuiz event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;
      emit(currentState.copyWith(isPaused: false));

      if (currentState.quizSet.isTimed) {
        _startTimer();
      }
    }
  }

  Future<void> _onRestartQuiz(
    RestartQuiz event,
    Emitter<QuizPlayerState> emit,
  ) async {
    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;
      add(StartQuiz(currentState.quizSet));
    }
  }

  void _startTimer() {
    _timer?.cancel();

    if (state is QuizPlayerReady) {
      final currentState = state as QuizPlayerReady;
      int remainingSeconds = currentState.remainingSeconds ?? 0;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        remainingSeconds--;

        if (remainingSeconds <= 0) {
          timer.cancel();
          add(TimerExpired());
        } else {
          add(TimerTick(remainingSeconds));
        }
      });
    }
  }
}
