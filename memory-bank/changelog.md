# Changelog

## [0.1.0] - 2026-06-06

- Страница логина (LoginPage) с валидацией полей
- JWT-аутентификация: POST /api/v1/auth/login
- Сохранение токена, username и roles в куках браузера
- Проверка токена при перезапуске: GET /api/v1/auth/me
- SplashPage с авто-проверкой токена и очисткой при невалидном
- Домашний экран HomePage с приветствием
- Data-driven меню: каждый пункт объявлен один раз с Set<String> ролей
- Сворачиваемое боковое меню (NavigationRail, AnimatedContainer 200/72px)
- i18n: русский (дефолт), английский (запасной) через ARB + flutter_localizations
- Браузерный Password Manager: нативный Flutter (AutofillGroup + autofillHints + finishAutofillContext)
- Переменные окружения: AppConfig.baseUrl через String.fromEnvironment
- 29 unit/widget-тестов (модели, сервисы, виджеты)

### Changed
- Замена dart:html на package:web
- Условные экспорты для web/stub во всех веб-зависимых модулях

### Fixed
- Ошибка 404 при входе: `form.requestSubmit()` в скрытой HTML-форме вызывал навигацию браузера, заменено на нативный `TextInput.finishAutofillContext()`
- Бесконечный спиннер при нажатии «назад» на HomePage: добавлен `PopScope` с `canPop: false` и logout
- Ошибки `dartDevEmbedder` при F5: добавлен `usePathUrlStrategy()` для path-навигации

### Removed
- Три файла password_manager (password_manager.dart, password_manager_web.dart, password_manager_stub.dart)
- Скрытая HTML-форма из web/index.html
- Удалён условный экспорт dart.library.html для password_manager
