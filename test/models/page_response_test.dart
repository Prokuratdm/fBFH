import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/models/club_response.dart';
import 'package:fbfh/models/page_response.dart';

void main() {
  group('PageResponse', () {
    test('fromJson парсит страницу с клубами', () {
      final json = {
        'content': [
          {
            'id': 'abc',
            'name': 'Юность',
            'address': 'Семашко',
            'description': 'Гордость',
            'logoUrl': null,
            'createdAt': 'now',
            'updatedAt': null,
          },
        ],
        'totalElements': 1,
        'totalPages': 1,
        'numberOfElements': 1,
        'number': 0,
        'size': 10,
        'first': true,
        'last': true,
        'empty': false,
      };

      final page = PageResponse.fromJson(json, ClubResponse.fromJson);

      expect(page.content, hasLength(1));
      expect(page.content.first.name, 'Юность');
      expect(page.totalElements, 1);
      expect(page.totalPages, 1);
      expect(page.first, isTrue);
      expect(page.last, isTrue);
      expect(page.empty, isFalse);
    });

    test('fromJson парсит пустую страницу', () {
      final json = {
        'content': [],
        'totalElements': 0,
        'totalPages': 0,
        'numberOfElements': 0,
        'number': 0,
        'size': 10,
        'first': true,
        'last': true,
        'empty': true,
      };

      final page = PageResponse.fromJson(json, ClubResponse.fromJson);

      expect(page.content, isEmpty);
      expect(page.totalElements, 0);
      expect(page.empty, isTrue);
    });
  });
}