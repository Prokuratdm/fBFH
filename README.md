# fBFH — Frontend for JBFH

Фронтенд на Flutter Web для системы управления хоккейными клубами, тренировками, детьми и нормативами.

## Быстрый старт

```bash
# Установка зависимостей
flutter pub get

# Генерация локализации
flutter gen-l10n

# Запуск (без инкогнито)
flutter run -d chrome --web-browser-no-incognito

# Запуск с другим бэкендом
flutter run -d chrome --dart-define=BASE_URL=http://prod:8080

# Тесты
flutter test
```

## Стек

| Технология | Назначение |
|-----------|------------|
| Flutter 3.x (Dart ^3.12) | Framework |
| `package:http` | HTTP-клиент |
| `package:web` | Browser API |
| `flutter_localizations` + ARB | i18n (русский по умолчанию) |
| `flutter_test` | Unit/widget тесты |

## Статус: Итерация 1 завершена (29 тестов пройдены)

- ✅ Страница логина (JWT + куки)
- ✅ Проверка токена при перезапуске (GET /me)
- ✅ Домашний экран с приветствием
- ✅ Data-driven меню по ролям (6 ролей), сворачиваемое
- ✅ i18n: ru (default) + en
- ✅ Браузерный Password Manager
- ✅ Переменные окружения (--dart-define)

## API бэкенда

| Метод | Путь | Назначение |
|-------|------|------------|
| POST | `/api/v1/auth/login` | Логин → JWT |
| GET | `/api/v1/auth/me` | Проверка токена → UserInfo |

## Структура проекта

```
lib/
├── main.dart                      # MaterialApp, роутинг
├── core/
│   ├── config/app_config.dart     # Переменные окружения
│   └── web/
│       └── password_manager.dart  # Browser Password Manager
├── l10n/                          # ARB-файлы + menu_items
├── models/                        # LoginResponse, UserInfo
├── pages/                         # SplashPage, LoginPage, HomePage
└── services/                      # AuthService, CookieStorage