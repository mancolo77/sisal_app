import 'package:hive/hive.dart';

part 'sport_section.g.dart';

@HiveType(typeId: 1)
enum SportSection {
  @HiveField(0)
  football,

  @HiveField(1)
  basketball,

  @HiveField(2)
  tennis,

  @HiveField(3)
  hockey,

  @HiveField(4)
  boxing,

  @HiveField(5)
  mma,

  @HiveField(6)
  athletics,

  @HiveField(7)
  cricket,

  @HiveField(8)
  esports,
}

extension SportSectionExtension on SportSection {
  String get displayName {
    switch (this) {
      case SportSection.football:
        return 'Football';
      case SportSection.basketball:
        return 'Basketball';
      case SportSection.tennis:
        return 'Tennis';
      case SportSection.hockey:
        return 'Hockey';
      case SportSection.boxing:
        return 'Boxing';
      case SportSection.mma:
        return 'MMA';
      case SportSection.athletics:
        return 'Athletics';
      case SportSection.cricket:
        return 'Cricket';
      case SportSection.esports:
        return 'Esports';
    }
  }

  String get emoji {
    switch (this) {
      case SportSection.football:
        return '⚽';
      case SportSection.basketball:
        return '🏀';
      case SportSection.tennis:
        return '🎾';
      case SportSection.hockey:
        return '🏒';
      case SportSection.boxing:
        return '🥊';
      case SportSection.mma:
        return '🥋';
      case SportSection.athletics:
        return '🏃‍♂️';
      case SportSection.cricket:
        return '🏏';
      case SportSection.esports:
        return '🎮';
    }
  }
}
