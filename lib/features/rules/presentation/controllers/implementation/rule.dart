import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/features/rules/data/models/rule.dart';
import 'package:t4g_for_business/features/rules/presentation/presenters/interface/rule.dart';
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

  // UI helpers
  @override
  void showRuleActions(RuleModel rule, RulesPresenterInterface presenter) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ShadButton.outline(
                onPressed: () {
                  Get.back();
                  presenter.onEditRule(rule.id);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit Rule')],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ShadButton.outline(
                onPressed: () {
                  Get.back();
                  presenter.onDuplicateRule(rule.id);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.copy, size: 16), SizedBox(width: 8), Text('Duplicate Rule')],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ShadButton.destructive(
                onPressed: () {
                  Get.back();
                  presenter.onDeleteRule(rule.id);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.delete, size: 16), SizedBox(width: 8), Text('Delete Rule')],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  void showMobileFiltersBottomSheet(RulesPresenterInterface presenter) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 16),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  presenter.selectedFilter.value == 'all'
                      ? const ShadButton(size: ShadButtonSize.sm, child: Text('All', style: TextStyle(fontSize: 12)))
                      : ShadButton.outline(
                          onPressed: () => presenter.onFilterChanged('all'),
                          size: ShadButtonSize.sm,
                          child: const Text('All', style: TextStyle(fontSize: 12)),
                        ),
                  presenter.selectedFilter.value == 'active'
                      ? const ShadButton(size: ShadButtonSize.sm, child: Text('Active', style: TextStyle(fontSize: 12)))
                      : ShadButton.outline(
                          onPressed: () => presenter.onFilterChanged('active'),
                          size: ShadButtonSize.sm,
                          child: const Text('Active', style: TextStyle(fontSize: 12)),
                        ),
                  presenter.selectedFilter.value == 'inactive'
                      ? const ShadButton(size: ShadButtonSize.sm, child: Text('Inactive', style: TextStyle(fontSize: 12)))
                      : ShadButton.outline(
                          onPressed: () => presenter.onFilterChanged('inactive'),
                          size: ShadButtonSize.sm,
                          child: const Text('Inactive', style: TextStyle(fontSize: 12)),
                        ),
                  presenter.selectedFilter.value == 'recent'
                      ? const ShadButton(size: ShadButtonSize.sm, child: Text('Recent', style: TextStyle(fontSize: 12)))
                      : ShadButton.outline(
                          onPressed: () => presenter.onFilterChanged('recent'),
                          size: ShadButtonSize.sm,
                          child: const Text('Recent', style: TextStyle(fontSize: 12)),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categories', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
                const SizedBox(height: 8),
                Obx(
                  () => Column(
                    children: presenter.availableCategories.map((category) {
                      final isSelected = presenter.selectedCategoriesFilter.contains(category);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            ShadCheckbox(
                              value: isSelected,
                              onChanged: (value) => presenter.onCategoryFilterChanged(category),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(category, style: const TextStyle(fontSize: 12))),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ShadButton(
                onPressed: () => Get.back(),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
