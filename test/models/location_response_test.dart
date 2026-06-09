import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/models/location_response.dart';

void main() {
  group('LocationResponse', () {
    test('fromJson парсит все поля', () {
      final json = {
        'id': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
        'name': 'Ледовый дворец',
        'active': true,
        'clubId': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
        'createdAt': '2026-06-09T12:46:00.921Z',
        'updatedAt': '2026-06-09T12:46:00.921Z',
      };

      final location = LocationResponse.fromJson(json);

      expect(location.id, '3fa85f64-5717-4562-b3fc-2c963f66afa6');
      expect(location.name, 'Ледовый дворец');
      expect(location.active, isTrue);
      expect(location.clubId, '3fa85f64-5717-4562-b3fc-2c963f66afa6');
      expect(location.createdAt, '2026-06-09T12:46:00.921Z');
      expect(location.updatedAt, '2026-06-09T12:46:00.921Z');
    });

    test('fromJson по умолчанию active=true, если поле отсутствует', () {
      final json = {
        'id': 'id-1',
        'name': 'Зал',
        'clubId': 'club-1',
        'createdAt': '2026-06-09T12:46:00.921Z',
        'updatedAt': '2026-06-09T12:46:00.921Z',
      };

      final location = LocationResponse.fromJson(json);

      expect(location.active, isTrue);
    });

    test('fromJson парсит active=false', () {
      final json = {
        'id': 'id-1',
        'name': 'Зал',
        'active': false,
        'clubId': 'club-1',
        'createdAt': '2026-06-09T12:46:00.921Z',
        'updatedAt': '2026-06-09T12:46:00.921Z',
      };

      final location = LocationResponse.fromJson(json);

      expect(location.active, isFalse);
    });

    test('fromJson парсит updatedAt = null', () {
      final json = {
        'id': 'id-1',
        'name': 'Зал',
        'active': true,
        'clubId': 'club-1',
        'createdAt': '2026-06-09T12:46:00.921Z',
        'updatedAt': null,
      };

      final location = LocationResponse.fromJson(json);

      expect(location.updatedAt, isNull);
    });

    test('fromJson работает когда updatedAt отсутствует', () {
      final json = {
        'id': 'id-1',
        'name': 'Зал',
        'active': true,
        'clubId': 'club-1',
        'createdAt': '2026-06-09T12:46:00.921Z',
      };

      final location = LocationResponse.fromJson(json);

      expect(location.updatedAt, isNull);
    });

    test('toJson с null updatedAt', () {
      const location = LocationResponse(
        id: 'id-1',
        name: 'Зал',
        active: true,
        clubId: 'club-1',
        createdAt: '2026-06-09T12:46:00.921Z',
        updatedAt: null,
      );

      final json = location.toJson();

      expect(json['updatedAt'], isNull);
    });

    test('toJson возвращает правильный Map', () {
      const location = LocationResponse(
        id: 'id-1',
        name: 'Зал',
        active: true,
        clubId: 'club-1',
        createdAt: 'created',
        updatedAt: 'updated',
      );

      final json = location.toJson();

      expect(json['id'], 'id-1');
      expect(json['name'], 'Зал');
      expect(json['active'], isTrue);
      expect(json['clubId'], 'club-1');
      expect(json['createdAt'], 'created');
      expect(json['updatedAt'], 'updated');
    });
  });

  group('LocationRequest', () {
    test('toJson возвращает name', () {
      const request = LocationRequest(name: 'Тренировочный зал');
      final json = request.toJson();

      expect(json, {'name': 'Тренировочный зал'});
    });
  });
}
