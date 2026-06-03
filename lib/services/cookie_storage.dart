/// Абстракция над куками браузера.
///
/// Позволяет подменять реализацию для тестов.
abstract class CookieStorage {
  /// Установить куку.
  void set(String name, String value);

  /// Получить значение куки или null.
  String? get(String name);

  /// Удалить куку.
  void delete(String name);
}

/// Реализация [CookieStorage] в памяти — для тестов.
class InMemoryCookieStorage implements CookieStorage {
  final Map<String, String> _cookies = {};

  @override
  void set(String name, String value) {
    _cookies[name] = value;
  }

  @override
  String? get(String name) {
    return _cookies[name];
  }

  @override
  void delete(String name) {
    _cookies.remove(name);
  }
}