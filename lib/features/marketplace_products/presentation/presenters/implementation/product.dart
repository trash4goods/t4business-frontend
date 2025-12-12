import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../rules/data/models/rule.dart';
import '../../../data/models/product.dart';
import '../../controllers/interface/product.dart';
import '../interface/product.dart';

class RewardsPresenterImpl extends GetxController
    with GetSingleTickerProviderStateMixin
    implements RewardsPresenterInterface {
  final RewardsControllerInterface _controller;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  RewardsPresenterImpl(this._controller);

  // Core data observables
  @override
  final RxList<RewardModel> rewards = <RewardModel>[].obs;

  @override
  final RxList<RewardModel> filteredRewards = <RewardModel>[].obs;

  @override
  final RxList<String> categories = <String>[].obs;

  @override
  final RxString selectedCategory = ''.obs;

  @override
  final RxBool isLoading = false.obs;

  @override
  final RxString searchQuery = ''.obs;

  // Status filter: all, active, inactive, recent
  @override
  final RxString selectedFilter = 'all'.obs;

  // Form observables
  @override
  final RxString formTitle = ''.obs;

  @override
  final RxString formDescription = ''.obs;

  @override
  final RxString formHeaderImage = ''.obs;

  @override
  final RxList<String> formCarouselImages = <String>[].obs;

  @override
  final RxString formLogo = ''.obs;

  @override
  final RxString formBarcode = ''.obs;

  @override
  final RxList<String> formCategories = <String>[].obs;

  @override
  final RxList<String> formLinkedRules = <String>[].obs;

  @override
  final RxBool formCanCheckout = false.obs;

  @override
  final RxBool isFormValid = false.obs;

  @override
  final RxBool isCreating = false.obs;

  @override
  final Rx<RewardModel?> editingReward = Rx<RewardModel?>(null);

  // Preview observables
  @override
  final RxString previewTitle = 'Reward Name'.obs;

  @override
  final RxString previewDescription =
      'Reward description will appear here...'.obs;

  @override
  final RxString previewHeaderImage = ''.obs;

  @override
  final RxList<String> previewCarouselImages = <String>[].obs;

  @override
  final RxString previewLogo = ''.obs;

  @override
  final RxString previewBarcode = '0000000000000'.obs;

  @override
  final RxList<String> previewCategories = <String>[].obs;

  // Rules data
  @override
  final RxList<RuleModel> availableRules = <RuleModel>[].obs;

  @override
  final RxList<RuleModel> selectedRulesData = <RuleModel>[].obs;

  // Animation observables
  @override
  final RxBool showRulesPanel = false.obs;

  @override
  final RxDouble rulesPanelHeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
    _setupFormValidation();
    _setupPreviewUpdates();
    loadRewards();
    loadAvailableRules();
    categories.addAll(_controller.getAllCategories());
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    ever(showRulesPanel, (bool show) {
      if (show) {
        _animationController.forward();
        rulesPanelHeight.value = 300.0;
      } else {
        _animationController.reverse();
        rulesPanelHeight.value = 0.0;
      }
    });
  }

  void _setupFormValidation() {
    ever(formTitle, (_) => _validateForm());
    ever(formDescription, (_) => _validateForm());
    ever(formHeaderImage, (_) => _validateForm());
    ever(formBarcode, (_) => _validateForm());
    ever(formCategories, (_) => _validateForm());
    ever(formLinkedRules, (_) => _validateForm());
  }

  void _setupPreviewUpdates() {
    ever(formTitle, (_) => updatePreview());
    ever(formDescription, (_) => updatePreview());
    ever(formHeaderImage, (_) => updatePreview());
    ever(formCarouselImages, (_) => updatePreview());
    ever(formLogo, (_) => updatePreview());
    ever(formBarcode, (_) => updatePreview());
    ever(formCategories, (_) => updatePreview());
  }

  @override
  Future<void> loadRewards() async {
    isLoading.value = true;
    try {
      final rewardList = await _controller.getAllRewards();
      rewards.assignAll(rewardList);
      filteredRewards.assignAll(rewardList);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> loadAvailableRules() async {
    try {
      final rulesList = await _controller.getAllRules();
      availableRules.assignAll(rulesList);
    } catch (e) {
      log('Error loading rules: $e');
    }
  }

  @override
  void onFilterChanged(String filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  @override
  void filterRewards(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  @override
  void searchRewards(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = rewards.toList();

    // Status filter
    switch (selectedFilter.value) {
      case 'active':
        filtered = filtered.where((r) => r.canCheckout).toList();
        break;
      case 'inactive':
        filtered = filtered.where((r) => !r.canCheckout).toList();
        break;
      case 'recent':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      default:
        // all
        break;
    }

    if (selectedCategory.value.isNotEmpty) {
      filtered = _controller.filterRewardsByCategory(selectedCategory.value);
    }

    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (reward) =>
                    reward.title.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    reward.description.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    reward.barcode.contains(searchQuery.value),
              )
              .toList();
    }

    filteredRewards.assignAll(filtered);
  }

  @override
  void startCreate() {
    clearForm();
    editingReward.value = null;
    isCreating.value = true;
    updatePreview();
  }

  @override
  void startEdit(RewardModel reward) {
    editingReward.value = reward;
    isCreating.value = true;
    formTitle.value = reward.title;
    formDescription.value = reward.description;
    formHeaderImage.value = reward.headerImage;
    formCarouselImages.assignAll(reward.carouselImage);
    formLogo.value = reward.logo;
    formBarcode.value = reward.barcode;
    formCategories.assignAll(reward.category);
    formLinkedRules.assignAll(reward.linkedRules);
    formCanCheckout.value = reward.canCheckout;
    _updateSelectedRulesData();
    updatePreview();
  }

  @override
  void updateFormField(String field, dynamic value) {
    switch (field) {
      case 'title':
        formTitle.value = value.toString();
        break;
      case 'description':
        formDescription.value = value.toString();
        break;
      case 'headerImage':
        formHeaderImage.value = value.toString();
        break;
      case 'carouselImages':
        if (value is List<String>) {
          formCarouselImages.assignAll(value);
        }
        break;
      case 'logo':
        formLogo.value = value.toString();
        break;
      case 'barcode':
        formBarcode.value = value.toString();
        break;
      case 'categories':
        if (value is List<String>) {
          formCategories.assignAll(value);
        }
        break;
      case 'linkedRules':
        if (value is List<String>) {
          formLinkedRules.assignAll(value);
          _updateSelectedRulesData();
        }
        break;
      case 'canCheckout':
        formCanCheckout.value = value as bool;
        break;
    }
    updatePreview();
  }

  @override
  Future<void> saveReward() async {
    if (!isFormValid.value) return;

    isLoading.value = true;
    try {
      final reward = RewardModel(
        id: editingReward.value?.id ?? 0,
        title: formTitle.value,
        description: formDescription.value,
        headerImage: formHeaderImage.value,
        carouselImage: formCarouselImages.toList(),
        logo: formLogo.value,
        barcode: formBarcode.value,
        category: formCategories.toList(),
        linkedRules: formLinkedRules.toList(),
        canCheckout: formCanCheckout.value,
        createdAt: editingReward.value?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (editingReward.value != null) {
        success = await _controller.updateReward(reward);
      } else {
        success = await _controller.createReward(reward);
      }

      if (success) {
        Get.snackbar(
          'Success',
          editingReward.value != null
              ? 'Reward updated successfully'
              : 'Reward created successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        await loadRewards();
        isCreating.value = false;
        cancelEdit();
      } else {
        Get.snackbar(
          'Error',
          'Failed to save reward',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> deleteReward(int id) async {
    isLoading.value = true;
    try {
      final success = await _controller.deleteReward(id);
      if (success) {
        Get.snackbar(
          'Success',
          'Reward deleted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        await loadRewards();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete reward',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void cancelEdit() {
    clearForm();
    editingReward.value = null;
    isCreating.value = false;
    showRulesPanel.value = false;
  }

  @override
  Future<void> uploadHeaderImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        final filePath = result.files.single.path!;
        final imageUrl = await _controller.uploadImage(filePath);
        formHeaderImage.value = imageUrl;
        Get.snackbar('Success', 'Header image uploaded successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload header image');
    }
  }

  @override
  Future<void> uploadCarouselImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        final filePath = result.files.single.path!;
        final imageUrl = await _controller.uploadImage(filePath);
        final updatedList = formCarouselImages.toList();
        updatedList.add(imageUrl);
        formCarouselImages.assignAll(updatedList);
        Get.snackbar('Success', 'Carousel image uploaded successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload carousel image');
    }
  }

  @override
  Future<void> uploadLogo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        final filePath = result.files.single.path!;
        final imageUrl = await _controller.uploadImage(filePath);
        formLogo.value = imageUrl;
        Get.snackbar('Success', 'Logo uploaded successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload logo');
    }
  }

  @override
  void toggleRulesPanel() {
    showRulesPanel.value = !showRulesPanel.value;
  }

  @override
  void showRulesSelectionDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 600,
          height: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.rule, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Link Rules to Reward',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Select rules that users must complete to unlock this reward. Users need to meet ANY of the selected rules.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: availableRules.length,
                    itemBuilder: (context, index) {
                      final rule = availableRules[index];
                      final isLinked = formLinkedRules.contains(rule.id);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              isLinked
                                  ? Colors.blue.withValues(alpha: 0.1)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isLinked ? Colors.blue : Colors.grey.shade300,
                            width: isLinked ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          leading: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  isLinked ? Colors.blue : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isLinked ? Icons.check : Icons.rule,
                              color:
                                  isLinked
                                      ? Colors.white
                                      : Colors.grey.shade600,
                            ),
                          ),
                          title: Text(
                            rule.title,
                            style: TextStyle(
                              fontWeight:
                                  isLinked
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            '${rule.recycleCount}x recycle • ${rule.categories.join(", ")}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Switch(
                            value: isLinked,
                            onChanged: (value) {
                              if (value) {
                                addLinkedRule(rule.id);
                              } else {
                                removeLinkedRule(rule.id);
                              }
                            },
                            activeColor: Colors.blue,
                          ),
                          onTap: () {
                            if (isLinked) {
                              removeLinkedRule(rule.id);
                            } else {
                              addLinkedRule(rule.id);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Linked ${formLinkedRules.length} rule(s) to this reward',
                        snackPosition: SnackPosition.TOP,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void addLinkedRule(String ruleId) {
    if (!formLinkedRules.contains(ruleId)) {
      formLinkedRules.add(ruleId);
      _updateSelectedRulesData();
    }
  }

  @override
  void removeLinkedRule(String ruleId) {
    formLinkedRules.remove(ruleId);
    _updateSelectedRulesData();
  }

  void _updateSelectedRulesData() {
    selectedRulesData.clear();
    for (String ruleId in formLinkedRules) {
      final rule = availableRules.firstWhereOrNull((r) => r.id == ruleId);
      if (rule != null) {
        selectedRulesData.add(rule);
      }
    }
  }

  @override
  void updatePreview() {
    previewTitle.value =
        formTitle.value.isEmpty ? 'Reward Name' : formTitle.value;
    previewDescription.value =
        formDescription.value.isEmpty
            ? 'Reward description will appear here...'
            : formDescription.value;
    previewHeaderImage.value = formHeaderImage.value;
    previewCarouselImages.assignAll(formCarouselImages);
    previewLogo.value = formLogo.value;
    previewBarcode.value =
        formBarcode.value.isEmpty ? '0000000000000' : formBarcode.value;
    previewCategories.assignAll(formCategories);
  }

  @override
  void clearForm() {
    formTitle.value = '';
    formDescription.value = '';
    formHeaderImage.value = '';
    formCarouselImages.clear();
    formLogo.value = '';
    formBarcode.value = '';
    formCategories.clear();
    formLinkedRules.clear();
    formCanCheckout.value = false;
    selectedRulesData.clear();
  }

  void _validateForm() {
    isFormValid.value =
        formTitle.value.isNotEmpty &&
        formDescription.value.isNotEmpty &&
        formHeaderImage.value.isNotEmpty &&
        formBarcode.value.isNotEmpty &&
        formCategories.isNotEmpty &&
        formLinkedRules.isNotEmpty;
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}
