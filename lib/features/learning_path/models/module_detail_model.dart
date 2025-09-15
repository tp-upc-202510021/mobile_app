import 'learning_module_content.dart';

class ModuleDetailModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final int orderIndex;
  final bool isBlocked;
  final LearningModuleContent? content;

  ModuleDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.orderIndex,
    required this.isBlocked,
    required this.content,
  });

  factory ModuleDetailModel.fromJson(Map<String, dynamic> json) {
    final contentJson = json['content'] as Map<String, dynamic>?;
    return ModuleDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      level: json['level'],
      orderIndex: json['order_index'],
      isBlocked: json['is_blocked'],
      content: contentJson != null
          ? LearningModuleContent.fromJson(contentJson)
          : null,
    );
  }
}
