import 'module_model.dart';

class LearningPathModel {
  final int? learningPathId;
  final int? userId;
  final DateTime? createdAt;
  final List<ModuleModel> modules;

  LearningPathModel({
    this.learningPathId,
    this.userId,
    this.createdAt,
    required this.modules,
  });

  factory LearningPathModel.fromJson(Map<String, dynamic> json) {
    return LearningPathModel(
      learningPathId: json['learning_path_id'] as int?,
      userId: json['user_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      modules:
          (json['modules'] as List<dynamic>?)
              ?.map((module) => ModuleModel.fromJson(module))
              .toList() ??
          [],
    );
  }
}
