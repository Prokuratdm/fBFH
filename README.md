# fBFH — Frontend for bFH

Фронтенд на Flutter для системы управления спортивными клубами, тренировками, детьми и нормативами.

## Быстрый старт (Web)

```bash
# Установка зависимостей
flutter pub get

# Запуск веб-версии (на localhost:8080 бэкенд)
flutter run -d chrome
```

## Стек

- **Flutter** 3.x (Dart)
- **HTTP**: `package:http`
- **Локализация**: `flutter_localizations` (русский по умолчанию)
- **Аутентификация**: JWT, хранится в куках браузера

## Платформы

- Web (основная)
- iOS
- Android

## Бэкенд

REST API на `http://localhost:8080/api/v1`. Требует запущенный бэкенд-сервер.