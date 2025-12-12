import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/app_routes.dart';
import '../../../auth/data/datasources/auth_cache.dart';
import '../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../../data/models/rules_result.dart';
import '../../data/usecase/rules_usecase.interface.dart';
import '../../../rewards/data/models/reward_result.dart';
import '../../../product_managment/data/models/barcode/barcode_result.dart';
import 'rules_v2_presenter.interface.dart';

class RulesV2PresenterImpl extends RulesV2PresenterInterface {
  final RulesV2UseCaseInterface useCase;
  final DashboardShellControllerInterface dashboardShellController;

  RulesV2PresenterImpl({
    required this.useCase,
    required this.dashboardShellController,
  });

  @override
  late GlobalKey<ScaffoldState> scaffoldKey;
  @override
  late String currentRoute;

  // OBX registered variables
  final _rules = Rxn<List<RulesResultModel>>();
  final _filteredRules = Rxn<List<RulesResultModel>>();
  final _selectedStatusFilter = RxString('active');
  final _statusFilters = RxList<String>(['active', 'inactive']);
  final _selectedFilter = RxString('all');
  final _viewMode = RxString('list');
  final _searchQuery = RxString('');
  final _isCreatingRule = RxBool(false);
  final _isEditingRule = RxnBool();

  // Pagination observables
  final _currentPage = RxInt(1);
  final _totalCount = RxInt(0);
  final _hasNextPage = RxBool(false);
  final _perPage = RxInt(10);
  final _isLoading = RxBool(false);

  // Create rule form observables
  final _createRuleStatus = RxBool(true);
  final _createRuleExpiryDate = Rxn<DateTime>();

  // Edit rule state
  final _currentEditingRule = Rxn<RulesResultModel>();
  RulesResultModel? _originalEditRuleData;
  final _isCreateRuleFormValid = RxBool(false);
  final _createRuleNameError = RxString('');
  final _createRuleQuantityError = RxString('');
  final _createRuleCooldownPeriodError = RxString('');
  final _createRuleUsageLimitError = RxString('');
  final _createRuleExpiryDateError = RxString('');
  final _barcodeSelectionError = RxString('');
  final _rewardSelectionError = RxString('');

  // Selection state observables
  final _selectedRewardIds = RxList<int>([]);
  final _selectedBarcodeIds = RxList<int>([]);

  // Toggle state observables (CREATE mode)
  final _allProducts = RxBool(false);
  final _allBarcodes = RxBool(false);

  // Toggle state observables (EDIT mode)
  final _addAllProducts = RxBool(false);
  final _addAllBarcodes = RxBool(false);
  final _removeAll = RxBool(false);

  // Store original selections for cancel functionality
  List<int> _originalSelectedRewardIds = [];
  List<int> _originalSelectedBarcodeIds = [];

  // Store original rule selections for edit delta calculations
  List<int> _originalRuleRewardIds = [];
  List<int> _originalRuleBarcodeIds = [];
  final _rewardSelectionItems = RxList<RewardResultModel>([]);
  final _barcodeSelectionItems = RxList<BarcodeResultModel>([]);
  final _isSelectionLoading = RxBool(false);
  final _selectionSearchQuery = RxString('');
  // Selection pagination observables
  final _selectionCurrentPage = RxInt(1);
  final _selectionTotalCount = RxInt(0);
  final _selectionPerPage = RxInt(10);
  final _selectionHasNext = RxBool(false);

  // Rules data getters and setters
  @override
  final nameTextFieldController = TextEditingController();
  @override
  final quantityTextFieldController = TextEditingController();
  @override
  final cooldownPeriodTextFieldController = TextEditingController();
  @override
  final usageLimitTextFieldController = TextEditingController();

  @override
  bool get isCreatingRule => _isCreatingRule.value;
  @override
  set isCreatingRule(bool value) => _isCreatingRule.value = value;

  @override
  bool? get isEditingRule => _isEditingRule.value;
  @override
  set isEditingRule(bool? value) => _isEditingRule.value = value;
  @override
  void refreshIsEditingRule() => _isEditingRule.refresh();

  @override
  List<RulesResultModel>? get rules => _rules.value;

  @override
  List<RulesResultModel>? get filteredRules => _filteredRules.value;
  @override
  set filteredRules(List<RulesResultModel>? value) =>
      _filteredRules.value = value;

  @override
  String get selectedStatusFilter => _selectedStatusFilter.value;
  @override
  set selectedStatusFilter(String value) => _selectedStatusFilter.value = value;

  @override
  List<String> get statusFilters => _statusFilters;
  @override
  set statusFilters(List<String> value) => _statusFilters.value = value;

  @override
  String get selectedFilter => _selectedFilter.value;
  @override
  set selectedFilter(String value) => _selectedFilter.value = value;

  @override
  String get viewMode => _viewMode.value;
  @override
  set viewMode(String value) => _viewMode.value = value;

  @override
  String get searchQuery => _searchQuery.value;
  @override
  set searchQuery(String value) => _searchQuery.value = value;

  // Pagination getters and setters
  @override
  int get currentPage => _currentPage.value;
  @override
  set currentPage(int value) => _currentPage.value = value;

