/// User domain model
class User {
  const User({required this.id, required this.email, this.username, this.createdAt});

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  final String id;
  final String email;
  final String? username;
  final DateTime? createdAt;

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          username == other.username &&
          createdAt == other.createdAt;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ username.hashCode ^ createdAt.hashCode;

  @override
  String toString() {
    return 'User{id: $id, email: $email, username: $username, createdAt: $createdAt}';
  }
}
