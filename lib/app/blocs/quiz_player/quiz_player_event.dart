import 'package:equatable/equatable.dart';
import '../../../domain/entities/quiz_set.dart';

abstract class QuizPlayerEvent extends Equatable {
  const QuizPlayerEvent();

  @override
  List<Object?> get props => [];
}

class StartQuiz extends QuizPlayerEvent {
  final QuizSet quizSet;

  const StartQuiz(this.quizSet);

  @override
  List<Object?> get props => [quizSet];
}

class AnswerQuestion extends QuizPlayerEvent {
  final String questionId;
  final List<String> selectedOptionIds;

  const AnswerQuestion({
    required this.questionId,
    required this.selectedOptionIds,
  });

  @override
  List<Object?> get props => [questionId, selectedOptionIds];
}

class NextQuestion extends QuizPlayerEvent {}

class PreviousQuestion extends QuizPlayerEvent {}

class GoToQuestion extends QuizPlayerEvent {
  final int questionIndex;

  const GoToQuestion(this.questionIndex);

  @override
  List<Object?> get props => [questionIndex];
}

class SubmitQuiz extends QuizPlayerEvent {}

class TimerTick extends QuizPlayerEvent {
  final int remainingSeconds;

  const TimerTick(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class TimerExpired extends QuizPlayerEvent {}

class PauseQuiz extends QuizPlayerEvent {}

class ResumeQuiz extends QuizPlayerEvent {}

class RestartQuiz extends QuizPlayerEvent {}
