import 'package:flutter/material.dart';
import 'package:t4g_for_business/features/dashboard/data/models/chart_data.dart';

abstract class DashboardControllerInterface {
  void refreshData();
  // Sidebar functionality
  void toggleSidebar();
  Future<void> logout();
  void navigateToPage(String route);
  // Mobile/tablet navigation from drawer
  void handleMobileNavigation(String route);

  // Date range management
  void setPresetDateRange(int days);
  void setThisYearRange();
  void setFromDate(DateTime? date);
  void setToDate(DateTime? date);
  void applySelectedDateRange();

  // UI action handlers (delegated from View)
  void onShowMetricsDetails();
  void onShowAllPerformers();
  void onShowAllActivity();
  void onShowReportsMenu();
  void downloadReport();

  // Dialogs and data providers
  void showDateRangePicker(BuildContext context);
  List<ChartData> getPieChartData();
}
