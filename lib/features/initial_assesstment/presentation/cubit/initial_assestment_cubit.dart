import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';
import 'package:mobile_app/features/initial_assesstment/repositories/initial_assestment_repository.dart';
import 'package:mobile_app/features/quiz/data/quiz_repository.dart';

part 'assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  final AssessmentRepository repository;
  final QuizRepository quizRepository;

  AssessmentCubit({required this.repository, required this.quizRepository})
    : super(AssessmentInitial());

  Future<void> submitInitialAssessment(InitialAssessmentResult result) async {
    try {
      emit(
        AssessmentProgress(
          assessmentSent: false,
          pathCreated: false,
          modulesCreated: 0,
          totalModules: 0,
          quizCreated: false,
        ),
      );

      await repository.sendInitialAssessment(result);

      emit(
        AssessmentProgress(
          assessmentSent: true,
          pathCreated: false,
          modulesCreated: 0,
          totalModules: 0,
          quizCreated: false,
        ),
      );

      final pathData = await repository.createLearningPath();

      emit(
        AssessmentProgress(
          assessmentSent: true,
          pathCreated: true,
          modulesCreated: 0,
          totalModules: pathData['modules'].length,
          quizCreated: false,
        ),
      );
      final moduleIds = (pathData['modules'] as List)
          .map<int>((m) => m['id'])
          .toList();

      if (moduleIds.isNotEmpty) {
        final firstModuleId = moduleIds.first;
        await repository.createLearningModule(firstModuleId);
        emit(
          AssessmentProgress(
            assessmentSent: true,
            pathCreated: true,
            modulesCreated: 1,
            totalModules: moduleIds.length,
            quizCreated: false,
          ),
        );
        //await quizRepository.generateQuiz(firstModuleId);

        emit(
          AssessmentProgress(
            assessmentSent: true,
            pathCreated: true,
            modulesCreated: 1,
            totalModules: moduleIds.length,
            quizCreated: true,
          ),
        );
      }

      emit(AssessmentSuccess());
    } catch (e) {
      emit(AssessmentError(e.toString()));
    }
  }

  Future<void> generateContentForModule(int moduleId) async {
    try {
      emit(AssessmentCreatingModules(current: 0, total: 1, quizCreated: false));
      await repository.createLearningModule(moduleId);
      emit(AssessmentCreatingModules(current: 1, total: 1, quizCreated: false));
      //await quizRepository.generateQuiz(moduleId);
      emit(AssessmentCreatingModules(current: 1, total: 1, quizCreated: true));
      emit(AssessmentSuccess());
    } catch (e) {
      emit(AssessmentError(e.toString()));
    }
  }
}
