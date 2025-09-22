import '../entities/feedback_entities.dart';

abstract class FeedbackRepository {
  Future<List<FeedbackQuestion>> getQuestions();
  Future<void> saveResponses(int moduleId, List<FeedbackResponse> responses);
}
