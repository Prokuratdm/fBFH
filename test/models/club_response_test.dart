import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/models/club_response.dart';

void main() {
  group('ClubResponse', () {
    test('fromJson парсит все поля', () {
      final json = {
        'id': 'e6aaeeeb-b20f-41b8-b454-9b9260b6ac2e',
        'name': 'Юность',
        'address': 'Семашко',
        'description': 'Гордость',
        'logoUrl': null,
        'createdAt': '2026-06-06T19:09:03.317133',
        'updatedAt': null,
      };

      final club = ClubResponse.fromJson(json);

      expect(club.id, 'e6aaeeeb-b20f-41b8-b454-9b9260b6ac2e');
      expect(club.name, 'Юность');
      expect(club.address, 'Семашко');
      expect(club.description, 'Гордость');
      expect(club.logoUrl, isNull);
      expect(club.createdAt, '2026-06-06T19:09:03.317133');
      expect(club.updatedAt, isNull);
    });

    test('fromJson парсит с logoUrl', () {
      final json = {
        'id': 'abc',
        'name': 'Test',
        'address': '',
        'description': '',
        'logoUrl': '/api/v1/clubs/abc/logo',
        'createdAt': '',
        'updatedAt': '',
      };

      final club = ClubResponse.fromJson(json);

      expect(club.logoUrl, '/api/v1/clubs/abc/logo');
    });

    test('toJson возвращает правильный Map', () {
      final club = ClubResponse(
        id: 'id',
        name: 'name',
        address: 'addr',
        description: 'desc',
        logoUrl: '/logo',
        createdAt: 'now',
        updatedAt: 'later',
      );

      final json = club.toJson();

      expect(json['id'], 'id');
      expect(json['name'], 'name');
      expect(json['address'], 'addr');
      expect(json['description'], 'desc');
      expect(json['logoUrl'], '/logo');
      expect(json['createdAt'], 'now');
      expect(json['updatedAt'], 'later');
    });

    test('toJson с null полями', () {
      final club = ClubResponse(
        id: 'id',
        name: 'name',
        address: 'addr',
        description: 'desc',
        createdAt: 'now',
      );

      final json = club.toJson();

      expect(json['logoUrl'], isNull);
      expect(json['updatedAt'], isNull);
    });
  });
}