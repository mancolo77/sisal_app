import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
import 'answer_option.dart';
import 'sport_section.dart';

part 'question_model.g.dart';

@HiveType(typeId: 3)
class QuestionModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final SportSection section;
  
  @HiveField(2)
  final String text;
  
  @HiveField(3)
  final List<AnswerOption> options;
  
  @HiveField(4)
  final List<String> correctOptionIds;
  
  @HiveField(5)
  final String? explanation;
  
  @HiveField(6)
  final String? tags;
  
  @HiveField(7)
  final int difficulty;

  const QuestionModel({
    required this.id,
    required this.section,
    required this.text,
    required this.options,
    required this.correctOptionIds,
    this.explanation,
    this.tags,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [
        id,
        section,
        text,
        options,
        correctOptionIds,
        explanation,
        tags,
        difficulty,
      ];

  bool get isMultipleChoice => correctOptionIds.length > 1;

  bool get isTrueFalse => options.length == 2;

  List<String> get tagsList => tags?.split(',').map((e) => e.trim()).toList() ?? [];

  QuestionModel copyWith({
    String? id,
    SportSection? section,
    String? text,
    List<AnswerOption>? options,
    List<String>? correctOptionIds,
    String? explanation,
    String? tags,
    int? difficulty,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      section: section ?? this.section,
      text: text ?? this.text,
      options: options ?? this.options,
      correctOptionIds: correctOptionIds ?? this.correctOptionIds,
      explanation: explanation ?? this.explanation,
      tags: tags ?? this.tags,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
