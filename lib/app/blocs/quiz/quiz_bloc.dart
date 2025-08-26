import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/quiz_set.dart';
import '../../../domain/repositories/quiz_repository.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;
  final Uuid _uuid = const Uuid();

  QuizBloc({required QuizRepository repository})
      : _repository = repository,
        super(QuizInitial()) {
    on<LoadQuizSets>(_onLoadQuizSets);
    on<LoadQuestions>(_onLoadQuestions);
    on<CreateQuizSet>(_onCreateQuizSet);
    on<DeleteQuizSet>(_onDeleteQuizSet);
    on<FilterQuizSets>(_onFilterQuizSets);
  }

  Future<void> _onLoadQuizSets(LoadQuizSets event, Emitter<QuizState> emit) async {
    emit(QuizLoading());
    
    try {
      final quizSets = event.section != null
          ? _repository.getQuizSetsBySection(event.section!)
          : _repository.getAllQuizSets();
      
      final questions = event.section != null
          ? _repository.getQuestionsBySection(event.section!)
          : _repository.getAllQuestions();

      emit(QuizLoaded(
        quizSets: quizSets,
        questions: questions,
        filteredQuizSets: quizSets,
      ));
    } catch (e) {
      emit(QuizError('Failed to load quiz sets: $e'));
    }
  }

  Future<void> _onLoadQuestions(LoadQuestions event, Emitter<QuizState> emit) async {
    try {
      final questions = event.section != null
          ? _repository.getQuestionsBySection(event.section!)
          : _repository.getAllQuestions();

      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        emit(currentState.copyWith(questions: questions));
      } else {
        emit(QuizLoaded(
          quizSets: [],
          questions: questions,
          filteredQuizSets: [],
        ));
      }
    } catch (e) {
      emit(QuizError('Failed to load questions: $e'));
    }
  }

  Future<void> _onCreateQuizSet(CreateQuizSet event, Emitter<QuizState> emit) async {
    try {
      final quizSet = QuizSet(
        id: _uuid.v4(),
        title: event.title,
        section: event.section,
        questionIds: event.questionIds,
        isSystem: false,
        shuffleQuestions: event.shuffleQuestions,
        shuffleOptions: event.shuffleOptions,
        timePerQuestionSec: event.timePerQuestionSec,
        createdAt: DateTime.now(),
      );

      await _repository.saveQuizSet(quizSet);
      
      emit(QuizSetCreated(quizSet));
      
      // Reload quiz sets
      add(LoadQuizSets());
    } catch (e) {
      emit(QuizError('Failed to create quiz set: $e'));
    }
  }

  Future<void> _onDeleteQuizSet(DeleteQuizSet event, Emitter<QuizState> emit) async {
    try {
      await _repository.deleteQuizSet(event.quizSetId);
      
      emit(QuizSetDeleted(event.quizSetId));
      
      // Reload quiz sets
      add(LoadQuizSets());
    } catch (e) {
      emit(QuizError('Failed to delete quiz set: $e'));
    }
  }

  Future<void> _onFilterQuizSets(FilterQuizSets event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      List<QuizSet> filtered = List.from(currentState.quizSets);

      // Filter by section
      if (event.section != null) {
        filtered = filtered.where((quiz) => quiz.section == event.section).toList();
      }

      // Filter by search query
      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        final query = event.searchQuery!.toLowerCase();
        filtered = filtered.where((quiz) => 
          quiz.title.toLowerCase().contains(query)
        ).toList();
      }

      // Filter by difficulty (based on questions in quiz)
      if (event.difficulty != null) {
        filtered = filtered.where((quiz) {
          final questions = _repository.getQuestionsByIds(quiz.questionIds);
          if (questions.isEmpty) return false;
          
          final avgDifficulty = questions
              .map((q) => q.difficulty)
              .reduce((a, b) => a + b) / questions.length;
          
          return avgDifficulty.round() == event.difficulty;
        }).toList();
      }

      emit(currentState.copyWith(filteredQuizSets: filtered));
    }
  }
}
