class BadgeFriendModel {
  final int id;
  final String name;
  final String description;
  final String unlockCondition;
  final String userDescription;
  final DateTime dateUnlocked;

  BadgeFriendModel({
    required this.id,
    required this.name,
    required this.description,
    required this.unlockCondition,
    required this.userDescription, // Lo que el usuario ve
    required this.dateUnlocked,
  });

  factory BadgeFriendModel.fromJson(Map<String, dynamic> json) {
    return BadgeFriendModel(
      id: json['badge_id'],
      name: json['name'],
      description: json['user_description'], // Lo que el usuario ve
      unlockCondition:
          json['unlock_condition'], // Lo que se necesita para desbloquearlo
      userDescription: json['user_description'], // Lo que el usuario ve
      dateUnlocked: DateTime.parse(json['date_unlocked']),
    );
  }
}
