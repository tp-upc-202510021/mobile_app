class UserModel {
  final int? id;
  final String email;
  final String? name;
  final String? role;
  final int? age;
  final String? preference; // 'loans' o 'investments'

  UserModel({
    this.id,
    required this.email,
    this.name,
    this.role,
    this.age,
    this.preference,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    role: json['role'],
    age: json['age'],
    preference: json['preference'],
  );
}
