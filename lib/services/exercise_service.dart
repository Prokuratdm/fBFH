import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../core/config/app_config.dart';
import '../models/exercise_response.dart';
import '../models/page_response.dart';
import 'auth_service.dart';

/// Сервис для работы с упражнениями.
class ExerciseService {
  final AuthService _authService;

  ExerciseService(this._authService);

  String? get _token => _authService.getToken();

  /// Токен для авторизации (используется в Image.network headers).
  String? get token => _authService.getToken();

  Map<String, String> get _headers => {
        'Accept': '*/*',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// Возвращает список типов упражнений (например, ["ICE", "LAND"]).
  Future<List<String>> getTypes() async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.exerciseTypesPath}',
    );
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as List<dynamic>;
      return body.map((e) => e as String).toList();
    } else {
      throw ExerciseException(_extractMessage(response));
    }
  }

  /// Возвращает пагинированный список упражнений.
  ///
  /// [active] — фильтр по активности (по умолчанию `true`).
  /// [type] — фильтр по типу (например `"ICE"`, `"LAND"` или `null` для всех).
  Future<PageResponse<ExerciseResponse>> getAll({
    bool active = true,
    String? type,
    int page = 0,
    int size = 100,
  }) async {
    final queryParams = <String, String>{
      'active': active.toString(),
      'page': page.toString(),
      'size': size.toString(),
    };
    if (type != null) {
      queryParams['type'] = type;
    }

    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.exercisesPath}',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return PageResponse.fromJson(body, ExerciseResponse.fromJson);
    } else {
      throw ExerciseException(_extractMessage(response));
    }
  }

  /// Возвращает детали упражнения по [id].
  Future<ExerciseResponse> getById(String id) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.exercisesPath}/$id',
    );
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return ExerciseResponse.fromJson(body);
    } else {
      throw ExerciseException(_extractMessage(response));
    }
  }

  /// Создаёт новое упражнение.
  ///
  /// [clubId] добавляется в тело запроса только если не `null`
  /// (например, для админа/методиста может быть выбран клуб).
  Future<ExerciseResponse> create({
    required ExerciseRequest request,
    String? clubId,
  }) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.exercisesPath}',
    );
    final body = <String, dynamic>{
      ...request.toJson(),
      if (clubId != null) 'clubId': clubId,
    };

    final response = await http.post(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return ExerciseResponse.fromJson(decoded);
    } else {
      throw ExerciseException(_extractMessage(response));
    }
  }

  /// Обновляет существующее упражнение.
  Future<ExerciseResponse> update(String id, ExerciseRequest request) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.exercisesPath}/$id',
    );

    final response = await http.put(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return ExerciseResponse.fromJson(decoded);
    } else {
      throw ExerciseException(_extractMessage(response));
    }
  }

  /// Загружает картинку упражнения.
  ///
  /// [bytes] — содержимое файла, [filename] — имя файла.
  /// Аналогично [ClubService.uploadLogo].
  Future<ExerciseResponse> uploadPicture(
    String id,
    List<int> bytes,
    String filename,
  ) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}${AppConfig.exercisePicturePath(id)}',
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
      return ExerciseResponse.fromJson(body);
    } else {
      throw ExerciseException(_extractMessage(response));
    }
  }

  /// Возвращает полный URL для картинки упражнения.
  String getPictureUrl(String id) {
    return '${AppConfig.baseUrl}${AppConfig.exercisePicturePath(id)}';
  }

  String _extractMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ??
          body['detail'] ??
          'Ошибка (${response.statusCode})';
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

/// Исключение при ошибке работы с упражнениями.
class ExerciseException implements Exception {
  final String message;
  const ExerciseException(this.message);

  @override
  String toString() => 'ExerciseException: $message';
}