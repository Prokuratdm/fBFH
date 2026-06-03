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
}