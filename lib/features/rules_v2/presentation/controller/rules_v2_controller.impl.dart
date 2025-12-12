import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/confirmation_dialog_service.dart';
import '../view/widgets/selection/selection_bottom_sheet.dart';
import '../../../../utils/helpers/snackbar_service.dart';
import '../../../auth/data/datasources/auth_cache.dart';
import '../../../rewards/data/models/reward_result.dart';
import '../../../product_managment/data/models/barcode/barcode_result.dart';
import '../../data/models/rules_result.dart';
import '../../data/usecase/rules_usecase.interface.dart';
import '../presenter/rules_v2_presenter.interface.dart';
import '../view/widgets/dialogs/create_rule_dialog.dart';
import '../view/widgets/dialogs/rule_form_mode.dart';
import 'rules_v2_controller.interface.dart';

class RulesV2ControllerImpl implements RulesV2ControllerInterface {
  final RulesV2PresenterInterface presenter;
  final RulesV2UseCaseInterface useCase;
  Timer? _validationTimer;

  RulesV2ControllerImpl({required this.presenter, required this.useCase});

  void dispose() {
    _validationTimer?.cancel();
  }

  @override
  void onStatusFilterChanged(String value) {
    presenter.selectedStatusFilter = value;
    _applyFilters();
  }

  @override
  void searchRewards(String query) {
    presenter.searchQuery = query;
    _applyFilters();
  }

  /// Search rules by name - following rewards pattern
  @override
  List<RulesResultModel> searchRules(String query) {
    presenter.searchQuery = query;
    _applyFilters();
    return presenter.filteredRules ?? [];
  }

  @override
  void onFilterChanged(String filter) {
    presenter.selectedFilter = filter;
    _applyFilters();
  }

  @override
  void toggleViewMode(String mode) => presenter.viewMode = mode;

  // Layout helpers
  @override
  int getGridCrossAxisCount(double width) {
    if (width >= 1800) return 6; // Ultra-wide screens
    if (width >= 1400) return 5; // Very large screens
    if (width >= 1100) return 4; // Large screens
    if (width >= 800) return 3; // Medium screens
    if (width >= 500) return 2; // Small screens
    return 1; // Mobile
  }

  @override
  double getGridSpacing(double width) {
    if (width >= 1200) return 20;
    if (width >= 768) return 16;
    return 12;
  }

  @override
  double getRewardChildAspectRatio(double width) {
    final crossAxisCount = getGridCrossAxisCount(width);
    if (width >= 1400) {
      return crossAxisCount >= 5 ? 0.7 : 0.75;
    } else if (width >= 1100) {
      return crossAxisCount >= 4 ? 0.75 : 0.8;
    } else if (width >= 800) {
      return 0.8;
    } else if (width >= 500) {
      return 0.9;
    } else {
      return 1.0;
    }
  }

  // Pagination methods
  @override
  Future<void> goToPage(int page) async {
    if (page != presenter.currentPage && page > 0) {
      presenter.currentPage = page;
      await _loadRules();
      _applyFilters();
    }
  }

  @override
  Future<void> refreshRules() async {
    presenter.currentPage = 1;
    await _loadRules();
    _applyFilters();
  }

  @override
  int getTotalPages() {
    return presenter.totalCount > 0
        ? (presenter.totalCount / presenter.perPage).ceil()
        : 1;
  }

  @override
  bool getHasPrevious() => presenter.currentPage > 1;

  @override
  int getSafeCurrentPage() => presenter.currentPage.clamp(1, getTotalPages());

  // Create rule form actions
  @override
  void onCreateRuleNameChanged(String value) {
    presenter.validateCreateRuleForm();
  }

  @override
  void onCreateRuleStatusChanged(bool value) {
    presenter.createRuleStatus = value;
    presenter.validateCreateRuleForm();
  }

  @override
  void onCreateRuleQuantityChanged(int? value) {
    presenter.validateCreateRuleForm();
  }

  @override
  void onCreateRuleCooldownPeriodChanged(int? value) {
    presenter.validateCreateRuleForm();
  }

  @override
  void onCreateRuleUsageLimitChanged(int? value) {
    presenter.validateCreateRuleForm();
  }

  @override
  void onCreateRuleExpiryDateChanged(DateTime? value) {
    presenter.createRuleExpiryDate = value;
    presenter.validateCreateRuleForm();
  }

