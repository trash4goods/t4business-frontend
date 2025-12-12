
import 'package:flutter/material.dart';
import '../../data/models/rules_result.dart';

abstract class RulesV2ControllerInterface {
  // Filter and search functions
  void onStatusFilterChanged(String value);
  void searchRewards(String query);
  List<RulesResultModel> searchRules(String query);
  void onFilterChanged(String filter);
  void toggleViewMode(String mode);
  
  // Layout helpers  
  int getGridCrossAxisCount(double width);
  double getGridSpacing(double width);
  double getRewardChildAspectRatio(double width);
  
  // Pagination methods
  Future<void> goToPage(int page);
  Future<void> refreshRules();
  int getTotalPages();
  bool getHasPrevious();
  int getSafeCurrentPage();

  // Snackbars
  void showError(String message);
  void showSuccess(String message);
  
  // Create rule form actions
  void onCreateRuleNameChanged(String value);
  void onCreateRuleStatusChanged(bool value);
  void onCreateRuleQuantityChanged(int? value);
  void onCreateRuleCooldownPeriodChanged(int? value);
  void onCreateRuleUsageLimitChanged(int? value);
  void onCreateRuleExpiryDateChanged(DateTime? value);
  void onCreateRuleRewardsSelection();
  void onCreateRuleBarcodesSelection();
  
  // Actions
  void startCreate();
  void cancelCreateRule();
  void saveCreateRule();
  
  // Edit rule actions
  void startEdit(RulesResultModel rule);
  void cancelEditRule();
  void saveEditRule();
  
  // Delete rule actions
  void confirmDeleteRule(BuildContext context, RulesResultModel rule);
  Future<void> deleteRule(int? ruleId);
}