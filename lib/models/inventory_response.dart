/// Ответ API для элемента инвентаря клуба.
///
/// Возвращается эндпоинтами:
/// - GET  /api/v1/inventory (внутри PageResponse.content)
/// - POST /api/v1/inventory
class InventoryResponse {
  final String id;
  final String name;
  final bool active;
  final String? clubId;
  final String? clubName;
  final String createdAt;
  final String? updatedAt;

  const InventoryResponse({
    required this.id,
    required this.name,
    required this.active,
    this.clubId,
    this.clubName,
    required this.createdAt,
    this.updatedAt,
  });

  factory InventoryResponse.fromJson(Map<String, dynamic> json) {
    return InventoryResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      active: (json['active'] as bool?) ?? true,
      clubId: json['clubId'] as String?,
      clubName: json['clubName'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'active': active,
      'clubId': clubId,
      'clubName': clubName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

/// Тело запроса для создания элемента инвентаря.
///
/// `clubId` опциональный — если `null`, поле не отправляется в API.
class InventoryRequest {
  final String name;
  final String? clubId;

  const InventoryRequest({required this.name, this.clubId});

  Map<String, dynamic> toJson() => {
        'name': name,
        if (clubId != null) 'clubId': clubId,
      };
}
