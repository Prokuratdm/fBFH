import 'auth_service.dart';
import 'cookie_storage.dart';

/// Stub-реализация для тестов (VM/не-веб).
final authService = AuthService(InMemoryCookieStorage());