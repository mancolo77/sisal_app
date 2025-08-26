// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_set.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuizSetAdapter extends TypeAdapter<QuizSet> {
  @override
  final int typeId = 4;

  @override
  QuizSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuizSet(
      id: fields[0] as String,
      title: fields[1] as String,
      section: fields[2] as SportSection,
      questionIds: (fields[3] as List).cast<String>(),
      isSystem: fields[4] as bool,
      shuffleQuestions: fields[5] as bool,
      shuffleOptions: fields[6] as bool,
      timePerQuestionSec: fields[7] as int?,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QuizSet obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.section)
      ..writeByte(3)
      ..write(obj.questionIds)
      ..writeByte(4)
      ..write(obj.isSystem)
      ..writeByte(5)
      ..write(obj.shuffleQuestions)
      ..writeByte(6)
      ..write(obj.shuffleOptions)
      ..writeByte(7)
      ..write(obj.timePerQuestionSec)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
