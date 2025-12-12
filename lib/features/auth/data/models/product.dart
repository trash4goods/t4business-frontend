class ProductModel {
  final int id;
  final String title;
  final String brand;
  final String description;
  final String headerImage;
  final List<String> carouselImage;
  final String barcode;
  final List<String> category;
  final DateTime createdAt;
  final int recycledCount;
  final List<String> linkedRewards;

  ProductModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.headerImage,
    required this.carouselImage,
    required this.barcode,
    required this.category,
    required this.createdAt,
    this.recycledCount = 0,
    this.linkedRewards = const [],
  });

  ProductModel copyWith({
    int? id,
    String? title,
    String? brand,
    String? description,
    String? headerImage,
    List<String>? carouselImage,
    String? barcode,
    List<String>? category,
    DateTime? createdAt,
    int? recycledCount,
    List<String>? linkedRewards,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      headerImage: headerImage ?? this.headerImage,
      carouselImage: carouselImage ?? this.carouselImage,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      recycledCount: recycledCount ?? this.recycledCount,
      linkedRewards: linkedRewards ?? this.linkedRewards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'brand': brand,
      'description': description,
      'headerImage': headerImage,
      'carouselImage': carouselImage,
      'barcode': barcode,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'recycledCount': recycledCount,
      'linkedRewards': linkedRewards,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      brand: json['brand'],
      description: json['description'],
      headerImage: json['headerImage'],
      carouselImage: List<String>.from(json['carouselImage'] ?? []),
      barcode: json['barcode'],
      category: List<String>.from(json['category']),
      createdAt: DateTime.parse(json['createdAt']),
      recycledCount: json['recycledCount'] ?? 0,
      linkedRewards: List<String>.from(json['linkedRewards'] ?? []),
    );
  }
}
