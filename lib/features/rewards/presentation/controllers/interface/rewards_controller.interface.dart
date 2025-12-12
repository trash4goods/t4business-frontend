import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../data/models/reward_result.dart';

abstract class RewardsControllerInterface {
  Future<void> updateReward();
  Future<void> deleteReward(int? rewardId);
  Future<void> createReward();

  void startCreate();
  void cancelEdit();

  // UI dialog helpers (controller owns dialog; view provides context/callbacks)
  void showFilterDialog(
    BuildContext context, {
    required void Function(String) onFilterChanged,
  });

  void onNavigate(String route);
  void onLogout();
  void onToggle();

  void filterRewards(String category);
  void onFilterChanged(String filter);
  void toggleViewMode(String mode);
  void onStatusFilterChanged(String value);

  // Layout helpers (moved from view)
  int getGridCrossAxisCount(double width);
  double getGridSpacing(double width);
  double getRewardChildAspectRatio(double width);

  // Actions
  void startEdit(RewardResultModel reward);
  void confirmDeleteReward(
    BuildContext context,
    RewardResultModel reward, {
    required Future<void> Function() onConfirm
  });

  // Pagination methods
  Future<void> goToPage(int page);
  Future<void> refreshRewards();
  int getTotalPages();
  bool getHasPrevious();
  int getSafeCurrentPage();

  // Filtering and searching
  List<RewardResultModel> filterRewardsByCategory(String category);
  List<RewardResultModel> filterRewardsByStatus(bool canCheckout);
  List<RewardResultModel> searchRewards(String query);

  void updateFormField(String field, dynamic value);
  Future<void> uploadHeaderImage();
  Future<void> uploadLogo();
  Future<void> uploadCarouselImage();

  // Image management methods
  void removeHeaderImage();
  void removeCarouselImage(String imageUrl);
  void replaceHeaderImage(String newImageUrl);

  // Image upload utility methods
  Future<String> uploadImage(String imagePath);
  Future<String> uploadImageWithBytes(Uint8List fileBytes, String fileName);

  // UI feedback methods
  void showError(String message);
  void showSuccess(String message);

  // Rule linking methods
  void onRuleSelection();

  // Validation functionality
  void openValidationDialog();
  void validateRedeemCode();
  void onValidationCodeChanged(String code);
  void closeValidationDialog();
}
