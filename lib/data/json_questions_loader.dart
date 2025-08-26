import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/entities/sport_section.dart';
import '../domain/entities/question_model.dart';
import '../domain/entities/answer_option.dart';
import '../domain/entities/quiz_set.dart';

class JsonQuestionsLoader {
  static Future<List<QuestionModel>> loadAllQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/complete_questions.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      List<QuestionModel> allQuestions = [];

      final questionsData = jsonData['questions'] as Map<String, dynamic>;

      for (String sectionKey in questionsData.keys) {
        final SportSection section = _getSportSectionFromString(sectionKey);
        final List<dynamic> sectionQuestions =
            questionsData[sectionKey] as List<dynamic>;

        for (Map<String, dynamic> questionData in sectionQuestions) {
          final question = _parseQuestion(questionData, section);
          allQuestions.add(question);
        }
      }

      return allQuestions;
    } catch (e) {
      print('Error loading questions from JSON: $e');
      return _getFallbackQuestions();
    }
  }

  static QuestionModel _parseQuestion(
    Map<String, dynamic> data,
    SportSection section,
  ) {
    final List<dynamic> optionsData = data['options'] as List<dynamic>;
    final List<AnswerOption> options = optionsData
        .map(
          (optionData) => AnswerOption(
            id: optionData['id'] as String,
            text: optionData['text'] as String,
          ),
        )
        .toList();

    return QuestionModel(
      id: data['id'] as String,
      section: section,
      text: data['text'] as String,
      options: options,
      correctOptionIds: List<String>.from(data['correct']),
      explanation: data['explanation'] as String?,
      difficulty: data['difficulty'] as int? ?? 2,
    );
  }

  static SportSection _getSportSectionFromString(String sectionString) {
    switch (sectionString.toLowerCase()) {
      case 'football':
        return SportSection.football;
      case 'basketball':
        return SportSection.basketball;
      case 'tennis':
        return SportSection.tennis;
      case 'hockey':
        return SportSection.hockey;
      case 'boxing':
        return SportSection.boxing;
      case 'mma':
        return SportSection.mma;
      case 'athletics':
        return SportSection.athletics;
      case 'cricket':
        return SportSection.cricket;
      case 'esports':
        return SportSection.esports;
      default:
        return SportSection.football;
    }
  }

  static List<QuizSet> generateQuizSetsFromQuestions(
    List<QuestionModel> questions,
  ) {
    List<QuizSet> quizSets = [];

    // Group questions by section
    Map<SportSection, List<QuestionModel>> questionsBySection = {};
    for (var question in questions) {
      if (!questionsBySection.containsKey(question.section)) {
        questionsBySection[question.section] = [];
      }
      questionsBySection[question.section]!.add(question);
    }

    // Create quiz sets for each section
    for (var entry in questionsBySection.entries) {
      final section = entry.key;
      final sectionQuestions = entry.value;

      if (sectionQuestions.isNotEmpty) {
        // Basic quiz (all questions)
        quizSets.add(
          QuizSet(
            id: 'quiz_${section.name}_all',
            title: '${section.displayName} - Complete Quiz',
            section: section,
            questionIds: sectionQuestions.map((q) => q.id).toList(),
            isSystem: true,
            shuffleQuestions: true,
            shuffleOptions: true,
            timePerQuestionSec: 45,
            createdAt: DateTime.now().subtract(
              Duration(days: sectionQuestions.length),
            ),
          ),
        );

        // Easy questions only (difficulty 1-2)
        final easyQuestions = sectionQuestions
            .where((q) => q.difficulty <= 2)
            .toList();
        if (easyQuestions.length >= 5) {
          quizSets.add(
            QuizSet(
              id: 'quiz_${section.name}_easy',
              title: '${section.displayName} - Basics',
              section: section,
              questionIds: easyQuestions.map((q) => q.id).toList(),
              isSystem: true,
              shuffleQuestions: true,
              shuffleOptions: true,
              timePerQuestionSec: 60,
              createdAt: DateTime.now().subtract(
                Duration(days: easyQuestions.length + 10),
              ),
            ),
          );
        }

        // Hard questions only (difficulty 3+)
        final hardQuestions = sectionQuestions
            .where((q) => q.difficulty >= 3)
            .toList();
        if (hardQuestions.length >= 3) {
          quizSets.add(
            QuizSet(
              id: 'quiz_${section.name}_hard',
              title: '${section.displayName} - Advanced',
              section: section,
              questionIds: hardQuestions.map((q) => q.id).toList(),
              isSystem: true,
              shuffleQuestions: true,
              shuffleOptions: false,
              timePerQuestionSec: 30,
              createdAt: DateTime.now().subtract(
                Duration(days: hardQuestions.length + 5),
              ),
            ),
          );
        }
      }
    }

    return quizSets;
  }

  static List<QuestionModel> _getFallbackQuestions() {
    // Fallback questions if JSON loading fails
    return [
      QuestionModel(
        id: 'fallback_001',
        section: SportSection.football,
        text:
            'How many players are on a football team on the field at one time?',
        options: [
          AnswerOption(id: 'fb_001_1', text: '9'),
          AnswerOption(id: 'fb_001_2', text: '10'),
          AnswerOption(id: 'fb_001_3', text: '11'),
          AnswerOption(id: 'fb_001_4', text: '12'),
        ],
        correctOptionIds: ['fb_001_3'],
        explanation:
            'A football team has 11 players on the field at any given time.',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'fallback_002',
        section: SportSection.basketball,
        text: 'How many points is a free throw worth?',
        options: [
          AnswerOption(id: 'fb_002_1', text: '1 point'),
          AnswerOption(id: 'fb_002_2', text: '2 points'),
          AnswerOption(id: 'fb_002_3', text: '3 points'),
          AnswerOption(id: 'fb_002_4', text: '4 points'),
        ],
        correctOptionIds: ['fb_002_1'],
        explanation: 'A free throw is worth 1 point in basketball.',
        difficulty: 1,
      ),
    ];
  }
}
