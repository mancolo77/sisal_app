import 'package:uuid/uuid.dart';
import '../domain/entities/sport_section.dart';
import '../domain/entities/question_model.dart';
import '../domain/entities/answer_option.dart';
import '../domain/entities/quiz_set.dart';

class SeedData {
  static const Uuid _uuid = Uuid();

  static List<QuestionModel> getSampleQuestions() {
    return [
      // Football questions
      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.football,
        text:
            'How many players are on a football team on the field at one time?',
        options: [
          AnswerOption(id: _uuid.v4(), text: '9'),
          AnswerOption(id: _uuid.v4(), text: '10'),
          AnswerOption(id: _uuid.v4(), text: '11'),
          AnswerOption(id: _uuid.v4(), text: '12'),
        ],
        correctOptionIds: ['11'], // This would need to match actual ID
        explanation:
            'A football team has 11 players on the field at any given time.',
        difficulty: 1,
      ),

      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.football,
        text:
            'What is the maximum duration of a FIFA World Cup match including extra time?',
        options: [
          AnswerOption(id: _uuid.v4(), text: '90 minutes'),
          AnswerOption(id: _uuid.v4(), text: '120 minutes'),
          AnswerOption(id: _uuid.v4(), text: '150 minutes'),
          AnswerOption(id: _uuid.v4(), text: '180 minutes'),
        ],
        correctOptionIds: ['120 minutes'],
        explanation:
            'A match can last up to 120 minutes including 30 minutes of extra time.',
        difficulty: 2,
      ),

