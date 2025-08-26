import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/sport_section.dart';
import '../../domain/entities/answer_option.dart';
import '../../domain/entities/question_model.dart';
import '../../domain/entities/quiz_set.dart';
import '../../domain/entities/given_answer.dart';
import '../../domain/entities/quiz_attempt.dart';
import '../../domain/entities/app_settings.dart';
import '../../core/constants/app_constants.dart';

class HiveDao {
  static HiveDao? _instance;
  static HiveDao get instance => _instance ??= HiveDao._internal();
  HiveDao._internal();

  // Initialize Hive and register adapters
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(SportSectionAdapter());
    Hive.registerAdapter(AnswerOptionAdapter());
    Hive.registerAdapter(QuestionModelAdapter());
    Hive.registerAdapter(QuizSetAdapter());
    Hive.registerAdapter(GivenAnswerAdapter());
    Hive.registerAdapter(QuizAttemptAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
  }

  // Open all boxes
  static Future<void> openBoxes() async {
    await Future.wait([
      Hive.openBox<QuestionModel>(AppConstants.questionsBox),
      Hive.openBox<QuizSet>(AppConstants.quizzesBox),
      Hive.openBox<QuizAttempt>(AppConstants.attemptsBox),
      Hive.openBox<AppSettings>(AppConstants.settingsBox),
    ]);
  }

  // Close all boxes
  static Future<void> closeBoxes() async {
    await Hive.close();
  }

  // Questions box operations
  Box<QuestionModel> get questionsBox =>
      Hive.box<QuestionModel>(AppConstants.questionsBox);

  Future<void> saveQuestion(QuestionModel question) async {
    await questionsBox.put(question.id, question);
  }

  Future<void> saveQuestions(List<QuestionModel> questions) async {
    final Map<String, QuestionModel> questionsMap = {
      for (var question in questions) question.id: question,
    };
    await questionsBox.putAll(questionsMap);
  }

  QuestionModel? getQuestion(String id) {
    return questionsBox.get(id);
  }

  List<QuestionModel> getAllQuestions() {
    return questionsBox.values.toList();
  }

  List<QuestionModel> getQuestionsBySection(SportSection section) {
    return questionsBox.values.where((q) => q.section == section).toList();
  }

  List<QuestionModel> getQuestionsByIds(List<String> ids) {
    return ids
        .map((id) => questionsBox.get(id))
        .whereType<QuestionModel>()
        .toList();
  }

  Future<void> deleteQuestion(String id) async {
    await questionsBox.delete(id);
  }

  // Quiz sets box operations
  Box<QuizSet> get quizSetsBox => Hive.box<QuizSet>(AppConstants.quizzesBox);

  Future<void> saveQuizSet(QuizSet quizSet) async {
    await quizSetsBox.put(quizSet.id, quizSet);
  }

  QuizSet? getQuizSet(String id) {
    return quizSetsBox.get(id);
  }

  List<QuizSet> getAllQuizSets() {
    return quizSetsBox.values.toList();
  }

  List<QuizSet> getQuizSetsBySection(SportSection section) {
    return quizSetsBox.values.where((q) => q.section == section).toList();
  }

  List<QuizSet> getSystemQuizSets() {
    return quizSetsBox.values.where((q) => q.isSystem).toList();
  }

  List<QuizSet> getUserQuizSets() {
    return quizSetsBox.values.where((q) => !q.isSystem).toList();
  }

  Future<void> deleteQuizSet(String id) async {
    await quizSetsBox.delete(id);
  }

  // Quiz attempts box operations
  Box<QuizAttempt> get attemptsBox =>
      Hive.box<QuizAttempt>(AppConstants.attemptsBox);

  Future<void> saveAttempt(QuizAttempt attempt) async {
    await attemptsBox.put(attempt.id, attempt);
  }

  QuizAttempt? getAttempt(String id) {
    return attemptsBox.get(id);
  }

  List<QuizAttempt> getAllAttempts() {
    return attemptsBox.values.toList();
  }

  List<QuizAttempt> getAttemptsByQuizSet(String quizSetId) {
    return attemptsBox.values.where((a) => a.quizSetId == quizSetId).toList();
  }

  List<QuizAttempt> getAttemptsSortedByDate({bool ascending = false}) {
    final attempts = getAllAttempts();
    attempts.sort(
      (a, b) => ascending
          ? a.startedAt.compareTo(b.startedAt)
          : b.startedAt.compareTo(a.startedAt),
    );
    return attempts;
  }

  Future<void> deleteAttempt(String id) async {
    await attemptsBox.delete(id);
  }

  /// Clear all quiz attempts (history)
  Future<void> clearAllAttempts() async {
    await attemptsBox.clear();
  }

  // Settings box operations
  Box<AppSettings> get settingsBox =>
      Hive.box<AppSettings>(AppConstants.settingsBox);

  Future<void> saveSettings(AppSettings settings) async {
    await settingsBox.put(AppConstants.settingsKey, settings);
  }

  AppSettings getSettings() {
    return settingsBox.get(AppConstants.settingsKey) ??
        AppSettings.defaultSettings();
  }

  // Clear all data
  Future<void> clearAllData() async {
    await Future.wait([
      questionsBox.clear(),
      quizSetsBox.clear(),
      attemptsBox.clear(),
      settingsBox.clear(),
    ]);
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    final totalQuestions = questionsBox.length;
    final totalQuizSets = quizSetsBox.length;
    final totalAttempts = attemptsBox.length;
    final userQuizSets = getUserQuizSets().length;
    final systemQuizSets = getSystemQuizSets().length;

    final attempts = getAllAttempts();
    double averageScore = 0.0;
    if (attempts.isNotEmpty) {
      averageScore =
          attempts.map((a) => a.scorePercent).reduce((a, b) => a + b) /
          attempts.length;
    }

    return {
      'totalQuestions': totalQuestions,
      'totalQuizSets': totalQuizSets,
      'totalAttempts': totalAttempts,
      'userQuizSets': userQuizSets,
      'systemQuizSets': systemQuizSets,
      'averageScore': averageScore,
    };
  }
}
