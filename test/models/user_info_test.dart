import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/models/user_info.dart';

void main() {
  group('UserInfo', () {
    final json = {
      'id': '3ba708f9-7f59-44bc-824f-cfdfe11d1436',
      'username': 'admin',
      'email': 'admin@jbfh.by',
      'enabled': true,
      'roles': ['ROLE_ADMIN'],
      'clubId': null,
      'clubName': null,
      'lastSeenAt': '2026-06-06T16:23:27.881291',
      'createdAt': '2026-06-02T16:03:12.889525',
    };

    test('fromJson парсит все поля', () {
      final user = UserInfo.fromJson(json);
      expect(user.id, json['id']);
      expect(user.username, 'admin');
      expect(user.email, 'admin@jbfh.by');
      expect(user.enabled, isTrue);
      expect(user.roles, ['ROLE_ADMIN']);
      expect(user.clubId, isNull);
      expect(user.clubName, isNull);
      expect(user.lastSeenAt, '2026-06-06T16:23:27.881291');
      expect(user.createdAt, '2026-06-02T16:03:12.889525');
    });

    test('fromJson парсит с clubId и clubName', () {
      final withClub = {
        ...json,
        'clubId': 'club-123',
        'clubName': 'BFH Minsk',
      };
      final user = UserInfo.fromJson(withClub);
      expect(user.clubId, 'club-123');
      expect(user.clubName, 'BFH Minsk');
    });

    test('fromJson обрабатывает несколько ролей', () {
      final multiRole = {
        ...json,
        'roles': ['ROLE_ADMIN', 'ROLE_CLUB'],
      };
      final user = UserInfo.fromJson(multiRole);
      expect(user.roles, ['ROLE_ADMIN', 'ROLE_CLUB']);
    });
  });
}