// authService экспортируется нужной конфигурацией в зависимости от платформы.
// В вебе — WebCookieStorage (dart:html), в тестах/VM — InMemoryCookieStorage.
export 'auth_service_config_stub.dart'
    if (dart.library.html) 'auth_service_config_web.dart';