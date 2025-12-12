import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/features/rules/data/models/rule.dart';
import 'package:t4g_for_business/features/rules/presentation/controllers/interface/rule.dart';
import 'package:t4g_for_business/features/rules/presentation/controllers/implementation/rule.dart';
import '../../../../../core/app/app_routes.dart';
import '../../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../../data/models/product_item.dart';
import '../interface/rule.dart';
import '../../../../../utils/helpers/snackbar_service.dart';

class RulesPresenterImpl extends RulesPresenterInterface {
  RulesPresenterImpl({required this.controller, required this.dashboardShellController});
  final RulesControllerInterface controller;

  final DashboardShellControllerInterface dashboardShellController;
  final RxString _currentRoute = AppRoutes.rulesV2.obs;

  // Core data observables
  @override
  final RxList<RuleModel> rules = <RuleModel>[].obs;

  @override
  final RxList<RuleModel> filteredRules = <RuleModel>[].obs;

  @override
  final Rxn<String> selectedRuleId = Rxn<String>();

  // UI-related observables
  @override
  final RxBool isEditing = false.obs;

  @override
  final TextEditingController titleController = TextEditingController();

  @override
  final TextEditingController descriptionController = TextEditingController();

  @override
  final TextEditingController recycleCountController = TextEditingController();

  @override
  final RxSet<String> selectedCategories = <String>{}.obs;

  @override
  final RxSet<String> selectedCategoriesForm = <String>{}.obs;

  @override
  final RxString selectedPriority = 'medium'.obs;

  @override
  final RxBool selectedStatus = true.obs;

  @override
  final RxList<RecyclingProductItem> selectedProducts =
      <RecyclingProductItem>[].obs;

  // Available products for selection
  @override
  final RxList<RecyclingProductItem> availableProducts =
      <RecyclingProductItem>[].obs;

  // Search and filter observables
  @override
  final RxString searchQuery = ''.obs;

  @override
  final RxString selectedFilter = 'all'.obs;

  @override
  final RxSet<String> selectedCategoriesFilter = <String>{}.obs;

  @override
  final RxString sortBy = 'name'.obs;

  @override
  final RxString viewMode = 'grid'.obs;

  @override
  final RxBool isBulkMode = false.obs;

  @override
  final RxBool showCreateDialog = false.obs;

  @override
  late GlobalKey<ScaffoldState> scaffoldKey;
  @override
  late RxString currentRoute = _currentRoute;
  @override
  void onNavigate(String value) => dashboardShellController.handleMobileNavigation(value);
  @override
  void onLogout() => dashboardShellController.logout();
  @override
  void onToggle() => dashboardShellController.toggleSidebar();

  @override
  void onInit() {
    super.onInit();
        scaffoldKey = dashboardShellController.scaffoldKey;
    dashboardShellController.currentRoute.value = currentRoute.value;
    _setupFilters();
    refreshRules();
    loadMockData();
    _loadMockProducts();
    dialogListeners();
  }

  void dialogListeners() {
    ever(showCreateDialog, (show) {
      if (show) {
        showCreateDialog.value = false;
        _showCreateRuleDialog();
      }
    });
  }

