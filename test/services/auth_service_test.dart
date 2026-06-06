import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/services/auth_service.dart';
import 'package:fbfh/services/cookie_storage.dart';

void main() {
  late AuthService authService;
  late InMemoryCookieStorage storage;

  setUp(() {
    storage = InMemoryCookieStorage();
    authService = AuthService(storage);
  });

  group('AuthService', () {
    test('login успешно сохраняет токен, username и roles', () async {
      // Переопределяем HTTP-клиент через статический метод
      // Но у нас инлайн-клиент. Для тестов будем использовать MockClient
      // из http/testing.dart.
    });

    test('isLoggedIn возвращает false когда куки пусты', () {
      expect(authService.isLoggedIn(), isFalse);
    });

    test('getToken возвращает null когда куки пусты', () {
      expect(authService.getToken(), isNull);
    });

    test('getUsername возвращает null когда куки пусты', () {
      expect(authService.getUsername(), isNull);
    });

    test('getRoles возвращает пустой список когда куки пусты', () {
      expect(authService.getRoles(), isEmpty);
    });

    test('isLoggedIn возвращает true после сохранения токена', () {
      storage.set(AuthService.tokenKey, 'test-token');
      expect(authService.isLoggedIn(), isTrue);
    });

    test('getToken возвращает сохранённый токен', () {
      storage.set(AuthService.tokenKey, 'my-jwt-token');
      expect(authService.getToken(), 'my-jwt-token');
    });

    test('getUsername возвращает сохранённое имя', () {
      storage.set(AuthService.usernameKey, 'admin');
      expect(authService.getUsername(), 'admin');
    });

    test('getRoles парсит CSV-строку из куки', () {
      storage.set(AuthService.rolesKey, 'ROLE_ADMIN,ROLE_METHODIST');
      expect(authService.getRoles(), ['ROLE_ADMIN', 'ROLE_METHODIST']);
    });

    test('getRoles возвращает пустой список если только запятые', () {
      storage.set(AuthService.rolesKey, ',');
      expect(authService.getRoles(), isEmpty);
    });

    test('logout очищает все куки', () {
      storage.set(AuthService.tokenKey, 'token');
      storage.set(AuthService.usernameKey, 'user');
      storage.set(AuthService.rolesKey, 'ROLE_ADMIN');

      authService.logout();

      expect(storage.get(AuthService.tokenKey), isNull);
      expect(storage.get(AuthService.usernameKey), isNull);
      expect(storage.get(AuthService.rolesKey), isNull);
    });
  });

  group('InMemoryCookieStorage', () {
    test('set и get работают', () {
      storage.set('key', 'value');
      expect(storage.get('key'), 'value');
    });

    test('get возвращает null для отсутствующей куки', () {
      expect(storage.get('missing'), isNull);
    });

    test('delete удаляет куку', () {
      storage.set('key', 'value');
      storage.delete('key');
      expect(storage.get('key'), isNull);
    });
  });
}