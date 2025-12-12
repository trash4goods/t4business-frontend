import '../../../../rules/data/models/rule.dart';
import '../../../data/models/product.dart';

abstract class RewardsControllerInterface {
  // Core CRUD operations
  Future<List<RewardModel>> getAllRewards();
  Future<RewardModel?> getRewardById(int id);
  Future<bool> createReward(RewardModel reward);
  Future<bool> updateReward(RewardModel reward);
  Future<bool> deleteReward(int id);

  // Filtering and searching
  List<RewardModel> filterRewardsByCategory(String category);
  List<RewardModel> filterRewardsByStatus(bool canCheckout);
  List<RewardModel> searchRewards(String query);

  // Categories management
  List<String> getAllCategories();
  void addCategory(String category);
  void removeCategory(String category);

  // Rules integration
  Future<List<RuleModel>> getAllRules();
  List<RuleModel> getRulesByIds(List<String> ruleIds);
  bool validateRuleCompletion(String ruleId, String userId);

  // Image upload functionality
  Future<String> uploadImage(String imagePath);
  Future<bool> deleteImage(String imageUrl);

  // Validation
  Future<bool> validateBarcode(String barcode);
  bool validateRewardData(RewardModel reward);

  // Bulk operations
  Future<bool> bulkDeleteRewards(List<int> ids);
  Future<bool> bulkUpdateRewardStatus(List<int> ids, bool canCheckout);

  // Analytics and reporting
  Map<String, int> getRewardStatistics();
  List<RewardModel> getMostPopularRewards(int limit);
  List<RewardModel> getRecentlyCreatedRewards(int limit);
}
