class AppConstants {
  // App info
  static const String appName = 'GreenArena';
  static const String appTagline = 'Sports Sections Quiz';
  static const String appDescription = 'Learn across sports sections, answer fast, review smarter — fully offline.';
  
  // Hive box names
  static const String sectionsBox = 'sections';
  static const String questionsBox = 'questions';
  static const String quizzesBox = 'quizzes';
  static const String attemptsBox = 'attempts';
  static const String settingsBox = 'settings';
  
  // Settings keys
  static const String settingsKey = 'app_settings';
  
  // Default values
  static const int defaultTimePerQuestion = 30; // seconds
  static const bool defaultShuffleQuestions = true;
  static const bool defaultShuffleOptions = true;
  static const int minDifficulty = 1;
  static const int maxDifficulty = 5;
  
  // UI constants
  static const double cardBorderRadius = 20.0;
  static const double buttonBorderRadius = 12.0;
  static const double chipBorderRadius = 20.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Quiz limits
  static const int maxQuestionsPerQuiz = 50;
  static const int minQuestionsPerQuiz = 3;
  static const int maxOptionsPerQuestion = 6;
  static const int minOptionsPerQuestion = 2;
  
  // Score thresholds
  static const double excellentScore = 90.0;
  static const double goodScore = 80.0;
  static const double fairScore = 70.0;
  static const double passScore = 60.0;
}
