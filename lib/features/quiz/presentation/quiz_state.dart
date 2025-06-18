part of 'quiz_cubit.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final Quiz quiz;
  QuizLoaded(this.quiz);
}

class QuizError extends QuizState {
  final String message;
  QuizError(this.message);
}

class QuizSubmitting extends QuizState {}

class QuizSubmitted extends QuizState {
  final int score;
  QuizSubmitted(this.score);
}
