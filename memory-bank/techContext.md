# Tech Context: fBFH

## Технологии
| Категория | Выбор | Версия |
|-----------|-------|--------|
| Framework | Flutter | 3.x (Dart SDK ^3.12.1) |
| HTTP-клиент | `package:http` | ^1.2.0 |
| Локализация | `flutter_localizations` + ARB | SDK |
| Форматирование | `intl` | ^0.20.2 |
| Web API | `package:web` | ^1.1.0 |
| Стейт-менеджмент | `setState` + `ChangeNotifier` (пока без Riverpod) | — |
| Роутинг | `Navigator` + `onGenerateRoute` (пока без go_router) | — |
| Тестирование | `flutter_test` + `package:testing` | SDK |
| Платформы | Web, iOS, Android | — |

## Development Setup
```bash
# Запуск веб-версии
flutter run -d chrome --web-browser-no-incognito

# С другим бэкендом
flutter run -d chrome --dart-define=BASE_URL=http://prod:8080

# Генерация локализации
flutter gen-l10n

# Тесты
flutter test
```

## Переменные окружения (--dart-define)
| Переменная | По умолчанию | Назначение |
|------------|-------------|------------|
| BASE_URL | http://localhost:8080 | Базовый URL бэкенда |

## API Endpoints
| Метод | Путь | Назначение |
|-------|------|------------|
| POST | /api/v1/auth/login | Логин (username, password) → JWT |
| GET | /api/v1/auth/me | Проверка токена → UserInfo |

## Зависимости
```
flutter, flutter_localizations  (SDK)
cupertino_icons: ^1.0.8
http: ^1.2.0
intl: ^0.20.2
web: ^1.1.0