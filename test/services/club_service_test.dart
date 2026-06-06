import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/services/auth_service.dart';
import 'package:fbfh/services/club_service.dart';
import 'package:fbfh/services/cookie_storage.dart';

void main() {
  group('ClubService', () {
    late ClubService clubService;
    late AuthService authService;

    setUp(() {
      final storage = InMemoryCookieStorage();
      storage.set(AuthService.tokenKey, 'test-token');
      authService = AuthService(storage);
      clubService = ClubService(authService);
    });

    test('getLogoUrl возвращает правильный URL', () {
      final url = clubService.getLogoUrl('club-id');
      expect(url, contains('/api/v1/clubs/club-id/logo'));
    });
  });
}