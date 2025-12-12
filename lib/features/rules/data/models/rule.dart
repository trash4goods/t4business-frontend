class RuleModel {
  final String id;
  final String title;
  final String description;
  final int recycleCount;
  final List<String> categories;
  final String priority; // 'high', 'medium', 'low'
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastModified;
  final String createdBy;
  final List<String> tags;

  RuleModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.recycleCount,
    required this.categories,
    this.priority = 'medium',
    this.isActive = true,
    required this.createdAt,
    this.lastModified,
    required this.createdBy,
    this.tags = const [],
  });

  /// Factory method to create a mock rule for testing/development
  factory RuleModel.mock({
    String? id,
    String? title,
    String? description,
    int? recycleCount,
    List<String>? categories,
    String? priority,
    bool? isActive,
    DateTime? createdAt,
    String? createdBy,
    List<String>? tags,
  }) {
    return RuleModel(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title ?? 'Sample Rule',
      description: description ?? 'This is a sample rule for testing purposes',
      recycleCount: recycleCount ?? 5,
      categories: categories ?? ['Plastic', 'Bottles'],
      priority: priority ?? 'medium',
      isActive: isActive ?? true,
      createdAt: createdAt ?? DateTime.now(),
      createdBy: createdBy ?? 'System',
      tags: tags ?? ['sample', 'test'],
    );
  }

  /// Get a list of predefined mock rules for development/testing
  static List<RuleModel> getMockRules() {
    final now = DateTime.now();

    return [
      RuleModel(
        id: 'rule_001',
        title: 'Recycle 10x Coca-Cola Small Bottles',
        description:
            'Recycle 10 small Coca-Cola plastic bottles (500ml or less) to earn a FREE Coca-Cola 6-pack reward. Valid for clear PET bottles with Coca-Cola branding.',
        recycleCount: 10,
        categories: ['Plastic', 'Bottles', 'Coca-Cola'],
        priority: 'high',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
        lastModified: now.subtract(const Duration(days: 5)),
        createdBy: 'Coca-Cola Partnership',
        tags: ['coca-cola', 'bottles', 'brand-specific', 'promotion'],
      ),

      RuleModel(
        id: 'rule_002',
        title: 'Recycle 15x Aluminum Cans for Starbucks Gift Card',
        description:
            'Collect and recycle 15 aluminum beverage cans to earn a \$10 Starbucks gift card. All beverage cans accepted (soda, beer, energy drinks).',
        recycleCount: 15,
        categories: ['Metal', 'Cans', 'Beverages'],
        priority: 'high',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 25)),
        lastModified: now.subtract(const Duration(days: 2)),
        createdBy: 'Starbucks Rewards',
        tags: ['aluminum', 'cans', 'gift-card', 'starbucks'],
      ),

      RuleModel(
        id: 'rule_003',
        title: 'Recycle 5x Large Cardboard Boxes for Amazon Credit',
        description:
            'Bundle and recycle 5 large cardboard shipping boxes (minimum 12x12x6 inches) to earn \$5 Amazon store credit. Boxes must be flattened and clean.',
        recycleCount: 5,
        categories: ['Cardboard', 'Shipping', 'E-commerce'],
        priority: 'medium',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 20)),
        createdBy: 'Amazon Green Initiative',
        tags: ['cardboard', 'shipping', 'amazon', 'credit'],
      ),

      RuleModel(
        id: 'rule_004',
        title: 'Recycle 8x Glass Wine Bottles for Wine Tasting Voucher',
        description:
            'Recycle 8 wine bottles (750ml glass) to receive a complimentary wine tasting voucher at participating local wineries. Labels may remain on bottles.',
        recycleCount: 8,
        categories: ['Glass', 'Wine', 'Alcohol'],
        priority: 'medium',
        isActive: false,
        createdAt: now.subtract(const Duration(days: 15)),
        lastModified: now.subtract(const Duration(days: 1)),
        createdBy: 'Local Wineries Alliance',
        tags: ['glass', 'wine', 'tasting', 'local-business'],
      ),

      RuleModel(
        id: 'rule_005',
        title: 'Recycle 3x Old Smartphones for Best Buy Gift Card',
        description:
            'Trade in 3 old smartphones (any condition, any brand) for a \$25 Best Buy gift card. Devices will be properly recycled or refurbished.',
        recycleCount: 3,
        categories: ['Electronics', 'Smartphones', 'E-waste'],
        priority: 'high',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 10)),
        createdBy: 'Best Buy Trade-In',
        tags: ['electronics', 'smartphones', 'trade-in', 'best-buy'],
      ),

      RuleModel(
        id: 'rule_006',
        title: 'Donate 2x Bags of Clothes for H&M Discount',
        description:
            'Donate 2 full bags of used clothing and textiles to earn a 20% discount on your next H&M purchase. Any brand clothing accepted.',
        recycleCount: 2,
        categories: ['Textiles', 'Clothing', 'Fashion'],
        priority: 'medium',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 8)),
        createdBy: 'H&M Conscious Collection',
        tags: ['textiles', 'clothing', 'fashion', 'h&m', 'discount'],
      ),

      RuleModel(
        id: 'rule_007',
        title: 'Recycle 20x AA/AAA Batteries for Tesla Supercharger Credit',
        description:
            'Safely dispose of 20 used AA or AAA batteries to receive \$15 Tesla Supercharger credit. Batteries must be non-rechargeable alkaline type.',
        recycleCount: 20,
        categories: ['Batteries', 'Hazardous', 'Energy'],
        priority: 'high',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 5)),
        lastModified: now.subtract(const Duration(hours: 12)),
        createdBy: 'Tesla Green Energy',
        tags: ['batteries', 'tesla', 'supercharger', 'energy'],
      ),

      RuleModel(
        id: 'rule_008',
        title: 'Compost 7x Bags of Organic Waste for Whole Foods Credit',
        description:
            'Bring 7 bags of organic kitchen scraps for composting to earn \$10 Whole Foods store credit. Includes fruit/vegetable peels, coffee grounds, eggshells.',
        recycleCount: 7,
        categories: ['Organic', 'Compost', 'Food Waste'],
        priority: 'medium',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 3)),
        createdBy: 'Whole Foods Sustainability',
        tags: ['organic', 'compost', 'whole-foods', 'food-waste'],
      ),

      RuleModel(
        id: 'rule_009',
        title: 'Mixed Recycling Challenge for Netflix Subscription',
        description:
            'Complete the ultimate recycling challenge: 5 plastic bottles, 5 cans, 3 cardboard boxes in one month to win 3 months of Netflix Premium.',
        recycleCount: 13,
        categories: ['Mixed', 'Challenge', 'Entertainment'],
        priority: 'high',
        isActive: true,
        createdAt: now.subtract(const Duration(days: 1)),
        createdBy: 'Netflix Sustainability',
        tags: ['mixed', 'challenge', 'netflix', 'premium', 'monthly'],
      ),

      RuleModel(
        id: 'rule_010',
        title: 'Recycle 6x Holiday Gift Boxes for Target Gift Card',
        description:
            'Recycle 6 holiday gift boxes and wrapping materials to receive a \$15 Target gift card. Perfect for post-holiday cleanup!',
        recycleCount: 6,
        categories: ['Seasonal', 'Packaging', 'Holiday'],
        priority: 'medium',
        isActive: false,
        createdAt: now.subtract(const Duration(hours: 6)),
        createdBy: 'Target Holiday Program',
        tags: ['seasonal', 'holiday', 'target', 'gift-card', 'cleanup'],
      ),
    ];
  }

  RuleModel copyWith({
    String? id,
    String? title,
    String? description,
    int? recycleCount,
    List<String>? categories,
    String? priority,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastModified,
    String? createdBy,
    List<String>? tags,
  }) {
    return RuleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      recycleCount: recycleCount ?? this.recycleCount,
      categories: categories ?? this.categories,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      createdBy: createdBy ?? this.createdBy,
      tags: tags ?? this.tags,
    );
  }
}
