import '../l10n/app_localizations.dart';

/// Хелпер для перевода enum-значений упражнений.
///
/// Если перевода нет — возвращает значение как есть (fallback на английский).
class ExerciseLabels {
  ExerciseLabels._();

  static String label(String enumValue, AppLocalizations l10n) {
    switch (enumValue) {
      case 'BEGINNING':
        return l10n.exerciseTrainingPart_BEGINNING;
      case 'MIDDLE':
        return l10n.exerciseTrainingPart_MIDDLE;
      case 'END':
        return l10n.exerciseTrainingPart_END;
      case 'STRENGTH':
        return l10n.exerciseFocus_STRENGTH;
      case 'ENDURANCE':
        return l10n.exerciseFocus_ENDURANCE;
      case 'COORDINATION':
        return l10n.exerciseFocus_COORDINATION;
      case 'SPEED':
        return l10n.exerciseFocus_SPEED;
      case 'FLEXIBILITY':
        return l10n.exerciseFocus_FLEXIBILITY;
      case 'TECHNICAL':
        return l10n.exerciseFocus_TECHNICAL;
      case 'PHYSICAL':
        return l10n.exercisePreparationType_PHYSICAL;
      case 'PSYCHOLOGICAL':
        return l10n.exercisePreparationType_PSYCHOLOGICAL;
      case 'TACTICAL':
        return l10n.exercisePreparationType_TACTICAL;
      case 'ICE':
        return l10n.exerciseTypeIce;
      case 'LAND':
        return l10n.exerciseTypeLand;
      default:
        return enumValue;
    }
  }
}

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
  final String? trainingPart;
  final List<String> focuses;
  final String? preparationType;

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
    this.trainingPart,
    required this.focuses,
    this.preparationType,
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
      trainingPart: json['trainingPart'] as String?,
      focuses: (json['focuses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      preparationType: json['preparationType'] as String?,
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
      'trainingPart': trainingPart,
      'focuses': focuses,
      'preparationType': preparationType,
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
  final String? trainingPart;
  final List<String> focuses;
  final String? preparationType;

  const ExerciseRequest({
    required this.name,
    required this.description,
    required this.type,
    this.url,
    required this.content,
    required this.inventoryIds,
    this.trainingPart,
    required this.focuses,
    this.preparationType,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'url': url,
      'content': content,
      'inventoryIds': inventoryIds,
      'trainingPart': trainingPart,
      'focuses': focuses,
      'preparationType': preparationType,
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
    String? trainingPart,
    List<String>? focuses,
    String? preparationType,
  }) {
    return ExerciseRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      url: url ?? this.url,
      content: content ?? this.content,
      inventoryIds: inventoryIds ?? this.inventoryIds,
      trainingPart: trainingPart ?? this.trainingPart,
      focuses: focuses ?? this.focuses,
      preparationType: preparationType ?? this.preparationType,
    );
  }
}