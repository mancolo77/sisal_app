import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';
import '../../../data/repositories/quiz_repository_impl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoNextQuestion = false;
  bool _showExplanations = true;
  double _defaultTimePerQuestion = 30.0;
  String _selectedDifficulty = 'Mixed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: AppTypography.h3)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Quiz Preferences'),
          _buildSwitchTile(
            title: 'Show Explanations',
            subtitle: 'Display explanations after each question',
            value: _showExplanations,
            onChanged: (value) => setState(() => _showExplanations = value),
            icon: Icons.lightbulb_outline,
          ),
          _buildSwitchTile(
            title: 'Auto Next Question',
            subtitle: 'Automatically move to next question after answering',
            value: _autoNextQuestion,
            onChanged: (value) => setState(() => _autoNextQuestion = value),
            icon: Icons.skip_next_outlined,
          ),
          _buildSliderTile(
            title: 'Default Time per Question',
            subtitle: '${_defaultTimePerQuestion.round()} seconds',
            value: _defaultTimePerQuestion,
            min: 10.0,
            max: 120.0,
            divisions: 11,
            onChanged: (value) =>
                setState(() => _defaultTimePerQuestion = value),
            icon: Icons.timer_outlined,
          ),
          _buildDropdownTile(
            title: 'Default Difficulty',
            subtitle: 'Preferred difficulty level for new quizzes',
            value: _selectedDifficulty,
            items: ['Easy', 'Medium', 'Hard', 'Mixed'],
            onChanged: (value) => setState(() => _selectedDifficulty = value!),
            icon: Icons.trending_up_outlined,
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Settings'),
          _buildActionTile(
            title: 'Reset All Settings',
            subtitle: 'Restore default app settings and clear all data',
            icon: Icons.restore_outlined,
            onTap: () => _showResetSettingsDialog(),
            color: AppColors.error,
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          _buildInfoTile(
            title: 'App Version',
            subtitle: '1.0.0',
            icon: Icons.info_outline,
          ),
          _buildActionTile(
            title: 'View Statistics',
            subtitle: 'See your overall quiz performance',
            icon: Icons.analytics_outlined,
            onTap: () => _showStatsDialog(),
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Text(
        title,
        style: AppTypography.h4.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(title, style: AppTypography.body),
        subtitle: Text(subtitle, style: AppTypography.caption),
        secondary: Icon(icon, color: AppColors.primary),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTypography.body),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: AppTypography.caption),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTypography.body),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: AppTypography.caption),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: AppTypography.body),
        subtitle: Text(subtitle, style: AppTypography.caption),
        trailing: Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTypography.body),
        subtitle: Text(subtitle, style: AppTypography.caption),
      ),
    );
  }

  void _showResetSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values and clear all quiz history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _resetSettingsAndClearHistory();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset and history cleared'),
                  ),
                );
              }
            },
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Overall Statistics'),
        content: FutureBuilder<Map<String, dynamic>>(
          future: _getOverallStats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final stats = snapshot.data ?? {};
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatRow(
                  'Total Quizzes Completed',
                  '${stats['totalQuizzes'] ?? 0}',
                ),
                _buildStatRow(
                  'Total Questions Answered',
                  '${stats['totalQuestions'] ?? 0}',
                ),
                _buildStatRow(
                  'Average Score',
                  '${stats['averageScore'] ?? 0}%',
                ),
                _buildStatRow('Best Score', '${stats['bestScore'] ?? 0}%'),
                _buildStatRow(
                  'Favorite Category',
                  '${stats['favoriteCategory'] ?? 'None'}',
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption),
          Text(
            value,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    setState(() {
      _autoNextQuestion = false;
      _showExplanations = true;
      _defaultTimePerQuestion = 30.0;
      _selectedDifficulty = 'Mixed';
    });
  }

  Future<void> _resetSettingsAndClearHistory() async {
    try {
      final repository = context.read<QuizRepositoryImpl>();
      // Clear all quiz attempts (history)
      await repository.clearAllAttempts();

      // Reset settings
      _resetSettings();

      print('Settings reset and history cleared successfully');
    } catch (e) {
      print('Error resetting settings and clearing history: $e');
    }
  }

  Future<Map<String, dynamic>> _getOverallStats() async {
    try {
      final repository = context.read<QuizRepositoryImpl>();
      final attempts = repository.getAllAttempts();

      if (attempts.isEmpty) {
        return {
          'totalQuizzes': 0,
          'totalQuestions': 0,
          'averageScore': 0,
          'bestScore': 0,
          'favoriteCategory': 'None',
        };
      }

      final totalQuizzes = attempts.length;
      final totalQuestions = attempts.fold<int>(
        0,
        (sum, attempt) => sum + attempt.totalCount,
      );
      final averageScore =
          attempts.fold<double>(
            0,
            (sum, attempt) => sum + attempt.scorePercent,
          ) /
          totalQuizzes;
      final bestScore = attempts.fold<double>(
        0,
        (best, attempt) =>
            attempt.scorePercent > best ? attempt.scorePercent : best,
      );

      // Find favorite category (most attempted)
      final categoryCounts = <String, int>{};
      for (final attempt in attempts) {
        final category = attempt.quizSetSafe.section.name;
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
      }

      final favoriteCategory =
          categoryCounts.entries
              .fold<MapEntry<String, int>?>(
                null,
                (best, entry) =>
                    best == null || entry.value > best.value ? entry : best,
              )
              ?.key ??
          'None';

      return {
        'totalQuizzes': totalQuizzes,
        'totalQuestions': totalQuestions,
        'averageScore': averageScore.round(),
        'bestScore': bestScore.round(),
        'favoriteCategory': favoriteCategory,
      };
    } catch (e) {
      print('Error getting stats: $e');
      return {
        'totalQuizzes': 0,
        'totalQuestions': 0,
        'averageScore': 0,
        'bestScore': 0,
        'favoriteCategory': 'None',
      };
    }
  }
}
