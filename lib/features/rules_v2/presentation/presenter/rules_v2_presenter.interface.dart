import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/rules_result.dart';
import '../../../rewards/data/models/reward_result.dart';
import '../../../product_managment/data/models/barcode/barcode_result.dart';

abstract class RulesV2PresenterInterface extends GetxController {
  GlobalKey<ScaffoldState> get scaffoldKey;
  String get currentRoute;

  bool get isCreatingRule;
  set isCreatingRule(bool value);
  
  bool? get isEditingRule;
  set isEditingRule(bool? value);
  void refreshIsEditingRule();

  TextEditingController get nameTextFieldController;
  TextEditingController get quantityTextFieldController;
  TextEditingController get cooldownPeriodTextFieldController;
  TextEditingController get usageLimitTextFieldController;
  
  // Rules data
  List<RulesResultModel>? get rules;
  List<RulesResultModel>? get filteredRules;
  set filteredRules(List<RulesResultModel>? value);
  
  // Filter and view state
  String get selectedStatusFilter;
  set selectedStatusFilter(String value);
  List<String> get statusFilters;
  set statusFilters(List<String> value);
  
  String get selectedFilter;
  set selectedFilter(String value);
  
  String get viewMode; // 'grid' or 'list'
  set viewMode(String value);
  
  String get searchQuery;
  set searchQuery(String value);
  
  // Pagination variables
  int get currentPage;
  set currentPage(int value);
  int get totalCount;
  set totalCount(int value);
  bool get hasNextPage;
  set hasNextPage(bool value);
  int get perPage;
  set perPage(int value);
  bool get isLoading;
  set isLoading(bool value);
  
  // Create rule form state
  bool get createRuleStatus;
  set createRuleStatus(bool value);
  
  DateTime? get createRuleExpiryDate;
  set createRuleExpiryDate(DateTime? value);
  
  // Edit rule state
  RulesResultModel? get currentEditingRule;
  set currentEditingRule(RulesResultModel? rule);
  
  // Change detection for edit mode
  bool get hasFormChanges;
  
  // Create rule form validation
  bool get isCreateRuleFormValid;
  String? get createRuleNameError;
  String? get createRuleQuantityError;
  String? get createRuleCooldownPeriodError;
  String? get createRuleUsageLimitError;
  String? get createRuleExpiryDateError;
  
  // Selection validation
  bool get isBarcodeSelectionValid;
  String? get barcodeSelectionError;
  String? get rewardSelectionError;
  bool get canSaveRule;

  // API methods
  Future<void> loadRules();
  
  // Filter methods
  void applyFilters();
  
  // Create rule form methods
  void validateCreateRuleForm();
  void resetCreateRuleForm();
  RulesResultModel createRuleModel();
  RulesResultModel createEditRuleModel();
  
  // Edit rule methods
  void populateFormForEdit(RulesResultModel rule);
  void resetEditRuleForm();

  // Selection state for rewards and barcodes
  RxList<int> get selectedRewardIds;
  set selectedRewardIds(List<int> value);

  RxList<int> get selectedBarcodeIds;
  set selectedBarcodeIds(List<int> value);

  // Selection counts for UI reactivity
  int get selectedRewardCount;
  int get selectedBarcodeCount;

  // Toggle states for bulk operations
  // CREATE mode toggles
  bool get allProducts;
  set allProducts(bool value);
  
  bool get allBarcodes;
  set allBarcodes(bool value);
  
  // EDIT mode toggles
  bool get addAllProducts;
  set addAllProducts(bool value);
  
  bool get addAllBarcodes;
  set addAllBarcodes(bool value);
  
  bool get removeAll;
  set removeAll(bool value);
  
  // Smart toggle validation
  bool get canRemoveAll;
  bool get canAddAllProducts;
  bool get canAddAllBarcodes;

  // Selection bottom sheet state
  List<RewardResultModel> get rewardSelectionItems;
  set rewardSelectionItems(List<RewardResultModel> value);

  List<BarcodeResultModel> get barcodeSelectionItems;
  set barcodeSelectionItems(List<BarcodeResultModel> value);

  bool get isSelectionLoading;
  set isSelectionLoading(bool value);

  String get selectionSearchQuery;
  set selectionSearchQuery(String value);

  // Selection pagination state
  int get selectionCurrentPage;
  set selectionCurrentPage(int value);
  
  int get selectionTotalCount;
  set selectionTotalCount(int value);
  
  int get selectionPerPage;
  set selectionPerPage(int value);
  
  bool get selectionHasNext;
  set selectionHasNext(bool value);

  // Selection methods
  void resetSelectionState();
  void populateSelectionsFromRule(RulesResultModel rule);
  void refreshSelections();
  
  // Type-specific backup/restore methods
  void storeOriginalRewardSelections();
  void restoreOriginalRewardSelections();
  void storeOriginalBarcodeSelections();
  void restoreOriginalBarcodeSelections();
  
  // Edit-specific methods
  List<int> get originalRuleRewardIds;
  List<int> get originalRuleBarcodeIds;
}