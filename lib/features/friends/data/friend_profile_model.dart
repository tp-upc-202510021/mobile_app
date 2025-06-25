import 'package:mobile_app/features/badge/data/badge_friend_model.dart';

class FriendProfile {
  final int id;
  final String email;
  final String name;
  final int age;
  final String preference;
  final String role;
  final DateTime dateJoined;
  final List<BadgeFriendModel> badges;

  FriendProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.preference,
    required this.role,
    required this.dateJoined,
    required this.badges,
  });

  factory FriendProfile.fromJson(Map<String, dynamic> json) {
    return FriendProfile(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      age: json['age'],
      preference: json['preference'],
      role: json['role'],
      dateJoined: DateTime.parse(json['date_joined']),
      badges: (json['badges'] as List<dynamic>)
          .map((badgeJson) => BadgeFriendModel.fromJson(badgeJson))
          .toList(),
    );
  }
}
