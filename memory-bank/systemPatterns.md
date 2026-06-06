# System Patterns: fBFH

## Архитектура
```
lib/
├── main.dart                          # MaterialApp, onGenerateRoute
├── core/
│   └── config/app_config.dart         # Переменные окружения (BASE_URL, пути API)
├── l10n/                              # ARB-файлы + генерация локализации
│   ├── app_ru.arb                     # Русский (дефолт)
│   ├── app_en.arb                     # Английский
│   └── menu_items.dart                # Data-driven реестр пунктов меню
├── models/
│   ├── login_response.dart            # Ответ POST /auth/login
│   └── user_info.dart                 # Ответ GET /auth/me
├── pages/
│   ├── splash_page.dart               # Старт: проверка токена → /home или /login
│   ├── login_page.dart                # Форма логина/пароля
│   └── home_page.dart                 # Приветствие + NavigationRail-меню
├── services/
│   ├── auth_service.dart              # HTTP-клиент: login(), me(), куки
│   ├── cookie_storage.dart            # Абстракция + InMemory-реализация
│   ├── auth_service_config.dart       # Условный export (web/stub)
│   ├── auth_service_config_web.dart   # WebCookieStorage через package:web
│   └── auth_service_config_stub.dart  # Stub для тестов (InMemory)
```

## Ключевые паттерны

### 1. Условные экспорты (dart.library.html)
Все файлы с `dart:html`/`package:web` изолированы в отдельных файлах. Подключаются через:
```dart
export 'stub.dart' if (dart.library.html) 'web.dart';
```
- `auth_service_config.dart` → authService (WebCookieStorage / InMemory)

### 2. Data-driven меню
Каждый пункт меню объявлен один раз с `Set<String>` ролей. Пункты собираются как объединение доступных для всех ролей пользователя с дедупликацией по label.

### 3. Auth flow
```
SplashPage → [нет токена] → LoginPage
          → [есть токен] → GET /me → [200] → HomePage(UserInfo)
                                    → [403] → очистить куки → LoginPage
LoginPage → POST /login → GET /me → HomePage(UserInfo)
HomePage → logout → очистить куки → LoginPage
```

### 4. Password Manager (нативный)
Форма логина обёрнута в `AutofillGroup`. Поля имеют `autofillHints: [AutofillHints.username]` и `[AutofillHints.password]`. После успешного логина вызывается `TextInput.finishAutofillContext()` — браузер предлагает сохранить пароль без скрытых HTML-форм.

### 5. DI через параметры виджетов
`AuthService` передаётся через опциональный параметр `LoginPage(authService:)`. Если не передан — берётся глобальный `authService` из `auth_service_config.dart`. Это позволяет тестам подменять на `AuthService(InMemoryCookieStorage())`.