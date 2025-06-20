class BadgeModel {
  final int id;
  final int userId;
  final String name;
  final String description;
  final String badgeDescription;
  final DateTime dateUnlocked;

  BadgeModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.badgeDescription,
    required this.dateUnlocked,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['badge_name'],
      description: json['description'],
      badgeDescription: json['badge_description'],
      dateUnlocked: DateTime.parse(json['date_unlocked']),
    );
  }
}
