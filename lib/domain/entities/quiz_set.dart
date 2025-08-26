import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'sport_section.dart';

part 'quiz_set.g.dart';

@HiveType(typeId: 4)
class QuizSet extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final SportSection section;
  
  @HiveField(3)
  final List<String> questionIds;
  
  @HiveField(4)
  final bool isSystem;
  
  @HiveField(5)
  final bool shuffleQuestions;
  
  @HiveField(6)
  final bool shuffleOptions;
  
  @HiveField(7)
  final int? timePerQuestionSec;
  
  @HiveField(8)
  final DateTime createdAt;

  const QuizSet({
    required this.id,
    required this.title,
    required this.section,
    required this.questionIds,
    required this.isSystem,
    required this.shuffleQuestions,
    required this.shuffleOptions,
    this.timePerQuestionSec,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        section,
        questionIds,
        isSystem,
        shuffleQuestions,
        shuffleOptions,
        timePerQuestionSec,
        createdAt,
      ];

  bool get isTimed => timePerQuestionSec != null && timePerQuestionSec! > 0;

  int get questionCount => questionIds.length;

  QuizSet copyWith({
    String? id,
    String? title,
    SportSection? section,
    List<String>? questionIds,
    bool? isSystem,
    bool? shuffleQuestions,
    bool? shuffleOptions,
    int? timePerQuestionSec,
    DateTime? createdAt,
  }) {
    return QuizSet(
      id: id ?? this.id,
      title: title ?? this.title,
      section: section ?? this.section,
      questionIds: questionIds ?? this.questionIds,
      isSystem: isSystem ?? this.isSystem,
      shuffleQuestions: shuffleQuestions ?? this.shuffleQuestions,
      shuffleOptions: shuffleOptions ?? this.shuffleOptions,
      timePerQuestionSec: timePerQuestionSec ?? this.timePerQuestionSec,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
