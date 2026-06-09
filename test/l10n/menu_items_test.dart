import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/l10n/menu_items.dart';
import 'package:fbfh/l10n/app_localizations.dart';

void main() {
  group('MenuItems.forRoles', () {
    test('объединяет пункты из нескольких ролей с дедупликацией', () {
      final roles = ['ROLE_ADMIN', 'ROLE_CLUB'];

      // Используем заглушку локализации
      final items = MenuItems.forRoles(roles, StubLocalizations());

      final labels = items.map((m) => m.label).toList();

      // Должны быть пункты из обеих ролей
      expect(labels, contains('Дашборд'));
      expect(labels, contains('Клубы'));
      expect(labels, contains('Мой клуб'));
      expect(labels, contains('Пользователи'));
      expect(labels, contains('Команды'));
      expect(labels, contains('Мои команды'));
      expect(labels, contains('Дети'));
      expect(labels, contains('Тренировки'));
      expect(labels, contains('Локации'));
      expect(labels, contains('Инвентарь'));
      expect(labels, contains('Упражнения'));
      expect(labels, contains('Нормативы'));
      expect(labels, contains('Шаблоны тренировок'));
      expect(labels, contains('Программы'));

      // 14 уникальных пунктов
      expect(items.length, 14);
    });

    test('ROLE_COACH возвращает правильные пункты', () {
      final items = MenuItems.forRoles(['ROLE_COACH'], StubLocalizations());
      final labels = items.map((m) => m.label).toList();

      expect(labels, contains('Мои команды'));
      expect(labels, contains('Дети'));
      expect(labels, contains('Тренировки'));
      expect(labels, contains('Локации'));
      expect(labels, contains('Инвентарь'));
      expect(labels, contains('Упражнения'));
      expect(labels, contains('Нормативы'));
      expect(items.length, 7);
    });

    test('ROLE_ADMIN возвращает правильные пункты', () {
      final items = MenuItems.forRoles(['ROLE_ADMIN'], StubLocalizations());
      final labels = items.map((m) => m.label).toList();

      expect(labels, contains('Дашборд'));
      expect(labels, contains('Клубы'));
      expect(labels, contains('Пользователи'));
      expect(labels, contains('Команды'));
      expect(labels, contains('Инвентарь'));
      expect(labels, contains('Упражнения'));
      expect(labels, contains('Нормативы'));
      expect(labels, contains('Шаблоны тренировок'));
      expect(labels, contains('Программы'));
      expect(items.length, 9);
    });

    test('пустые роли возвращают пустой список', () {
      final items = MenuItems.forRoles([], StubLocalizations());
      expect(items, isEmpty);
    });

    test('неизвестная роль возвращает пустой список', () {
      final items = MenuItems.forRoles(['ROLE_UNKNOWN'], StubLocalizations());
      expect(items, isEmpty);
    });
  });
}

/// Заглушка AppLocalizations для тестирования MenuItems.
/// Возвращает ключи как есть — они совпадают с label из menu_items.dart.
class StubLocalizations implements AppLocalizations {
  @override
  String get localeName => 'ru';

  @override
  String get appTitle => 'appTitle';
  @override
  String get loginTitle => 'loginTitle';
  @override
  String get usernameLabel => 'usernameLabel';
  @override
  String get passwordLabel => 'passwordLabel';
  @override
  String get loginButton => 'loginButton';
  @override
  String get loginError => 'loginError';
  @override
  String get loginNetworkError => 'loginNetworkError';
  @override
  String welcome(String username) => 'welcome $username';
  @override
  String get logoutButton => 'logoutButton';
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

  @override
  String get clubsTitle => 'Клубы';
  @override
  String get clubsCreateButton => 'clubsCreateButton';
  @override
  String get clubNameLabel => 'clubNameLabel';
  @override
  String get clubAddressLabel => 'clubAddressLabel';
  @override
  String get clubDescriptionLabel => 'clubDescriptionLabel';
  @override
  String get clubLogoLabel => 'clubLogoLabel';
  @override
  String get clubCreateDialogTitle => 'clubCreateDialogTitle';
  @override
  String get clubLogoErrorSize => 'clubLogoErrorSize';
  @override
  String get clubLogoErrorDimensions => 'clubLogoErrorDimensions';
  @override
  String get clubLogoSelectFile => 'clubLogoSelectFile';
  @override
  String get clubCreate => 'clubCreate';
  @override
  String get clubNoLogo => 'clubNoLogo';
  @override
  String get clubRetry => 'clubRetry';
  @override
  String get clubLogoUploadError => 'clubLogoUploadError';

  @override
  String get usersTitle => 'usersTitle';
  @override
  String get usersCreateButton => 'usersCreateButton';
  @override
  String get userCreated => 'userCreated';
  @override
  String get userDetailTitle => 'userDetailTitle';
  @override
  String get userUsernameLabel => 'userUsernameLabel';
  @override
  String get userPasswordLabel => 'userPasswordLabel';
  @override
  String get userEmailLabel => 'userEmailLabel';
  @override
  String get userRolesLabel => 'userRolesLabel';
  @override
  String get userClubLabel => 'userClubLabel';
  @override
  String get userChangePassword => 'userChangePassword';
  @override
  String get newPasswordLabel => 'newPasswordLabel';
  @override
  String get passwordChanged => 'passwordChanged';
  @override
  String get roleAdmin => 'roleAdmin';
  @override
  String get roleMethodist => 'roleMethodist';
  @override
  String get roleCoach => 'roleCoach';
  @override
  String get roleMainCoach => 'roleMainCoach';
  @override
  String get roleClub => 'roleClub';
  @override
  String get roleClubMethodist => 'roleClubMethodist';
  @override
  String get filterRole => 'filterRole';
  @override
  String get filterClub => 'filterClub';
  @override
  String get filterUsername => 'filterUsername';
  @override
  String get allRoles => 'allRoles';
  @override
  String get allClubs => 'allClubs';
  @override
  String get noClub => 'noClub';

  @override
  String get locationsTitle => 'Локации';
  @override
  String get locationsCreateButton => 'locationsCreateButton';
  @override
  String get locationNameLabel => 'locationNameLabel';
  @override
  String get locationCreateDialogTitle => 'locationCreateDialogTitle';
  @override
  String get locationCreate => 'locationCreate';
  @override
  String get locationCreated => 'locationCreated';
  @override
  String get locationsEmpty => 'locationsEmpty';
  @override
  String get locationsNoClub => 'locationsNoClub';

  @override
  String get inventoryTitle => 'Инвентарь';
  @override
  String get inventoryCreateButton => 'inventoryCreateButton';
  @override
  String get inventoryNameLabel => 'inventoryNameLabel';
  @override
  String get inventoryClubLabel => 'inventoryClubLabel';
  @override
  String get inventoryCreateDialogTitle => 'inventoryCreateDialogTitle';
  @override
  String get inventoryCreate => 'inventoryCreate';
  @override
  String get inventoryCreated => 'inventoryCreated';
  @override
  String get inventoryEmpty => 'inventoryEmpty';
  @override
  String get inventoryNoClub => 'inventoryNoClub';
}
