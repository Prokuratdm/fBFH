import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/services/auth_service.dart';
import 'package:fbfh/services/cookie_storage.dart';
import 'package:fbfh/services/exercise_service.dart';

void main() {
  group('ExerciseService', () {
    late ExerciseService exerciseService;
    late AuthService authService;

    setUp(() {
      final storage = InMemoryCookieStorage();
      storage.set(AuthService.tokenKey, 'test-token');
      authService = AuthService(storage);
      exerciseService = ExerciseService(authService);
    });

    test('создаётся без ошибок', () {
      expect(exerciseService, isNotNull);
      expect(authService.getToken(), 'test-token');
    });

    test('getPictureUrl возвращает правильный URL', () {
      final url = exerciseService.getPictureUrl('abc-123');
      expect(url, contains('/api/v1/exercises/abc-123/picture'));
    });

    test('ExerciseException содержит сообщение', () {
      const ex = ExerciseException('Test error');
      expect(ex.message, 'Test error');
      expect(ex.toString(), contains('Test error'));
    });
  });
}