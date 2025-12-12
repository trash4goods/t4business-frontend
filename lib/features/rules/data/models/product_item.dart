class RecyclingProductItem {
  final String id;
  final String title;
  final String description;
  final bool isActive;
  final DateTime createdAt;

  RecyclingProductItem({
    required this.id,
    required this.title,
    required this.description,
    this.isActive = true,
    required this.createdAt,
  });

  RecyclingProductItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RecyclingProductItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
