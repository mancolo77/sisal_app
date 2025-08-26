// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'given_answer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GivenAnswerAdapter extends TypeAdapter<GivenAnswer> {
  @override
  final int typeId = 5;

  @override
  GivenAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GivenAnswer(
      questionId: fields[0] as String,
      chosenOptionIds: (fields[1] as List).cast<String>(),
      timeSpentSec: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GivenAnswer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.chosenOptionIds)
      ..writeByte(2)
      ..write(obj.timeSpentSec);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GivenAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
