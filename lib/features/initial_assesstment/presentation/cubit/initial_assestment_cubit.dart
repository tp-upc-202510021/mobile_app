import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';
import 'package:mobile_app/features/initial_assesstment/repositories/initial_assestment_repository.dart';

part 'assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  final AssessmentRepository repository;

  AssessmentCubit({required this.repository}) : super(AssessmentInitial());

  Future<void> submitInitialAssessment(InitialAssessmentResult result) async {
    try {
      emit(AssessmentLoading());
      await repository.sendInitialAssessment(result);

      emit(AssessmentCreatingPath());
      final pathData = await repository.createLearningPath();

      final moduleIds = (pathData['modules'] as List)
          .map<int>((m) => m['id'] as int)
          .toList();

      print('Module IDs: $moduleIds');

      // Proceso uno por uno con feedback
      for (int i = 0; i < moduleIds.length; i++) {
        emit(
          AssessmentCreatingModules(current: i + 1, total: moduleIds.length),
        );
        await repository.createLearningModules([moduleIds[i]]);
      }

      emit(AssessmentSuccess());
    } catch (e) {
      emit(AssessmentError(e.toString()));
    }
  }
}