  @override
  int get totalCount => _totalCount.value;
  @override
  set totalCount(int value) => _totalCount.value = value;

  @override
  bool get hasNextPage => _hasNextPage.value;
  @override
  set hasNextPage(bool value) => _hasNextPage.value = value;

  @override
  int get perPage => _perPage.value;
  @override
  set perPage(int value) => _perPage.value = value;

  @override
  bool get isLoading => _isLoading.value;
  @override
  set isLoading(bool value) => _isLoading.value = value;

  // Create rule form getters and setters
  @override
  bool get createRuleStatus => _createRuleStatus.value;
  @override
  set createRuleStatus(bool value) => _createRuleStatus.value = value;

  @override
  DateTime? get createRuleExpiryDate => _createRuleExpiryDate.value;
  @override
  set createRuleExpiryDate(DateTime? value) =>
      _createRuleExpiryDate.value = value;

  @override
  RulesResultModel? get currentEditingRule => _currentEditingRule.value;
  @override
  set currentEditingRule(RulesResultModel? rule) =>
      _currentEditingRule.value = rule;

  @override
  bool get hasFormChanges => _computeHasChanges();

  @override
  bool get isCreateRuleFormValid => _isCreateRuleFormValid.value;

  @override
  String? get createRuleNameError =>
      _createRuleNameError.value.isEmpty ? null : _createRuleNameError.value;

  @override
  String? get createRuleQuantityError =>
      _createRuleQuantityError.value.isEmpty
          ? null
          : _createRuleQuantityError.value;

  @override
  String? get createRuleCooldownPeriodError =>
      _createRuleCooldownPeriodError.value.isEmpty
          ? null
          : _createRuleCooldownPeriodError.value;

  @override
  String? get createRuleUsageLimitError =>
      _createRuleUsageLimitError.value.isEmpty
          ? null
          : _createRuleUsageLimitError.value;

  @override
  String? get createRuleExpiryDateError =>
      _createRuleExpiryDateError.value.isEmpty
          ? null
          : _createRuleExpiryDateError.value;

  @override
  bool get isBarcodeSelectionValid {
    final hasRewards = _selectedRewardIds.isNotEmpty;
    final hasBarcodes = _selectedBarcodeIds.isNotEmpty;
    final isEditMode = _currentEditingRule.value != null;

    final rewardsToggle = isEditMode ? addAllProducts : allProducts;
    final barcodesToggle = isEditMode ? addAllBarcodes : allBarcodes;
    final removeAllToggle = isEditMode ? removeAll : false;

    if (removeAllToggle) return true; // Always valid if removing all

    return (!hasRewards && !hasBarcodes) ||
        (hasRewards && hasBarcodes) ||
        (rewardsToggle && barcodesToggle) ||
        (barcodesToggle && !rewardsToggle && hasRewards) ||
        (rewardsToggle && !barcodesToggle && hasBarcodes);
  }

  @override
  String? get barcodeSelectionError =>
      _barcodeSelectionError.value.isEmpty
          ? null
          : _barcodeSelectionError.value;

  @override
  String? get rewardSelectionError =>
      _rewardSelectionError.value.isEmpty ? null : _rewardSelectionError.value;

  @override
  bool get canSaveRule =>
      _isCreateRuleFormValid.value && isBarcodeSelectionValid;

  @override
  void onInit() {
    super.onInit();
    scaffoldKey = dashboardShellController.scaffoldKey;
    currentRoute = AppRoutes.rulesV2;
    dashboardShellController.currentRoute.value = currentRoute;

    _initializeViewMode();
    loadRules();

    log(
      '[RulesV2Presenter] Initialized with search and filter functionality ready',
    );
  }

  void _initializeViewMode() {
    // Set default view mode based on screen size
    final screenWidth = Get.width;
    final isMobileOrTablet = screenWidth < 1200;
    _viewMode.value =
        (isMobileOrTablet ? 'list' : 'list'); // for now set all default as list
  }

