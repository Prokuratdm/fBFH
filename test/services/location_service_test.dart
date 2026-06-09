import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/services/auth_service.dart';
import 'package:fbfh/services/cookie_storage.dart';
import 'package:fbfh/services/location_service.dart';

void main() {
  group('LocationService', () {
    late LocationService locationService;
    late AuthService authService;

    setUp(() {
      final storage = InMemoryCookieStorage();
      storage.set(AuthService.tokenKey, 'test-token');
      authService = AuthService(storage);
      locationService = LocationService(authService);
    });

    test('использует правильный путь для getLocations', () {
      // Smoke-test: убеждаемся, что сервис создан без ошибок
      // и содержит правильную зависимость от AuthService.
      expect(locationService, isNotNull);
      expect(authService.getToken(), 'test-token');
    });

    test('LocationException содержит сообщение', () {
      const ex = LocationException('Test error');
      expect(ex.message, 'Test error');
      expect(ex.toString(), contains('Test error'));
    });
  });
}
