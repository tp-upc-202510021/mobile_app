import 'package:mobile_app/features/quiz/data/quiz_model.dart';

import 'quiz_service.dart';

class QuizRepository {
  final QuizService _quizService;

  QuizRepository(this._quizService);

  Future<Map<String, dynamic>> generateQuiz(int moduleId) {
    return _quizService.generateQuiz(moduleId);
  }

  Future<Quiz> getQuiz(int moduleId) => _quizService.fetchQuiz(moduleId);

  Future<void> submitQuizResult({required int quizId, required int score}) {
    return _quizService.submitQuizResult(quizId: quizId, score: score);
  }
}
