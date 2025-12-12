import 'package:t4g_for_business/features/rules/data/models/rule.dart';
import '../interface/rule.dart';

class RulesControllerImpl implements RulesControllerInterface {
  // Private data storage - no observables here
  final List<RuleModel> _rules = [];
  final List<String> _categories = [
    'Plastic',
    'Glass',
    'Metal',
    'Paper',
    'Electronic',
    'Organic',
  ];

  /// Initialize controller with mock data for development/testing
  RulesControllerImpl({bool useMockData = false}) {
    if (useMockData) {
      _initializeMockData();
    }
  }

  /// Initialize the controller with predefined mock rules
  void _initializeMockData() {
    _rules.clear();
    _rules.addAll(RuleModel.getMockRules());
  }

  /// Manually load mock data (useful for development)
  void loadMockData() {
    _initializeMockData();
  }

  /// Clear all rules and optionally reload with mock data
  void clearRules({bool reloadMockData = false}) {
    _rules.clear();
    if (reloadMockData) {
      _initializeMockData();
    }
  }

  @override
  List<RuleModel> getAllRules() {
    return List.from(_rules);
  }

  @override
  RuleModel? getRuleById(String id) {
    try {
      return _rules.firstWhere((rule) => rule.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void createRule(
    String title,
    String description,
    int recycleCount,
    List<String> categories,
    String priority,
    List<String> tags,
  ) {
    final rule = RuleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      recycleCount: recycleCount,
      categories: categories,
      priority: priority,
      isActive: true,
      createdAt: DateTime.now(),
      createdBy: 'current_user', // Replace with actual user
      tags: tags,
    );
    _rules.add(rule);
  }

  @override
  void updateRule(
    String id,
    String title,
    String description,
    int recycleCount,
    List<String> categories,
    String priority,
    List<String> tags,
  ) {
    final index = _rules.indexWhere((rule) => rule.id == id);
    if (index != -1) {
      final existingRule = _rules[index];
      _rules[index] = existingRule.copyWith(
        title: title,
        description: description,
        recycleCount: recycleCount,
        categories: categories,
        priority: priority,
        lastModified: DateTime.now(),
        tags: tags,
      );
    }
  }

  @override
  void deleteRule(String id) {
    _rules.removeWhere((rule) => rule.id == id);
  }

  @override
  void duplicateRule(String id) {
    final originalRule = getRuleById(id);
    if (originalRule != null) {
      createRule(
        '${originalRule.title} (Copy)',
        originalRule.description,
        originalRule.recycleCount,
        originalRule.categories,
        originalRule.priority,
        [...originalRule.tags, 'duplicate'],
      );
    }
  }

  @override
  List<RuleModel> filterRulesByCategory(List<String> categories) {
    if (categories.isEmpty) return getAllRules();
    return _rules.where((rule) {
      return rule.categories.any((cat) => categories.contains(cat));
    }).toList();
  }


  @override
  List<RuleModel> filterRulesByStatus(bool isActive) {
    return _rules.where((rule) => rule.isActive == isActive).toList();
  }

  @override
  List<RuleModel> searchRules(String query) {
    if (query.isEmpty) return getAllRules();
    final lowercaseQuery = query.toLowerCase();
    return _rules.where((rule) {
      return rule.title.toLowerCase().contains(lowercaseQuery) ||
          rule.description.toLowerCase().contains(lowercaseQuery) ||
          rule.categories.any(
            (cat) => cat.toLowerCase().contains(lowercaseQuery),
          ) ||
          rule.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  @override
  List<RuleModel> sortRules(List<RuleModel> rules, String sortBy) {
    final sortedRules = List<RuleModel>.from(rules);
    switch (sortBy) {
      case 'name':
        sortedRules.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'date':
        sortedRules.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'priority':
        final priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
        sortedRules.sort(
          (a, b) => (priorityOrder[b.priority] ?? 0).compareTo(
            priorityOrder[a.priority] ?? 0,
          ),
        );
        break;
      case 'category':
        sortedRules.sort(
          (a, b) => a.categories.first.compareTo(b.categories.first),
        );
        break;
    }
    return sortedRules;
  }

  @override
  void bulkDeleteRules(List<String> ids) {
    _rules.removeWhere((rule) => ids.contains(rule.id));
  }

  @override
  void bulkUpdateRulesStatus(List<String> ids, bool isActive) {
    for (int i = 0; i < _rules.length; i++) {
      if (ids.contains(_rules[i].id)) {
        _rules[i] = _rules[i].copyWith(
          isActive: isActive,
          lastModified: DateTime.now(),
        );
      }
    }
  }

  @override
  void exportRulesToJson() {
    // Implementation for exporting rules to JSON
    // This would typically involve converting rules to JSON and saving to file
  }

  @override
  void importRulesFromJson(String jsonData) {
    // Implementation for importing rules from JSON
    // This would typically involve parsing JSON and creating Rule objects
  }

  @override
  List<String> getAllCategories() {
    return List.from(_categories);
  }

  @override
  void addCategory(String category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
    }
  }

  @override
  void removeCategory(String category) {
    _categories.remove(category);
  }
}
