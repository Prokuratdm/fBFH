import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/models/inventory_response.dart';

void main() {
  group('InventoryResponse', () {
    test('fromJson парсит все поля', () {
      final json = {
        'id': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
        'name': 'Шайба',
        'active': true,
        'clubId': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
        'clubName': 'Юность',
        'createdAt': '2026-06-09T13:17:15.016Z',
      };

      final inv = InventoryResponse.fromJson(json);

      expect(inv.id, '3fa85f64-5717-4562-b3fc-2c963f66afa6');
      expect(inv.name, 'Шайба');
      expect(inv.active, isTrue);
      expect(inv.clubId, '3fa85f64-5717-4562-b3fc-2c963f66afa6');
      expect(inv.clubName, 'Юность');
      expect(inv.createdAt, '2026-06-09T13:17:15.016Z');
      expect(inv.updatedAt, isNull);
    });

    test('fromJson по умолчанию active=true', () {
      final json = {
        'id': 'id-1',
        'name': 'Клюшка',
        'clubId': 'club-1',
        'clubName': 'BFH',
        'createdAt': '2026-06-09T13:17:15.016Z',
      };
      final inv = InventoryResponse.fromJson(json);
      expect(inv.active, isTrue);
    });

    test('fromJson работает с clubName=null', () {
      final json = {
        'id': 'id-1',
        'name': 'Шайба',
        'active': true,
        'clubId': 'club-1',
        'clubName': null,
        'createdAt': '2026-06-09T13:17:15.016Z',
      };
      final inv = InventoryResponse.fromJson(json);
      expect(inv.clubName, isNull);
    });

    test('fromJson парсит updatedAt когда присутствует', () {
      final json = {
        'id': 'id-1',
        'name': 'Шайба',
        'active': true,
        'clubId': 'club-1',
        'clubName': 'BFH',
        'createdAt': '2026-06-09T13:17:15.016Z',
        'updatedAt': '2026-06-09T14:00:00.000Z',
      };
      final inv = InventoryResponse.fromJson(json);
      expect(inv.updatedAt, '2026-06-09T14:00:00.000Z');
    });

    test('toJson возвращает правильный Map', () {
      const inv = InventoryResponse(
        id: 'id-1',
        name: 'Шайба',
        active: true,
        clubId: 'club-1',
        clubName: 'BFH',
        createdAt: '2026-06-09T13:17:15.016Z',
      );
      final json = inv.toJson();
      expect(json['id'], 'id-1');
      expect(json['name'], 'Шайба');
      expect(json['active'], isTrue);
      expect(json['clubId'], 'club-1');
      expect(json['clubName'], 'BFH');
      expect(json['createdAt'], '2026-06-09T13:17:15.016Z');
    });
  });

  group('InventoryRequest', () {
    test('toJson возвращает name и clubId', () {
      const request = InventoryRequest(name: 'Клюшка', clubId: 'club-1');
      final json = request.toJson();
      expect(json, {'name': 'Клюшка', 'clubId': 'club-1'});
    });

    test('toJson без clubId не включает поле clubId', () {
      const request = InventoryRequest(name: 'Клюшка');
      final json = request.toJson();
      expect(json, {'name': 'Клюшка'});
      expect(json.containsKey('clubId'), isFalse);
    });
  });

  group('InventoryResponse без clubId', () {
    test('fromJson парсит clubId = null', () {
      final json = {
        'id': 'id-1',
        'name': 'Шайба',
        'active': true,
        'clubId': null,
        'clubName': null,
        'createdAt': '2026-06-09T13:17:15.016Z',
      };
      final inv = InventoryResponse.fromJson(json);
      expect(inv.clubId, isNull);
      expect(inv.clubName, isNull);
    });

    test('fromJson работает когда clubId отсутствует', () {
      final json = {
        'id': 'id-1',
        'name': 'Шайба',
        'active': true,
        'createdAt': '2026-06-09T13:17:15.016Z',
      };
      final inv = InventoryResponse.fromJson(json);
      expect(inv.clubId, isNull);
    });

    test('toJson с null clubId', () {
      const inv = InventoryResponse(
        id: 'id-1',
        name: 'Шайба',
        active: true,
        createdAt: '2026-06-09T13:17:15.016Z',
      );
      final json = inv.toJson();
      expect(json['clubId'], isNull);
    });
  });
}
