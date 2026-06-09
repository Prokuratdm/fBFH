/// Ответ API для локации клуба.
///
/// Возвращается эндпоинтами:
/// - GET  /api/v1/clubs/{clubId}/locations
/// - POST /api/v1/clubs/{clubId}/locations
class LocationResponse {
  final String id;
  final String name;
  final bool active;
  final String clubId;
  final String createdAt;
  final String? updatedAt;

  const LocationResponse({
    required this.id,
    required this.name,
    required this.active,
    required this.clubId,
    required this.createdAt,
    this.updatedAt,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      active: (json['active'] as bool?) ?? true,
      clubId: json['clubId'] as String,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

/// Тело запроса для создания локации.
class LocationRequest {
  final String name;

  const LocationRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}
