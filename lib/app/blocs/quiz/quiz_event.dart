import 'package:equatable/equatable.dart';
import '../../../domain/entities/sport_section.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizSets extends QuizEvent {
  final SportSection? section;

  const LoadQuizSets({this.section});

  @override
  List<Object?> get props => [section];
}

class LoadQuestions extends QuizEvent {
  final SportSection? section;

  const LoadQuestions({this.section});

  @override
  List<Object?> get props => [section];
}

class CreateQuizSet extends QuizEvent {
  final String title;
  final SportSection section;
  final List<String> questionIds;
  final bool shuffleQuestions;
  final bool shuffleOptions;
  final int? timePerQuestionSec;

  const CreateQuizSet({
    required this.title,
    required this.section,
    required this.questionIds,
    required this.shuffleQuestions,
    required this.shuffleOptions,
    this.timePerQuestionSec,
  });

  @override
  List<Object?> get props => [
        title,
        section,
        questionIds,
        shuffleQuestions,
        shuffleOptions,
        timePerQuestionSec,
      ];
}

class DeleteQuizSet extends QuizEvent {
  final String quizSetId;

  const DeleteQuizSet(this.quizSetId);

  @override
  List<Object?> get props => [quizSetId];
}

class FilterQuizSets extends QuizEvent {
  final SportSection? section;
  final int? difficulty;
  final String? searchQuery;

  const FilterQuizSets({
    this.section,
    this.difficulty,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [section, difficulty, searchQuery];
}
