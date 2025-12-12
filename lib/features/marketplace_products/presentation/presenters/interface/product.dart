import 'package:get/get.dart';
import '../../../../rules/data/models/rule.dart';
import '../../../data/models/product.dart';

abstract class RewardsPresenterInterface extends GetxController {
  // Core data observables
  RxList<RewardModel> get rewards;
  RxList<RewardModel> get filteredRewards;
  RxList<String> get categories;
  RxString get selectedCategory;
  RxBool get isLoading;
  RxString get searchQuery;
  // Status filter: all, active, inactive, recent
  RxString get selectedFilter;

  // Form observables
  RxString get formTitle;
  RxString get formDescription;
  RxString get formHeaderImage;
  RxList<String> get formCarouselImages;
  RxString get formLogo;
  RxString get formBarcode;
  RxList<String> get formCategories;
  RxList<String> get formLinkedRules;
  RxBool get formCanCheckout;
  RxBool get isFormValid;
  RxBool get isCreating;
  Rx<RewardModel?> get editingReward;

  // Preview observables
  RxString get previewTitle;
  RxString get previewDescription;
  RxString get previewHeaderImage;
  RxList<String> get previewCarouselImages;
  RxString get previewLogo;
  RxString get previewBarcode;
  RxList<String> get previewCategories;

  // Rules data
  RxList<RuleModel> get availableRules;
  RxList<RuleModel> get selectedRulesData;

  // Animation controllers
  RxBool get showRulesPanel;
  RxDouble get rulesPanelHeight;

  // Core methods
  Future<void> loadRewards();
  Future<void> loadAvailableRules();
  void filterRewards(String category);
  void searchRewards(String query);
  void onFilterChanged(String filter);

  // Form methods
  void startCreate();
  void startEdit(RewardModel reward);
  void updateFormField(String field, dynamic value);
  Future<void> saveReward();
  Future<void> deleteReward(int id);
  void cancelEdit();

  // Image upload methods
  Future<void> uploadHeaderImage();
  Future<void> uploadCarouselImage();
  Future<void> uploadLogo();

  // Rules management
  void showRulesSelectionDialog();
  void addLinkedRule(String ruleId);
  void removeLinkedRule(String ruleId);
  void toggleRulesPanel();

  // Preview methods
  void updatePreview();
  void clearForm();
}
