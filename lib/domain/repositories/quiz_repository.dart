import '../entities/question_model.dart';
import '../entities/quiz_set.dart';
import '../entities/quiz_attempt.dart';
import '../entities/app_settings.dart';
import '../entities/sport_section.dart';

abstract class QuizRepository {
  // Questions
  Future<void> saveQuestion(QuestionModel question);
  Future<void> saveQuestions(List<QuestionModel> questions);
  QuestionModel? getQuestion(String id);
  List<QuestionModel> getAllQuestions();
  List<QuestionModel> getQuestionsBySection(SportSection section);
  List<QuestionModel> getQuestionsByIds(List<String> ids);
  Future<void> deleteQuestion(String id);

  // Quiz Sets
  Future<void> saveQuizSet(QuizSet quizSet);
  QuizSet? getQuizSet(String id);
  List<QuizSet> getAllQuizSets();
  List<QuizSet> getQuizSetsBySection(SportSection section);
  List<QuizSet> getSystemQuizSets();
  List<QuizSet> getUserQuizSets();
  Future<void> deleteQuizSet(String id);

  // Quiz Attempts
  Future<void> saveAttempt(QuizAttempt attempt);
  QuizAttempt? getAttempt(String id);
  List<QuizAttempt> getAllAttempts();
  List<QuizAttempt> getAttemptsByQuizSet(String quizSetId);
  List<QuizAttempt> getAttemptsSortedByDate({bool ascending = false});
  Future<void> deleteAttempt(String id);

  // Settings
  Future<void> saveSettings(AppSettings settings);
  AppSettings getSettings();

  // Utility
  Future<void> clearAllData();
  Map<String, dynamic> getStatistics();
}