      // Basketball questions
      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.basketball,
        text: 'How many points is a free throw worth in basketball?',
        options: [
          AnswerOption(id: _uuid.v4(), text: '1 point'),
          AnswerOption(id: _uuid.v4(), text: '2 points'),
          AnswerOption(id: _uuid.v4(), text: '3 points'),
          AnswerOption(id: _uuid.v4(), text: '4 points'),
        ],
        correctOptionIds: ['1 point'],
        explanation: 'A free throw is worth 1 point in basketball.',
        difficulty: 1,
      ),

      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.basketball,
        text: 'Which of the following are violations in basketball?',
        options: [
          AnswerOption(id: _uuid.v4(), text: 'Traveling'),
          AnswerOption(id: _uuid.v4(), text: 'Double dribble'),
          AnswerOption(id: _uuid.v4(), text: 'Shot clock violation'),
          AnswerOption(id: _uuid.v4(), text: 'Slam dunk'),
        ],
        correctOptionIds: [
          'Traveling',
          'Double dribble',
          'Shot clock violation',
        ],
        explanation:
            'Traveling, double dribble, and shot clock violations are all violations. Slam dunks are legal.',
        difficulty: 3,
      ),

      // Tennis questions
      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.tennis,
        text: 'What is the scoring system in tennis?',
        options: [
          AnswerOption(id: _uuid.v4(), text: '0, 15, 30, 40, Game'),
          AnswerOption(id: _uuid.v4(), text: '1, 2, 3, 4, Game'),
          AnswerOption(id: _uuid.v4(), text: '0, 10, 20, 30, Game'),
          AnswerOption(id: _uuid.v4(), text: '5, 10, 15, 20, Game'),
        ],
        correctOptionIds: ['0, 15, 30, 40, Game'],
        explanation:
            'Tennis uses the unique scoring system of 0 (love), 15, 30, 40, and Game.',
        difficulty: 2,
      ),

      // Hockey questions
      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.hockey,
        text: 'How many periods are there in a standard ice hockey game?',
        options: [
          AnswerOption(id: _uuid.v4(), text: '2'),
          AnswerOption(id: _uuid.v4(), text: '3'),
          AnswerOption(id: _uuid.v4(), text: '4'),
          AnswerOption(id: _uuid.v4(), text: '5'),
        ],
        correctOptionIds: ['3'],
        explanation: 'A standard ice hockey game consists of 3 periods.',
        difficulty: 1,
      ),

      // Boxing questions
      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.boxing,
        text:
            'How many rounds are in a professional boxing championship fight?',
        options: [
          AnswerOption(id: _uuid.v4(), text: '10 rounds'),
          AnswerOption(id: _uuid.v4(), text: '12 rounds'),
          AnswerOption(id: _uuid.v4(), text: '15 rounds'),
          AnswerOption(id: _uuid.v4(), text: '20 rounds'),
        ],
        correctOptionIds: ['12 rounds'],
        explanation:
            'Professional boxing championship fights are typically 12 rounds.',
        difficulty: 2,
      ),

      // Athletics questions
      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.athletics,
        text: 'What is the standard distance of a marathon?',
        options: [
          AnswerOption(id: _uuid.v4(), text: '26.2 miles (42.195 km)'),
          AnswerOption(id: _uuid.v4(), text: '25 miles (40.23 km)'),
          AnswerOption(id: _uuid.v4(), text: '30 miles (48.28 km)'),
          AnswerOption(id: _uuid.v4(), text: '24 miles (38.62 km)'),
        ],
        correctOptionIds: ['26.2 miles (42.195 km)'],
        explanation: 'A marathon is exactly 26.2 miles or 42.195 kilometers.',
        difficulty: 2,
      ),

      // Cricket questions
      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.cricket,
        text: 'How many players are on a cricket team?',
        options: [
          AnswerOption(id: _uuid.v4(), text: '9'),
          AnswerOption(id: _uuid.v4(), text: '10'),
          AnswerOption(id: _uuid.v4(), text: '11'),
          AnswerOption(id: _uuid.v4(), text: '12'),
        ],
        correctOptionIds: ['11'],
        explanation: 'A cricket team consists of 11 players.',
        difficulty: 1,
      ),

      // Esports questions
      QuestionModel(
        id: _uuid.v4(),
        section: SportSection.esports,
        text:
            'Which game is known for the annual tournament "The International"?',
        options: [
          AnswerOption(id: _uuid.v4(), text: 'League of Legends'),
          AnswerOption(id: _uuid.v4(), text: 'Dota 2'),
          AnswerOption(id: _uuid.v4(), text: 'Counter-Strike'),
          AnswerOption(id: _uuid.v4(), text: 'Fortnite'),
        ],
        correctOptionIds: ['Dota 2'],
        explanation:
            'The International is the premier annual tournament for Dota 2.',
        difficulty: 3,
      ),
    ];
  }

  static List<QuizSet> getSampleQuizSets(List<QuestionModel> questions) {
    final footballQuestions = questions
        .where((q) => q.section == SportSection.football)
        .toList();
    final basketballQuestions = questions
        .where((q) => q.section == SportSection.basketball)
        .toList();
    final tennisQuestions = questions
        .where((q) => q.section == SportSection.tennis)
        .toList();

    return [
      QuizSet(
        id: _uuid.v4(),
        title: 'Football Basics',
        section: SportSection.football,
        questionIds: footballQuestions.map((q) => q.id).toList(),
        isSystem: true,
        shuffleQuestions: true,
        shuffleOptions: true,
        timePerQuestionSec: 30,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),

      QuizSet(
        id: _uuid.v4(),
        title: 'Basketball Fundamentals',
        section: SportSection.basketball,
        questionIds: basketballQuestions.map((q) => q.id).toList(),
        isSystem: true,
        shuffleQuestions: true,
        shuffleOptions: false,
        timePerQuestionSec: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),

      QuizSet(
        id: _uuid.v4(),
        title: 'Tennis Quick Quiz',
        section: SportSection.tennis,
        questionIds: tennisQuestions.map((q) => q.id).toList(),
        isSystem: true,
        shuffleQuestions: false,
        shuffleOptions: true,
        timePerQuestionSec: null, // Untimed
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),

      QuizSet(
        id: _uuid.v4(),
        title: 'Mixed Sports Challenge',
        section: SportSection.football,
        questionIds: questions.take(5).map((q) => q.id).toList(),
        isSystem: true,
        shuffleQuestions: true,
        shuffleOptions: true,
        timePerQuestionSec: 60,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Fix the question IDs to match the actual generated IDs
  static List<QuestionModel> getFixedQuestions() {
    final questions = <QuestionModel>[];

    // Football questions
    final footballQ1Options = [
      AnswerOption(id: 'f1_opt1', text: '9'),
      AnswerOption(id: 'f1_opt2', text: '10'),
      AnswerOption(id: 'f1_opt3', text: '11'),
      AnswerOption(id: 'f1_opt4', text: '12'),
    ];
    questions.add(
      QuestionModel(
        id: 'football_q1',
        section: SportSection.football,
        text:
            'How many players are on a football team on the field at one time?',
        options: footballQ1Options,
        correctOptionIds: ['f1_opt3'],
        explanation:
            'A football team has 11 players on the field at any given time.',
        difficulty: 1,
      ),
    );

    final footballQ2Options = [
      AnswerOption(id: 'f2_opt1', text: '90 minutes'),
      AnswerOption(id: 'f2_opt2', text: '120 minutes'),
      AnswerOption(id: 'f2_opt3', text: '150 minutes'),
      AnswerOption(id: 'f2_opt4', text: '180 minutes'),
    ];
    questions.add(
      QuestionModel(
        id: 'football_q2',
        section: SportSection.football,
        text:
            'What is the maximum duration of a FIFA World Cup match including extra time?',
        options: footballQ2Options,
        correctOptionIds: ['f2_opt2'],
        explanation:
            'A match can last up to 120 minutes including 30 minutes of extra time.',
        difficulty: 2,
      ),
    );

    // Basketball questions
    final basketballQ1Options = [
      AnswerOption(id: 'b1_opt1', text: '1 point'),
      AnswerOption(id: 'b1_opt2', text: '2 points'),
      AnswerOption(id: 'b1_opt3', text: '3 points'),
      AnswerOption(id: 'b1_opt4', text: '4 points'),
    ];
    questions.add(
      QuestionModel(
        id: 'basketball_q1',
        section: SportSection.basketball,
        text: 'How many points is a free throw worth in basketball?',
        options: basketballQ1Options,
        correctOptionIds: ['b1_opt1'],
        explanation: 'A free throw is worth 1 point in basketball.',
        difficulty: 1,
      ),
    );

    final basketballQ2Options = [
      AnswerOption(id: 'b2_opt1', text: 'Traveling'),
      AnswerOption(id: 'b2_opt2', text: 'Double dribble'),
      AnswerOption(id: 'b2_opt3', text: 'Shot clock violation'),
      AnswerOption(id: 'b2_opt4', text: 'Slam dunk'),
    ];
    questions.add(
      QuestionModel(
        id: 'basketball_q2',
        section: SportSection.basketball,
        text: 'Which of the following are violations in basketball?',
        options: basketballQ2Options,
        correctOptionIds: ['b2_opt1', 'b2_opt2', 'b2_opt3'],
        explanation:
            'Traveling, double dribble, and shot clock violations are all violations. Slam dunks are legal.',
        difficulty: 3,
      ),
    );

    // Tennis questions
    final tennisQ1Options = [
      AnswerOption(id: 't1_opt1', text: '0, 15, 30, 40, Game'),
      AnswerOption(id: 't1_opt2', text: '1, 2, 3, 4, Game'),
      AnswerOption(id: 't1_opt3', text: '0, 10, 20, 30, Game'),
      AnswerOption(id: 't1_opt4', text: '5, 10, 15, 20, Game'),
    ];
    questions.add(
      QuestionModel(
        id: 'tennis_q1',
        section: SportSection.tennis,
        text: 'What is the scoring system in tennis?',
        options: tennisQ1Options,
        correctOptionIds: ['t1_opt1'],
        explanation:
            'Tennis uses the unique scoring system of 0 (love), 15, 30, 40, and Game.',
        difficulty: 2,
      ),
    );

    // Add more questions for other sports...
    return questions;
  }

  static List<QuizSet> getFixedQuizSets(List<QuestionModel> questions) {
    final footballQuestions = questions
        .where((q) => q.section == SportSection.football)
        .toList();
    final basketballQuestions = questions
        .where((q) => q.section == SportSection.basketball)
        .toList();
    final tennisQuestions = questions
        .where((q) => q.section == SportSection.tennis)
        .toList();

    return [
      QuizSet(
        id: 'quiz_football_basics',
        title: 'Football Basics',
        section: SportSection.football,
        questionIds: footballQuestions.map((q) => q.id).toList(),
        isSystem: true,
        shuffleQuestions: true,
        shuffleOptions: true,
        timePerQuestionSec: 30,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),

      QuizSet(
        id: 'quiz_basketball_fundamentals',
        title: 'Basketball Fundamentals',
        section: SportSection.basketball,
        questionIds: basketballQuestions.map((q) => q.id).toList(),
        isSystem: true,
        shuffleQuestions: true,
        shuffleOptions: false,
        timePerQuestionSec: 45,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),

      QuizSet(
        id: 'quiz_tennis_quick',
        title: 'Tennis Quick Quiz',
        section: SportSection.tennis,
        questionIds: tennisQuestions.map((q) => q.id).toList(),
        isSystem: true,
        shuffleQuestions: false,
        shuffleOptions: true,
        timePerQuestionSec: null,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