  // Toggle callback methods
  void onAllProductsChanged(bool value) {
    presenter.allProducts = value;
    presenter.validateCreateRuleForm();
  }

  void onAllBarcodesChanged(bool value) {
    presenter.allBarcodes = value;
    presenter.validateCreateRuleForm();
  }

  void onAddAllProductsChanged(bool value) {
    // Don't allow enabling if Remove All is active
    if (value && presenter.removeAll) return;
    
    presenter.addAllProducts = value;
    presenter.validateCreateRuleForm();
  }

  void onAddAllBarcodesChanged(bool value) {
    // Don't allow enabling if Remove All is active
    if (value && presenter.removeAll) return;
    
    presenter.addAllBarcodes = value;
    presenter.validateCreateRuleForm();
  }

  void onRemoveAllChanged(bool value) {
    // Only allow enabling if there are items to remove
    if (value && !presenter.canRemoveAll) return;
    
    // If enabling Remove All, disable the Add All toggles
    if (value) {
      presenter.addAllProducts = false;
      presenter.addAllBarcodes = false;
    }
    
    presenter.removeAll = value;
    presenter.validateCreateRuleForm();
  }

  @override
  void onCreateRuleRewardsSelection() async {
    // Store current REWARD selections before opening dialog (for cancel functionality)
    presenter.storeOriginalRewardSelections();
    
    // Reset pagination and items state but preserve selections
    presenter.resetSelectionState();
    
    await _loadInitialRewards();

    Get.bottomSheet(
      Obx(
        () => SelectionBottomSheet(
          title: 'Select Rewards',
          items: presenter.rewardSelectionItems,
          selectedIds: presenter.selectedRewardIds,
          isLoading: presenter.isSelectionLoading,
          searchQuery: presenter.selectionSearchQuery,
          currentPage: presenter.selectionCurrentPage,
          totalCount: presenter.selectionTotalCount,
          perPage: presenter.selectionPerPage,
          hasNext: presenter.selectionHasNext,
          getDisplayName: (item) => item.name ?? '',
          getId: (item) => item.id ?? 0,
          getSubtitle: (item) => item.description ?? '',
          getImageUrl: (item) => item.headerImage,
          onSearchChanged: _onRewardSearchChanged,
          onItemToggled: _onRewardToggled,
          onPageChanged: _onRewardPageChanged,
          onConfirm: _onRewardSelectionConfirmed,
          onCancel: _onRewardSelectionCancelled,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  void onCreateRuleBarcodesSelection() async {
    // Store current BARCODE selections before opening dialog (for cancel functionality)
    presenter.storeOriginalBarcodeSelections();
    
    // Reset pagination and items state but preserve selections
    presenter.resetSelectionState();
    
    await _loadInitialBarcodes();

    Get.bottomSheet(
      Obx(
        () => SelectionBottomSheet(
          title: 'Select Barcodes',
          items: presenter.barcodeSelectionItems,
          selectedIds: presenter.selectedBarcodeIds,
          isLoading: presenter.isSelectionLoading,
          searchQuery: presenter.selectionSearchQuery,
          currentPage: presenter.selectionCurrentPage,
          totalCount: presenter.selectionTotalCount,
          perPage: presenter.selectionPerPage,
          hasNext: presenter.selectionHasNext,
          getDisplayName: (item) => item.name ?? '',
          getId: (item) => item.id ?? 0,
          getSubtitle: (item) => item.brand ?? '',
          getImageUrl: (item) => item.headerImage,
          onSearchChanged: _onBarcodeSearchChanged,
          onItemToggled: _onBarcodeToggled,
          onPageChanged: _onBarcodePageChanged,
          onConfirm: _onBarcodeSelectionConfirmed,
          onCancel: _onBarcodeSelectionCancelled,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Actions
  @override
  void startCreate() {
    presenter.resetCreateRuleForm();
    presenter.isCreatingRule = true;

    _showRuleFormDialog(RuleFormMode.create);
  }

  @override
  void cancelCreateRule() {
    presenter.resetCreateRuleForm();
    presenter.isCreatingRule = false;
    Get.back();
  }

  @override
  void saveCreateRule() async {
    // Validate before saving
    presenter.validateCreateRuleForm();
    
    if (!presenter.canSaveRule) {
      if (presenter.barcodeSelectionError != null) {
        showError(presenter.barcodeSelectionError!);
      } else if (presenter.rewardSelectionError != null) {
        showError(presenter.rewardSelectionError!);
      } else {
        showError('Please fix all validation errors before saving');
      }
      return;
    }

    final rule = presenter.createRuleModel();

    log('[RulesV2Controller] Creating new rule: ${rule.name}');

    try {
      // get the token
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if (cachedUser?.accessToken == null) {
        cancelCreateRule();
        return;
      }

      await useCase.createRule(rule, token: cachedUser!.accessToken!);
      cancelCreateRule();
      showSuccess('Rule created successfully');
      await refreshRules();
    } catch (e) {
      showError('Failed to create rule: $e');
      cancelCreateRule();
    }
  }

  // Edit rule actions
  @override
  void startEdit(RulesResultModel rule) {
    presenter.populateFormForEdit(rule);
    presenter.isEditingRule = true;

    _showRuleFormDialog(RuleFormMode.edit);
  }

  @override
  void cancelEditRule() {
    presenter.resetEditRuleForm();
    presenter.isEditingRule = null;
    presenter.refreshIsEditingRule();
    Get.back();
  }

  @override
  void saveEditRule() async {
    // Validate before saving
    presenter.validateCreateRuleForm();
    
    if (!presenter.canSaveRule) {
      if (presenter.barcodeSelectionError != null) {
        showError(presenter.barcodeSelectionError!);
      } else if (presenter.rewardSelectionError != null) {
        showError(presenter.rewardSelectionError!);
      } else {
        showError('Please fix all validation errors before saving');
      }
      return;
    }

    final updatedRule = presenter.createEditRuleModel();
    final originalRule = presenter.currentEditingRule;

    if (originalRule != null) {
      // Use the complete updatedRule which includes addProductIds/addBarcodeIds
      final ruleToUpdate = updatedRule;

      log(
        '[RulesV2Controller] Updating rule: ${ruleToUpdate.name} (ID: ${originalRule.id})',
      );

      // get the token
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

      if (cachedUser?.accessToken == null || originalRule.id == null) {
        cancelEditRule();
        return;
      }

      try {
        await useCase.updateRule(
          originalRule.id!,
          ruleToUpdate,
          token: cachedUser!.accessToken!,
        );
        cancelEditRule();
        showSuccess('Rule updated successfully');
        await refreshRules();
      } catch (e) {
        showError('Failed to update rule: $e');
      }
    } else {
      cancelEditRule();
    }
  }

  void _showRuleFormDialog(RuleFormMode mode) {
    log('[RulesV2Controller] _showRuleFormDialog - selectedRewardIds: ${presenter.selectedRewardIds}');
    log('[RulesV2Controller] _showRuleFormDialog - selectedBarcodeIds: ${presenter.selectedBarcodeIds}');
    log('[RulesV2Controller] _showRuleFormDialog - rewardsCount: ${presenter.selectedRewardIds.length}');
    log('[RulesV2Controller] _showRuleFormDialog - barcodesCount: ${presenter.selectedBarcodeIds.length}');
    
    Get.dialog(
      Obx(
        () => CreateRuleDialog(
          // Form mode
          mode: mode,

          // Form field values
          status: presenter.createRuleStatus,
          expiryDate: presenter.createRuleExpiryDate,

          // Form validation
          isFormValid: presenter.canSaveRule,
          nameError: presenter.createRuleNameError,
          quantityError: presenter.createRuleQuantityError,
          cooldownPeriodError: presenter.createRuleCooldownPeriodError,
          usageLimitError: presenter.createRuleUsageLimitError,
          expiryDateError: presenter.createRuleExpiryDateError,
          barcodeSelectionError: presenter.barcodeSelectionError,
          rewardSelectionError: presenter.rewardSelectionError,

          // Callback functions
          onNameChanged: onCreateRuleNameChanged,
          onStatusChanged: onCreateRuleStatusChanged,
          onQuantityChanged: onCreateRuleQuantityChanged,
          onCooldownPeriodChanged: onCreateRuleCooldownPeriodChanged,
          onUsageLimitChanged: onCreateRuleUsageLimitChanged,
          onExpiryDateChanged: onCreateRuleExpiryDateChanged,

          onCancel: mode.isCreate ? cancelCreateRule : cancelEditRule,
          onSave: mode.isCreate ? saveCreateRule : saveEditRule,
          onRewardsSelection: onCreateRuleRewardsSelection,
          onBarcodesSelection: onCreateRuleBarcodesSelection,
          
          // Selection counts
          rewardsCount: presenter.selectedRewardCount,
          barcodesCount: presenter.selectedBarcodeCount,

          // Toggle states
          allProducts: presenter.allProducts,
          allBarcodes: presenter.allBarcodes,
          addAllProducts: presenter.addAllProducts,
          addAllBarcodes: presenter.addAllBarcodes,
          removeAll: presenter.removeAll,
          canRemoveAll: presenter.canRemoveAll,
          canAddAllProducts: presenter.canAddAllProducts,
          canAddAllBarcodes: presenter.canAddAllBarcodes,
          
          // Toggle callbacks
          onAllProductsChanged: onAllProductsChanged,
          onAllBarcodesChanged: onAllBarcodesChanged,
          onAddAllProductsChanged: onAddAllProductsChanged,
          onAddAllBarcodesChanged: onAddAllBarcodesChanged,
          onRemoveAllChanged: onRemoveAllChanged,

          // TextEditingControllers
          nameTextFieldController: presenter.nameTextFieldController,
          quantityTextFieldController: presenter.quantityTextFieldController,
          cooldownPeriodTextFieldController:
              presenter.cooldownPeriodTextFieldController,
          usageLimitTextFieldController:
              presenter.usageLimitTextFieldController,
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _applyFilters() {
    presenter.applyFilters();
  }

  Future<void> _loadRules() async {
    log(
      '[RulesV2Controller] Loading rules - Page: ${presenter.currentPage}, Search: "${presenter.searchQuery}"',
    );
    await presenter.loadRules();
  }

  @override
  void confirmDeleteRule(BuildContext context, RulesResultModel rule) {
    ConfirmationDialogService.showDeleteConfirmation(
      context: context,
      itemName: rule.name ?? '',
      itemType: 'rule',
      onConfirm: () async {
        await deleteRule(rule.id);
      },
    );
  }

  @override
  Future<void> deleteRule(int? ruleId) async {
    if (ruleId == null) {
      showError('Rule ID is null');
      return;
    }
    // get the token
    final cachedUser = await AuthCacheDataSource.instance.getUserAuth();

    if (cachedUser?.accessToken == null) return;

    try {
      await useCase.deleteRule(ruleId, token: cachedUser!.accessToken!);
      showSuccess('Rule deleted successfully');
    } catch (e) {
      showError('Failed to delete rule: $e');
      return;
    }

    // update the view
    await refreshRules();
  }

  @override
  void showError(String message) => SnackbarServiceHelper.showError(
    message,
    position: SnackPosition.BOTTOM,
    actionLabel: 'Dismiss',
    onActionPressed: () => Get.back(),
  );

  @override
  void showSuccess(String message) => SnackbarServiceHelper.showSuccess(
    message,
    position: SnackPosition.BOTTOM,
    actionLabel: 'OK',
  );

  // Selection helper methods
  Future<void> _loadInitialRewards() async {
    presenter.isSelectionLoading = true;
    presenter.selectionCurrentPage = 1;

    try {
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
      if (cachedUser?.accessToken != null) {
        final result = await useCase.fetchRewards(
          page: 1,
          pageSize: presenter.selectionPerPage,
          search: presenter.selectionSearchQuery,
          token: cachedUser!.accessToken!,
        );

        presenter.rewardSelectionItems = result.items;
        presenter.selectionTotalCount = result.totalCount;
        presenter.selectionHasNext = result.hasMore;
      }
    } catch (e) {
      showError('Failed to load rewards: $e');
    } finally {
      presenter.isSelectionLoading = false;
    }
  }

  Future<void> _loadRewardsPage(int page) async {
    presenter.isSelectionLoading = true;
    presenter.selectionCurrentPage = page;

    try {
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
      if (cachedUser?.accessToken != null) {
        final result = await useCase.fetchRewards(
          page: page,
          pageSize: presenter.selectionPerPage,
          search: presenter.selectionSearchQuery,
          token: cachedUser!.accessToken!,
        );

        presenter.rewardSelectionItems = result.items;
        presenter.selectionTotalCount = result.totalCount;
        presenter.selectionHasNext = result.hasMore;
      }
    } catch (e) {
      showError('Failed to load rewards: $e');
    } finally {
      presenter.isSelectionLoading = false;
    }
  }

  void _onRewardPageChanged(int page) {
    _loadRewardsPage(page);
  }

  void _onRewardSearchChanged(String query) {
    presenter.selectionSearchQuery = query;
    _loadRewardsPage(1);
  }

  void _onRewardToggled(int id) {
    log('[RulesV2Controller] Before reward toggle - count: ${presenter.selectedRewardCount}');
    if (presenter.selectedRewardIds.contains(id)) {
      presenter.selectedRewardIds.remove(id);
      log('[RulesV2Controller] Removed reward $id');
    } else {
      presenter.selectedRewardIds.add(id);
      log('[RulesV2Controller] Added reward $id');
    }
    // Force UI update for immediate reactivity
    presenter.refreshSelections();
    log('[RulesV2Controller] After reward toggle - count: ${presenter.selectedRewardCount}');
    // Debounced validation to allow user to make related changes
    _debounceValidation();
  }


  Future<void> _loadInitialBarcodes() async {
    presenter.isSelectionLoading = true;
    presenter.selectionCurrentPage = 1;

    try {
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
      if (cachedUser?.accessToken != null) {
        final result = await useCase.fetchBarcodes(
          page: 1,
          pageSize: presenter.selectionPerPage,
          search: presenter.selectionSearchQuery,
          token: cachedUser!.accessToken!,
        );

        presenter.barcodeSelectionItems = result.items;
        presenter.selectionTotalCount = result.totalCount;
        presenter.selectionHasNext = result.hasMore;
      }
    } catch (e) {
      showError('Failed to load barcodes: $e');
    } finally {
      presenter.isSelectionLoading = false;
    }
  }

  Future<void> _loadBarcodesPage(int page) async {
    presenter.isSelectionLoading = true;
    presenter.selectionCurrentPage = page;

    try {
      final cachedUser = await AuthCacheDataSource.instance.getUserAuth();
      if (cachedUser?.accessToken != null) {
        final result = await useCase.fetchBarcodes(
          page: page,
          pageSize: presenter.selectionPerPage,
          search: presenter.selectionSearchQuery,
          token: cachedUser!.accessToken!,
        );

        presenter.barcodeSelectionItems = result.items;
        presenter.selectionTotalCount = result.totalCount;
        presenter.selectionHasNext = result.hasMore;
      }
    } catch (e) {
      showError('Failed to load barcodes: $e');
    } finally {
      presenter.isSelectionLoading = false;
    }
  }

  void _onBarcodePageChanged(int page) {
    _loadBarcodesPage(page);
  }

  void _onBarcodeSearchChanged(String query) {
    presenter.selectionSearchQuery = query;
    _loadBarcodesPage(1);
  }

  void _onBarcodeToggled(int id) {
    if (presenter.selectedBarcodeIds.contains(id)) {
      presenter.selectedBarcodeIds.remove(id);
    } else {
      presenter.selectedBarcodeIds.add(id);
    }
    // Force UI update for immediate reactivity
    presenter.refreshSelections();
    // Debounced validation to allow user to make related changes
    _debounceValidation();
  }

  // Debounced validation to allow users to make multiple selection changes
  void _debounceValidation() {
    _validationTimer?.cancel();
    _validationTimer = Timer(const Duration(milliseconds: 500), () {
      presenter.validateCreateRuleForm();
    });
  }

  // Selection confirmation methods
  void _onRewardSelectionConfirmed() {
    // Selections are already in presenter.selectedRewardIds
    // No additional action needed - they persist until form is saved
    _validationTimer?.cancel(); // Cancel any pending validation
    presenter.validateCreateRuleForm(); // Validate immediately on confirmation
    Get.back();
    showSuccess('Reward selection updated');
  }

  void _onRewardSelectionCancelled() {
    presenter.restoreOriginalRewardSelections();
    Get.back();
  }

  void _onBarcodeSelectionConfirmed() {
    // Selections are already in presenter.selectedBarcodeIds
    // No additional action needed - they persist until form is saved
    _validationTimer?.cancel(); // Cancel any pending validation
    presenter.validateCreateRuleForm(); // Validate immediately on confirmation
    Get.back();
    showSuccess('Barcode selection updated');
  }

  void _onBarcodeSelectionCancelled() {
    presenter.restoreOriginalBarcodeSelections();
    Get.back();
  }

}
