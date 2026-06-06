import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../core/config/app_config.dart';
import '../models/club_response.dart';
import '../models/page_response.dart';
import 'auth_service.dart';

/// Сервис для работы с клубами.
class ClubService {
  final AuthService _authService;

  ClubService(this._authService);

  String? get _token => _authService.getToken();

  Map<String, String> get _headers => {
        'Accept': '*/*',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// Создаёт новый клуб.
  /// Возвращает [ClubResponse] или выбрасывает исключение при ошибке.
  Future<ClubResponse> createClub({
    required String name,
    required String address,
    required String description,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.clubsPath}');
    final response = await http.post(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'address': address,
        'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ClubResponse.fromJson(body);
    } else {
      throw ClubException(_extractMessage(response));
    }
  }

  /// Загружает логотип клуба.
  /// [bytes] — содержимое файла, [filename] — имя файла.
  Future<ClubResponse> uploadLogo(String clubId, List<int> bytes, String filename) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.clubLogoPath(clubId)}',
    );
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_headers);
    request.files.add(
      http.MultipartFile.fromBytes('file', bytes,
          filename: filename, contentType: _mediaType(filename)),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ClubResponse.fromJson(body);
    } else {
      throw ClubException(_extractMessage(response));
    }
  }

  /// Возвращает список клубов с пагинацией.
  Future<PageResponse<ClubResponse>> getClubs({
    int page = 0,
    int size = 10,
  }) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.clubsPath}?page=$page&size=$size',
    );
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return PageResponse.fromJson(body, ClubResponse.fromJson);
    } else {
      throw ClubException(_extractMessage(response));
    }
  }

  /// Возвращает полный URL для загрузки логотипа.
  String getLogoUrl(String clubId) {
    return '${AppConfig.baseUrl}${AppConfig.clubLogoPath(clubId)}';
  }

  String _extractMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['detail'] ?? 'Ошибка (${response.statusCode})';
    } catch (_) {
      return 'Ошибка сервера (${response.statusCode})';
    }
  }

  MediaType _mediaType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return MediaType('image', 'png');
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'webp':
        return MediaType('image', 'webp');
      case 'svg':
        return MediaType('image', 'svg+xml');
      case 'gif':
        return MediaType('image', 'gif');
      default:
        return MediaType('application', 'octet-stream');
    }
  }
}

/// Исключение при ошибке работы с клубами.
class ClubException implements Exception {
  final String message;
  const ClubException(this.message);

  @override
  String toString() => 'ClubException: $message';
}