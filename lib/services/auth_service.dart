import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/login_response.dart';
import 'cookie_storage.dart';

/// Сервис аутентификации.
///
/// Выполняет логин через POST /api/v1/auth/login,
/// сохраняет токен/username/roles в [CookieStorage].
class AuthService {
  // URL берётся из AppConfig (String.fromEnvironment с дефолтом).

  static const String tokenKey = 'token';
  static const String usernameKey = 'username';
  static const String rolesKey = 'roles';

  final CookieStorage _storage;

  /// Создаёт сервис с переданным хранилищем кук.
  AuthService(this._storage);

  /// Выполняет вход, возвращает [LoginResponse].
  /// При ошибке HTTP или сетевой ошибке выбрасывает исключение.
  Future<LoginResponse> login(String username, String password) async {
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.loginPath}');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final loginResponse = LoginResponse.fromJson(body);
      _saveToStorage(loginResponse);
      return loginResponse;
    } else {
      String message;
      try {
        final body = jsonDecode(response.body);
        message = body['message'] ?? 'Неверный логин или пароль';
      } catch (_) {
        message = 'Ошибка сервера (${response.statusCode})';
      }
      throw AuthException(message);
    }
  }

  /// Возвращает сохранённый токен или null.
  String? getToken() => _storage.get(tokenKey);

  /// Возвращает сохранённое имя пользователя или null.
  String? getUsername() => _storage.get(usernameKey);

  /// Возвращает сохранённые роли или пустой список.
  List<String> getRoles() {
    final raw = _storage.get(rolesKey);
    if (raw == null || raw.isEmpty) return [];
    return raw.split(',').where((r) => r.isNotEmpty).toList();
  }

  /// Проверяет, сохранён ли токен (пользователь авторизован).
  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  /// Удаляет все сохранённые данные (выход).
  void logout() {
    _storage.delete(tokenKey);
    _storage.delete(usernameKey);
    _storage.delete(rolesKey);
  }

  void _saveToStorage(LoginResponse response) {
    _storage.set(tokenKey, response.token);
    _storage.set(usernameKey, response.username);
    _storage.set(rolesKey, response.roles.join(','));
  }
}

/// Исключение при ошибке аутентификации.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}