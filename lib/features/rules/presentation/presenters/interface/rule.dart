import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/features/rules/data/models/rule.dart';
import '../../../data/models/product_item.dart';

abstract class RulesPresenterInterface extends GetxController {
  // Core data observables
  RxList<RuleModel> get rules;
  RxList<RuleModel> get filteredRules;
  Rxn<String> get selectedRuleId;

  // UI-related observables
  RxBool get isEditing;
  TextEditingController get titleController;
  TextEditingController get descriptionController;
  TextEditingController get recycleCountController;
  RxSet<String> get selectedCategories;
  RxSet<String> get selectedCategoriesForm;
  RxString get selectedPriority;
  RxBool get selectedStatus;
  RxList<RecyclingProductItem> get selectedProducts;
  RxList<RecyclingProductItem> get availableProducts;

  // Search and filter observables
  RxString get searchQuery;
  RxString get selectedFilter;
  RxSet<String> get selectedCategoriesFilter;
  RxString get sortBy;
  RxString get viewMode;
  RxBool get isBulkMode;

  // Computed properties
  int get activeRulesCount;
  int get categoriesCount;
  List<String> get availableCategories;

  // Form validation
  RxBool get isFormValid;
  RxBool get showCreateDialog;

  // Core CRUD operations
  void onCreate(
    String title,
    String description,
    int recycleCount,
    List<String> categories,
    String priority,
    List<String> tags,
  );
  void onUpdate(
    String id,
    String title,
    String description,
    int recycleCount,
    List<String> categories,
    String priority,
    List<String> tags,
  );
  void deleteRule(String id);
  void onEdit(String id);
  void onCancelEdit();

  // Enhanced operations
  void onCreateRule();
  void onEditRule(String ruleId);
  void onCreateNewRule(
    String title,
    int recycleCount,
    List<RecyclingProductItem> products,
    bool isActive,
  );
  void onUpdateRule(
    String id,
    String title,
    int recycleCount,
    List<RecyclingProductItem> products,
    bool isActive,
  );
  void onDuplicateRule(String ruleId);
  void onDeleteRule(String ruleId);
  void onRuleSelected(String ruleId);

  // Search and filter operations
  void onSearchChanged(String query);
  void onFilterChanged(String filter);
  void onCategoryFilterChanged(String category);
  void onSortChanged(String? sort);

  // Bulk operations
  void toggleBulkMode();
  void exportRules();
  void importRules();

  // Utility methods
  void refreshRules();
  void clearForm();

  // Development/Testing methods
  void loadMockData();
  void clearAllRules({bool reloadMockData = false});

  // Form methods
  void validateForm();
  
  // Product selection methods
  void toggleProductSelection(RecyclingProductItem product);
  bool isProductSelected(RecyclingProductItem product);
}
