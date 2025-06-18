import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/quiz/data/quiz_model.dart';
import 'package:mobile_app/features/quiz/data/quiz_repository.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _quizRepository;
  Quiz? _quiz;
  QuizCubit(this._quizRepository) : super(QuizInitial());

  Quiz? get quiz => _quiz;
  Future<void> loadQuiz(int moduleId) async {
    try {
      emit(QuizLoading());
      final quiz = await _quizRepository.getQuiz(moduleId);
      _quiz = quiz;
      emit(QuizLoaded(quiz));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  Future<void> submitResult({required int quizId, required int score}) async {
    try {
      emit(QuizSubmitting());
      await _quizRepository.submitQuizResult(quizId: quizId, score: score);
      emit(QuizSubmitted(score));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }
}
