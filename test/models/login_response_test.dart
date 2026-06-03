import 'package:flutter_test/flutter_test.dart';
import 'package:fbfh/models/login_response.dart';

void main() {
  group('LoginResponse', () {
    final json = {
      'token': 'eyJhbGciOiJIUzUxMiJ9.foo.bar',
      'userId': '3ba708f9-7f59-44bc-824f-cfdfe11d1436',
      'username': 'admin',
      'roles': ['ROLE_ADMIN'],
    };

    test('fromJson парсит все поля', () {
      final response = LoginResponse.fromJson(json);
      expect(response.token, json['token']);
      expect(response.userId, json['userId']);
      expect(response.username, json['username']);
      expect(response.roles, ['ROLE_ADMIN']);
    });

    test('toJson возвращает правильный Map', () {
      final response = LoginResponse.fromJson(json);
      final output = response.toJson();
      expect(output['token'], json['token']);
      expect(output['userId'], json['userId']);
      expect(output['username'], json['username']);
      expect(output['roles'], ['ROLE_ADMIN']);
    });

    test('fromJson обрабатывает несколько ролей', () {
      final multiRole = {
        ...json,
        'roles': ['ROLE_ADMIN', 'ROLE_CLUB'],
      };
      final response = LoginResponse.fromJson(multiRole);
      expect(response.roles, ['ROLE_ADMIN', 'ROLE_CLUB']);
    });

    test('fromJson обрабатывает пустой список ролей', () {
      final noRoles = {
        ...json,
        'roles': <String>[],
      };
      final response = LoginResponse.fromJson(noRoles);
      expect(response.roles, isEmpty);
    });
  });
}