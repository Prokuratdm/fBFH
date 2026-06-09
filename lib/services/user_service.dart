import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/page_response.dart';
import '../models/user_response.dart';
import 'auth_service.dart';

/// Сервис для работы с пользователями.
class UserService {
  final AuthService _authService;

  UserService(this._authService);

  String? get _token => _authService.getToken();

  Map<String, String> get _headers => {
        'Accept': '*/*',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// Возвращает список пользователей с пагинацией и фильтрами.
  Future<PageResponse<UserResponse>> getUsers({
    int page = 0,
    int size = 10,
    String? clubId,
    String? role,
    String? username,
  }) async {
    final params = {
      'page': page.toString(),
      'size': size.toString(),
      if (clubId != null) 'clubId': clubId,
      if (role != null) 'role': role,
      if (username != null && username.isNotEmpty) 'username': username,
    };
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.usersPath}')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return PageResponse.fromJson(body, UserResponse.fromJson);
    } else {
      throw UserException(_extractMessage(response));
    }
  }

  /// Создаёт нового пользователя.
  Future<UserResponse> createUser({
    required String username,
    required String password,
    required String email,
    required List<String> roles,
    String? clubId,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.usersPath}');
    final response = await http.post(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'roles': roles,
        if (clubId != null) 'clubId': clubId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return UserResponse.fromJson(body);
    } else {
      throw UserException(_extractMessage(response));
    }
  }

  /// Возвращает детальную информацию о пользователе.
  Future<UserResponse> getUser(String id) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.userPath(id)}',
    );
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return UserResponse.fromJson(body);
    } else {
      throw UserException(_extractMessage(response));
    }
  }

  /// Меняет пароль пользователя.
  Future<void> changePassword(String id, String newPassword) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.userPasswordPath(id)}',
    );
    final response = await http.put(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      throw UserException(_extractMessage(response));
    }
  }

  String _extractMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['detail'] ?? 'Ошибка (${response.statusCode})';
    } catch (_) {
      return 'Ошибка сервера (${response.statusCode})';
    }
  }
}

class UserException implements Exception {
  final String message;
  const UserException(this.message);

  @override
  String toString() => 'UserException: $message';
}