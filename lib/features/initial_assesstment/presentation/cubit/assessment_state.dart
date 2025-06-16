part of 'initial_assestment_cubit.dart';

abstract class AssessmentState {}

class AssessmentInitial extends AssessmentState {}

class AssessmentLoading extends AssessmentState {}

class AssessmentSuccess extends AssessmentState {}

class AssessmentCreatingPath extends AssessmentState {}

class AssessmentCreatingModules extends AssessmentState {}

class AssessmentError extends AssessmentState {
  final String message;
  AssessmentError(this.message);
}
