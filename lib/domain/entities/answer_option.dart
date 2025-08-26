import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'answer_option.g.dart';

@HiveType(typeId: 2)
class AnswerOption extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String text;

  const AnswerOption({
    required this.id,
    required this.text,
  });

  @override
  List<Object?> get props => [id, text];

  AnswerOption copyWith({
    String? id,
    String? text,
  }) {
    return AnswerOption(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }
}
