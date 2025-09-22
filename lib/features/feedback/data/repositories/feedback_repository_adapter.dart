import '../../domain/entities/feedback_entities.dart';
import '../models/feedback_models.dart';
import '../services/feedback_service.dart';
import '../../domain/repositories/feedback_repository.dart';

class FeedbackRepositoryAdapter implements FeedbackRepository {
  final FeedbackService service;
  FeedbackRepositoryAdapter(this.service);

  @override
  Future<List<FeedbackQuestion>> getQuestions() async {
    final dataModels = await service.fetchQuestions();
    return dataModels
        .map(
          (m) => FeedbackQuestion(
            id: m.id,
            questionText: m.questionText,
            questionType: m.questionType,
            predefinedAnswers: m.predefinedAnswers,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveResponses(
    int moduleId,
    List<FeedbackResponse> responses,
  ) async {
    final dataModels = responses
        .map(
          (r) =>
              FeedbackResponseModel(questionId: r.questionId, answer: r.answer),
        )
        .toList();
    await service.saveResponses(moduleId, dataModels);
  }
}
