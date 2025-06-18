part of 'initial_assestment_cubit.dart';

abstract class AssessmentState {}

class AssessmentInitial extends AssessmentState {}

class AssessmentLoading extends AssessmentState {}

class AssessmentSuccess extends AssessmentState {}

class AssessmentCreatingPath extends AssessmentState {}

class AssessmentCreatingModules extends AssessmentState {
  final int current;
  final int total;
  final bool quizCreated;

  AssessmentCreatingModules({
    required this.current,
    required this.total,
    required this.quizCreated,
  });
}

class AssessmentError extends AssessmentState {
  final String message;
  AssessmentError(this.message);
}

class AssessmentProgress extends AssessmentState {
  final bool assessmentSent;
  final bool pathCreated;
  final int modulesCreated;
  final int totalModules;
  final bool quizCreated;

  AssessmentProgress({
    required this.assessmentSent,
    required this.pathCreated,
    required this.modulesCreated,
    required this.totalModules,
    required this.quizCreated,
  });
}
