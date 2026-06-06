/// Ответ API для клуба.
class ClubResponse {
  final String id;
  final String name;
  final String address;
  final String description;
  final String? logoUrl;
  final String createdAt;
  final String? updatedAt;

  const ClubResponse({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    this.logoUrl,
    required this.createdAt,
    this.updatedAt,
  });

  factory ClubResponse.fromJson(Map<String, dynamic> json) {
    return ClubResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'logoUrl': logoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}