import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/quiz_attempt.dart';
import '../../../domain/entities/sport_section.dart';
import '../../../data/repositories/quiz_repository_impl.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';
import '../../../core/utils/quiz_utils.dart';
import '../../../app/routes/app_router.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<QuizAttempt>? _attempts;
  bool _isLoading = true;
  SportSection? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadAttempts();
  }

  Future<void> _loadAttempts() async {
    try {
      final repository = context.read<QuizRepositoryImpl>();
      final attempts = repository.getAllAttempts();

      // Sort by date (newest first)
      attempts.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      setState(() {
        _attempts = attempts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading attempts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<QuizAttempt> get _filteredAttempts {
    if (_attempts == null) return [];
    if (_selectedFilter == null) return _attempts!;
    return _attempts!
        .where((attempt) => attempt.quizSetSafe.section == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz History', style: AppTypography.h3),
        actions: [
          if (_attempts != null && _attempts!.isNotEmpty)
            PopupMenuButton<SportSection?>(
              icon: const Icon(Icons.filter_list_outlined),
              onSelected: (section) {
                setState(() {
                  _selectedFilter = section;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: null, child: Text('All Sections')),
                ...SportSection.values.map(
                  (section) => PopupMenuItem(
                    value: section,
                    child: Text(section.displayName),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _attempts == null || _attempts!.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Quiz History',
              style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your first quiz to see your attempt history here.',
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Start a Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    final filteredAttempts = _filteredAttempts;

    if (filteredAttempts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_list_off_outlined,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No Results',
                style: AppTypography.h3.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No quiz attempts found for ${_selectedFilter?.displayName}.',
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = null;
                  });
                },
                child: const Text('Clear Filter'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAttempts,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredAttempts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildStatsHeader(filteredAttempts);
          }

          final attempt = filteredAttempts[index - 1];
          return _buildAttemptCard(attempt);
        },
      ),
    );
  }

  Widget _buildStatsHeader(List<QuizAttempt> attempts) {
    final totalAttempts = attempts.length;
    final averageScore = attempts.isEmpty
        ? 0.0
        : attempts.fold<double>(
                0,
                (sum, attempt) => sum + attempt.scorePercent,
              ) /
              totalAttempts;
    final bestScore = attempts.isEmpty
        ? 0.0
        : attempts.fold<double>(
            0,
            (best, attempt) =>
                attempt.scorePercent > best ? attempt.scorePercent : best,
          );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedFilter == null
                  ? 'Overall Statistics'
                  : '${_selectedFilter!.displayName} Statistics',
              style: AppTypography.h4,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Attempts',
                    '$totalAttempts',
                    Icons.quiz_outlined,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Average Score',
                    '${averageScore.round()}%',
                    Icons.trending_up_outlined,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Best Score',
                    '${bestScore.round()}%',
                    Icons.star_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.h4.copyWith(color: AppColors.primary)),
        Text(label, style: AppTypography.caption, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildAttemptCard(QuizAttempt attempt) {
    final scoreColor = _getScoreColor(attempt.scorePercent);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scoreColor.withOpacity(0.1),
          child: Text(
            attempt.quizSetSafe.section.emoji,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          attempt.quizSetSafe.title,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${attempt.correctCount}/${attempt.totalCount} correct • ${QuizUtils.formatDuration(attempt.duration)}',
              style: AppTypography.caption,
            ),
            Text(
              QuizUtils.formatDateTime(attempt.completedAt),
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${attempt.scorePercent.round()}%',
                style: AppTypography.caption.copyWith(
                  color: scoreColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              attempt.scoreGrade,
              style: AppTypography.caption.copyWith(
                color: scoreColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onTap: () => context.push(AppRouter.review, extra: attempt),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppColors.success;
    if (score >= 70) return AppColors.primary;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }
}