  /// Loads rules from API following the rewards pattern
  @override
  Future<void> loadRules() async {
    try {
      _isLoading.value = true;

      // Get user token
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if (cachedUser?.accessToken == null) {
        log('[RulesV2PresenterImpl] No access token available');
        return;
      }

      final result = await useCase.getRules(
        token: cachedUser!.accessToken!,
        page: _currentPage.value,
        perPage: _perPage.value,
        search: _searchQuery.value,
      );

      if (result != null) {
        // Update pagination state
        if (result.pagination != null) {
          _totalCount.value = result.pagination!.count ?? 0;
          _hasNextPage.value = result.pagination!.hasNext ?? false;
          _perPage.value = result.pagination!.perPage ?? 10;

          // Calculate safe current page
          final apiPage = result.pagination!.page ?? 1;
          final calculatedTotalPages =
              _totalCount.value > 0
                  ? ((_totalCount.value / _perPage.value).ceil())
                  : 1;

          _currentPage.value = apiPage.clamp(1, calculatedTotalPages);
        }

        _filteredRules.value = result.result?.toList() ?? [];
        _rules.value = _filteredRules.value;

        // Apply initial filtering based on default status filter
        _applyInitialFilters();
      }
    } catch (e) {
      log('[RulesV2PresenterImpl] Error loading rules: $e');
      _filteredRules.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  void _applyInitialFilters() {
    // Apply status filter based on default selectedStatusFilter ('active')
    if (_selectedStatusFilter.value == 'active') {
      _filteredRules.value =
          _rules.value
              ?.where(
                (rule) => (rule.status ?? 'inactive').toLowerCase() == 'active',
              )
              .toList();
    } else if (_selectedStatusFilter.value == 'inactive') {
      _filteredRules.value =
          _rules.value
              ?.where(
                (rule) =>
                    (rule.status ?? 'inactive').toLowerCase() == 'inactive',
              )
              .toList();
    }
    // For 'all' or other values, keep all rules (no filtering)
  }

  @override
  void applyFilters() {
    log(
      '[RulesV2Presenter] Applying filters - Status: $selectedStatusFilter, Search: "$searchQuery"',
    );

    // Always start from the original rules list
    var filtered = (_rules.value ?? []).toList();

    if (filtered.isEmpty) {
      log('[RulesV2Presenter] No rules to filter');
      return;
    }

    log('[RulesV2Presenter] Starting with ${filtered.length} rules');

    // Status filter
    switch (selectedStatusFilter) {
      case 'active':
        filtered =
            filtered
                .where(
                  (rule) =>
                      (rule.status ?? 'inactive').toLowerCase() == 'active',
                )
                .toList();
        log('[RulesV2Presenter] After active filter: ${filtered.length} rules');
        break;
      case 'inactive':
        filtered =
            filtered
                .where(
                  (rule) =>
                      (rule.status ?? 'inactive').toLowerCase() == 'inactive',
                )
                .toList();
        log(
          '[RulesV2Presenter] After inactive filter: ${filtered.length} rules',
        );
        break;
      default:
        // all - no status filtering
        break;
    }

    // Search filter - search in name only (rules don't have description field)
    if (searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (rule) => (rule.name ?? '').toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
              )
              .toList();
      log(
        '[RulesV2Presenter] After search filter ("$searchQuery"): ${filtered.length} rules',
      );
    }

    _filteredRules.value = filtered;
    log('[RulesV2Presenter] Final filtered rules: ${filtered.length}');
  }

  @override
  void validateCreateRuleForm() {
    // Reset all errors first
    _createRuleNameError.value = '';
    _createRuleQuantityError.value = '';
    _createRuleCooldownPeriodError.value = '';
    _createRuleUsageLimitError.value = '';
    _createRuleExpiryDateError.value = '';
    _barcodeSelectionError.value = '';
    _rewardSelectionError.value = '';

    // Validate name field (required)
    final name = nameTextFieldController.text.trim();
    if (name.isEmpty) {
      _createRuleNameError.value = 'Rule name is required';
    } else if (name.length < 3) {
      _createRuleNameError.value = 'Name must be at least 3 characters';
    } else if (name.length > 50) {
      _createRuleNameError.value = 'Name must not exceed 50 characters';
    } else {
      // In edit mode, allow the same name if it's the current rule being edited
      final isEditMode = _currentEditingRule.value != null;
      final currentRuleName = _currentEditingRule.value?.name;

      if (isEditMode && name == currentRuleName) {
        // Allow keeping the same name in edit mode
        // No validation error
      } else {
        // TODO: Add duplicate name check against other rules
        // This would require checking against the rules list
        // For now, we'll skip this validation
      }
    }

    // Validate quantity field (required)
    final quantityText = quantityTextFieldController.text.trim();
    final quantity = int.tryParse(quantityText);
    if (quantityText.isEmpty || quantity == null) {
      _createRuleQuantityError.value = 'Quantity is required';
    } else if (quantity < 0) {
      _createRuleQuantityError.value = 'Quantity must be greater or equal to 0';
    } else if (quantity > 10000) {
      _createRuleQuantityError.value = 'Quantity must not exceed 10000';
    }

    // Validate cooldown period (optional, but if provided must be valid)
    final cooldownText = cooldownPeriodTextFieldController.text.trim();
    if (cooldownText.isNotEmpty) {
      final cooldown = int.tryParse(cooldownText);
      if (cooldown == null || cooldown <= 0) {
        _createRuleCooldownPeriodError.value =
            'Cooldown must be greater than 0';
      } else if (cooldown > 365) {
        _createRuleCooldownPeriodError.value =
            'Cooldown must not exceed 365 days';
      }
    }

    // Validate usage limit (optional, but if provided must be valid)
    final usageLimitText = usageLimitTextFieldController.text.trim();
    if (usageLimitText.isNotEmpty) {
      final usageLimit = int.tryParse(usageLimitText);
      if (usageLimit == null || usageLimit <= 0) {
        _createRuleUsageLimitError.value = 'Usage limit must be greater than 0';
      } else if (usageLimit > 10000) {
        _createRuleUsageLimitError.value = 'Usage limit must not exceed 10000';
      }
    }

    // Validate expiry date (optional, but if provided must be in the future)
    if (_createRuleExpiryDate.value != null) {
      final now = DateTime.now();
      final selectedDate = _createRuleExpiryDate.value!;
      if (selectedDate.isBefore(DateTime(now.year, now.month, now.day))) {
        _createRuleExpiryDateError.value = 'Expiry date must be in the future';
      }
    }

    /// Returns true if the current reward/barcode selection matches a valid scenario
    bool isValidRewardBarcodeScenario({required bool isEditMode}) {
      // CREATE mode toggles
      final allRewards =
          isEditMode ? _addAllProducts.value : _allProducts.value;
      final allBarcodes =
          isEditMode ? _addAllBarcodes.value : _allBarcodes.value;
      final hasRewards = _selectedRewardIds.isNotEmpty;
      final hasBarcodes = _selectedBarcodeIds.isNotEmpty;
      final removeAll = isEditMode ? _removeAll.value : false;

      if (removeAll) return true; // Remove all is always valid in edit mode

      // Valid scenarios:
      // 1. No rewards, no barcodes (empty rule)
      if (!allRewards && !allBarcodes && !hasRewards && !hasBarcodes) {
        return true;
      }
      // 2. Manual rewards + manual barcodes
      if (!allRewards && !allBarcodes && hasRewards && hasBarcodes) return true;
      // 3. "Link All Rewards" + manual barcodes
      if (allRewards && !allBarcodes && hasBarcodes) return true;
      // 4. "Link All Barcodes" + manual rewards
      if (!allRewards && allBarcodes && hasRewards) return true;
      // 5. "Link All Rewards" + "Link All Barcodes"
      if (allRewards && allBarcodes) return true;
      return false;
    }

    // Validate interdependence: if one type is specified, the other must also be specified
    final isEditMode = _currentEditingRule.value != null;
    final validScenario = isValidRewardBarcodeScenario(isEditMode: isEditMode);
    _rewardSelectionError.value = '';
    _barcodeSelectionError.value = '';

    if (!validScenario) {
      // Set error messages for invalid scenarios
      final allRewards =
          isEditMode ? _addAllProducts.value : _allProducts.value;
      final allBarcodes =
          isEditMode ? _addAllBarcodes.value : _allBarcodes.value;
      final hasRewards = _selectedRewardIds.isNotEmpty;
      final hasBarcodes = _selectedBarcodeIds.isNotEmpty;
      if (allRewards && !allBarcodes && !hasBarcodes) {
        _barcodeSelectionError.value =
            'When linking all rewards, either enable "Link All Barcodes" or select at least one barcode';
      } else if (allBarcodes && !allRewards && !hasRewards) {
        _rewardSelectionError.value =
            'When linking all barcodes, either enable "Link All Rewards" or select at least one reward';
      } else if (hasRewards && !hasBarcodes && !allBarcodes) {
        _barcodeSelectionError.value =
            'Select at least one barcode or unselect all rewards to continue';
      } else if (hasBarcodes && !hasRewards && !allRewards) {
        _rewardSelectionError.value =
            'Select at least one reward or unselect all barcodes to continue';
      } else {
        _rewardSelectionError.value = 'Invalid reward/barcode selection';
        _barcodeSelectionError.value = 'Invalid reward/barcode selection';
      }
    }

    // Base validation - all required fields valid and no errors
    final isBaseValid =
        _createRuleNameError.value.isEmpty &&
        _createRuleQuantityError.value.isEmpty &&
        _createRuleCooldownPeriodError.value.isEmpty &&
        _createRuleUsageLimitError.value.isEmpty &&
        _createRuleExpiryDateError.value.isEmpty &&
        _barcodeSelectionError.value.isEmpty &&
        _rewardSelectionError.value.isEmpty &&
        nameTextFieldController.text.trim().isNotEmpty &&
        quantityTextFieldController.text.trim().isNotEmpty;

    // For edit mode, also require changes to be made
    final isCurrentlyEditingRule = _currentEditingRule.value != null;
    _isCreateRuleFormValid.value =
        isBaseValid && (!isCurrentlyEditingRule || hasFormChanges);

    log('[RulesV2Presenter] === VALIDATION SUMMARY ===');
    log('[RulesV2Presenter] Mode: ${isEditMode ? "EDIT" : "CREATE"}');
    log(
      '[RulesV2Presenter] Toggle states - allProducts: ${_allProducts.value}, allBarcodes: ${_allBarcodes.value}',
    );
    log(
      '[RulesV2Presenter] Edit toggles - addAllProducts: ${_addAllProducts.value}, addAllBarcodes: ${_addAllBarcodes.value}, removeAll: ${_removeAll.value}',
    );
    log(
      '[RulesV2Presenter] Selection states - selectedRewards: ${_selectedRewardIds.length}, selectedBarcodes: ${_selectedBarcodeIds.length}',
    );
    log(
      '[RulesV2Presenter] Form text fields - name: "${nameTextFieldController.text.trim()}", quantity: "${quantityTextFieldController.text.trim()}"',
    );
    log(
      '[RulesV2Presenter] Form field errors - name: "${_createRuleNameError.value}", quantity: "${_createRuleQuantityError.value}", cooldown: "${_createRuleCooldownPeriodError.value}", usageLimit: "${_createRuleUsageLimitError.value}", expiryDate: "${_createRuleExpiryDateError.value}"',
    );
    log(
      '[RulesV2Presenter] Selection errors - barcodeError: "${_barcodeSelectionError.value}", rewardError: "${_rewardSelectionError.value}"',
    );
    log('[RulesV2Presenter] Base validation components:');
    log(
      '[RulesV2Presenter]   - nameError.isEmpty: ${_createRuleNameError.value.isEmpty}',
    );
    log(
      '[RulesV2Presenter]   - quantityError.isEmpty: ${_createRuleQuantityError.value.isEmpty}',
    );
    log(
      '[RulesV2Presenter]   - cooldownError.isEmpty: ${_createRuleCooldownPeriodError.value.isEmpty}',
    );
    log(
      '[RulesV2Presenter]   - usageLimitError.isEmpty: ${_createRuleUsageLimitError.value.isEmpty}',
    );
    log(
      '[RulesV2Presenter]   - expiryDateError.isEmpty: ${_createRuleExpiryDateError.value.isEmpty}',
    );
    log(
      '[RulesV2Presenter]   - barcodeSelectionError.isEmpty: ${_barcodeSelectionError.value.isEmpty}',
    );
    log(
      '[RulesV2Presenter]   - rewardSelectionError.isEmpty: ${_rewardSelectionError.value.isEmpty}',
    );
    log(
      '[RulesV2Presenter]   - nameText.isNotEmpty: ${nameTextFieldController.text.trim().isNotEmpty}',
    );
    log(
      '[RulesV2Presenter]   - quantityText.isNotEmpty: ${quantityTextFieldController.text.trim().isNotEmpty}',
    );
    log(
      '[RulesV2Presenter] isBaseValid: $isBaseValid, isCurrentlyEditingRule: $isCurrentlyEditingRule, hasFormChanges: $hasFormChanges',
    );
    log(
      '[RulesV2Presenter] Final result - canSaveRule: ${_isCreateRuleFormValid.value}',
    );
    log('[RulesV2Presenter] ========================');
  }

  @override
  void resetCreateRuleForm() {
    // Clear text controllers
    nameTextFieldController.clear();
    quantityTextFieldController.clear();
    cooldownPeriodTextFieldController.clear();
    usageLimitTextFieldController.clear();

    // Reset remaining state
    _createRuleStatus.value = true;
    _createRuleExpiryDate.value = null;

    // Clear selections
    _selectedRewardIds.clear();
    _selectedBarcodeIds.clear();

    // Clear toggle states
    _allProducts.value = false;
    _allBarcodes.value = false;
    _addAllProducts.value = false;
    _addAllBarcodes.value = false;
    _removeAll.value = false;

    // Clear errors
    _createRuleNameError.value = '';
    _createRuleQuantityError.value = '';
    _createRuleCooldownPeriodError.value = '';
    _createRuleUsageLimitError.value = '';
    _createRuleExpiryDateError.value = '';
    _barcodeSelectionError.value = '';
    _rewardSelectionError.value = '';
    _isCreateRuleFormValid.value = false;

    // Validate the initial state
    validateCreateRuleForm();
  }

  @override
  RulesResultModel createRuleModel() {
    // Debug logging
    log(
      '[RulesV2Presenter] createRuleModel - selectedRewardIds: ${_selectedRewardIds.toList()}',
    );
    log(
      '[RulesV2Presenter] createRuleModel - selectedBarcodeIds: ${_selectedBarcodeIds.toList()}',
    );
    log(
      '[RulesV2Presenter] createRuleModel - allProducts: ${_allProducts.value}',
    );
    log(
      '[RulesV2Presenter] createRuleModel - allBarcodes: ${_allBarcodes.value}',
    );

    final productIds =
        _allProducts.value
            ? null
            : (_selectedRewardIds.isNotEmpty
                ? _selectedRewardIds.toList()
                : null);
    final barcodeIds =
        _allBarcodes.value
            ? null
            : (_selectedBarcodeIds.isNotEmpty
                ? _selectedBarcodeIds.toList()
                : null);
    final allProducts = _allProducts.value ? 'True' : 'False';
    final allBarcodes = _allBarcodes.value ? 'True' : 'False';

    log('[RulesV2Presenter] createRuleModel - productIds: $productIds');
    log('[RulesV2Presenter] createRuleModel - barcodeIds: $barcodeIds');
    log('[RulesV2Presenter] createRuleModel - allProducts: $allProducts');
    log('[RulesV2Presenter] createRuleModel - allBarcodes: $allBarcodes');

    return RulesResultModel(
      name: nameTextFieldController.text.trim(),
      status: _createRuleStatus.value ? 'active' : 'inactive',
      quantity: int.tryParse(quantityTextFieldController.text.trim()),
      cooldownPeriod: int.tryParse(
        cooldownPeriodTextFieldController.text.trim(),
      ),
      usageLimit: int.tryParse(usageLimitTextFieldController.text.trim()),
      expiryDate: _createRuleExpiryDate.value,
      // For CREATE: use productIds/barcodeIds when manually selected, or use allProducts/allBarcodes toggles
      productIds: productIds,
      barcodeIds: barcodeIds,
      allProducts: allProducts,
      allBarcodes: allBarcodes,
    );
  }

  @override
  RulesResultModel createEditRuleModel() {
    // Calculate deltas: what to add vs what to remove
    final currentRewardIds = Set<int>.from(_selectedRewardIds);
    final originalRewardIds = Set<int>.from(_originalRuleRewardIds);
    final currentBarcodeIds = Set<int>.from(_selectedBarcodeIds);
    final originalBarcodeIds = Set<int>.from(_originalRuleBarcodeIds);

    // Items to add = current - original
    final rewardsToAdd =
        currentRewardIds.difference(originalRewardIds).toList();
    final barcodesToAdd =
        currentBarcodeIds.difference(originalBarcodeIds).toList();

    // Items to remove = original - current
    final rewardsToRemove =
        originalRewardIds.difference(currentRewardIds).toList();
    final barcodesToRemove =
        originalBarcodeIds.difference(currentBarcodeIds).toList();

    return RulesResultModel(
      name: nameTextFieldController.text.trim(),
      status: _createRuleStatus.value ? 'active' : 'inactive',
      quantity: int.tryParse(quantityTextFieldController.text.trim()),
      cooldownPeriod: int.tryParse(
        cooldownPeriodTextFieldController.text.trim(),
      ),
      usageLimit: int.tryParse(usageLimitTextFieldController.text.trim()),
      expiryDate: _createRuleExpiryDate.value,
      // For EDIT: use delta operations or bulk toggles
      addProductIds:
          _addAllProducts.value
              ? null
              : (rewardsToAdd.isEmpty ? null : rewardsToAdd),
      addBarcodeIds:
          _addAllBarcodes.value
              ? null
              : (barcodesToAdd.isEmpty ? null : barcodesToAdd),
      removeProductIds:
          _removeAll.value
              ? null
              : (rewardsToRemove.isEmpty ? null : rewardsToRemove),
      removeBarcodeIds:
          _removeAll.value
              ? null
              : (barcodesToRemove.isEmpty ? null : barcodesToRemove),
      // Bulk operation toggles
      addAllProducts: _addAllProducts.value ? 'True' : 'False',
      addAllBarcodes: _addAllBarcodes.value ? 'True' : 'False',
      removeAll: _removeAll.value ? 'True' : 'False',
    );
  }

  @override
  void populateFormForEdit(RulesResultModel rule) {
    // Set current editing rule
    _currentEditingRule.value = rule;

    // Store original data for change detection
    _originalEditRuleData = RulesResultModel(
      name: rule.name,
      status: rule.status,
      quantity: rule.quantity,
      cooldownPeriod: rule.cooldownPeriod,
      usageLimit: rule.usageLimit,
      expiryDate: rule.expiryDate,
    );

    // Populate text controllers with existing rule data
    nameTextFieldController.text = rule.name ?? '';
    quantityTextFieldController.text = rule.quantity?.toString() ?? '';
    cooldownPeriodTextFieldController.text =
        rule.cooldownPeriod?.toString() ?? '';
    usageLimitTextFieldController.text = rule.usageLimit?.toString() ?? '';

    // Set reactive values
    _createRuleStatus.value =
        (rule.status?.toLowerCase() == 'active') ? true : false;
    _createRuleExpiryDate.value = rule.expiryDate;

    // Populate selections from rule data
    populateSelectionsFromRule(rule);

    // Clear any existing errors
    _createRuleNameError.value = '';
    _createRuleQuantityError.value = '';
    _createRuleCooldownPeriodError.value = '';
    _createRuleUsageLimitError.value = '';
    _createRuleExpiryDateError.value = '';

    // Validate the populated form
    validateCreateRuleForm();
  }

  @override
  void resetEditRuleForm() {
    // Clear current editing rule and original data
    _currentEditingRule.value = null;
    _originalEditRuleData = null;

    // For edit mode, we should reset to clean state but NOT call resetCreateRuleForm
    // as that would clear selections that should be preserved

    // Clear text controllers
    nameTextFieldController.clear();
    quantityTextFieldController.clear();
    cooldownPeriodTextFieldController.clear();
    usageLimitTextFieldController.clear();

    // Reset remaining state
    _createRuleStatus.value = true;
    _createRuleExpiryDate.value = null;

    // Clear selections (this is appropriate when fully resetting edit mode)
    _selectedRewardIds.clear();
    _selectedBarcodeIds.clear();

    // Clear toggle states - CRITICAL for preventing state leaks
    _allProducts.value = false;
    _allBarcodes.value = false;
    _addAllProducts.value = false;
    _addAllBarcodes.value = false;
    _removeAll.value = false;

    // Clear errors
    _createRuleNameError.value = '';
    _createRuleQuantityError.value = '';
    _createRuleCooldownPeriodError.value = '';
    _createRuleUsageLimitError.value = '';
    _createRuleExpiryDateError.value = '';
    _barcodeSelectionError.value = '';
    _rewardSelectionError.value = '';
    _isCreateRuleFormValid.value = false;
  }

  bool _computeHasChanges() {
    if (_originalEditRuleData == null) return false;

    // Compare current form values with original data
    final currentName = nameTextFieldController.text.trim();
    final originalName = _originalEditRuleData!.name ?? '';

    final currentStatus = _createRuleStatus.value;
    final originalStatus =
        (_originalEditRuleData!.status?.toLowerCase() == 'active');

    final currentQuantity = int.tryParse(
      quantityTextFieldController.text.trim(),
    );
    final originalQuantity = _originalEditRuleData!.quantity;

    final currentCooldown = int.tryParse(
      cooldownPeriodTextFieldController.text.trim(),
    );
    final originalCooldown = _originalEditRuleData!.cooldownPeriod;

    final currentUsageLimit = int.tryParse(
      usageLimitTextFieldController.text.trim(),
    );
    final originalUsageLimit = _originalEditRuleData!.usageLimit;

    final currentExpiryDate = _createRuleExpiryDate.value;
    final originalExpiryDate = _originalEditRuleData!.expiryDate;

    // Check for selection changes
    final currentRewardIds = Set<int>.from(_selectedRewardIds);
    final originalRewardIds = Set<int>.from(_originalRuleRewardIds);
    final rewardSelectionsChanged =
        currentRewardIds.length != originalRewardIds.length ||
        !currentRewardIds.containsAll(originalRewardIds);

    final currentBarcodeIds = Set<int>.from(_selectedBarcodeIds);
    final originalBarcodeIds = Set<int>.from(_originalRuleBarcodeIds);
    final barcodeSelectionsChanged =
        currentBarcodeIds.length != originalBarcodeIds.length ||
        !currentBarcodeIds.containsAll(originalBarcodeIds);

    // Check for toggle changes - these are operation flags in EDIT mode
    // Any toggle set to true indicates an operation will be performed, which is a change
    final toggleChanges =
        _addAllProducts.value || _addAllBarcodes.value || _removeAll.value;

    final hasChanges =
        currentName != originalName ||
        currentStatus != originalStatus ||
        currentQuantity != originalQuantity ||
        currentCooldown != originalCooldown ||
        currentUsageLimit != originalUsageLimit ||
        !_datesEqual(currentExpiryDate, originalExpiryDate) ||
        rewardSelectionsChanged ||
        barcodeSelectionsChanged ||
        toggleChanges;

    log(
      '[RulesV2Presenter] _computeHasChanges - toggleChanges: $toggleChanges, hasChanges: $hasChanges',
    );
    log(
      '[RulesV2Presenter] Toggle states - addAllProducts: ${_addAllProducts.value}, addAllBarcodes: ${_addAllBarcodes.value}, removeAll: ${_removeAll.value}',
    );

    return hasChanges;
  }

  bool _datesEqual(DateTime? date1, DateTime? date2) {
    if (date1 == null && date2 == null) return true;
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Selection state getters and setters
  @override
  RxList<int> get selectedRewardIds => _selectedRewardIds;
  @override
  set selectedRewardIds(List<int> value) => _selectedRewardIds.assignAll(value);

  @override
  RxList<int> get selectedBarcodeIds => _selectedBarcodeIds;
  @override
  set selectedBarcodeIds(List<int> value) =>
      _selectedBarcodeIds.assignAll(value);

  @override
  int get selectedRewardCount => _selectedRewardIds.length;

  @override
  int get selectedBarcodeCount => _selectedBarcodeIds.length;

  // Toggle states getters and setters
  @override
  bool get allProducts => _allProducts.value;
  @override
  set allProducts(bool value) => _allProducts.value = value;

  @override
  bool get allBarcodes => _allBarcodes.value;
  @override
  set allBarcodes(bool value) => _allBarcodes.value = value;

  @override
  bool get addAllProducts => _addAllProducts.value;
  @override
  set addAllProducts(bool value) => _addAllProducts.value = value;

  @override
  bool get addAllBarcodes => _addAllBarcodes.value;
  @override
  set addAllBarcodes(bool value) => _addAllBarcodes.value = value;

  @override
  bool get removeAll => _removeAll.value;
  @override
  set removeAll(bool value) => _removeAll.value = value;

  @override
  bool get canRemoveAll {
    // Only available in edit mode and when rule has existing items
    if (_currentEditingRule.value == null) return false;

    final rule = _currentEditingRule.value!;
    final hasRewards = rule.rewards != null && rule.rewards!.isNotEmpty;
    final hasBarcodes = rule.barcodes != null && rule.barcodes!.isNotEmpty;
    final canRemove = hasRewards || hasBarcodes;

    log(
      '[RulesV2Presenter] canRemoveAll - hasRewards: $hasRewards (${rule.rewards?.length ?? 0}), hasBarcodes: $hasBarcodes (${rule.barcodes?.length ?? 0}), canRemove: $canRemove',
    );

    return canRemove;
  }

  @override
  bool get canAddAllProducts {
    // Can't add all products if remove all is enabled
    return !_removeAll.value;
  }

  @override
  bool get canAddAllBarcodes {
    // Can't add all barcodes if remove all is enabled
    return !_removeAll.value;
  }

  @override
  List<RewardResultModel> get rewardSelectionItems => _rewardSelectionItems;
  @override
  set rewardSelectionItems(List<RewardResultModel> value) =>
      _rewardSelectionItems.assignAll(value);

  @override
  List<BarcodeResultModel> get barcodeSelectionItems => _barcodeSelectionItems;
  @override
  set barcodeSelectionItems(List<BarcodeResultModel> value) =>
      _barcodeSelectionItems.assignAll(value);

  @override
  bool get isSelectionLoading => _isSelectionLoading.value;
  @override
  set isSelectionLoading(bool value) => _isSelectionLoading.value = value;

  @override
  String get selectionSearchQuery => _selectionSearchQuery.value;
  @override
  set selectionSearchQuery(String value) => _selectionSearchQuery.value = value;

  @override
  int get selectionCurrentPage => _selectionCurrentPage.value;
  @override
  set selectionCurrentPage(int value) => _selectionCurrentPage.value = value;

  @override
  int get selectionTotalCount => _selectionTotalCount.value;
  @override
  set selectionTotalCount(int value) => _selectionTotalCount.value = value;

  @override
  int get selectionPerPage => _selectionPerPage.value;
  @override
  set selectionPerPage(int value) => _selectionPerPage.value = value;

  @override
  bool get selectionHasNext => _selectionHasNext.value;
  @override
  set selectionHasNext(bool value) => _selectionHasNext.value = value;

  @override
  void resetSelectionState() {
    // Reset only the list items and pagination state
    // DO NOT clear selectedRewardIds/selectedBarcodeIds as they hold the user's selections
    _rewardSelectionItems.clear();
    _barcodeSelectionItems.clear();
    _isSelectionLoading.value = false;
    _selectionSearchQuery.value = '';
    _selectionCurrentPage.value = 1;
    _selectionTotalCount.value = 0;
    _selectionPerPage.value = 10;
    _selectionHasNext.value = false;
  }

  @override
  void populateSelectionsFromRule(RulesResultModel rule) {
    // Debug: Check the raw rule data
    log(
      '[RulesV2Presenter] populateSelectionsFromRule - RAW rule.rewards: ${rule.rewards}',
    );
    log(
      '[RulesV2Presenter] populateSelectionsFromRule - RAW rule.barcodes: ${rule.barcodes}',
    );

    // When editing, extract IDs from the fetched barcodes and rewards objects
    // NOT from addProductIds/addBarcodeIds (those are for sending updates)
    final rewardIds =
        rule.rewards
            ?.map((reward) {
              log(
                '[RulesV2Presenter] Processing reward: id=${reward.id}, name=${reward.name}',
              );
              return reward.id;
            })
            .whereType<int>()
            .toList() ??
        [];

    final barcodeIds =
        rule.barcodes
            ?.map((barcode) {
              log(
                '[RulesV2Presenter] Processing barcode: id=${barcode.id}, name=${barcode.name}',
              );
              return barcode.id;
            })
            .whereType<int>()
            .toList() ??
        [];

    log(
      '[RulesV2Presenter] populateSelectionsFromRule - rewards: ${rule.rewards?.length ?? 0} objects, extracted IDs: $rewardIds',
    );
    log(
      '[RulesV2Presenter] populateSelectionsFromRule - barcodes: ${rule.barcodes?.length ?? 0} objects, extracted IDs: $barcodeIds',
    );

    // Store original rule selections for delta calculation
    _originalRuleRewardIds = List<int>.from(rewardIds);
    _originalRuleBarcodeIds = List<int>.from(barcodeIds);

    // Set current selections
    _selectedRewardIds.assignAll(rewardIds);
    _selectedBarcodeIds.assignAll(barcodeIds);

    log(
      '[RulesV2Presenter] selectedRewardIds after assignAll: $_selectedRewardIds',
    );
    log(
      '[RulesV2Presenter] selectedBarcodeIds after assignAll: $_selectedBarcodeIds',
    );
  }

  @override
  void refreshSelections() {
    // Trigger GetX reactivity for RxLists
    _selectedRewardIds.refresh();
    _selectedBarcodeIds.refresh();
  }

  @override
  void storeOriginalRewardSelections() {
    _originalSelectedRewardIds = List<int>.from(_selectedRewardIds);
  }

  @override
  void restoreOriginalRewardSelections() {
    _selectedRewardIds.assignAll(_originalSelectedRewardIds);
  }

  @override
  void storeOriginalBarcodeSelections() {
    _originalSelectedBarcodeIds = List<int>.from(_selectedBarcodeIds);
  }

  @override
  void restoreOriginalBarcodeSelections() {
    _selectedBarcodeIds.assignAll(_originalSelectedBarcodeIds);
  }

  @override
  List<int> get originalRuleRewardIds => _originalRuleRewardIds;

  @override
  List<int> get originalRuleBarcodeIds => _originalRuleBarcodeIds;
}
