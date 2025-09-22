import '../models/feedback_models.dart';
import '../services/feedback_service.dart';

abstract class FeedbackRepository {
  Future<List<FeedbackQuestionModel>> getQuestions();
  Future<void> saveResponses(
    int moduleId,
    List<FeedbackResponseModel> responses,
  );
}

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackService service;
  FeedbackRepositoryImpl(this.service);

  @override
  Future<List<FeedbackQuestionModel>> getQuestions() =>
      service.fetchQuestions();

  @override
  Future<void> saveResponses(
    int moduleId,
    List<FeedbackResponseModel> responses,
  ) => service.saveResponses(moduleId, responses);
}
