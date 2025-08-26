import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 7)
class AppSettings extends Equatable {
  @HiveField(0)
  final bool defaultShuffleQuestions;
  
  @HiveField(1)
  final bool defaultShuffleOptions;
  
  @HiveField(2)
  final int defaultTimePerQuestionSec;

  const AppSettings({
    required this.defaultShuffleQuestions,
    required this.defaultShuffleOptions,
    required this.defaultTimePerQuestionSec,
  });

  @override
  List<Object?> get props => [
        defaultShuffleQuestions,
        defaultShuffleOptions,
        defaultTimePerQuestionSec,
      ];

  bool get isTimerEnabled => defaultTimePerQuestionSec > 0;

  factory AppSettings.defaultSettings() {
    return const AppSettings(
      defaultShuffleQuestions: true,
      defaultShuffleOptions: true,
      defaultTimePerQuestionSec: 30,
    );
  }

  AppSettings copyWith({
    bool? defaultShuffleQuestions,
    bool? defaultShuffleOptions,
    int? defaultTimePerQuestionSec,
  }) {
    return AppSettings(
      defaultShuffleQuestions: defaultShuffleQuestions ?? this.defaultShuffleQuestions,
      defaultShuffleOptions: defaultShuffleOptions ?? this.defaultShuffleOptions,
      defaultTimePerQuestionSec: defaultTimePerQuestionSec ?? this.defaultTimePerQuestionSec,
    );
  }
}
