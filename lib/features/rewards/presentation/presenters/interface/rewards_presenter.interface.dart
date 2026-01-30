import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../rules/data/models/rule.dart';
import '../../../data/models/reward_result.dart';
import '../../../data/models/reward_result_file.dart';
import '../../../data/models/validate_reward.dart';

abstract class RewardsPresenterInterface extends GetxController {
  // VARIABLES
  /// Global from parent DashboardShell
  GlobalKey<ScaffoldState> get scaffoldKey;
  String get currentRoute;

  List<RewardResultModel>? get rewards;
  List<RewardResultModel>? get filteredRewards;
  set filteredRewards(List<RewardResultModel>? value);

  bool get isLoading;
  set isLoading(bool value);

  bool get isSaving;
  set isSaving(bool value);

  bool get isCreating;
  set isCreating(bool value);

  RewardResultModel? get editingReward;
  set editingReward(RewardResultModel? value);

  List<String> get categories;
  String get selectedCategory;
  set selectedCategory(String value);
  String get selectedFilter;
  set selectedFilter(String value);
  String get viewMode; // 'grid' or 'list'
  set viewMode(String value);
  String get searchQuery;
  set searchQuery(String value);
  String get selectedStatusFilter;
  set selectedStatusFilter(String value);
  List<String> get statusFilters;
  set statusFilters(List<String> value);

  // Pagination observables
  int get currentPage;
  set currentPage(int value);
  int get totalCount;
  set totalCount(int value);
  bool get hasNextPage;
  set hasNextPage(bool value);
  int get perPage;
  set perPage(int value);

  // Form observables
  String get formTitle;
  set formTitle(String value);
  String get formDescription;
  set formDescription(String value);
  String get formHeaderImage;
  set formHeaderImage(String value);
  List<String> get formCarouselImages;
  set formCarouselImages(List<String> value);
  String get formLogo;
  set formLogo(String value);
  List<String> get formCategories;
  set formCategories(List<String> value);
  List<String> get formLinkedRules;
  set formLinkedRules(List<String> value);
  bool get formCanCheckout;
  set formCanCheckout(bool value);
  int get formQuantity;
  set formQuantity(int value);
  DateTime? get formExpiryDate;
  set formExpiryDate(DateTime? value);
  bool get isFormValid;
  set isFormValid(bool value);
  bool get canSaveReward;

  // Image management for editing
  List<int> get filesToDelete;
  void initializeEditingMode(List<RewardResultFileModel> originalFiles);
  void markFileForDeletion(int fileId);
  void clearEditingState();
  RewardResultFileModel? findOriginalFileByUrl(String url);
  void setOriginalHeaderFile(RewardResultFileModel? file);
  void setOriginalCarouselFiles(List<RewardResultFileModel> files);
  void markCurrentHeaderForDeletion();
  void markCarouselFileForDeletion(String url);

  // Preview observables
  String get previewTitle;
  set previewTitle(String value);
  String get previewDescription;
  set previewDescription(String value);
  String get previewHeaderImage;
  set previewHeaderImage(String value);
  List<String> get previewCarouselImages;
  set previewCarouselImages(List<String> value);
  String get previewLogo;
  set previewLogo(String value);
  List<String> get previewCategories;
  set previewCategories(List<String> value);

  // Rules data
  List<RuleModel> get availableRules;
  List<RuleModel> get selectedRulesData;

  // Rule selection state (similar to rules_v2)
  bool get isRuleSelectionLoading;
  set isRuleSelectionLoading(bool value);
  String get ruleSelectionSearchQuery;
  set ruleSelectionSearchQuery(String value);
  int get ruleSelectionCurrentPage;
  set ruleSelectionCurrentPage(int value);
  int get ruleSelectionTotalCount;
  set ruleSelectionTotalCount(int value);
  int get ruleSelectionPerPage;
  bool get ruleSelectionHasNext;
  set ruleSelectionHasNext(bool value);
  List<RuleModel> get ruleSelectionItems;
  set ruleSelectionItems(List<RuleModel> value);
  
  // Selection management
  void resetRuleSelectionState();
  void storeOriginalRuleSelections();
  void restoreOriginalRuleSelections();
  
  // New rule selection methods (following rules_v2 pattern)
  RxList<int> get selectedRuleIds;
  set selectedRuleIds(List<int> value);
  int get selectedRuleCount;
  void populateSelectionsFromReward(RewardResultModel reward);
  void refreshRuleSelections();
  List<int> get originalRewardRuleIds;
  Map<String, List<int>?> calculateRuleDelta();

  // Animation controllers
  bool get showRulesPanel;
  set showRulesPanel(bool value);
  double get rulesPanelHeight;

  // Validation state
  String get validationRedeemCode;
  set validationRedeemCode(String value);
  bool get isValidatingReward;
  set isValidatingReward(bool value);
  String? get validationErrorMessage;
  set validationErrorMessage(String? value);
  String? get validationSuccessMessage;
  set validationSuccessMessage(String? value);
  ValidateRewardModel? get validatedReward;
  set validatedReward(ValidateRewardModel? value);

  // FUNCTIONS
  Future<void> loadRewards({bool forceRefresh = false});
  Future<void> refreshRewards();
  Future<void> loadAvailableRules();
  void resetValidationState();

  // Image conversion loading states
  bool get isConvertingHeaderImage;
  set isConvertingHeaderImage(bool value);
  bool get isConvertingCarouselImage;
  set isConvertingCarouselImage(bool value);
  bool get isConvertingLogo;
  set isConvertingLogo(bool value);

  // Preview methods
  void updatePreview();
  void clearForm();
  void updateSelectedRulesData();
  void validateForm();
}
