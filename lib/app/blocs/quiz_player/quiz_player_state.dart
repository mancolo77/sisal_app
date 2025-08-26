import 'package:equatable/equatable.dart';
import '../../../domain/entities/quiz_set.dart';
import '../../../domain/entities/question_model.dart';
import '../../../domain/entities/given_answer.dart';
import '../../../domain/entities/quiz_attempt.dart';

abstract class QuizPlayerState extends Equatable {
  const QuizPlayerState();

  @override
  List<Object?> get props => [];
}

class QuizPlayerInitial extends QuizPlayerState {}

class QuizPlayerLoading extends QuizPlayerState {}

class QuizPlayerReady extends QuizPlayerState {
  final QuizSet quizSet;
  final List<QuestionModel> questions;
  final int currentQuestionIndex;
  final List<GivenAnswer> answers;
  final DateTime startTime;
  final int? remainingSeconds;
  final bool isPaused;

  const QuizPlayerReady({
    required this.quizSet,
    required this.questions,
    required this.currentQuestionIndex,
    required this.answers,
    required this.startTime,
    this.remainingSeconds,
    this.isPaused = false,
  });

  @override
  List<Object?> get props => [
        quizSet,
        questions,
        currentQuestionIndex,
        answers,
        startTime,
        remainingSeconds,
        isPaused,
      ];

  QuestionModel get currentQuestion => questions[currentQuestionIndex];
  
  bool get isFirstQuestion => currentQuestionIndex == 0;
  
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  
  bool get hasAnsweredCurrentQuestion {
    return answers.any((answer) => answer.questionId == currentQuestion.id);
  }

  GivenAnswer? get currentAnswer {
    return answers.firstWhere(
      (answer) => answer.questionId == currentQuestion.id,
      orElse: () => GivenAnswer(
        questionId: currentQuestion.id,
        chosenOptionIds: [],
        timeSpentSec: 0,
      ),
    );
  }

  int get answeredQuestionsCount {
    return answers.where((answer) => answer.chosenOptionIds.isNotEmpty).length;
  }

  double get progress => (currentQuestionIndex + 1) / questions.length;

  bool get canSubmit => answeredQuestionsCount == questions.length;

  QuizPlayerReady copyWith({
    QuizSet? quizSet,
    List<QuestionModel>? questions,
    int? currentQuestionIndex,
    List<GivenAnswer>? answers,
    DateTime? startTime,
    int? remainingSeconds,
    bool? isPaused,
  }) {
    return QuizPlayerReady(
      quizSet: quizSet ?? this.quizSet,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
      startTime: startTime ?? this.startTime,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

class QuizPlayerCompleted extends QuizPlayerState {
  final QuizAttempt attempt;
  final List<QuestionModel> questions;

  const QuizPlayerCompleted({
    required this.attempt,
    required this.questions,
  });

  @override
  List<Object?> get props => [attempt, questions];
}

class QuizPlayerError extends QuizPlayerState {
  final String message;

  const QuizPlayerError(this.message);

  @override
  List<Object?> get props => [message];
}
