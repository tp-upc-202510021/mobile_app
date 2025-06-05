class ModuleModel {
  final String title;
  final String description;
  final String level;
  final int orderIndex;
  final bool isBlocked;

  ModuleModel({
    required this.title,
    required this.description,
    required this.level,
    required this.orderIndex,
    required this.isBlocked,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      title: json['title'],
      description: json['description'],
      level: json['level'],
      orderIndex: json['order_index'],
      isBlocked: json['is_blocked'],
    );
  }
}
