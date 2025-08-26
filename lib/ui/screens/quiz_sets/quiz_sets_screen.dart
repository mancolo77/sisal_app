import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/sport_section.dart';
import '../../../domain/entities/quiz_set.dart';
import '../../../app/blocs/quiz/quiz_bloc.dart';
import '../../../app/blocs/quiz/quiz_event.dart';
import '../../../app/blocs/quiz/quiz_state.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/colors/app_colors.dart';
import '../../../core/typography/app_typography.dart';
import '../../widgets/quiz_set_card.dart';
import '../../widgets/section_filter_chips.dart';
import '../../widgets/loading_indicator.dart';

class QuizSetsScreen extends StatefulWidget {
  final SportSection? section;

  const QuizSetsScreen({super.key, this.section});

  @override
  State<QuizSetsScreen> createState() => _QuizSetsScreenState();
}

class _QuizSetsScreenState extends State<QuizSetsScreen> {
  final TextEditingController _searchController = TextEditingController();
  SportSection? _selectedSection;

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.section;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizBloc>().add(LoadQuizSets(section: _selectedSection));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedSection?.displayName ?? 'All Quiz Sets',
          style: AppTypography.h3,
        ),
      ),
      body: Column(
        children: [
          // Search and filters
          _buildSearchAndFilters(),

          // Quiz sets list
          Expanded(
            child: BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                if (state is QuizLoading) {
                  return const LoadingIndicator();
                } else if (state is QuizLoaded) {
                  return _buildQuizSetsList(state.filteredQuizSets);
                } else if (state is QuizError) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search quiz sets...',
              prefixIcon: const Icon(Icons.search_outlined),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                      icon: const Icon(Icons.clear_outlined),
                    )
                  : null,
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),

          // Section filter chips
          SectionFilterChips(
            selectedSection: _selectedSection,
            onSectionChanged: _onSectionChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSetsList(List<QuizSet> quizSets) {
    if (quizSets.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: quizSets.length,
      itemBuilder: (context, index) {
        final quizSet = quizSets[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == quizSets.length - 1 ? 0 : 16,
          ),
          child: QuizSetCard(
            quizSet: quizSet,
            onTap: () => _startQuiz(quizSet),
            onEdit: quizSet.isSystem ? null : () => _editQuizSet(quizSet),
            onDelete: quizSet.isSystem ? null : () => _deleteQuizSet(quizSet),
            onDuplicate: () => _duplicateQuizSet(quizSet),
          ),
        );
      },
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
              Icons.quiz_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Quiz Sets Found',
              style: AppTypography.h3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedSection != null
                  ? 'No quiz sets available for ${_selectedSection!.displayName}'
                  : 'No quiz sets match your search criteria',
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: AppTypography.h3.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<QuizBloc>().add(
                  LoadQuizSets(section: _selectedSection),
                );
              },
              icon: const Icon(Icons.refresh_outlined),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    context.read<QuizBloc>().add(
      FilterQuizSets(section: _selectedSection, searchQuery: query),
    );
  }

  void _onSectionChanged(SportSection? section) {
    setState(() {
      _selectedSection = section;
    });
    context.read<QuizBloc>().add(LoadQuizSets(section: section));
  }

  void _startQuiz(QuizSet quizSet) {
    context.push(AppRouter.player, extra: quizSet);
  }

  void _editQuizSet(QuizSet quizSet) {
    // TODO: Implement edit quiz set
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit quiz set - Coming soon!')),
    );
  }

  void _deleteQuizSet(QuizSet quizSet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz Set'),
        content: Text('Are you sure you want to delete "${quizSet.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<QuizBloc>().add(DeleteQuizSet(quizSet.id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _duplicateQuizSet(QuizSet quizSet) {
    // TODO: Implement duplicate quiz set
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duplicate quiz set - Coming soon!')),
    );
  }
}
