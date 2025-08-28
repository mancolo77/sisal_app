import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/quiz_set.dart';
import '../../domain/entities/quiz_attempt.dart';
import '../../domain/entities/sport_section.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../../ui/screens/home_sections/home_sections_screen.dart';
import '../../ui/screens/quiz_sets/quiz_sets_screen.dart';
import '../../ui/screens/player/quiz_player_screen.dart';
import '../../ui/screens/results/results_screen.dart';
import '../../ui/screens/review/review_screen.dart';
import '../../ui/screens/history/history_screen.dart';
import '../../ui/screens/create_quiz/create_quiz_screen.dart';
import '../../ui/screens/settings/settings_screen.dart';
import '../../data/webview_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String quizSets = '/quiz-sets';
  static const String player = '/player';
  static const String results = '/results';
  static const String review = '/review';
  static const String history = '/history';
  static const String createQuiz = '/create-quiz';
  static const String settings = '/settings';
  static const String webview = '/webview';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeSectionsScreen(),
      ),
      GoRoute(
        path: quizSets,
        name: 'quiz-sets',
        builder: (context, state) {
          final sectionName = state.uri.queryParameters['section'];
          SportSection? section;

          if (sectionName != null) {
            try {
              section = SportSection.values.firstWhere(
                (s) => s.name == sectionName,
              );
            } catch (e) {
              section = null;
            }
          }

          return QuizSetsScreen(section: section);
        },
      ),
      GoRoute(
        path: player,
        name: 'player',
        builder: (context, state) {
          final quizSet = state.extra as QuizSet?;
          if (quizSet == null) {
            return const Scaffold(
              body: Center(child: Text('Quiz set not found')),
            );
          }
          return QuizPlayerScreen(quizSet: quizSet);
        },
      ),
      GoRoute(
        path: results,
        name: 'results',
        builder: (context, state) {
          final attempt = state.extra as QuizAttempt?;
          if (attempt == null) {
            return const Scaffold(
              body: Center(child: Text('Quiz attempt not found')),
            );
          }
          return ResultsScreen(attempt: attempt);
        },
      ),
      GoRoute(
        path: review,
        name: 'review',
        builder: (context, state) {
          final attempt = state.extra as QuizAttempt?;
          if (attempt == null) {
            return const Scaffold(
              body: Center(child: Text('Quiz attempt not found')),
            );
          }
          return ReviewScreen(attempt: attempt);
        },
      ),
      GoRoute(
        path: history,
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: createQuiz,
        name: 'create-quiz',
        builder: (context, state) {
          final sectionName = state.uri.queryParameters['section'];
          SportSection? section;

          if (sectionName != null) {
            try {
              section = SportSection.values.firstWhere(
                (s) => s.name == sectionName,
              );
            } catch (e) {
              section = null;
            }
          }

          return CreateQuizScreen(preselectedSection: section);
        },
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: webview,
        name: 'webview',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'];
          if (url == null || url.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('URL not provided')),
            );
          }
          return WebviewPage(url: url);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
