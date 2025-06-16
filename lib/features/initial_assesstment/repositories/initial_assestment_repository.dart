import 'package:mobile_app/features/initial_assesstment/models/initial_assestment_model.dart';
import 'package:mobile_app/features/initial_assesstment/services/initial_assestment_service.dart';

class AssessmentRepository {
  final AssessmentService service;

  AssessmentRepository({required this.service});

  Future<void> sendInitialAssessment(InitialAssessmentResult result) {
    return service.submitInitialAssessment(result);
  }
}
