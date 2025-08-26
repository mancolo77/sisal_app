import 'package:equatable/equatable.dart';
import '../../../domain/entities/quiz_set.dart';
import '../../../domain/entities/question_model.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuizSet> quizSets;
  final List<QuestionModel> questions;
  final List<QuizSet> filteredQuizSets;

  const QuizLoaded({
    required this.quizSets,
    required this.questions,
    required this.filteredQuizSets,
  });

  @override
  List<Object?> get props => [quizSets, questions, filteredQuizSets];

  QuizLoaded copyWith({
    List<QuizSet>? quizSets,
    List<QuestionModel>? questions,
    List<QuizSet>? filteredQuizSets,
  }) {
    return QuizLoaded(
      quizSets: quizSets ?? this.quizSets,
      questions: questions ?? this.questions,
      filteredQuizSets: filteredQuizSets ?? this.filteredQuizSets,
    );
  }
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}

class QuizSetCreated extends QuizState {
  final QuizSet quizSet;

  const QuizSetCreated(this.quizSet);

  @override
  List<Object?> get props => [quizSet];
}

class QuizSetDeleted extends QuizState {
  final String quizSetId;

  const QuizSetDeleted(this.quizSetId);

  @override
  List<Object?> get props => [quizSetId];
}
