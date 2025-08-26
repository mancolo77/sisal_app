import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/dao/hive_dao.dart';
import 'data/repositories/quiz_repository_impl.dart';
import 'data/json_questions_loader.dart';
import 'app/blocs/quiz/quiz_bloc.dart';
import 'app/blocs/quiz_player/quiz_player_bloc.dart';
import 'app/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveDao.init();
  await HiveDao.openBoxes();

  // Seed initial data
  await _seedInitialData();

  runApp(const GreenArenaApp());
}

Future<void> _seedInitialData() async {
  final repository = QuizRepositoryImpl();

  // Check if data already exists
  final existingQuestions = repository.getAllQuestions();
  if (existingQuestions.isNotEmpty) {
    return; // Data already seeded
  }

  try {
    // Load questions from JSON
    final questions = await JsonQuestionsLoader.loadAllQuestions();
    await repository.saveQuestions(questions);

    // Generate quiz sets from loaded questions
    final quizSets = JsonQuestionsLoader.generateQuizSetsFromQuestions(
      questions,
    );
    for (final quizSet in quizSets) {
      await repository.saveQuizSet(quizSet);
    }

    print(
      'Successfully loaded ${questions.length} questions and ${quizSets.length} quiz sets',
    );
  } catch (e) {
    print('Error seeding initial data: $e');
  }
}

class GreenArenaApp extends StatelessWidget {
  const GreenArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => QuizRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                QuizBloc(repository: context.read<QuizRepositoryImpl>()),
          ),
          BlocProvider(
            create: (context) =>
                QuizPlayerBloc(repository: context.read<QuizRepositoryImpl>()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Sisal',
          theme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
