/// Ответ API для упражнения.
///
/// Возвращается эндпоинтами:
/// - GET    /api/v1/exercises (внутри PageResponse.content)
/// - GET    /api/v1/exercises/{id}
/// - POST   /api/v1/exercises
/// - PUT    /api/v1/exercises/{id}
/// - POST   /api/v1/exercises/{id}/picture (после загрузки картинки)
class ExerciseResponse {
  final String id;
  final String name;
  final String description;
  final String type;
  final String? pictureUrl;
  final String? url;
  final String content;
  final bool active;
  final String? clubId;
  final String? clubName;
  final List<String> inventoryIds;
  final String createdAt;
  final String? updatedAt;

  const ExerciseResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.pictureUrl,
    this.url,
    required this.content,
    required this.active,
    this.clubId,
    this.clubName,
    required this.inventoryIds,
    required this.createdAt,
    this.updatedAt,
  });

  factory ExerciseResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: (json['description'] as String?) ?? '',
      type: json['type'] as String,
      pictureUrl: json['pictureUrl'] as String?,
      url: json['url'] as String?,
      content: (json['content'] as String?) ?? '',
      active: (json['active'] as bool?) ?? true,
      clubId: json['clubId'] as String?,
      clubName: json['clubName'] as String?,
      inventoryIds: (json['inventoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'pictureUrl': pictureUrl,
      'url': url,
      'content': content,
      'active': active,
      'clubId': clubId,
      'clubName': clubName,
      'inventoryIds': inventoryIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

/// Тело запроса для создания/редактирования упражнения.
///
/// POST /api/v1/exercises (дополнительно передаётся `clubId` в JSON)
/// PUT  /api/v1/exercises/{id}
class ExerciseRequest {
  final String name;
  final String description;
  final String type;
  final String? url;
  final String content;
  final List<String> inventoryIds;

  const ExerciseRequest({
    required this.name,
    required this.description,
    required this.type,
    this.url,
    required this.content,
    required this.inventoryIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'url': url,
      'content': content,
      'inventoryIds': inventoryIds,
    };
  }

  /// Создаёт копию с изменёнными полями (для редактирования).
  ExerciseRequest copyWith({
    String? name,
    String? description,
    String? type,
    String? url,
    String? content,
    List<String>? inventoryIds,
  }) {
    return ExerciseRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      url: url ?? this.url,
      content: content ?? this.content,
      inventoryIds: inventoryIds ?? this.inventoryIds,
    );
  }
}