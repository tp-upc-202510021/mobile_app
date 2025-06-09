import 'package:mobile_app/features/learning_path/models/module_detail_model.dart';
import '../models/learning_path_model.dart';
import '../services/learning_path_service.dart';

class LearningPathRepository {
  final LearningPathService _service;

  LearningPathRepository(this._service);

  Future<LearningPathModel> getLearningPath() async {
    final data = await _service.fetchLearningPath();
    return LearningPathModel.fromJson(data);
  }

  Future<ModuleDetailModel> getModuleDetail(int moduleId) async {
    final data = await _service.fetchModuleDetail(moduleId);
    return ModuleDetailModel.fromJson(data);
  }
}
