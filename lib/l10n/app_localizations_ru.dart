// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'fBFH';

  @override
  String get loginTitle => 'Вход в систему';

  @override
  String get usernameLabel => 'Логин';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginError => 'Ошибка входа';

  @override
  String get loginNetworkError => 'Сетевая ошибка. Проверьте подключение.';

  @override
  String welcome(String username) {
    return 'Привет, $username!';
  }

  @override
  String get logoutButton => 'Выйти';

  @override
  String get menuDashboard => 'Дашборд';

  @override
  String get menuClubs => 'Клубы';

  @override
  String get menuMyClub => 'Мой клуб';

  @override
  String get menuUsers => 'Пользователи';

  @override
  String get menuTeams => 'Команды';

  @override
  String get menuMyTeams => 'Мои команды';

  @override
  String get menuChildren => 'Дети';

  @override
  String get menuTrainings => 'Тренировки';

  @override
  String get menuLocations => 'Локации';

  @override
  String get menuInventory => 'Инвентарь';

  @override
  String get menuExercises => 'Упражнения';

  @override
  String get menuStandards => 'Нормативы';

  @override
  String get menuTemplates => 'Шаблоны тренировок';

  @override
  String get menuPrograms => 'Программы';

  @override
  String get inDevelopment => 'В разработке';

  @override
  String get fieldRequired => 'Обязательное поле';
}
