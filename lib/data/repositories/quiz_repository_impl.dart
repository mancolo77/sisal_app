import '../../domain/entities/question_model.dart';
import '../../domain/entities/quiz_set.dart';
import '../../domain/entities/quiz_attempt.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/sport_section.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../dao/hive_dao.dart';

class QuizRepositoryImpl implements QuizRepository {
  final HiveDao _dao = HiveDao.instance;

  // Questions
  @override
  Future<void> saveQuestion(QuestionModel question) async {
    await _dao.saveQuestion(question);
  }

  @override
  Future<void> saveQuestions(List<QuestionModel> questions) async {
    await _dao.saveQuestions(questions);
  }

  @override
  QuestionModel? getQuestion(String id) {
    return _dao.getQuestion(id);
  }

  @override
  List<QuestionModel> getAllQuestions() {
    return _dao.getAllQuestions();
  }

  @override
  List<QuestionModel> getQuestionsBySection(SportSection section) {
    return _dao.getQuestionsBySection(section);
  }

  @override
  List<QuestionModel> getQuestionsByIds(List<String> ids) {
    return _dao.getQuestionsByIds(ids);
  }

  @override
  Future<void> deleteQuestion(String id) async {
    await _dao.deleteQuestion(id);
  }

  // Quiz Sets
  @override
  Future<void> saveQuizSet(QuizSet quizSet) async {
    await _dao.saveQuizSet(quizSet);
  }

  @override
  QuizSet? getQuizSet(String id) {
    return _dao.getQuizSet(id);
  }

  @override
  List<QuizSet> getAllQuizSets() {
    return _dao.getAllQuizSets();
  }

  @override
  List<QuizSet> getQuizSetsBySection(SportSection section) {
    return _dao.getQuizSetsBySection(section);
  }

  @override
  List<QuizSet> getSystemQuizSets() {
    return _dao.getSystemQuizSets();
  }

  @override
  List<QuizSet> getUserQuizSets() {
    return _dao.getUserQuizSets();
  }

  @override
  Future<void> deleteQuizSet(String id) async {
    await _dao.deleteQuizSet(id);
  }

  // Quiz Attempts
  @override
  Future<void> saveAttempt(QuizAttempt attempt) async {
    await _dao.saveAttempt(attempt);
  }

  @override
  QuizAttempt? getAttempt(String id) {
    return _dao.getAttempt(id);
  }

  @override
  List<QuizAttempt> getAllAttempts() {
    return _dao.getAllAttempts();
  }

  @override
  List<QuizAttempt> getAttemptsByQuizSet(String quizSetId) {
    return _dao.getAttemptsByQuizSet(quizSetId);
  }

  @override
  List<QuizAttempt> getAttemptsSortedByDate({bool ascending = false}) {
    return _dao.getAttemptsSortedByDate(ascending: ascending);
  }

  @override
  Future<void> deleteAttempt(String id) async {
    await _dao.deleteAttempt(id);
  }

  /// Clear all quiz attempts (history)
  Future<void> clearAllAttempts() async {
    await _dao.clearAllAttempts();
  }

  // Settings
  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _dao.saveSettings(settings);
  }

  @override
  AppSettings getSettings() {
    return _dao.getSettings();
  }

  // Utility
  @override
  Future<void> clearAllData() async {
    await _dao.clearAllData();
  }

  @override
  Map<String, dynamic> getStatistics() {
    return _dao.getStatistics();
  }
}
