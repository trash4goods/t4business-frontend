import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../core/app/app_images.dart';
import '../../../../rules/data/models/rule.dart';
import '../../../data/models/product.dart';
import '../interface/product.dart';

class RewardsControllerImpl extends GetxController
    implements RewardsControllerInterface {
  // Mock data storage
  final RxList<RewardModel> _rewards = <RewardModel>[].obs;
  final RxList<String> _categories =
      <String>[
        'Discount Coupons',
        'Gift Cards',
        'Free Shipping',
        'Eco Points',
        'Digital Badges',
        'Exclusive Access',
        'Cashback',
        'Product Samples',
      ].obs;

  // Mock rules data - in real app this would come from rules service
  final RxList<RuleModel> _availableRules = <RuleModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMockData();
    _initializeMockRules();
  }

  void _initializeMockData() {
    _rewards.addAll([
      RewardModel(
        id: 1,
        title: '15% Mind the Trash Discount',
        description:
            '15% discount on all products from the 1st Zero Waste Online Store in Portugal. Vegan, organic, and plastic-free products that promote a more conscious lifestyle. Not applicable to promotional items. Code valid until 31/12/2025.',
        headerImage: AppImages.cocaColaCanBarcode,
        carouselImage: [AppImages.cocaColaCan, AppImages.cocaColaCans],
        logo: AppImages.pingoDoceWaterBottle,
        barcode: '1234567890123',
        category: ['Discount Coupons', 'Eco-friendly'],
        linkedRules: ['rule_1', 'rule_2'],
        canCheckout: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RewardModel(
        id: 2,
        title: 'Free Shipping Voucher',
        description:
            'Get free shipping on your next order over €25. Valid for sustainable and eco-friendly products only.',
        headerImage: AppImages.pingoDoceWaterBottleBarcode,
        carouselImage: [AppImages.pingoDoceWaterBottle],
        logo: AppImages.cocaColaCan,
        barcode: '2234567890123',
        category: ['Free Shipping', 'Eco-friendly'],
        linkedRules: ['rule_3'],
        canCheckout: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      RewardModel(
        id: 3,
        title: '€10 Gift Card',
        description:
            '€10 gift card for sustainable brands and eco-friendly products. Can be used on any participating store.',
        headerImage: AppImages.cocaColaCan,
        carouselImage: [AppImages.cocaColaCan, AppImages.cocaColaCans],
        logo: AppImages.pingoDoceWaterBottle,
        barcode: '3234567890123',
        category: ['Gift Cards', 'Cashback'],
        linkedRules: ['rule_1', 'rule_4'],
        canCheckout: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }

  void _initializeMockRules() {
    _availableRules.addAll([
      RuleModel(
        id: 'rule_1',
        title: 'Recycle 5 Plastic Bottles',
        description: 'Recycle 5 plastic bottles to unlock rewards',
        recycleCount: 5,
        categories: ['Plastic', 'Bottles'],
        priority: 'medium',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        createdBy: 'admin',
        tags: ['plastic', 'bottles'],
      ),
      RuleModel(
        id: 'rule_2',
        title: 'Recycle 3 Glass Items',
        description: 'Recycle 3 glass items to earn eco points',
        recycleCount: 3,
        categories: ['Glass'],
        priority: 'high',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        createdBy: 'admin',
        tags: ['glass'],
      ),
      RuleModel(
        id: 'rule_3',
        title: 'Recycle 10 Paper Items',
        description: 'Recycle 10 paper items for free shipping',
        recycleCount: 10,
        categories: ['Paper'],
        priority: 'low',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        createdBy: 'admin',
        tags: ['paper'],
      ),
      RuleModel(
        id: 'rule_4',
        title: 'Recycle 2 Electronic Items',
        description: 'Recycle 2 electronic items for special rewards',
        recycleCount: 2,
        categories: ['Electronic'],
        priority: 'high',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        createdBy: 'admin',
        tags: ['electronic'],
      ),
    ]);
  }

  @override
  Future<List<RewardModel>> getAllRewards() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate API call
    return _rewards.toList();
  }

  @override
  Future<RewardModel?> getRewardById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _rewards.firstWhereOrNull((reward) => reward.id == id);
  }

  @override
  Future<bool> createReward(RewardModel reward) async {
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      final newReward = reward.copyWith(
        id: _rewards.length + 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _rewards.add(newReward);
      log('✅ Reward created successfully: ${newReward.title}');
      return true;
    } catch (e) {
      log('❌ Failed to create reward: $e');
      return false;
    }
  }

  @override
  Future<bool> updateReward(RewardModel reward) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final index = _rewards.indexWhere((r) => r.id == reward.id);
      if (index != -1) {
        _rewards[index] = reward.copyWith(updatedAt: DateTime.now());
        log('✅ Reward updated successfully: ${reward.title}');
        return true;
      }
      log('❌ Reward not found for update: ${reward.id}');
      return false;
    } catch (e) {
      log('❌ Failed to update reward: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteReward(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final initialLength = _rewards.length;
      _rewards.removeWhere((reward) => reward.id == id);
      final removedCount = initialLength - _rewards.length;
      if (removedCount > 0) {
        log('✅ Reward deleted successfully: $id');
        return true;
      }
      log('❌ Reward not found for deletion: $id');
      return false;
    } catch (e) {
      log('❌ Failed to delete reward: $e');
      return false;
    }
  }

  @override
  List<RewardModel> filterRewardsByCategory(String category) {
    if (category.isEmpty) return _rewards.toList();
    return _rewards
        .where(
          (reward) => reward.category.any(
            (cat) => cat.toLowerCase().contains(category.toLowerCase()),
          ),
        )
        .toList();
  }

  @override
  List<RewardModel> filterRewardsByStatus(bool canCheckout) {
    return _rewards
        .where((reward) => reward.canCheckout == canCheckout)
        .toList();
  }

  @override
  List<RewardModel> searchRewards(String query) {
    if (query.isEmpty) return _rewards.toList();
    final lowercaseQuery = query.toLowerCase();
    return _rewards
        .where(
          (reward) =>
              reward.title.toLowerCase().contains(lowercaseQuery) ||
              reward.description.toLowerCase().contains(lowercaseQuery) ||
              reward.barcode.contains(query) ||
              reward.category.any(
                (cat) => cat.toLowerCase().contains(lowercaseQuery),
              ),
        )
        .toList();
  }

  @override
  List<String> getAllCategories() {
    return _categories.toList();
  }

  @override
  void addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
      log('✅ Category added: $category');
    }
  }

  @override
  void removeCategory(String category) {
    _categories.remove(category);
    log('✅ Category removed: $category');
  }

  @override
  Future<List<RuleModel>> getAllRules() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _availableRules.toList();
  }

  @override
  List<RuleModel> getRulesByIds(List<String> ruleIds) {
    return _availableRules.where((rule) => ruleIds.contains(rule.id)).toList();
  }

  @override
  bool validateRuleCompletion(String ruleId, String userId) {
    // Mock validation - in real app this would check user's recycling progress
    final rule = _availableRules.firstWhereOrNull((r) => r.id == ruleId);
    if (rule == null) return false;

    // Simulate random completion status for demo
    return DateTime.now().millisecond % 2 == 0;
  }

  @override
  Future<String> uploadImage(String imagePath) async {
    log('🔄 Controller: Uploading image from path: $imagePath');
    try {
      if (kIsWeb) {
        // For web, handle blob URLs
        log('🌐 Web platform detected - processing blob URL');
        await Future.delayed(
          const Duration(milliseconds: 1000),
        ); // Simulate upload delay

        // In a real app, you'd upload to a server and get back a URL
        // For demo, we'll return a mock URL or use the blob URL directly
        final webImageUrl =
            imagePath.startsWith('blob:')
                ? imagePath
                : 'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch}';

        log('✅ Controller: Returning web image URL: $webImageUrl');
        return webImageUrl;
      } else {
        // For mobile/desktop, handle local files
        log('📱 Mobile/Desktop platform detected - processing local file');

        // In a real app, you'd upload to cloud storage
        // For demo, return a mock URL
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final mockUrl =
            'https://storage.example.com/rewards/reward_image_$timestamp.jpg';

        await Future.delayed(const Duration(milliseconds: 1000));
        log('✅ Controller: Returning mock URL: $mockUrl');
        return mockUrl;
      }
    } catch (e) {
      log('💥 Controller error: $e');
      // Fallback: return a test image URL
      final fallbackUrl =
          'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch}';
      log('🔄 Using fallback URL: $fallbackUrl');
      return fallbackUrl;
    }
  }

  @override
  Future<bool> deleteImage(String imageUrl) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      // In a real app, you'd delete from cloud storage
      log('✅ Image deleted successfully: $imageUrl');
      return true;
    } catch (e) {
      log('❌ Failed to delete image: $e');
      return false;
    }
  }

  @override
  Future<bool> validateBarcode(String barcode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simple validation: check if barcode is 13 digits
    final isValid = barcode.length == 13 && int.tryParse(barcode) != null;
    log('🔍 Barcode validation for $barcode: $isValid');
    return isValid;
  }

  @override
  bool validateRewardData(RewardModel reward) {
    final isValid =
        reward.title.isNotEmpty &&
        reward.description.isNotEmpty &&
        reward.headerImage.isNotEmpty &&
        reward.barcode.isNotEmpty &&
        reward.category.isNotEmpty &&
        reward.linkedRules.isNotEmpty;

    log('🔍 Reward data validation: $isValid');
    return isValid;
  }

  @override
  Future<bool> bulkDeleteRewards(List<int> ids) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final initialLength = _rewards.length;
      for (int id in ids) {
        _rewards.removeWhere((reward) => reward.id == id);
      }
      final deletedCount = initialLength - _rewards.length;
      log('✅ Bulk deleted $deletedCount rewards');
      return deletedCount > 0;
    } catch (e) {
      log('❌ Failed to bulk delete rewards: $e');
      return false;
    }
  }

  @override
  Future<bool> bulkUpdateRewardStatus(List<int> ids, bool canCheckout) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      int updatedCount = 0;
      for (int i = 0; i < _rewards.length; i++) {
        if (ids.contains(_rewards[i].id)) {
          _rewards[i] = _rewards[i].copyWith(
            canCheckout: canCheckout,
            updatedAt: DateTime.now(),
          );
          updatedCount++;
        }
      }
      log('✅ Bulk updated $updatedCount rewards status to $canCheckout');
      return updatedCount > 0;
    } catch (e) {
      log('❌ Failed to bulk update reward status: $e');
      return false;
    }
  }

  @override
  Map<String, int> getRewardStatistics() {
    final totalRewards = _rewards.length;
    final activeRewards = _rewards.where((r) => r.canCheckout).length;
    final inactiveRewards = totalRewards - activeRewards;
    final totalCategories = _categories.length;
    final totalLinkedRules =
        _rewards.expand((r) => r.linkedRules).toSet().length;

    return {
      'totalRewards': totalRewards,
      'activeRewards': activeRewards,
      'inactiveRewards': inactiveRewards,
      'totalCategories': totalCategories,
      'totalLinkedRules': totalLinkedRules,
    };
  }

  @override
  List<RewardModel> getMostPopularRewards(int limit) {
    // Mock popularity based on creation date (newer = more popular)
    final sortedRewards =
        _rewards.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedRewards.take(limit).toList();
  }

  @override
  List<RewardModel> getRecentlyCreatedRewards(int limit) {
    final sortedRewards =
        _rewards.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedRewards.take(limit).toList();
  }

  // Helper method to get rules data for rewards
  List<RuleModel> getLinkedRulesForReward(RewardModel reward) {
    return getRulesByIds(reward.linkedRules);
  }

  // Method to check if user can checkout a reward
  bool canUserCheckoutReward(RewardModel reward, String userId) {
    if (!reward.canCheckout) return false;

    // Check if user has completed any of the linked rules
    for (String ruleId in reward.linkedRules) {
      if (validateRuleCompletion(ruleId, userId)) {
        return true;
      }
    }
    return false;
  }

  // Method to get rewards available for a specific user
  List<RewardModel> getAvailableRewardsForUser(String userId) {
    return _rewards
        .where((reward) => canUserCheckoutReward(reward, userId))
        .toList();
  }

  // Method to get rewards by category with pagination
  List<RewardModel> getRewardsByCategory(
    String category, {
    int page = 1,
    int limit = 10,
  }) {
    final filtered = filterRewardsByCategory(category);
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= filtered.length) return [];

    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }
}
