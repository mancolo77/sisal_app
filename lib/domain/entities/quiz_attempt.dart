import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'given_answer.dart';
import 'quiz_set.dart';
import 'sport_section.dart';

part 'quiz_attempt.g.dart';

@HiveType(typeId: 6)
class QuizAttempt extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String quizSetId;

  @HiveField(2)
  final DateTime startedAt;

  @HiveField(3)
  final DateTime finishedAt;

  @HiveField(4)
  final List<GivenAnswer> answers;

  @HiveField(5)
  final int correctCount;

  @HiveField(6)
  final int totalCount;

  @HiveField(7)
  final double scorePercent;

  @HiveField(8)
  final QuizSet? quizSet;

  const QuizAttempt({
    required this.id,
    required this.quizSetId,
    required this.startedAt,
    required this.finishedAt,
    required this.answers,
    required this.correctCount,
    required this.totalCount,
    required this.scorePercent,
    this.quizSet,
  });

  @override
  List<Object?> get props => [
    id,
    quizSetId,
    startedAt,
    finishedAt,
    answers,
    correctCount,
    totalCount,
    scorePercent,
    quizSet,
  ];

  Duration get duration => finishedAt.difference(startedAt);

  DateTime get completedAt => finishedAt;

  /// Get QuizSet - either from stored value or create a fallback
  QuizSet get quizSetSafe {
    if (quizSet != null) return quizSet!;

    // Create fallback QuizSet for old data
    return QuizSet(
      id: quizSetId,
      title: 'Quiz',
      section: SportSection.football, // Default section
      questionIds: answers.map((a) => a.questionId).toList(),
      isSystem: true,
      timePerQuestionSec: null,
      shuffleQuestions: false,
      shuffleOptions: false,
      createdAt: startedAt,
    );
  }

  int get totalTimeSpent =>
      answers.fold(0, (sum, answer) => sum + answer.timeSpentSec);

  bool get isPerfectScore => scorePercent == 100.0;

  String get scoreGrade {
    if (scorePercent >= 90) return 'Excellent';
    if (scorePercent >= 80) return 'Good';
    if (scorePercent >= 70) return 'Fair';
    if (scorePercent >= 60) return 'Pass';
    return 'Needs Improvement';
  }

  QuizAttempt copyWith({
    String? id,
    String? quizSetId,
    DateTime? startedAt,
    DateTime? finishedAt,
    List<GivenAnswer>? answers,
    int? correctCount,
    int? totalCount,
    double? scorePercent,
    QuizSet? quizSet,
  }) {
    return QuizAttempt(
      id: id ?? this.id,
      quizSetId: quizSetId ?? this.quizSetId,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      answers: answers ?? this.answers,
      correctCount: correctCount ?? this.correctCount,
      totalCount: totalCount ?? this.totalCount,
      scorePercent: scorePercent ?? this.scorePercent,
      quizSet: quizSet ?? this.quizSet,
    );
  }
}
