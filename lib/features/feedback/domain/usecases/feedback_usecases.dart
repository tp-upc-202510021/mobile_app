import '../entities/feedback_entities.dart';
import '../repositories/feedback_repository.dart';

class GetFeedbackQuestionsUseCase {
  final FeedbackRepository repository;
  GetFeedbackQuestionsUseCase(this.repository);

  Future<List<FeedbackQuestion>> call() => repository.getQuestions();
}

class SaveFeedbackResponsesUseCase {
  final FeedbackRepository repository;
  SaveFeedbackResponsesUseCase(this.repository);

  Future<void> call(int moduleId, List<FeedbackResponse> responses) =>
      repository.saveResponses(moduleId, responses);
}
