class RewardModel {
  final int id;
  final String title;
  final String description;
  final String headerImage;
  final List<String> carouselImage;
  final String logo;
  final String barcode;
  final List<String> category;
  final List<String> linkedRules; // Rules linked to this reward
  final bool canCheckout; // Enabled when user meets rule criteria
  final DateTime createdAt;
  final DateTime updatedAt;

  RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.headerImage,
    required this.carouselImage,
    required this.logo,
    required this.barcode,
    required this.category,
    this.linkedRules = const [],
    this.canCheckout = false,
    required this.createdAt,
    required this.updatedAt,
  });

  RewardModel copyWith({
    int? id,
    String? title,
    String? description,
    String? headerImage,
    List<String>? carouselImage,
    String? logo,
    String? barcode,
    List<String>? category,
    List<String>? linkedRules,
    bool? canCheckout,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      headerImage: headerImage ?? this.headerImage,
      carouselImage: carouselImage ?? this.carouselImage,
      logo: logo ?? this.logo,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      linkedRules: linkedRules ?? this.linkedRules,
      canCheckout: canCheckout ?? this.canCheckout,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
