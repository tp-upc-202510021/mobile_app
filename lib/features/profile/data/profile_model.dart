class ProfileModel {
  final int id;
  final String email;
  final String name;
  final int age;
  final String preference;
  final String role;
  final DateTime dateJoined;
  final List<dynamic> badges;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.preference,
    required this.role,
    required this.dateJoined,
    required this.badges,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      age: json['age'],
      preference: json['preference'],
      role: json['role'],
      dateJoined: DateTime.parse(json['date_joined']),
      badges: json['badges'],
    );
  }
}
