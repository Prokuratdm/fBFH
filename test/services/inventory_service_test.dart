import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/services/auth_service.dart';
import 'package:fbfh/services/cookie_storage.dart';
import 'package:fbfh/services/inventory_service.dart';

void main() {
  group('InventoryService', () {
    late InventoryService inventoryService;
    late AuthService authService;

    setUp(() {
      final storage = InMemoryCookieStorage();
      storage.set(AuthService.tokenKey, 'test-token');
      authService = AuthService(storage);
      inventoryService = InventoryService(authService);
    });

    test('создаётся без ошибок', () {
      expect(inventoryService, isNotNull);
      expect(authService.getToken(), 'test-token');
    });

    test('InventoryException содержит сообщение', () {
      const ex = InventoryException('Test error');
      expect(ex.message, 'Test error');
      expect(ex.toString(), contains('Test error'));
    });
  });
}
