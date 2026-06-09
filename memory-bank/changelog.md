# Changelog

## [0.4.3] - 2026-06-09

### Fixed
- **InventoryPage** — убран фильтр `_filterOutUnassigned`: записи с `clubId == null` (например, "Человек паук") теперь корректно отображаются в листинге у админа и клубных работников. Подпись клуба (`subtitle`) показывается только когда `clubName != null` (т.е. у админа, если бэкенд прислал название клуба; у клубного работника подпись скрыта в любом случае).

## [0.4.2] - 2026-06-09

### Changed
- **InventoryResponse.clubId** сделан опциональным (`String?`) — бэкенд может прислать `null` или не прислать поле
- **InventoryService.createInventory** — `clubId` теперь `String?`; если `null`, поле `clubId` НЕ отправляется в теле запроса
- **InventoryPage** — в листинге фильтруются записи с пустым/null `clubId` (не отображаются)
- **InventoryPage** — убран snackbar `inventoryNoClubSelected`, диалог создания открывается всегда (просто с `clubId=null`)
- Удалён ключ `inventoryNoClubSelected` из `app_ru.arb`/`app_en.arb` и `StubLocalizations`
- **InventoryRequest** — `clubId` теперь `String?` (опциональный)

## [0.4.1] - 2026-06-09

### Changed
- **InventoryPage** — упрощена форма создания: убран дропбокс клубов, `clubId` подставляется автоматически из `UserInfo.clubId` (клубные роли) или показывается snackbar `inventoryNoClubSelected` (если у пользователя нет привязки)
- **InventoryPage** — в листинге `clubName` показывается только если у пользователя `defaultClubId == null` (т.е. для админа/методиста); клубным работникам название клуба не нужно
- Удалена подгрузка `ClubService.getClubs()` из InventoryPage
- Удалены неиспользуемые импорты `ClubService`, `ClubResponse` из InventoryPage
- Новый ключ локализации: `inventoryNoClubSelected` (ru + en)

## [0.4.0] - 2026-06-09

### Added
- **InventoryPage**: страница инвентаря
  - Создание: POST /api/v1/inventory (body: {name, clubId})
  - Список с пагинацией (size=100 по умолчанию): GET /api/v1/inventory?page=&size=
  - В диалоге создания дропбокс клубов (подгружается через ClubService); preselect = user.clubId
  - Список отображает name + clubName (если есть)
- **InventoryResponse** и **InventoryRequest** модели
- **InventoryService** (getInventory с пагинацией, createInventory) + InventoryException
- **AppConfig.inventoryPath** = `/api/v1/inventory`
- 9 новых ключей локализации (ru + en): inventoryTitle, inventoryCreateButton, inventoryNameLabel, inventoryClubLabel, inventoryCreateDialogTitle, inventoryCreate, inventoryCreated, inventoryEmpty, inventoryNoClub
- 8 новых unit-тестов (всего 54): inventory_response, inventory_service, StubLocalizations обновлён

### Changed
- **HomePage** интегрирует InventoryPage в IndexedStack через GlobalKey<InventoryPageState>
- menuInventory (для ролей ADMIN, CLUB, CLUB_METHODIST, COACH, MAIN_COACH) теперь показывает InventoryPage

## [0.3.1] - 2026-06-09

### Fixed
- **LocationResponse.updatedAt** сделан опциональным (`String?`) — бэкенд может прислать `null` или не прислать поле в ответах на GET и POST /api/v1/clubs/{clubId}/locations

## [0.3.0] - 2026-06-09

### Added
- **LocationsPage**: страница локаций клуба
  - Создание локации: POST /api/v1/clubs/{clubId}/locations
  - Список локаций (только имя): GET /api/v1/clubs/{clubId}/locations
  - clubId берётся из UserInfo (из /api/v1/auth/me)
  - Заглушка "locationsNoClub" если у пользователя нет clubId
- **LocationResponse** и **LocationRequest** модели
- **LocationService** (getLocations, createLocation) с LocationException
- **AppConfig.clubLocationsPath(clubId)** — путь `/api/v1/clubs/{clubId}/locations`
- 8 новых ключей локализации (ru + en): locationsTitle, locationsCreateButton, locationNameLabel, locationCreateDialogTitle, locationCreate, locationCreated, locationsEmpty, locationsNoClub
- 7 новых unit-тестов (всего 43): location_response, location_service

### Changed
- **HomePage** интегрирует LocationsPage в IndexedStack через GlobalKey<LocationsPageState>
- menuLocations (для ролей CLUB, COACH, MAIN_COACH) теперь показывает LocationsPage вместо placeholder

## [0.2.0] - 2026-06-09

### Added
- **UsersPage**: страница пользователей с CRUD для админа
  - Создание пользователя: POST /api/v1/users (дропбокс ролей — Admin/Methodist/Club; для Club — дропбокс клубов)
  - Список с пагинацией: GET /api/v1/users?page=&size=
  - Фильтры: роль (все 6 ролей), клуб, логин (поиск)
  - Диалог деталей пользователя: GET /api/v1/users/{id}
  - Смена пароля: PUT /api/v1/users/{id}/password (admin)
- **UserResponse** модель
- **UserService** (getUsers с фильтрами, createUser, getUser, changePassword)
- **MIME-типы для логотипов**: `http_parser.MediaType` (image/png, image/jpeg, image/webp, image/svg+xml, image/gif)
- Авторизованный `Image.network` с headers — логотипы клубов отображаются в листинге
- `refresh()` через `GlobalKey` в ClubsPage и UsersPage — обновление списка при переходе в меню
- `usePathUrlStrategy()` (flutter_web_plugins) — без DevTools-ошибок при F5
- Зависимости: file_picker 11.0.2, image 4.8.0, flutter_web_plugins
- 36 unit/widget-тестов (все passing)

### Changed
- **HomePage** теперь shell с `IndexedStack` — меню всегда видно при навигации между разделами
- Все внутренние страницы встраиваются в HomePage, а не открываются через `Navigator.pushNamed`
- `ClubsPage` — без собственного `Scaffold`, кнопка «Создать клуб» сверху над списком
- `menuUsers` теперь показывает `UsersPage` вместо placeholder «В разработке»
- Логотипы клубов отображаются в листинге (Image.network с токеном)

### Fixed
- Ошибка 404 при входе: `form.requestSubmit()` в скрытой HTML-форме вызывал навигацию браузера, заменено на нативный `TextInput.finishAutofillContext()`
- Бесконечный спиннер при нажатии «назад» на HomePage: `PopScope` с `canPop: false` (ничего не делает)
- Ошибки `dartDevEmbedder` при F5: `usePathUrlStrategy()` для path-навигации
- Бэкенд отвергал PNG с `application/octet-stream`: добавлен правильный `MediaType` для multipart
- Ошибка загрузки лого отменяла создание клуба: `uploadLogo` обёрнут в try-catch, клуб остаётся созданным
- Логотипы не отображались в листинге: `Image.network` теперь получает `Authorization: Bearer <token>`
- `FilePicker.platform.pickFiles` — старый API, заменён на `FilePicker.pickFiles` (v11.x)

## [0.1.0] - 2026-06-06

### Added
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

### Removed
- Три файла password_manager (password_manager.dart, password_manager_web.dart, password_manager_stub.dart)
- Скрытая HTML-форма из web/index.html
- Удалён условный экспорт dart.library.html для password_manager