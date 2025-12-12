import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:t4g_for_business/core/services/navigation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/features/auth/data/datasources/auth_cache.dart';

import '../../../../../core/app/app_routes.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../utils/helpers/snackbar_service.dart';
import '../../../../dashboard_shell/presentation/presenter/dashboard_shell_presenter.interface.dart';
import '../../../domain/usecase/usecase.dart';
import '../../../views/dashboard.dart';
import '../../presenters/interface/dashboard.dart';
import '../interface/dashboard.dart';
import 'package:t4g_for_business/features/dashboard/presentation/widgets/date_range_selector.dart';
import 'package:t4g_for_business/features/dashboard/data/models/chart_data.dart';

class DashboardControllerImpl implements DashboardControllerInterface {
  DashboardControllerImpl({
    required this.presenter,
    required this.usecase,
    required this.dashboardShellPresenter,
  });
  final DashboardPresenterInterface presenter;
  final DashboardUsecaseInterface usecase;
  final DashboardShellPresenterInterface dashboardShellPresenter;

  @override
  void refreshData() {
    presenter.loadDashboardData();
  }

  @override
  void toggleSidebar() {
    presenter.isCollapsed.toggle();
  }

  @override
  void navigateToPage(String route) => CustomNavigationService.offNested(route);

  @override
  Future<void> logout() async {
    try {
      //-TODO: MOVE DASHBOARDSHELL DATASOURCE, REPOSITORY LOGIC TO DASHBOARD 
      await usecase.signOut();
      await AuthService.instance.logout();
      // clear user profile from cache
      await AuthCacheDataSource.instance.clearUserAuth();
      NavigationService.offAll(AppRoutes.login);
    } catch (e) {
      showError('Logout failed: ${e.toString()}');
    }
  }

  @override
  void handleMobileNavigation(String route) {
    presenter.currentRoute.value = route;
    presenter.scaffoldKey.currentState?.closeDrawer();
    navigateToPage(route);
  }

  void showError(String message) => SnackbarServiceHelper.showError(
    message,
    position: SnackPosition.TOP,
    actionLabel: 'Dismiss',
    onActionPressed: () => Get.back(),
  );

  void showSuccess(String message) => SnackbarServiceHelper.showSuccess(
    message,
    position: SnackPosition.TOP,
    actionLabel: 'OK',
  );

  // Date range management
  @override
  void setPresetDateRange(int days) {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));
    presenter.setSelectedDateRange(DateTimeRange(start: start, end: end));
    presenter.setSelectedDateRangeText('Last $days days');
  }

  @override
  void setThisYearRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    final end = DateTime(now.year, 12, 31);
    presenter.setSelectedDateRange(DateTimeRange(start: start, end: end));
    presenter.setSelectedDateRangeText('This Year');
  }

  @override
  void setFromDate(DateTime? date) {
    if (date == null) return;
    final current = presenter.selectedDateRange.value;
    final newRange = DateTimeRange(
      start: date,
      end: current?.end ?? date.add(const Duration(days: 30)),
    );
    presenter.setSelectedDateRange(newRange);
    _updateCustomDateText();
  }

  @override
  void setToDate(DateTime? date) {
    if (date == null) return;
    final current = presenter.selectedDateRange.value;
    final newRange = DateTimeRange(
      start: current?.start ?? date.subtract(const Duration(days: 30)),
      end: date,
    );
    presenter.setSelectedDateRange(newRange);
    _updateCustomDateText();
  }

  void _updateCustomDateText() {
    final range = presenter.selectedDateRange.value;
    if (range != null) {
      presenter.setSelectedDateRangeText(
        '${_fmt(range.start)} - ${_fmt(range.end)}',
      );
    }
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  void applySelectedDateRange() {
    // Could trigger a usecase filter here; for now just refresh and notify
    refreshData();
    showSuccess(
      'Dashboard updated for ${presenter.selectedDateRangeText.value}',
    );
  }

  // UI action handlers
  @override
  void onShowMetricsDetails() {
    showSuccess('Detailed analytics view coming soon!');
  }

  @override
  void onShowAllPerformers() {
    showSuccess('Detailed performance analytics coming soon!');
  }

  @override
  void onShowAllActivity() {
    showSuccess('Complete activity history coming soon!');
  }

  @override
  void onShowReportsMenu() {
    showSuccess('Business analytics and reports coming soon!');
  }

  @override
  void downloadReport() {
    showSuccess('Generating and downloading report...');
  }

  @override
  void showDateRangePicker(BuildContext context) {
    showShadDialog(
      context: context,
      builder:
          (context) => ShadDialog(
            title: const Text('Select Date Range'),
            description: const Text(
              'Choose a custom date range for dashboard data',
            ),
            actions: [
              ShadButton.outline(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ShadButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  applySelectedDateRange();
                },
                child: const Text('Apply'),
              ),
            ],
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  DateRangeSelector(
                    selectedRange: presenter.selectedDateRange,
                    onPresetDays: (days) => setPresetDateRange(days),
                    onThisYear: setThisYearRange,
                    onFromDateSelected: (date) => setFromDate(date),
                    onToDateSelected: (date) => setToDate(date),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
    );
  }

  @override
  List<ChartData> getPieChartData() {
    return presenter.getPieChartData();
  }
}
