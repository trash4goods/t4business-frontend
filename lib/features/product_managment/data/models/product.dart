class ProductModel {
  final int id;
  final String title;
  final String brand;
  final String description;
  final String headerImage;
  final List<String> carouselImage;
  // List of items (title + barcode) for multi-item products
  final List<Map<String, String>> items;

  // Representative barcode (first item's barcode or standalone barcode)
  final String barcode;
  final List<String> category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> linkedRewards; // Rewards linked to this product

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
    required this.updatedAt,
    this.items = const [],
    this.linkedRewards = const [],
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      brand: map['brand'] ?? '',
      description: map['description'] ?? '',
      headerImage: map['headerImage'] ?? '',
      carouselImage: List<String>.from(map['carouselImage'] ?? []),
      items: (map['items'] as List<dynamic>? ?? [])
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      barcode: map['barcode'] ?? '',
      category: List<String>.from(map['category'] ?? []),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      linkedRewards: List<String>.from(map['linkedRewards'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'brand': brand,
      'description': description,
      'headerImage': headerImage,
      'carouselImage': carouselImage,
      'items': items,
      'barcode': barcode,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'linkedRewards': linkedRewards,
    };
  }

  ProductModel copyWith({
    int? id,
    String? title,
    String? brand,
    String? description,
    String? headerImage,
    List<String>? carouselImage,
    String? barcode,
    List<Map<String, String>>? items,
    List<String>? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? linkedRewards,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      headerImage: headerImage ?? this.headerImage,
      carouselImage: carouselImage ?? this.carouselImage,
      items: items ?? this.items,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      linkedRewards: linkedRewards ?? this.linkedRewards,
    );
  }
}
