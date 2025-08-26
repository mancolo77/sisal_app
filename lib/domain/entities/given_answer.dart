import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'given_answer.g.dart';

@HiveType(typeId: 5)
class GivenAnswer extends Equatable {
  @HiveField(0)
  final String questionId;
  
  @HiveField(1)
  final List<String> chosenOptionIds;
  
  @HiveField(2)
  final int timeSpentSec;

  const GivenAnswer({
    required this.questionId,
    required this.chosenOptionIds,
    required this.timeSpentSec,
  });

  @override
  List<Object?> get props => [questionId, chosenOptionIds, timeSpentSec];

  bool get hasAnswer => chosenOptionIds.isNotEmpty;

  GivenAnswer copyWith({
    String? questionId,
    List<String>? chosenOptionIds,
    int? timeSpentSec,
  }) {
    return GivenAnswer(
      questionId: questionId ?? this.questionId,
      chosenOptionIds: chosenOptionIds ?? this.chosenOptionIds,
      timeSpentSec: timeSpentSec ?? this.timeSpentSec,
    );
  }
}
