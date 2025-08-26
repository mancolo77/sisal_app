import 'dart:math';
import '../constants/app_constants.dart';

class QuizUtils {
  static final Random _random = Random();

  /// Calculate score percentage from correct and total counts
  static double calculateScore(int correctCount, int totalCount) {
    if (totalCount == 0) return 0.0;
    return (correctCount / totalCount) * 100.0;
  }

  /// Get score grade based on percentage
  static String getScoreGrade(double scorePercent) {
    if (scorePercent >= AppConstants.excellentScore) return 'Excellent';
    if (scorePercent >= AppConstants.goodScore) return 'Good';
    if (scorePercent >= AppConstants.fairScore) return 'Fair';
    if (scorePercent >= AppConstants.passScore) return 'Pass';
    return 'Needs Improvement';
  }

  /// Get score color based on percentage
  static String getScoreColor(double scorePercent) {
    if (scorePercent >= AppConstants.excellentScore) return 'success';
    if (scorePercent >= AppConstants.goodScore) return 'primary';
    if (scorePercent >= AppConstants.fairScore) return 'warning';
    if (scorePercent >= AppConstants.passScore) return 'secondary';
    return 'error';
  }

  /// Shuffle a list randomly
  static List<T> shuffleList<T>(List<T> list) {
    final shuffled = List<T>.from(list);
    shuffled.shuffle(_random);
    return shuffled;
  }

  /// Format duration to readable string
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Format time in seconds to readable string
  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return '${minutes}m ${remainingSeconds}s';
    } else {
      return '${remainingSeconds}s';
    }
  }

  /// Format DateTime to readable string
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if two lists of strings are equal (order independent)
  static bool areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;

    final set1 = Set<String>.from(list1);
    final set2 = Set<String>.from(list2);

    return set1.containsAll(set2) && set2.containsAll(set1);
  }

  /// Generate a random UUID-like string
  static String generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      8,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Validate quiz set data
  static String? validateQuizSet({
    required String title,
    required List<String> questionIds,
    int? timePerQuestion,
  }) {
    if (title.trim().isEmpty) {
      return 'Quiz title cannot be empty';
    }

    if (questionIds.length < AppConstants.minQuestionsPerQuiz) {
      return 'Quiz must have at least ${AppConstants.minQuestionsPerQuiz} questions';
    }

    if (questionIds.length > AppConstants.maxQuestionsPerQuiz) {
      return 'Quiz cannot have more than ${AppConstants.maxQuestionsPerQuiz} questions';
    }

    if (timePerQuestion != null && timePerQuestion < 5) {
      return 'Time per question must be at least 5 seconds';
    }

    return null;
  }

  /// Get difficulty label
  static String getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Very Easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Medium';
      case 4:
        return 'Hard';
      case 5:
        return 'Very Hard';
      default:
        return 'Unknown';
    }
  }

  /// Get emoji for difficulty
  static String getDifficultyEmoji(int difficulty) {
    switch (difficulty) {
      case 1:
        return '🟢';
      case 2:
        return '🟡';
      case 3:
        return '🟠';
      case 4:
        return '🔴';
      case 5:
        return '⚫';
      default:
        return '❓';
    }
  }
}
