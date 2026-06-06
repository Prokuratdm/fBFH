/// Конфигурация приложения.
///
/// Переменные, зависящие от окружения, задаются через --dart-define:
/// ```bash
/// flutter run -d chrome --dart-define=BASE_URL=http://localhost:8080
/// ```
class AppConfig {
  AppConfig._();

  /// Базовый URL бэкенда.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  /// Путь для логина относительно [baseUrl].
  static const String loginPath = '/api/v1/auth/login';

  /// Путь для проверки токена и получения информации о пользователе.
  static const String mePath = '/api/v1/auth/me';

  /// Путь для работы с клубами.
  static const String clubsPath = '/api/v1/clubs';

  /// Путь для логотипа клуба.
  static String clubLogoPath(String id) => '/api/v1/clubs/$id/logo';
}
