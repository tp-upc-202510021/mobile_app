import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';
import 'package:mobile_app/features/initial_assesstment/repositories/initial_assestment_repository.dart';

part 'assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  final AssessmentRepository repository;

  AssessmentCubit({required this.repository}) : super(AssessmentInitial());

  Future<void> submitInitialAssessment(InitialAssessmentResult result) async {
    emit(AssessmentLoading());
    try {
      await repository.sendInitialAssessment(result);
      emit(AssessmentSuccess());
    } catch (e) {
      emit(AssessmentError(e.toString()));
    }
  }
}
