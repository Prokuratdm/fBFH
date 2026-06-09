/// Ответ API для пользователя.
class UserResponse {
  final String id;
  final String username;
  final String email;
  final bool enabled;
  final List<String> roles;
  final String? clubId;
  final String? clubName;
  final String? lastSeenAt;
  final String createdAt;

  const UserResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.enabled,
    required this.roles,
    this.clubId,
    this.clubName,
    this.lastSeenAt,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      enabled: json['enabled'] as bool,
      roles: (json['roles'] as List<dynamic>).cast<String>(),
      clubId: json['clubId'] as String?,
      clubName: json['clubName'] as String?,
      lastSeenAt: json['lastSeenAt'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'enabled': enabled,
      'roles': roles,
      'clubId': clubId,
      'clubName': clubName,
      'lastSeenAt': lastSeenAt,
      'createdAt': createdAt,
    };
  }
}