class ModuleDetailModel {
  final int id;
  final String title;
  final String description;
  final String level;
  final int orderIndex;
  final bool isBlocked;
  final List<ModulePage> pages;

  ModuleDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.orderIndex,
    required this.isBlocked,
    required this.pages,
  });

  factory ModuleDetailModel.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>?;

    final pagesJson = content != null && content['pages'] != null
        ? content['pages'] as List<dynamic>
        : [];

    return ModuleDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      level: json['level'],
      orderIndex: json['order_index'],
      isBlocked: json['is_blocked'],
      pages: pagesJson.map((e) => ModulePage.fromJson(e)).toList(),
    );
  }
}

class ModulePage {
  final String type;
  final String content;

  ModulePage({required this.type, required this.content});

  factory ModulePage.fromJson(Map<String, dynamic> json) {
    return ModulePage(type: json['type'], content: json['content']);
  }
}
