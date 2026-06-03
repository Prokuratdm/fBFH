/// Модель ответа от POST /api/v1/auth/login
class LoginResponse {
  final String token;
  final String userId;
  final String username;
  final List<String> roles;

  const LoginResponse({
    required this.token,
    required this.userId,
    required this.username,
    required this.roles,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      roles: (json['roles'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'username': username,
      'roles': roles,
    };
  }
}