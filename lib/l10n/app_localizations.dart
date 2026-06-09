import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'fBFH'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In ru, this message translates to:
  /// **'Вход в систему'**
  String get loginTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Логин'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка входа'**
  String get loginError;

  /// No description provided for @loginNetworkError.
  ///
  /// In ru, this message translates to:
  /// **'Сетевая ошибка. Проверьте подключение.'**
  String get loginNetworkError;

  /// No description provided for @welcome.
  ///
  /// In ru, this message translates to:
  /// **'Привет, {username}!'**
  String welcome(String username);

  /// No description provided for @logoutButton.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get logoutButton;

  /// No description provided for @menuDashboard.
  ///
  /// In ru, this message translates to:
  /// **'Дашборд'**
  String get menuDashboard;

  /// No description provided for @menuClubs.
  ///
  /// In ru, this message translates to:
  /// **'Клубы'**
  String get menuClubs;

  /// No description provided for @menuMyClub.
  ///
  /// In ru, this message translates to:
  /// **'Мой клуб'**
  String get menuMyClub;

  /// No description provided for @menuUsers.
  ///
  /// In ru, this message translates to:
  /// **'Пользователи'**
  String get menuUsers;

  /// No description provided for @menuTeams.
  ///
  /// In ru, this message translates to:
  /// **'Команды'**
  String get menuTeams;

  /// No description provided for @menuMyTeams.
  ///
  /// In ru, this message translates to:
  /// **'Мои команды'**
  String get menuMyTeams;

  /// No description provided for @menuChildren.
  ///
  /// In ru, this message translates to:
  /// **'Дети'**
  String get menuChildren;

  /// No description provided for @menuTrainings.
  ///
  /// In ru, this message translates to:
  /// **'Тренировки'**
  String get menuTrainings;

  /// No description provided for @menuLocations.
  ///
  /// In ru, this message translates to:
  /// **'Локации'**
  String get menuLocations;

  /// No description provided for @menuInventory.
  ///
  /// In ru, this message translates to:
  /// **'Инвентарь'**
  String get menuInventory;

  /// No description provided for @menuExercises.
  ///
  /// In ru, this message translates to:
  /// **'Упражнения'**
  String get menuExercises;

  /// No description provided for @menuStandards.
  ///
  /// In ru, this message translates to:
  /// **'Нормативы'**
  String get menuStandards;

  /// No description provided for @menuTemplates.
  ///
  /// In ru, this message translates to:
  /// **'Шаблоны тренировок'**
  String get menuTemplates;

  /// No description provided for @menuPrograms.
  ///
  /// In ru, this message translates to:
  /// **'Программы'**
  String get menuPrograms;

  /// No description provided for @inDevelopment.
  ///
  /// In ru, this message translates to:
  /// **'В разработке'**
  String get inDevelopment;

  /// No description provided for @fieldRequired.
  ///
  /// In ru, this message translates to:
  /// **'Обязательное поле'**
  String get fieldRequired;

  /// No description provided for @clubsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Клубы'**
  String get clubsTitle;

  /// No description provided for @clubsCreateButton.
  ///
  /// In ru, this message translates to:
  /// **'Создать новый клуб'**
  String get clubsCreateButton;

  /// No description provided for @clubNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get clubNameLabel;

  /// No description provided for @clubAddressLabel.
  ///
  /// In ru, this message translates to:
  /// **'Адрес'**
  String get clubAddressLabel;

  /// No description provided for @clubDescriptionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Описание'**
  String get clubDescriptionLabel;

  /// No description provided for @clubLogoLabel.
  ///
  /// In ru, this message translates to:
  /// **'Логотип'**
  String get clubLogoLabel;

  /// No description provided for @clubCreateDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый клуб'**
  String get clubCreateDialogTitle;

  /// No description provided for @clubLogoErrorSize.
  ///
  /// In ru, this message translates to:
  /// **'Файл логотипа не должен превышать 200 КБ'**
  String get clubLogoErrorSize;

  /// No description provided for @clubLogoErrorDimensions.
  ///
  /// In ru, this message translates to:
  /// **'Логотип должен быть не больше 200×200 пикселей'**
  String get clubLogoErrorDimensions;

  /// No description provided for @clubLogoSelectFile.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать файл'**
  String get clubLogoSelectFile;

  /// No description provided for @clubCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get clubCreate;

  /// No description provided for @clubNoLogo.
  ///
  /// In ru, this message translates to:
  /// **'Без лого'**
  String get clubNoLogo;

  /// No description provided for @clubRetry.
  ///
  /// In ru, this message translates to:
  /// **'Повторить'**
  String get clubRetry;

  /// No description provided for @clubLogoUploadError.
  ///
  /// In ru, this message translates to:
  /// **'Логотип не загружен. Добавьте его при редактировании клуба.'**
  String get clubLogoUploadError;

  /// No description provided for @usersTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пользователи'**
  String get usersTitle;

  /// No description provided for @usersCreateButton.
  ///
  /// In ru, this message translates to:
  /// **'Создать пользователя'**
  String get usersCreateButton;

  /// No description provided for @userCreated.
  ///
  /// In ru, this message translates to:
  /// **'Пользователь создан'**
  String get userCreated;

  /// No description provided for @userDetailTitle.
  ///
  /// In ru, this message translates to:
  /// **'Информация о пользователе'**
  String get userDetailTitle;

  /// No description provided for @userUsernameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Логин'**
  String get userUsernameLabel;

  /// No description provided for @userPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get userPasswordLabel;

  /// No description provided for @userEmailLabel.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get userEmailLabel;

  /// No description provided for @userRolesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Роли'**
  String get userRolesLabel;

  /// No description provided for @userClubLabel.
  ///
  /// In ru, this message translates to:
  /// **'Клуб'**
  String get userClubLabel;

  /// No description provided for @userChangePassword.
  ///
  /// In ru, this message translates to:
  /// **'Сменить пароль'**
  String get userChangePassword;

  /// No description provided for @newPasswordLabel.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get newPasswordLabel;

  /// No description provided for @passwordChanged.
  ///
  /// In ru, this message translates to:
  /// **'Пароль изменён'**
  String get passwordChanged;

  /// No description provided for @roleAdmin.
  ///
  /// In ru, this message translates to:
  /// **'Админ'**
  String get roleAdmin;

  /// No description provided for @roleMethodist.
  ///
  /// In ru, this message translates to:
  /// **'Методист'**
  String get roleMethodist;

  /// No description provided for @roleCoach.
  ///
  /// In ru, this message translates to:
  /// **'Тренер'**
  String get roleCoach;

  /// No description provided for @roleMainCoach.
  ///
  /// In ru, this message translates to:
  /// **'Старший тренер'**
  String get roleMainCoach;

  /// No description provided for @roleClub.
  ///
  /// In ru, this message translates to:
  /// **'Клуб'**
  String get roleClub;

  /// No description provided for @roleClubMethodist.
  ///
  /// In ru, this message translates to:
  /// **'Методист клуба'**
  String get roleClubMethodist;

  /// No description provided for @filterRole.
  ///
  /// In ru, this message translates to:
  /// **'Роль'**
  String get filterRole;

  /// No description provided for @filterClub.
  ///
  /// In ru, this message translates to:
  /// **'Клуб'**
  String get filterClub;

  /// No description provided for @filterUsername.
  ///
  /// In ru, this message translates to:
  /// **'Логин'**
  String get filterUsername;

  /// No description provided for @allRoles.
  ///
  /// In ru, this message translates to:
  /// **'Все роли'**
  String get allRoles;

  /// No description provided for @allClubs.
  ///
  /// In ru, this message translates to:
  /// **'Все клубы'**
  String get allClubs;

  /// No description provided for @noClub.
  ///
  /// In ru, this message translates to:
  /// **'Без клуба'**
  String get noClub;

  /// No description provided for @locationsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Локации'**
  String get locationsTitle;

  /// No description provided for @locationsCreateButton.
  ///
  /// In ru, this message translates to:
  /// **'Создать локацию'**
  String get locationsCreateButton;

  /// No description provided for @locationNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get locationNameLabel;

  /// No description provided for @locationCreateDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая локация'**
  String get locationCreateDialogTitle;

  /// No description provided for @locationCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get locationCreate;

  /// No description provided for @locationCreated.
  ///
  /// In ru, this message translates to:
  /// **'Локация создана'**
  String get locationCreated;

  /// No description provided for @locationsEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Список локаций пуст'**
  String get locationsEmpty;

  /// No description provided for @locationsNoClub.
  ///
  /// In ru, this message translates to:
  /// **'У пользователя не привязан клуб. Локации недоступны.'**
  String get locationsNoClub;

  /// No description provided for @inventoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'Инвентарь'**
  String get inventoryTitle;

  /// No description provided for @inventoryCreateButton.
  ///
  /// In ru, this message translates to:
  /// **'Создать инвентарь'**
  String get inventoryCreateButton;

  /// No description provided for @inventoryNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Название'**
  String get inventoryNameLabel;

  /// No description provided for @inventoryClubLabel.
  ///
  /// In ru, this message translates to:
  /// **'Клуб'**
  String get inventoryClubLabel;

  /// No description provided for @inventoryCreateDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый инвентарь'**
  String get inventoryCreateDialogTitle;

  /// No description provided for @inventoryCreate.
  ///
  /// In ru, this message translates to:
  /// **'Создать'**
  String get inventoryCreate;

  /// No description provided for @inventoryCreated.
  ///
  /// In ru, this message translates to:
  /// **'Инвентарь создан'**
  String get inventoryCreated;

  /// No description provided for @inventoryEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Список инвентаря пуст'**
  String get inventoryEmpty;

  /// No description provided for @inventoryNoClub.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступных клубов для создания инвентаря.'**
  String get inventoryNoClub;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
