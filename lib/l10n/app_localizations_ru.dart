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

  @override
  String get clubsTitle => 'Клубы';

  @override
  String get clubsCreateButton => 'Создать новый клуб';

  @override
  String get clubNameLabel => 'Название';

  @override
  String get clubAddressLabel => 'Адрес';

  @override
  String get clubDescriptionLabel => 'Описание';

  @override
  String get clubLogoLabel => 'Логотип';

  @override
  String get clubCreateDialogTitle => 'Новый клуб';

  @override
  String get clubLogoErrorSize => 'Файл логотипа не должен превышать 200 КБ';

  @override
  String get clubLogoErrorDimensions =>
      'Логотип должен быть не больше 200×200 пикселей';

  @override
  String get clubLogoSelectFile => 'Выбрать файл';

  @override
  String get clubCreate => 'Создать';

  @override
  String get clubNoLogo => 'Без лого';

  @override
  String get clubRetry => 'Повторить';

  @override
  String get clubLogoUploadError =>
      'Логотип не загружен. Добавьте его при редактировании клуба.';

  @override
  String get usersTitle => 'Пользователи';

  @override
  String get usersCreateButton => 'Создать пользователя';

  @override
  String get userCreated => 'Пользователь создан';

  @override
  String get userDetailTitle => 'Информация о пользователе';

  @override
  String get userUsernameLabel => 'Логин';

  @override
  String get userPasswordLabel => 'Пароль';

  @override
  String get userEmailLabel => 'Email';

  @override
  String get userRolesLabel => 'Роли';

  @override
  String get userClubLabel => 'Клуб';

  @override
  String get userChangePassword => 'Сменить пароль';

  @override
  String get newPasswordLabel => 'Новый пароль';

  @override
  String get passwordChanged => 'Пароль изменён';

  @override
  String get roleAdmin => 'Админ';

  @override
  String get roleMethodist => 'Методист';

  @override
  String get roleCoach => 'Тренер';

  @override
  String get roleMainCoach => 'Старший тренер';

  @override
  String get roleClub => 'Клуб';

  @override
  String get roleClubMethodist => 'Методист клуба';

  @override
  String get filterRole => 'Роль';

  @override
  String get filterClub => 'Клуб';

  @override
  String get filterUsername => 'Логин';

  @override
  String get allRoles => 'Все роли';

  @override
  String get allClubs => 'Все клубы';

  @override
  String get noClub => 'Без клуба';

  @override
  String get locationsTitle => 'Локации';

  @override
  String get locationsCreateButton => 'Создать локацию';

  @override
  String get locationNameLabel => 'Название';

  @override
  String get locationCreateDialogTitle => 'Новая локация';

  @override
  String get locationCreate => 'Создать';

  @override
  String get locationCreated => 'Локация создана';

  @override
  String get locationsEmpty => 'Список локаций пуст';

  @override
  String get locationsNoClub =>
      'У пользователя не привязан клуб. Локации недоступны.';

  @override
  String get inventoryTitle => 'Инвентарь';

  @override
  String get inventoryCreateButton => 'Создать инвентарь';

  @override
  String get inventoryNameLabel => 'Название';

  @override
  String get inventoryClubLabel => 'Клуб';

  @override
  String get inventoryCreateDialogTitle => 'Новый инвентарь';

  @override
  String get inventoryCreate => 'Создать';

  @override
  String get inventoryCreated => 'Инвентарь создан';

  @override
  String get inventoryEmpty => 'Список инвентаря пуст';

  @override
  String get inventoryNoClub => 'Нет доступных клубов для создания инвентаря.';

  @override
  String get exercisesTitle => 'Упражнения';

  @override
  String get exercisesCreateButton => 'Создать упражнение';

  @override
  String get exercisesEmpty => 'Список упражнений пуст';

  @override
  String get exerciseNameLabel => 'Название';

  @override
  String get exerciseDescriptionLabel => 'Описание';

  @override
  String get exerciseTypeLabel => 'Тип';

  @override
  String get exerciseTypeAll => 'Все типы';

  @override
  String get exerciseTypeIce => 'Лёд';

  @override
  String get exerciseTypeLand => 'Земля';

  @override
  String get exerciseUrlLabel => 'Ссылка на видео (YouTube)';

  @override
  String get exerciseContentLabel => 'Содержание';

  @override
  String get exerciseInventoryLabel => 'Инвентарь';

  @override
  String get exerciseCreateDialogTitle => 'Новое упражнение';

  @override
  String get exerciseEditDialogTitle => 'Редактирование упражнения';

  @override
  String get exerciseCreate => 'Создать';

  @override
  String get exerciseSave => 'Сохранить';

  @override
  String get exerciseCreated => 'Упражнение создано';

  @override
  String get exerciseUpdated => 'Упражнение обновлено';

  @override
  String get exerciseEditButton => 'Редактировать';

  @override
  String get exerciseUploadPicture => 'Загрузить картинку';

  @override
  String get exerciseReplacePicture => 'Заменить картинку';

  @override
  String get exercisePictureEmpty => 'Картинка не загружена';

  @override
  String get exercisePictureUploaded => 'Картинка загружена';

  @override
  String get exerciseDetailSelect => 'Выберите упражнение из списка';
}
