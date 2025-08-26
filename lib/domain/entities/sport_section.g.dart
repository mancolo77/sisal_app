// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SportSectionAdapter extends TypeAdapter<SportSection> {
  @override
  final int typeId = 1;

  @override
  SportSection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SportSection.football;
      case 1:
        return SportSection.basketball;
      case 2:
        return SportSection.tennis;
      case 3:
        return SportSection.hockey;
      case 4:
        return SportSection.boxing;
      case 5:
        return SportSection.mma;
      case 6:
        return SportSection.athletics;
      case 7:
        return SportSection.cricket;
      case 8:
        return SportSection.esports;
      default:
        return SportSection.football;
    }
  }

  @override
  void write(BinaryWriter writer, SportSection obj) {
    switch (obj) {
      case SportSection.football:
        writer.writeByte(0);
        break;
      case SportSection.basketball:
        writer.writeByte(1);
        break;
      case SportSection.tennis:
        writer.writeByte(2);
        break;
      case SportSection.hockey:
        writer.writeByte(3);
        break;
      case SportSection.boxing:
        writer.writeByte(4);
        break;
      case SportSection.mma:
        writer.writeByte(5);
        break;
      case SportSection.athletics:
        writer.writeByte(6);
        break;
      case SportSection.cricket:
        writer.writeByte(7);
        break;
      case SportSection.esports:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
