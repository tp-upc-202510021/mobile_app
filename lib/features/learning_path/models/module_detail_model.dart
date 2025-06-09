class ModuleDetailModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final int orderIndex;
  final bool isBlocked;
  final String content;

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
    return ModuleDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      level: json['level'],
      orderIndex: json['order_index'],
      isBlocked: json['is_blocked'],
      content: json['content'] ?? 'Sin contenido',
    );
  }
}
