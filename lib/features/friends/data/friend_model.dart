class Friend {
  final int id;
  final String username;
  final String email;

  Friend({required this.id, required this.username, required this.email});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['friend_id'], // <-- actualizado
      username: json['friend_name'], // <-- actualizado
      email: json['friend_email'], // <-- actualizado
    );
  }
}
