/// Модель ответа от GET /api/v1/auth/me
class UserInfo {
  final String id;
  final String username;
  final String email;
  final bool enabled;
  final List<String> roles;
  final String? clubId;
  final String? clubName;
  final String lastSeenAt;
  final String createdAt;

  const UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.enabled,
    required this.roles,
    this.clubId,
    this.clubName,
    required this.lastSeenAt,
    required this.createdAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      enabled: json['enabled'] as bool,
      roles: (json['roles'] as List<dynamic>).cast<String>(),
      clubId: json['clubId'] as String?,
      clubName: json['clubName'] as String?,
      lastSeenAt: json['lastSeenAt'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}