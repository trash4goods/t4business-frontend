import 'package:t4g_for_business/features/rules/data/models/rule.dart';

abstract class RulesControllerInterface {
  // Data access methods only - no observables
  List<RuleModel> getAllRules();
  RuleModel? getRuleById(String id);
  void createRule(String title, String description, int recycleCount, List<String> categories, String priority, List<String> tags);
  void updateRule(String id, String title, String description, int recycleCount, List<String> categories, String priority, List<String> tags);
  void deleteRule(String id);
  void duplicateRule(String id);
  
  // Utility methods
  List<RuleModel> filterRulesByCategory(List<String> categories);
  List<RuleModel> filterRulesByStatus(bool isActive);
  List<RuleModel> searchRules(String query);
  List<RuleModel> sortRules(List<RuleModel> rules, String sortBy);
  
  // Bulk operations
  void bulkDeleteRules(List<String> ids);
  void bulkUpdateRulesStatus(List<String> ids, bool isActive);
  
  // Data persistence
  void exportRulesToJson();
  void importRulesFromJson(String jsonData);
  
  // Categories management
  List<String> getAllCategories();
  void addCategory(String category);
  void removeCategory(String category);
}
