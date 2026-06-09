# Tech Context: fBFH

## Технологии
| Категория | Выбор | Версия |
|-----------|-------|--------|
| Framework | Flutter | 3.x (Dart SDK ^3.12.1) |
| HTTP-клиент | `package:http` | ^1.2.0 |
| HTTP parser | `package:http_parser` | (для MediaType) |
| Локализация | `flutter_localizations` + ARB | SDK |
| Форматирование | `intl` | ^0.20.2 |
| Web API | `package:web` | ^1.1.0 |
| URL Strategy | `package:flutter_web_plugins` | SDK |
| File picker | `package:file_picker` | ^11.0.2 |
| Image | `package:image` | ^4.8.0 (декодирование для проверки размеров) |
| Стейт-менеджмент | `setState` + `GlobalKey` (пока без Riverpod) | — |
| Роутинг | `Navigator` + `onGenerateRoute` (пока без go_router) | — |
| Тестирование | `flutter_test` | SDK |
| Платформы | Web, iOS, Android | — |

## Development Setup
```bash
# Запуск веб-версии
flutter run -d chrome --web-browser-no-incognito

# С другим бэкендом
flutter run -d chrome --dart-define=BASE_URL=http://prod:8080

# Генерация локализации (использует l10n.yaml)
flutter gen-l10n

# Тесты
flutter test
```

## Переменные окружения (--dart-define)
| Переменная | По умолчанию | Назначение |
|------------|-------------|------------|
| BASE_URL | http://localhost:8080 | Базовый URL бэкенда |

## API Endpoints (после Итерации 2)
| Метод | Путь | Назначение |
|-------|------|------------|
| POST | /api/v1/auth/login | Логин (username, password) → JWT |
| GET  | /api/v1/auth/me | Проверка токена → UserInfo |
| GET  | /api/v1/clubs?page=&size= | Список клубов с пагинацией |
| POST | /api/v1/clubs | Создание клуба (name, address, description) |
| POST | /api/v1/clubs/{id}/logo | Загрузка логотипа (multipart, image/*) |
| GET  | /api/v1/clubs/{id}/logo | Скачивание логотипа (требует Authorization) |
| GET  | /api/v1/users?page=&size=&role=&clubId=&username= | Список пользователей |
| POST | /api/v1/users | Создание пользователя (admin) |
| GET  | /api/v1/users/{id} | Детали пользователя |
| PUT  | /api/v1/users/{id}/password | Смена пароля (admin) |

## Зависимости
```yaml
dependencies:
  flutter: { sdk: flutter }
  flutter_localizations: { sdk: flutter }
  flutter_web_plugins: { sdk: flutter }
  cupertino_icons: ^1.0.8
  http: ^1.2.0
  intl: ^0.20.2
  web: ^1.1.0
  file_picker: ^11.0.2
  image: ^4.8.0

dev_dependencies:
  flutter_test: { sdk: flutter }
  flutter_lints: ^6.0.0
```

## Тестовое покрытие
36 unit/widget-тестов:
- `test/models/`: club_response, login_response, page_response, user_info
- `test/services/`: auth_service, club_service
- `test/l10n/`: menu_items
- `test/widget_test.dart`: LoginPage, HomePage