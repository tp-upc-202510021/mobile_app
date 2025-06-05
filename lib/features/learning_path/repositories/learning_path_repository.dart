import '../models/learning_path_model.dart';
import '../services/learning_path_service.dart';

class LearningPathRepository {
  final LearningPathService _service;

  LearningPathRepository(this._service);

  Future<LearningPathModel> getLearningPath() async {
    final data = await _service.fetchLearningPath();
    return LearningPathModel.fromJson(data);
  }
}
