import 'package:flutter_test/flutter_test.dart';

import 'package:fbfh/models/exercise_response.dart';

void main() {
  group('ExerciseResponse', () {
    final json = {
      'id': '550e8400-e29b-41d4-a716-446655440000',
      'name': 'Ведение шайбы',
      'description': 'Упражнение на ведение шайбы по кругу',
      'type': 'ICE',
      'pictureUrl': 'http://localhost:8080/api/v1/exercises/550e8400/picture',
      'url': 'https://youtube.com/watch?v=abc',
      'content': 'Подробное описание упражнения',
      'active': true,
      'clubId': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
      'clubName': 'ЦСКА',
      'inventoryIds': [
        'inv-1',
        'inv-2',
      ],
      'createdAt': '2026-06-09T15:57:27.900Z',
      'updatedAt': '2026-06-09T16:00:00.000Z',
    };

    test('fromJson парсит все поля', () {
      final exercise = ExerciseResponse.fromJson(json);

      expect(exercise.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(exercise.name, 'Ведение шайбы');
      expect(exercise.description, 'Упражнение на ведение шайбы по кругу');
      expect(exercise.type, 'ICE');
      expect(exercise.pictureUrl,
          'http://localhost:8080/api/v1/exercises/550e8400/picture');
      expect(exercise.url, 'https://youtube.com/watch?v=abc');
      expect(exercise.content, 'Подробное описание упражнения');
      expect(exercise.active, isTrue);
      expect(exercise.clubId, '3fa85f64-5717-4562-b3fc-2c963f66afa6');
      expect(exercise.clubName, 'ЦСКА');
      expect(exercise.inventoryIds, ['inv-1', 'inv-2']);
      expect(exercise.createdAt, '2026-06-09T15:57:27.900Z');
      expect(exercise.updatedAt, '2026-06-09T16:00:00.000Z');
    });

    test('fromJson обрабатывает минимальный JSON', () {
      final minimal = {
        'id': '1',
        'name': 'Test',
        'type': 'LAND',
        'content': '',
        'active': true,
        'inventoryIds': [],
        'createdAt': '2026-01-01T00:00:00Z',
      };

      final exercise = ExerciseResponse.fromJson(minimal);

      expect(exercise.description, '');
      expect(exercise.pictureUrl, isNull);
      expect(exercise.url, isNull);
      expect(exercise.content, '');
      expect(exercise.clubId, isNull);
      expect(exercise.clubName, isNull);
      expect(exercise.inventoryIds, isEmpty);
      expect(exercise.updatedAt, isNull);
    });

    test('fromJson обрабатывает null-поля', () {
      final withNulls = {
        'id': '2',
        'name': 'Test',
        'description': null,
        'type': 'ICE',
        'pictureUrl': null,
        'url': null,
        'content': null,
        'active': false,
        'clubId': null,
        'clubName': null,
        'inventoryIds': null,
        'createdAt': '2026-01-01T00:00:00Z',
        'updatedAt': null,
      };

      final exercise = ExerciseResponse.fromJson(withNulls);

      expect(exercise.description, '');
      expect(exercise.pictureUrl, isNull);
      expect(exercise.url, isNull);
      expect(exercise.content, '');
      expect(exercise.clubId, isNull);
      expect(exercise.clubName, isNull);
      expect(exercise.inventoryIds, isEmpty);
      expect(exercise.updatedAt, isNull);
      expect(exercise.active, isFalse);
    });

    test('toJson сериализует обратно', () {
      final exercise = ExerciseResponse(
        id: 'x',
        name: 'Push-ups',
        description: 'desc',
        type: 'LAND',
        pictureUrl: 'http://pic',
        url: 'http://vid',
        content: 'content',
        active: true,
        clubId: 'c1',
        clubName: 'Club',
        inventoryIds: ['i1'],
        createdAt: '2026-01-01T00:00:00Z',
        updatedAt: '2026-01-02T00:00:00Z',
      );

      final result = exercise.toJson();

      expect(result['id'], 'x');
      expect(result['name'], 'Push-ups');
      expect(result['type'], 'LAND');
      expect(result['inventoryIds'], ['i1']);
      expect(result['clubId'], 'c1');
    });
  });

  group('ExerciseRequest', () {
    test('toJson — все поля', () {
      final request = ExerciseRequest(
        name: 'Test',
        description: 'Desc',
        type: 'ICE',
        url: 'https://youtube.com',
        content: 'Content',
        inventoryIds: ['inv-1', 'inv-2'],
      );

      final json = request.toJson();

      expect(json['name'], 'Test');
      expect(json['description'], 'Desc');
      expect(json['type'], 'ICE');
      expect(json['url'], 'https://youtube.com');
      expect(json['content'], 'Content');
      expect(json['inventoryIds'], ['inv-1', 'inv-2']);
    });

    test('toJson — url null', () {
      final request = ExerciseRequest(
        name: 'T',
        description: '',
        type: 'LAND',
        content: '',
        inventoryIds: [],
      );

      final json = request.toJson();

      expect(json['url'], isNull);
    });

    test('copyWith меняет отдельные поля', () {
      final original = ExerciseRequest(
        name: 'A',
        description: 'B',
        type: 'ICE',
        url: 'old-url',
        content: 'C',
        inventoryIds: ['x'],
      );

      final updated = original.copyWith(name: 'New');

      expect(updated.name, 'New');
      expect(updated.description, 'B'); // не изменилось
      expect(updated.type, 'ICE');
      expect(updated.url, 'old-url');
      expect(updated.content, 'C');
      expect(updated.inventoryIds, ['x']);
    });

    test('copyWith может очистить inventoryIds', () {
      final original = ExerciseRequest(
        name: 'A',
        description: 'B',
        type: 'ICE',
        content: 'C',
        inventoryIds: ['x', 'y'],
      );

      final updated = original.copyWith(inventoryIds: []);

      expect(updated.inventoryIds, isEmpty);
    });
  });
}