import 'module_model.dart';

class LearningPathModel {
  final int learningPathId;
  final int userId;
  final DateTime createdAt;
  final List<ModuleModel> modules;

  LearningPathModel({
    required this.learningPathId,
    required this.userId,
    required this.createdAt,
    required this.modules,
  });

  factory LearningPathModel.fromJson(Map<String, dynamic> json) {
    return LearningPathModel(
      learningPathId: json['learning_path_id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      modules: (json['modules'] as List)
          .map((module) => ModuleModel.fromJson(module))
          .toList(),
    );
  }
}
