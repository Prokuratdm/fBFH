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

  /// Путь для работы с пользователями.
  static const String usersPath = '/api/v1/users';

  /// Путь для конкретного пользователя.
  static String userPath(String id) => '/api/v1/users/$id';

  /// Путь для смены пароля пользователя.
  static String userPasswordPath(String id) => '/api/v1/users/$id/password';

  /// Путь для локаций конкретного клуба.
  static String clubLocationsPath(String clubId) =>
      '/api/v1/clubs/$clubId/locations';

  /// Путь для работы с инвентарём.
  static const String inventoryPath = '/api/v1/inventory';

  /// Путь для работы с упражнениями.
  static const String exercisesPath = '/api/v1/exercises';

  /// Путь для получения типов упражнений.
  static const String exerciseTypesPath = '/api/v1/exercises/types';

  /// Путь для картинки упражнения.
  static String exercisePicturePath(String id) => '/api/v1/exercises/$id/picture';

  /// Все возможные роли пользователей.
  static const List<String> allRoles = [
    'ROLE_ADMIN',
    'ROLE_METHODIST',
    'ROLE_COACH',
    'ROLE_MAIN_COACH',
    'ROLE_CLUB',
    'ROLE_CLUB_METHODIST',
  ];

  /// Роли, доступные админу при создании пользователя.
  static const List<String> adminCreatableRoles = [
    'ROLE_ADMIN',
    'ROLE_METHODIST',
    'ROLE_CLUB',
  ];
}
