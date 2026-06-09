import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/location_response.dart';
import 'auth_service.dart';

/// Сервис для работы с локациями клубов.
class LocationService {
  final AuthService _authService;

  LocationService(this._authService);

  String? get _token => _authService.getToken();

  Map<String, String> get _headers => {
        'Accept': '*/*',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// Возвращает список локаций указанного клуба.
  ///
  /// Backend возвращает массив объектов `LocationResponse`,
  /// без пагинации — поэтому работаем с обычным `List`.
  Future<List<LocationResponse>> getLocations(String clubId) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.clubLocationsPath(clubId)}',
    );
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List<dynamic>;
      return body
          .map((e) => LocationResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw LocationException(_extractMessage(response));
    }
  }

  /// Создаёт новую локацию для указанного клуба.
  /// Возвращает созданную [LocationResponse] или выбрасывает исключение.
  Future<LocationResponse> createLocation({
    required String clubId,
    required String name,
  }) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.clubLocationsPath(clubId)}',
    );
    final response = await http.post(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return LocationResponse.fromJson(body);
    } else {
      throw LocationException(_extractMessage(response));
    }
  }

  String _extractMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['detail'] ?? 'Ошибка (${response.statusCode})';
    } catch (_) {
      return 'Ошибка сервера (${response.statusCode})';
    }
  }
}

/// Исключение при ошибке работы с локациями.
class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}