  void _setupFilters() {
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedFilter, (_) => _applyFilters());
    ever(selectedCategoriesFilter, (_) => _applyFilters());
    ever(sortBy, (_) => _applyFilters());
    ever(rules, (_) => _applyFilters());
  }

  void _applyFilters() {
    List<RuleModel> filtered = List.from(rules);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = controller.searchRules(searchQuery.value);
    }

    // Apply status filter
    switch (selectedFilter.value) {
      case 'active':
        filtered = controller.filterRulesByStatus(true);
        break;
      case 'inactive':
        filtered = controller.filterRulesByStatus(false);
        break;
      case 'recent':
        filtered = controller.sortRules(filtered, 'date');
        filtered = filtered.take(10).toList();
        break;
    }

    // Apply category filter
    if (selectedCategoriesFilter.isNotEmpty) {
      filtered = controller.filterRulesByCategory(
        selectedCategoriesFilter.toList(),
      );
    }

    // Apply sorting
    filtered = controller.sortRules(filtered, sortBy.value);

    filteredRules.assignAll(filtered);
  }

  // Computed properties
  @override
  int get activeRulesCount => rules.where((rule) => rule.isActive).length;

  @override
  int get categoriesCount =>
      rules.expand((rule) => rule.categories).toSet().length;

  @override
  List<String> get availableCategories => controller.getAllCategories();

  // Core CRUD operations
  @override
  void onCreate(
    String title,
    String description,
    int recycleCount,
    List<String> categories,
    String priority,
    List<String> tags,
  ) {
    controller.createRule(
      title,
      description,
      recycleCount,
      categories,
      priority,
      tags,
    );
    refreshRules();
    clearForm();
  }

  @override
  void onUpdate(
    String id,
    String title,
    String description,
    int recycleCount,
    List<String> categories,
    String priority,
    List<String> tags,
  ) {
    controller.updateRule(
      id,
      title,
      description,
      recycleCount,
      categories,
      priority,
      tags,
    );
    refreshRules();
    clearForm();
    isEditing.value = false;
  }

  @override
  void deleteRule(String id) {
    controller.deleteRule(id);
    refreshRules();
    clearForm();
    isEditing.value = false;
  }

  @override
  void onEdit(String id) {
    final rule = controller.getRuleById(id);
    if (rule != null) {
      titleController.text = rule.title;
      descriptionController.text = rule.description;
      recycleCountController.text = rule.recycleCount.toString();
      selectedCategories.assignAll(rule.categories);
      selectedCategoriesForm.assignAll(rule.categories);
      selectedPriority.value = rule.priority;
      selectedRuleId.value = id;
      isEditing.value = true;
    }
  }

  @override
  void onCancelEdit() {
    clearForm();
    isEditing.value = false;
    selectedRuleId.value = null;
  }

  // Enhanced operations

  @override
  void onCreateRule() {
    clearForm();
    isEditing.value = false;
    showCreateDialog.value = true;
  }

  /*@override
  void onEditRule(String ruleId) {
    final rule = controller.getRuleById(ruleId);
    if (rule != null) {
      titleController.text = rule.title;
      descriptionController.text = rule.description;
      recycleCountController.text = rule.recycleCount.toString();
      selectedCategoriesForm.assignAll(rule.categories);
      selectedPriority.value = rule.priority;
      selectedRuleId.value = ruleId;
      isEditing.value = true;
      _showRuleDialog();
    }
  }*/

  @override
  void onDuplicateRule(String ruleId) {
    controller.duplicateRule(ruleId);
    refreshRules();
    SnackbarServiceHelper.showSuccess(
      'Rule duplicated successfully',
      position: SnackPosition.TOP,
      actionLabel: 'OK',
    );
  }

  @override
  void onDeleteRule(String ruleId) {
    showShadDialog(
      context: Get.context!,
      builder: (context) => ShadDialog(
        title: const Text('Delete Rule'),
        description: const Text(
          'Are you sure you want to delete this rule? This action cannot be undone.',
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () {
              controller.deleteRule(ruleId);
              refreshRules();
              Navigator.of(context).pop();
              SnackbarServiceHelper.showSuccess(
                'Rule deleted successfully',
                position: SnackPosition.TOP,
                actionLabel: 'OK',
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void onRuleSelected(String ruleId) {
    Get.toNamed('/rules/$ruleId');
  }

  // Search and filter operations
  @override
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  @override
  void onFilterChanged(String filter) {
    selectedFilter.value = filter;
  }

  @override
  void onCategoryFilterChanged(String category) {
    if (selectedCategoriesFilter.contains(category)) {
      selectedCategoriesFilter.remove(category);
    } else {
      selectedCategoriesFilter.add(category);
    }
  }

  @override
  void onSortChanged(String? sort) {
    if (sort != null) {
      sortBy.value = sort;
    }
  }

  // Bulk operations
  @override
  void toggleBulkMode() {
    isBulkMode.value = !isBulkMode.value;
  }

  @override
  void exportRules() {
    controller.exportRulesToJson();
    SnackbarServiceHelper.showInfo(
      'Rules exported successfully',
      position: SnackPosition.TOP,
      actionLabel: 'OK',
    );
  }

  @override
  void importRules() {
    SnackbarServiceHelper.showInfo(
      'Import functionality coming soon',
      position: SnackPosition.TOP,
      actionLabel: 'OK',
    );
  }

  // Utility methods
  @override
  void refreshRules() {
    rules.assignAll(controller.getAllRules());
  }

  /// Load mock data for development/testing purposes
  @override
  void loadMockData() {
    // Check if controller has loadMockData method
    if (controller is RulesControllerImpl) {
      (controller as RulesControllerImpl).loadMockData();
      refreshRules();
    }
  }

  /// Show confirmation dialog for clearing all rules
  @override
  void showClearAllRulesConfirmation() {
    showShadDialog(
      context: Get.context!,
      builder: (context) => ShadDialog.alert(
        title: const Text('Clear All Rules'),
        description: const Text(
          'Are you sure you want to clear all rules? This action cannot be undone and will remove all existing rules.',
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () {
              Navigator.of(context).pop();
              clearAllRules();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  /// Clear all rules and optionally reload with mock data
  @override
  void clearAllRules({bool reloadMockData = false}) {
    // Check if controller has clearRules method
    if (controller is RulesControllerImpl) {
      (controller as RulesControllerImpl).clearRules(
        reloadMockData: reloadMockData,
      );
      refreshRules();
    }
  }

  @override
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    recycleCountController.clear();
    selectedCategoriesForm.clear();
    selectedCategories.clear();
    selectedPriority.value = 'medium';
    selectedStatus.value = true;
    selectedProducts.clear();
    selectedRuleId.value = null;
    isEditing.value = false;
    isFormValid.value = false;
  }

  @override
  final RxBool isFormValid = false.obs;

  @override
  void validateForm() {
    isFormValid.value =
        titleController.text.isNotEmpty &&
        recycleCountController.text.isNotEmpty &&
        selectedProducts.isNotEmpty;
  }

  @override
  void onEditRule(String ruleId) {
    final rule = controller.getRuleById(ruleId);
    if (rule != null) {
      titleController.text = rule.title;
      descriptionController.text = rule.description;
      recycleCountController.text = rule.recycleCount.toString();
      selectedCategoriesForm.assignAll(rule.categories);
      selectedPriority.value = rule.priority;
      selectedStatus.value = rule.isActive;
      selectedRuleId.value = ruleId;
      // Initialize selectedProducts from the rule's linked categories/tags.
      // Since we currently persist linked products as category names (and tags),
      // reconstruct the selection by matching availableProducts by title.
      final ruleTitles = rule.categories.map((c) => c.toLowerCase()).toSet();
      final matchedProducts = availableProducts
          .where((p) => ruleTitles.contains(p.title.toLowerCase()))
          .toList();
      selectedProducts.assignAll(matchedProducts);
      isEditing.value = true;
      validateForm();
      showCreateDialog.value = true;
    }
  }

  @override
  void onCreateNewRule(
    String title,
    int recycleCount,
    List<RecyclingProductItem> products,
    bool isActive,
  ) {
    // Create categories from selected products
    final categories = products.map((product) => product.title).toList();
    
    // Create rule using the existing controller method
    controller.createRule(
      title,
      '', // description - could be enhanced later
      recycleCount,
      categories,
      'medium', // default priority
      products.map((product) => product.title.toLowerCase()).toList(), // tags from products
    );
    
    // Update the rule's status if it's not active
    if (!isActive) {
      final rules = controller.getAllRules();
      if (rules.isNotEmpty) {
        final newRule = rules.last; // Get the just-created rule
        controller.bulkUpdateRulesStatus([newRule.id], isActive);
      }
    }
    
    refreshRules();
    clearForm();
  }

  @override
  void onUpdateRule(
    String id,
    String title,
    int recycleCount,
    List<RecyclingProductItem> products,
    bool isActive,
  ) {
    // Create categories from selected products
    final categories = products.map((product) => product.title).toList();
    
    // Update rule using the existing controller method
    controller.updateRule(
      id,
      title,
      '', // description - could be enhanced later
      recycleCount,
      categories,
      'medium', // default priority
      products.map((product) => product.title.toLowerCase()).toList(), // tags from products
    );
    
    // Update the rule's status
    controller.bulkUpdateRulesStatus([id], isActive);
    
    refreshRules();
    clearForm();
  }

  /// Load mock products for development/testing
  void _loadMockProducts() {
    final mockProducts = [
      RecyclingProductItem(
        id: '1',
        title: 'Coca-Cola Zero 330ml',
        description: 'Sugar-free cola drink in aluminum can',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      RecyclingProductItem(
        id: '2',
        title: 'Coca-Cola 1L',
        description: 'Classic cola drink in plastic bottle',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      RecyclingProductItem(
        id: '3',
        title: 'Pepsi 500ml',
        description: 'Cola drink in plastic bottle',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      RecyclingProductItem(
        id: '4',
        title: 'Sprite 330ml Can',
        description: 'Lemon-lime soda in aluminum can',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      RecyclingProductItem(
        id: '5',
        title: 'Fanta Orange 2L',
        description: 'Orange flavored soda in plastic bottle',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      RecyclingProductItem(
        id: '6',
        title: 'Water Bottle 500ml',
        description: 'Pure water in recyclable plastic bottle',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      RecyclingProductItem(
        id: '7',
        title: 'Red Bull 250ml',
        description: 'Energy drink in aluminum can',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      RecyclingProductItem(
        id: '8',
        title: 'Juice Box 200ml',
        description: 'Apple juice in recyclable carton',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ];

    availableProducts.assignAll(mockProducts);
  }

  /// Toggle product selection
  @override
  void toggleProductSelection(RecyclingProductItem product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
    validateForm();
  }

  /// Check if product is selected
  @override
  bool isProductSelected(RecyclingProductItem product) {
    return selectedProducts.contains(product);
  }

  void _showCreateRuleDialog() {
    showShadDialog(
      context: Get.context!,
      builder:
          (context) => ShadDialog(
            title: Text(isEditing.value ? 'Edit Rule' : 'Create New Rule'),
            description: const Text(
              "Configure your recycling rule. Click save when you're done.",
            ),
            actions: [
              ShadButton.outline(
                onPressed: () {
                  clearForm();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              Obx(
                () => ShadButton(
                  onPressed:
                      isFormValid.value
                          ? () {
                            _saveRule();
                            Navigator.of(context).pop();
                          }
                          : null,
                  child: Text(isEditing.value ? 'Update Rule' : 'Create Rule'),
                ),
              ),
            ],
            child: Container(
              width: 375,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _buildRuleForm(),
            ),
          ),
    );
  }

  Widget _buildRuleForm() {
    final theme = ShadTheme.of(Get.context!);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Title Field
        Row(
          children: [
            Expanded(
              child: Text(
                'Title',
                textAlign: TextAlign.end,
                style: theme.textTheme.small,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: ShadInput(
                controller: titleController,
                placeholder: const Text('Enter rule title'),
                onChanged: (_) => validateForm(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Recycle Times Field
        Row(
          children: [
            Expanded(
              child: Text(
                'Recycle Times',
                textAlign: TextAlign.end,
                style: theme.textTheme.small,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: ShadInput(
                controller: recycleCountController,
                placeholder: const Text('Enter number (e.g., 5)'),
                keyboardType: TextInputType.number,
                onChanged: (_) => validateForm(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Status Field
        Row(
          children: [
            Expanded(
              child: Text(
                'Status',
                textAlign: TextAlign.end,
                style: theme.textTheme.small,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Obx(() => Row(
                children: [
                  ShadSwitch(
                    value: selectedStatus.value,
                    onChanged: (value) {
                      selectedStatus.value = value;
                      validateForm();
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(selectedStatus.value ? 'Active' : 'Inactive'),
                ],
              )),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Link Product Field
        Row(
          children: [
            Expanded(
              child: Text(
                'Link Product',
                textAlign: TextAlign.end,
                style: theme.textTheme.small,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: ShadButton.outline(
                onPressed: _showProductSelector,
                child: const Text('Select Products'),
              ),
            ),
          ],
        ),

        // Show selected products
        Obx(() {
          if (selectedProducts.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Products:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      selectedProducts.map((product) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF0F172A,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  selectedProducts.remove(product);
                                  validateForm();
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _saveRule() {
    if (titleController.text.isEmpty || recycleCountController.text.isEmpty) {
      SnackbarServiceHelper.showError(
        'Please fill in all required fields',
        position: SnackPosition.TOP,
        actionLabel: 'OK',
      );
      return;
    }

    final recycleCount = int.tryParse(recycleCountController.text);
    if (recycleCount == null || recycleCount <= 0) {
      SnackbarServiceHelper.showError(
        'Please enter a valid recycle count',
        position: SnackPosition.TOP,
        actionLabel: 'OK',
      );
      return;
    }

    if (selectedProducts.isEmpty) {
      SnackbarServiceHelper.showError(
        'Please select at least one product',
        position: SnackPosition.TOP,
        actionLabel: 'OK',
      );
      return;
    }

    if (isEditing.value && selectedRuleId.value != null) {
      onUpdateRule(
        selectedRuleId.value!,
        titleController.text,
        recycleCount,
        selectedProducts.toList(),
        selectedStatus.value,
      );
    } else {
      onCreateNewRule(
        titleController.text,
        recycleCount,
        selectedProducts.toList(),
        selectedStatus.value,
      );
    }

    SnackbarServiceHelper.showSuccess(
      isEditing.value
          ? 'Rule updated successfully'
          : 'Rule created successfully',
      position: SnackPosition.TOP,
      actionLabel: 'OK',
    );
  }

  void _showProductSelector() {
    showShadSheet(
      side: ShadSheetSide.bottom,
      context: Get.context!,
      builder: (context) => Obx(() => _buildProductSelectionSheet()),
    );
  }

  Widget _buildProductSelectionSheet() {
    final screenHeight = MediaQuery.of(Get.context!).size.height;
    final sheetHeight = screenHeight * 0.4; // 40% of screen height

    return ShadSheet(
      title: const Text('Link Products'),
      description: const Text('Select products to link with this rule'),
      child: Container(
        width: double.infinity,
        height: sheetHeight,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Products list
            Expanded(
              child: ListView.builder(
                itemCount: availableProducts.length,
                itemBuilder: (context, index) {
                  final product = availableProducts[index];
                  final isSelected = isProductSelected(product);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(
                                    0xFF0F172A,
                                  ).withValues(alpha: 0.1)
                                  : const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFE2E8F0),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () => toggleProductSelection(product),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                // Product icon
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF0F172A,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.inventory_2,
                                    size: 16,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Product info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0F172A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        product.description,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF64748B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),

                                // Selection indicator
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0F172A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Footer with action buttons
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${selectedProducts.length} selected',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                ShadButton.outline(
                  size: ShadButtonSize.sm,
                  onPressed: () {
                    selectedProducts.clear();
                    validateForm();
                  },
                  child: const Text('Clear'),
                ),
                const SizedBox(width: 8),
                ShadButton(
                  size: ShadButtonSize.sm,
                  onPressed: () => Navigator.of(Get.context!).pop(),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
