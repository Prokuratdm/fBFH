# System Patterns: fBFH

## Архитектура

```
lib/
├── main.dart                          # MaterialApp, onGenerateRoute, usePathUrlStrategy
├── core/
│   └── config/app_config.dart         # BASE_URL, API-пути, allRoles, adminCreatableRoles
├── l10n/                              # ARB-файлы + генерация локализации
│   ├── app_ru.arb                     # Русский (дефолт, 50+ строк)
│   ├── app_en.arb                     # Английский
│   └── menu_items.dart                # Data-driven реестр пунктов меню
├── models/
│   ├── login_response.dart            # POST /auth/login ответ
│   ├── user_info.dart                 # GET /auth/me ответ
│   ├── user_response.dart             # GET /users/{id} ответ (UserResponse)
│   ├── club_response.dart             # GET /clubs/{id} ответ
│   └── page_response.dart             # Дженерик Spring Page<T> обёртка
├── pages/
│   ├── splash_page.dart               # Старт: проверка токена → /home или /login
│   ├── login_page.dart                # Форма логина/пароля (AutofillGroup)
│   ├── home_page.dart                 # SHELL: меню + IndexedStack
│   ├── clubs_page.dart                # Клубы: создание, список, логотипы
│   └── users_page.dart                # Пользователи: создание, фильтры, смена пароля
├── services/
│   ├── auth_service.dart              # login(), me(), куки, logout
│   ├── club_service.dart              # createClub, uploadLogo (MIME), getClubs
│   ├── user_service.dart              # getUsers, createUser, getUser, changePassword
│   ├── cookie_storage.dart            # Абстракция + InMemory-реализация
│   ├── auth_service_config.dart       # Условный export (web/stub)
│   ├── auth_service_config_web.dart   # WebCookieStorage через package:web
│   └── auth_service_config_stub.dart  # Stub для тестов (InMemory)
```

## Ключевые паттерны

### 1. HomePage как shell с IndexedStack
```
HomePage
├── AppBar (logout, welcome)
└── Body (Row)
    ├── AnimatedContainer (NavigationRail — меню 200/72px)
    ├── VerticalDivider
    └── IndexedStack (index: _selectedIndex)
        ├── ClubsPage (для menuClubs/menuMyClub)
        ├── UsersPage (для menuUsers)
        └── Placeholder «В разработке» (для остальных)
```

**Преимущества**:
- Меню всегда видно при навигации между разделами
- Кнопка «назад» браузера не теряет состояние
- Нет вложенных `Navigator.push`

### 2. Refresh через GlobalKey
Каждая страница в IndexedStack имеет публичный `State`:
```dart
class ClubsPageState extends State<ClubsPage> {
  void refresh() { _clubs.clear(); _loadClubs(); }
}
```
HomePage владеет `GlobalKey<ClubsPageState>` и вызывает `_clubsKey.currentState?.refresh()` в `onDestinationSelected`.

### 3. Условные экспорты (dart.library.html)
```dart
export 'stub.dart' if (dart.library.html) 'web.dart';
```
Только для `auth_service_config.dart`. Остальные модули не имеют web-зависимостей.

### 4. Data-driven меню
`MenuItems.forRoles(roles, l10n)` — каждый пункт один раз с `Set<String>` ролей. Пункты объединяются по всем ролям пользователя с дедупликацией по label.

### 5. Auth flow
```
SplashPage → [нет токена] → LoginPage
          → [есть токен] → GET /me → [200] → HomePage(UserInfo)
                                    → [403] → очистить куки → LoginPage
LoginPage → POST /login → GET /me → HomePage(UserInfo)
HomePage → logout → очистить куки → LoginPage
```

### 6. Password Manager (нативный)
`AutofillGroup` обёртка + `autofillHints: [AutofillHints.username]` / `[AutofillHints.password]`. После успешного логина `TextInput.finishAutofillContext()`.

### 7. DI через опциональный параметр виджетов
`AuthService` передаётся через `widget.authService ?? authService` (глобальный из `auth_service_config.dart`). Тесты подменяют на `AuthService(InMemoryCookieStorage())`.

### 8. Авторизованные HTTP-запросы
```dart
Map<String, String> get _headers => {
  'Accept': '*/*',
  if (_token != null) 'Authorization': 'Bearer $_token',
};
```

### 9. Multipart с явным contentType
```dart
http.MultipartFile.fromBytes('file', bytes,
  filename: filename,
  contentType: _mediaType(filename),  // image/png, image/jpeg и т.д.
);
```
Без `contentType` бэкенд Spring получает `application/octet-stream` и отвергает.

### 10. Image.network с авторизацией
```dart
Image.network(
  logoUrl,
  headers: token != null ? {'Authorization': 'Bearer $token'} : null,
  errorBuilder: (_, __, ___) => const Icon(Icons.business),
);
```
Без `headers` картинка не загрузится (401).

### 11. PageResponse<T> для Spring Page
Дженерик-обёртка для пагинированного ответа. `fromJson(json, T Function(Map) fromItem)` парсит и массив, и метаданные пагинации.

### 12. usePathUrlStrategy()
`usePathUrlStrategy()` в `main()` — без DevTools-ошибок `dartDevEmbedder` при F5.

### 13. clubId из UserInfo для вложенных ресурсов
Страницы, привязанные к клубу текущего пользователя (например, LocationsPage), берут `clubId` из `UserInfo.clubId` (ответ `/api/v1/auth/me`). Не нужен дополнительный запрос для получения клуба.

```dart
class LocationsPage extends StatefulWidget {
  final String? clubId;
  const LocationsPage({super.key, required this.clubId, this.authService});
}
```

В HomePage: `LocationsPage(key: _locationsKey, clubId: widget.user.clubId)`. Если `clubId == null` — показывается заглушка `locationsNoClub`.

## API endpoints (после Итерации 4)

| Метод | Путь | Назначение |
|-------|------|------------|
| POST | /api/v1/auth/login | Логин → JWT |
| GET  | /api/v1/auth/me | Проверка токена |
| GET  | /api/v1/clubs?page=&size= | Список клубов |
| POST | /api/v1/clubs | Создание клуба |
| POST | /api/v1/clubs/{id}/logo | Загрузка лого (multipart) |
| GET  | /api/v1/clubs/{id}/logo | Скачивание лого |
| GET  | /api/v1/users?page=&size=&role=&clubId=&username= | Список пользователей |
| POST | /api/v1/users | Создание пользователя |
| GET  | /api/v1/users/{id} | Детали пользователя |
| PUT  | /api/v1/users/{id}/password | Смена пароля |
| GET  | /api/v1/clubs/{clubId}/locations | Список локаций клуба |
| POST | /api/v1/clubs/{clubId}/locations | Создание локации |
| GET  | /api/v1/inventory?page=&size= | Список инвентаря (Spring Page) |
| POST | /api/v1/inventory | Создание инвентаря (body: {name, clubId}) |
