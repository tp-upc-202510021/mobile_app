part of 'feedback_cubit.dart';

abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackLoaded extends FeedbackState {
  final List<FeedbackQuestion> questions;
  FeedbackLoaded(this.questions);
}

class FeedbackSubmitting extends FeedbackState {}

class FeedbackSubmitted extends FeedbackState {}

class FeedbackError extends FeedbackState {
  final String message;
  FeedbackError(this.message);
}
