import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';
import '../models/inventory_response.dart';
import '../models/page_response.dart';
import 'auth_service.dart';

/// Сервис для работы с инвентарём.
class InventoryService {
  final AuthService _authService;

  InventoryService(this._authService);

  String? get _token => _authService.getToken();

  Map<String, String> get _headers => {
        'Accept': '*/*',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  /// Возвращает список инвентаря с пагинацией.
  Future<PageResponse<InventoryResponse>> getInventory({
    int page = 0,
    int size = 100,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.inventoryPath}')
        .replace(queryParameters: {
      'page': page.toString(),
      'size': size.toString(),
    });
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return PageResponse.fromJson(body, InventoryResponse.fromJson);
    } else {
      throw InventoryException(_extractMessage(response));
    }
  }

  /// Создаёт новый элемент инвентаря.
  /// Если [clubId] равен `null`, поле `clubId` в теле запроса не отправляется.
  Future<InventoryResponse> createInventory({
    required String name,
    String? clubId,
  }) async {
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.inventoryPath}');
    final response = await http.post(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        if (clubId != null) 'clubId': clubId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return InventoryResponse.fromJson(body);
    } else {
      throw InventoryException(_extractMessage(response));
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

/// Исключение при ошибке работы с инвентарём.
class InventoryException implements Exception {
  final String message;
  const InventoryException(this.message);

  @override
  String toString() => 'InventoryException: $message';
}
