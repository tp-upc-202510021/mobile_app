import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';
import 'package:mobile_app/features/initial_assesstment/repositories/initial_assestment_repository.dart';

part 'assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  final AssessmentRepository repository;

  AssessmentCubit({required this.repository}) : super(AssessmentInitial());

  Future<void> submitInitialAssessment(InitialAssessmentResult result) async {
    try {
      emit(
        AssessmentProgress(
          assessmentSent: false,
          pathCreated: false,
          modulesCreated: 0,
          totalModules: 0,
        ),
      );

      await repository.sendInitialAssessment(result);

      emit(
        AssessmentProgress(
          assessmentSent: true,
          pathCreated: false,
          modulesCreated: 0,
          totalModules: 0,
        ),
      );

      final pathData = await repository.createLearningPath();

      emit(
        AssessmentProgress(
          assessmentSent: true,
          pathCreated: true,
          modulesCreated: 0,
          totalModules: pathData['modules'].length,
        ),
      );
      final moduleIds = (pathData['modules'] as List)
          .map<int>((m) => m['id'])
          .toList();

      if (moduleIds.isNotEmpty) {
        await repository.createLearningModule(moduleIds.first);
        emit(
          AssessmentProgress(
            assessmentSent: true,
            pathCreated: true,
            modulesCreated: 1,
            totalModules: moduleIds.length,
          ),
        );
      }

      emit(AssessmentSuccess());
    } catch (e) {
      emit(AssessmentError(e.toString()));
    }
  }
}
