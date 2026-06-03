// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

import 'auth_service.dart';
import 'cookie_storage.dart';

/// Реализация [CookieStorage] через document.cookie браузера.
class WebCookieStorage implements CookieStorage {
  @override
  void set(String name, String value) {
    html.document.cookie = '$name=$value; path=/; SameSite=Lax';
  }

  @override
  String? get(String name) {
    final cookies = html.document.cookie?.split('; ') ?? [];
    for (final cookie in cookies) {
      final parts = cookie.split('=');
      if (parts.length == 2 && parts[0] == name) {
        return parts[1];
      }
    }
    return null;
  }

  @override
  void delete(String name) {
    html.document.cookie = '$name=; path=/; max-age=0';
  }
}

/// Глобальный экземпляр [AuthService] для веб-приложения.
final authService = AuthService(WebCookieStorage());