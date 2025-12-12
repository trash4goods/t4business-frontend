import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/core/app/app_routes.dart';
import '../../../core/app/constants.dart';
import '../../../core/app/custom_getview.dart';
import '../../../core/app/themes/app_colors.dart';
import '../../../core/app/themes/app_text_styles.dart';
import '../../../core/widgets/sidebar_navigation.dart';
import '../../product_managment/presentation/view/product.dart';
import '../../product_managment/presentation/bindings/product.dart';
import 'package:t4g_for_business/features/marketplace_products/presentation/bindings/product.dart'
    as marketplace_binding;
import 'package:t4g_for_business/features/marketplace_products/presentation/view/product.dart'
    as marketplace_view;
import 'package:t4g_for_business/features/rules/presentation/bindings/rule.dart'
    as rules_binding;
import 'package:t4g_for_business/features/rules/presentation/view/rule.dart'
    as rules_view;
import '../../profile/presentation/views/profile.dart';
import '../../profile/presentation/bindings/profile.dart';
import '../presentation/controllers/interface/dashboard.dart';
import '../presentation/presenters/interface/dashboard.dart';
import '../../../core/widgets/charts/recycling_pie_chart.dart';
import '../data/models/chart_data.dart';
import '../data/models/chart_config.dart';

class DashboardView
    extends
        CustomGetView<
          DashboardControllerInterface,
          DashboardPresenterInterface
        > {
  const DashboardView({super.key});

  // Reactive date range variables
  static final RxString _selectedDateRangeText = 'Last 30 days'.obs;
  static final Rx<DateTimeRange?> _selectedDateRange = Rx<DateTimeRange?>(null);

  @override
  Widget buildView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async => log('Refreshing dashboard data...'),
            child: Container(
              decoration: BoxDecoration(color: AppColors.surfaceElevated),
              child: Row(
                children: [
                  if (isDesktop)
                    Obx(
                      () => SidebarNavigation(
                        currentRoute: presenter.currentRoute.value,
                        isCollapsed: presenter.isCollapsed.value,
                        onToggle: businessController.toggleSidebar,
                        onNavigate: businessController.navigateToPage,
                        onLogout: businessController.logout,
                      ),
                    ),
                  Expanded(child: _buildCurrentPage(context, constraints)),
                ],
              ),
            ),
          ),
          drawer:
              !isDesktop
                  ? Drawer(
                    child: Obx(
                      () => SidebarNavigation(
                        currentRoute: presenter.currentRoute.value,
                        isCollapsed: false,
                        onToggle: () {
                          // Close drawer when toggle is pressed on mobile/tablet
                          Scaffold.of(context).closeDrawer();
                        },
                        onNavigate:
                            (route) => _handleMobileNavigation(context, route),
                        onLogout: businessController.logout,
                      ),
                    ),
                  )
                  : null,
        );
      },
    );
  }

  void _handleMobileNavigation(BuildContext context, String route) {
    // Close drawer on mobile/tablet if it's open
    // Use a slight delay to ensure smooth animation
    Navigator.of(context).pop();

    // Navigate to the page first
    businessController.navigateToPage(route);
  }

  Widget _buildCurrentPage(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      switch (presenter.currentRoute.value) {
        case AppRoutes.dashboard:
          return _buildDashboardContent(context, constraints);
        case AppRoutes.productManagement:
          ProductsBinding().dependencies();
          return _buildProductManagementContent(context, constraints);
        case AppRoutes.marketplaceProducts:
          marketplace_binding.MarketplaceProductsBinding().dependencies();
          return _buildMarketplaceProductsContent(context, constraints);
        case AppRoutes.rules:
          rules_binding.RulesBinding().dependencies();
          return _buildRulesContent(context, constraints);
        case AppRoutes.profile:
          ProfileBinding().dependencies();
          return _buildProfileContent(context, constraints);
        default:
          return _buildDashboardContent(context, constraints);
      }
    });
  }

  Widget _buildProductManagementContent(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return Column(
      children: [
        _buildPageHeader(
          context,
          constraints,
          title: 'Recycling Products',
          subtitle:
              'Manage your product catalog and track recycling performance',
          icon: Icons.recycling_outlined,
        ),
        Expanded(child: ProductsPage()),
      ],
    );
  }

  Widget _buildMarketplaceProductsContent(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return Column(
      children: [
        _buildPageHeader(
          context,
          constraints,
          title: 'Rewards',
          subtitle: 'Manage your marketplace product catalog',
          icon: Icons.storefront_outlined,
        ),
        Expanded(child: marketplace_view.RewardsPage()),
      ],
    );
  }

  Widget _buildRulesContent(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        _buildPageHeader(
          context,
          constraints,
          title: 'Rules',
          subtitle:
              'Create and manage recycling rules for your rewards program',
          icon: Icons.rule_outlined,
        ),
        Expanded(child: rules_view.RulesPage()),
      ],
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return Column(
      children: [
        _buildPageHeader(
          context,
          constraints,
          title: 'Profile Settings',
          subtitle: 'Manage your account and business information',
          icon: Icons.person_outline,
        ),
        Expanded(child: ProfileView()),
      ],
    );
  }

  Widget _buildPageHeader(
    BuildContext context,
    BoxConstraints constraints, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, size: 20),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.foreground,
                    ),
                  ),
            ),
            const SizedBox(width: 16),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      isDesktop ? AppTextStyles.h3green : AppTextStyles.h4green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return Column(
      children: [
        _buildHeader(context, constraints),
        Expanded(
          child: Obx(() {
            if (presenter.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              );
            }

            if (presenter.error != null) {
              return _buildErrorState();
            }

            return _buildMainDashboardContent(context, constraints);
          }),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop) ...[
            Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, size: 20),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.foreground,
                    ),
                  ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style:
                      isDesktop ? AppTextStyles.h3green : AppTextStyles.h4green,
                ),
              ],
            ),
          ),
          _buildHeaderActions(isDesktop, context),
        ],
      ),
    );
  }

  Widget _buildHeaderActions(bool isDesktop, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShadButton.outline(
          onPressed: businessController.refreshData,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_outlined, size: 16, color: AppColors.primary),
              if (isDesktop) ...[
                const SizedBox(width: 6),
                Text(
                  'Refresh',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(width: 12),
          Obx(
            () => ShadButton.outline(
              onPressed: () => _showDateRangePicker(Get.context!),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedDateRangeText.value,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showDateRangePicker(BuildContext context) {
    showShadDialog(
      context: context,
      builder:
          (context) => ShadDialog(
            title: const Text('Select Date Range'),
            description: const Text(
              'Choose a custom date range for dashboard data',
            ),
            child: Container(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  _buildDateRangeSelector(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            actions: [
              ShadButton.outline(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ShadButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _applyDateRange();
                },
                child: const Text('Apply'),
              ),
            ],
          ),
    );
  }

  Widget _buildDateRangeSelector(BuildContext context) {
    return Column(
      children: [
        // Quick preset buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetButton('Last 7 days', () => _setPresetRange(7)),
            _buildPresetButton('Last 30 days', () => _setPresetRange(30)),
            _buildPresetButton('Last 90 days', () => _setPresetRange(90)),
            _buildPresetButton('This Year', () => _setThisYear()),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        // Custom date range input
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From Date',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShadButton.outline(
                    onPressed: () => _selectStartDate(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            _selectedDateRange.value?.start != null
                                ? _formatDate(_selectedDateRange.value!.start)
                                : 'Select start date',
                            style: AppTextStyles.small,
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To Date',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShadButton.outline(
                    onPressed: () => _selectEndDate(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            _selectedDateRange.value?.end != null
                                ? _formatDate(_selectedDateRange.value!.end)
                                : 'Select end date',
                            style: AppTextStyles.small,
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetButton(String label, VoidCallback onPressed) {
    return ShadButton.outline(
      onPressed: onPressed,
      size: ShadButtonSize.sm,
      child: Text(label),
    );
  }

  void _setPresetRange(int days) {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));
    _selectedDateRange.value = DateTimeRange(start: start, end: end);
    _selectedDateRangeText.value = 'Last $days days';
  }

  void _setThisYear() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    final end = DateTime(now.year, 12, 31);
    _selectedDateRange.value = DateTimeRange(start: start, end: end);
    _selectedDateRangeText.value = 'This Year';
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateRange.value?.start ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final currentRange = _selectedDateRange.value;
      _selectedDateRange.value = DateTimeRange(
        start: picked,
        end: currentRange?.end ?? picked.add(const Duration(days: 30)),
      );
      _updateCustomDateText();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateRange.value?.end ?? DateTime.now(),
      firstDate: _selectedDateRange.value?.start ?? DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final currentRange = _selectedDateRange.value;
      _selectedDateRange.value = DateTimeRange(
        start: currentRange?.start ?? picked.subtract(const Duration(days: 30)),
        end: picked,
      );
      _updateCustomDateText();
    }
  }

  void _updateCustomDateText() {
    final range = _selectedDateRange.value;
    if (range != null) {
      _selectedDateRangeText.value =
          '${_formatDate(range.start)} - ${_formatDate(range.end)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _applyDateRange() {
    // Here you can trigger data refresh with the selected date range
    final range = _selectedDateRange.value;
    if (range != null) {
      log('Applying date range: ${range.start} to ${range.end}');
      // Call your data refresh method with the date range
      businessController.refreshData();

      // Show success message
      Get.snackbar(
        'Date Range Applied',
        'Dashboard data updated for ${_selectedDateRangeText.value}',
        backgroundColor: AppColors.primary.withOpacity(0.1),
        colorText: AppColors.primary,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.7),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.destructive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.destructive,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Something went wrong', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              presenter.error!,
              style: AppTextStyles.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: businessController.refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDashboardContent(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business Overview Cards
          _buildBusinessOverviewCards(context, constraints),
          const SizedBox(height: 24),

          // Key Metrics Grid
          _buildShadMetricsGrid(context, constraints),
          const SizedBox(height: 24),

          // Analytics & Insights Row
          _buildAnalyticsRow(context, constraints),
          const SizedBox(height: 24),

          // Performance Dashboard
          _buildPerformanceDashboard(context, constraints),
          const SizedBox(height: 24),

          // Charts and Recent Activity Layout
          isDesktop
              ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildChartsSection(context, constraints),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: _buildRecentActivity(context, constraints)),
                ],
              )
              : Column(
                children: [
                  _buildChartsSection(context, constraints),
                  const SizedBox(height: 24),
                  _buildRecentActivity(context, constraints),
                ],
              ),
          const SizedBox(height: 24),

          // Recent Activity & Quick Actions
          _buildActivityAndActions(context, constraints),
        ],
      ),
    );
  }

  Widget _buildBusinessOverviewCards(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.business_center,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Overview',
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Your recycling business performance at a glance',
                        style: AppTextStyles.muted,
                      ),
                    ],
                  ),
                ),
                ShadBadge(
                  backgroundColor: AppColors.success.withOpacity(0.1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Live Data',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isDesktop
                ? Row(
                  children: [
                    Expanded(
                      child: _buildQuickStatCard(
                        'Total Revenue',
                        '\$12,450',
                        '+15%',
                        Icons.trending_up,
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickStatCard(
                        'Items Recycled',
                        '2,847',
                        '+8%',
                        Icons.recycling,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickStatCard(
                        'Active Customers',
                        '156',
                        '+12%',
                        Icons.people,
                        AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickStatCard(
                        'Environmental Impact',
                        '1.2T CO₂',
                        '+5%',
                        Icons.eco,
                        AppColors.success,
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickStatCard(
                            'Revenue',
                            '\$12,450',
                            '+15%',
                            Icons.trending_up,
                            AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickStatCard(
                            'Recycled',
                            '2,847',
                            '+8%',
                            Icons.recycling,
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickStatCard(
                            'Customers',
                            '156',
                            '+12%',
                            Icons.people,
                            AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickStatCard(
                            'CO₂ Saved',
                            '1.2T',
                            '+5%',
                            Icons.eco,
                            AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const Spacer(),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.small.copyWith(
              color: AppColors.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadMetricsGrid(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Key Performance Metrics',
              style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            ShadButton.outline(
              onPressed: () => _showMetricsDetails(),
              size: ShadButtonSize.sm,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.analytics_outlined, size: 14),
                  SizedBox(width: 4),
                  Text('View Details'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        isDesktop
            ? Row(
              children: [
                Expanded(
                  child: _buildShadMetricCard(
                    'Products',
                    presenter.totalProducts.toString(),
                    '+12%',
                    Icons.inventory_2_outlined,
                    AppColors.primary,
                    'Total products in catalog',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildShadMetricCard(
                    'Recycled',
                    presenter.totalRecycled.toString(),
                    '+8%',
                    Icons.recycling_outlined,
                    AppColors.success,
                    'Items successfully recycled',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildShadMetricCard(
                    'Rate',
                    '${presenter.totalProducts > 0 ? ((presenter.totalRecycled / presenter.totalProducts) * 100).toStringAsFixed(1) : '0'}%',
                    '+2.5%',
                    Icons.trending_up_outlined,
                    AppColors.warning,
                    'Recycling efficiency rate',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildShadMetricCard(
                    'Rewards',
                    '43',
                    '+18%',
                    Icons.card_giftcard_outlined,
                    AppColors.secondary,
                    'Active reward programs',
                  ),
                ),
              ],
            )
            : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildShadMetricCard(
                        'Products',
                        presenter.totalProducts.toString(),
                        '+12%',
                        Icons.inventory_2_outlined,
                        AppColors.primary,
                        'Total products',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildShadMetricCard(
                        'Recycled',
                        presenter.totalRecycled.toString(),
                        '+8%',
                        Icons.recycling_outlined,
                        AppColors.success,
                        'Items recycled',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildShadMetricCard(
                        'Rate',
                        '${presenter.totalProducts > 0 ? ((presenter.totalRecycled / presenter.totalProducts) * 100).toStringAsFixed(1) : '0'}%',
                        '+2.5%',
                        Icons.trending_up_outlined,
                        AppColors.warning,
                        'Success rate',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildShadMetricCard(
                        'Rewards',
                        '43',
                        '+18%',
                        Icons.card_giftcard_outlined,
                        AppColors.secondary,
                        'Active rewards',
                      ),
                    ),
                  ],
                ),
              ],
            ),
      ],
    );
  }

  Widget _buildShadMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
    String description,
  ) {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const Spacer(),
                ShadBadge(
                  backgroundColor: AppColors.success.withOpacity(0.1),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.foreground,
              ),
            ),
            Text(
              description,
              style: AppTextStyles.small.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMetricsDetails() {
    Get.snackbar(
      'Metrics Details',
      'Detailed analytics view coming soon!',
      backgroundColor: AppColors.primary.withOpacity(0.1),
      colorText: AppColors.primary,
    );
  }

  Widget _buildAnalyticsRow(BuildContext context, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return isDesktop
        ? Row(
          children: [
            Expanded(flex: 2, child: _buildTrendChart()),
            const SizedBox(width: 24),
            Expanded(child: _buildTopPerformers()),
          ],
        )
        : Column(
          children: [
            _buildTrendChart(),
            const SizedBox(height: 24),
            _buildTopPerformers(),
          ],
        );
  }

  Widget _buildTrendChart() {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recycling Trends',
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                ShadBadge(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    'Last 30 Days',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 48,
                      color: AppColors.primary.withOpacity(0.6),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Interactive Chart',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Recycling trends visualization',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTrendIndicator('Items', '↗ 23%', AppColors.success),
                const SizedBox(width: 16),
                _buildTrendIndicator('Revenue', '↗ 15%', AppColors.success),
                const SizedBox(width: 16),
                _buildTrendIndicator('Efficiency', '↗ 8%', AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.small.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPerformers() {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Top Performers',
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                ShadButton.outline(
                  onPressed: () => _showAllPerformers(),
                  size: ShadButtonSize.sm,
                  child: Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...List.generate(4, (index) {
              final products = [
                'Plastic Bottles',
                'Paper Waste',
                'Metal Cans',
                'Glass Items',
              ];
              final counts = ['847', '623', '459', '234'];
              final percentages = ['32%', '24%', '18%', '26%'];

              return Padding(
                padding: EdgeInsets.only(bottom: index < 3 ? 16 : 0),
                child: _buildPerformerItem(
                  index + 1,
                  products[index],
                  counts[index],
                  percentages[index],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformerItem(
    int rank,
    String name,
    String count,
    String percentage,
  ) {
    final colors = [
      AppColors.warning,
      AppColors.success,
      AppColors.primary,
      AppColors.secondary,
    ];
    final color = colors[(rank - 1) % colors.length];

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                '$count items recycled',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        ShadBadge(
          backgroundColor: color.withOpacity(0.1),
          child: Text(
            percentage,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showAllPerformers() {
    Get.snackbar(
      'Top Performers',
      'Detailed performance analytics coming soon!',
      backgroundColor: AppColors.primary.withOpacity(0.1),
      colorText: AppColors.primary,
    );
  }

  Widget _buildPerformanceDashboard(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.eco, color: AppColors.success, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Environmental Impact Dashboard',
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Track your positive environmental contributions',
                        style: AppTextStyles.muted,
                      ),
                    ],
                  ),
                ),
                ShadButton.outline(
                  onPressed: () => _showImpactReport(),
                  size: ShadButtonSize.sm,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.download_outlined, size: 14),
                      SizedBox(width: 4),
                      Text('Export Report'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            constraints.maxWidth > AppConstants.tabletBreakpoint
                ? Row(
                  children: [
                    Expanded(
                      child: _buildImpactCard(
                        'CO₂ Reduced',
                        '1,247 kg',
                        'Equivalent to 15 trees planted',
                        Icons.park,
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImpactCard(
                        'Water Saved',
                        '3,420 L',
                        'Equivalent to 68 showers',
                        Icons.water_drop,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImpactCard(
                        'Energy Saved',
                        '847 kWh',
                        'Powers 12 homes for 1 day',
                        Icons.bolt,
                        AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImpactCard(
                        'Waste Diverted',
                        '2.3 tons',
                        'From landfills this month',
                        Icons.delete_sweep,
                        AppColors.secondary,
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildImpactCard(
                            'CO₂ Reduced',
                            '1,247 kg',
                            'Equiv. to 15 trees',
                            Icons.park,
                            AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildImpactCard(
                            'Water Saved',
                            '3,420 L',
                            'Equiv. to 68 showers',
                            Icons.water_drop,
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildImpactCard(
                            'Energy Saved',
                            '847 kWh',
                            '12 homes for 1 day',
                            Icons.bolt,
                            AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildImpactCard(
                            'Waste Diverted',
                            '2.3 tons',
                            'From landfills',
                            Icons.delete_sweep,
                            AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard(
    String title,
    String value,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            description,
            style: AppTextStyles.small.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  void _showImpactReport() {
    Get.snackbar(
      'Impact Report',
      'Environmental impact report will be downloaded!',
      backgroundColor: AppColors.success.withOpacity(0.1),
      colorText: AppColors.success,
    );
  }

  Widget _buildMetricsGrid(BuildContext context, BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final isDesktop = screenWidth > AppConstants.tabletBreakpoint;
    final isTablet =
        screenWidth > AppConstants.mobileBreakpoint &&
        screenWidth <= AppConstants.tabletBreakpoint;

    // Calculate optimal card width and count based on screen size
    double optimalCardWidth;
    int crossAxisCount;
    double spacing;

    if (isDesktop) {
      // Desktop: Aim for 280-320px card width
      optimalCardWidth = 300;
      crossAxisCount = (screenWidth / (optimalCardWidth + 24)).floor().clamp(
        2,
        4,
      );
      spacing = 24;
    } else if (isTablet) {
      // Tablet: Aim for 250-280px card width
      optimalCardWidth = 265;
      crossAxisCount = (screenWidth / (optimalCardWidth + 16)).floor().clamp(
        2,
        3,
      );
      spacing = 16;
    } else {
      // Mobile: Single column with full width
      crossAxisCount = 1;
      spacing = 12;
    }

    // Calculate actual card width based on available space
    final totalSpacing = spacing * (crossAxisCount - 1);
    final actualCardWidth = (screenWidth - totalSpacing) / crossAxisCount;

    // More flexible aspect ratio calculation
    // Ensure minimum height while being responsive
    final minCardHeight = isDesktop ? 120.0 : (isTablet ? 110.0 : 100.0);
    final maxCardHeight = isDesktop ? 160.0 : (isTablet ? 140.0 : 130.0);

    // Calculate height based on content needs and available width
    double cardHeight;
    if (actualCardWidth < 200) {
      cardHeight = minCardHeight; // Compact for very small cards
    } else if (actualCardWidth > 350) {
      cardHeight = maxCardHeight; // Taller for very wide cards
    } else {
      // Interpolate between min and max based on width
      final factor = (actualCardWidth - 200) / (350 - 200);
      cardHeight = minCardHeight + (maxCardHeight - minCardHeight) * factor;
    }

    final aspectRatio = actualCardWidth / cardHeight;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: aspectRatio,
      children: [
        _buildMetricCard(
          title: 'Total Products',
          value: presenter.totalProducts.toString(),
          change: '+12%',
          isPositive: true,
          icon: Icons.inventory_2_outlined,
          screenWidth: actualCardWidth,
          cardHeight: cardHeight,
        ),
        _buildMetricCard(
          title: 'Products Recycled',
          value: presenter.totalRecycled.toString(),
          change: '+8%',
          isPositive: true,
          icon: Icons.recycling_outlined,
          screenWidth: actualCardWidth,
          cardHeight: cardHeight,
        ),
        _buildMetricCard(
          title: 'Recycling Rate',
          value:
              presenter.totalProducts > 0
                  ? '${((presenter.totalRecycled / presenter.totalProducts) * 100).toStringAsFixed(1)}%'
                  : '0%',
          change: '+2.5%',
          isPositive: true,
          icon: Icons.trending_up_outlined,
          screenWidth: actualCardWidth,
          cardHeight: cardHeight,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
    required double screenWidth,
    required double cardHeight,
  }) {
    // Calculate responsive sizing based on card dimensions
    final isVerySmall = screenWidth < 180 || cardHeight < 100;
    final isSmall = screenWidth < 220 || cardHeight < 120;
    final isLarge = screenWidth > 280 && cardHeight > 140;

    // Dynamic padding based on card size
    final cardPadding =
        isVerySmall ? 8.0 : (isSmall ? 12.0 : (isLarge ? 20.0 : 16.0));

    // Dynamic font sizes based on card size
    final titleFontSize =
        isVerySmall ? 10.0 : (isSmall ? 11.0 : (isLarge ? 13.0 : 12.0));
    final valueFontSize =
        isVerySmall ? 16.0 : (isSmall ? 20.0 : (isLarge ? 28.0 : 24.0));
    final changeFontSize =
        isVerySmall ? 9.0 : (isSmall ? 10.0 : (isLarge ? 12.0 : 11.0));
    final iconSize =
        isVerySmall ? 14.0 : (isSmall ? 16.0 : (isLarge ? 20.0 : 18.0));

    // Dynamic spacing
    final spacing =
        isVerySmall ? 4.0 : (isSmall ? 6.0 : (isLarge ? 10.0 : 8.0));

    // Determine if we should hide the description text for very small cards
    final showDescription = !isVerySmall && screenWidth > 160;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with title and icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.small.copyWith(
                      fontSize: titleFontSize,
                      color: AppColors.mutedForeground,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: isVerySmall ? 1 : 2,
                  ),
                ),
                SizedBox(width: spacing * 0.5),
                Icon(icon, size: iconSize, color: AppColors.mutedForeground),
              ],
            ),

            SizedBox(height: spacing),

            // Value - this takes priority in layout
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: valueFontSize,
                      color: AppColors.foreground,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: spacing * 0.5),

            // Change indicator - flexible layout
            Flexible(
              child: Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    size: changeFontSize + 1,
                    color:
                        isPositive ? AppColors.success : AppColors.destructive,
                  ),
                  SizedBox(width: spacing * 0.3),
                  Text(
                    change,
                    style: AppTextStyles.small.copyWith(
                      color:
                          isPositive
                              ? AppColors.success
                              : AppColors.destructive,
                      fontWeight: FontWeight.w500,
                      fontSize: changeFontSize,
                      height: 1.0,
                    ),
                  ),
                  if (showDescription) ...[
                    SizedBox(width: spacing * 0.3),
                    Flexible(
                      child: Text(
                        'vs last month',
                        style: AppTextStyles.small.copyWith(
                          fontSize: changeFontSize - 1,
                          color: AppColors.mutedForeground,
                          height: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.7),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Performance',
                      style: isDesktop ? AppTextStyles.h4 : AppTextStyles.large,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track your products recycling trends over time',
                      style: AppTextStyles.muted,
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'View Report',
                    style: AppTextStyles.smallGreen,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          SizedBox(
            height: isDesktop ? 400 : 300,
            child: RecyclingPieChart(
              data: _generatePieChartData(),
              config: const ChartConfig(
                title: 'Most Recycled Products',
                subtitle: 'Jan - Jun 2024',
                showTooltip: true,
                showLegend: true,
              ),
              onSectionTapped: (data) {
                // Handle section tap - could navigate to product details
                log('Tapped on ${data.label}: ${data.value}');
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ChartData> _generatePieChartData() {
    final products = presenter.getMostRecycledProducts();

    // Define colors for different product categories
    final categoryColors = {
      'Bottles': AppColors.primary,
      'Electronics': const Color(0xFF10B981), // Green
      'Stationery': const Color(0xFFF59E0B), // Amber
      'Eco-friendly': const Color(0xFF8B5CF6), // Purple
      'Bamboo': const Color(0xFFF97316), // Orange
      'Paper': const Color(0xFF06B6D4), // Cyan
    };

    // Convert products to pie chart data
    return products.map((product) {
      // Get color based on first category or use a default
      final category =
          product.category.isNotEmpty ? product.category.first : 'Other';
      final color = categoryColors[category] ?? AppColors.secondary;

      return ChartData(
        label: product.title,
        value: product.recycledCount.toDouble(),
        color: color,
        category: category,
      );
    }).toList();
  }

  Widget _buildRecentActivity(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.7),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Recycled Products',
            style: isDesktop ? AppTextStyles.h4 : AppTextStyles.large,
          ),
          const SizedBox(height: 16),
          if (presenter.mostRecycledProducts.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No products found', style: AppTextStyles.muted),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: presenter.mostRecycledProducts.length,
              separatorBuilder:
                  (context, index) =>
                      const Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, index) {
                final product = presenter.mostRecycledProducts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors
                              .chartColors[index % AppColors.chartColors.length]
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: AppTextStyles.small.copyWith(
                              fontWeight: FontWeight.w600,
                              color:
                                  AppColors.chartColors[index %
                                      AppColors.chartColors.length],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              product.category.join(' â€¢ '),
                              style: AppTextStyles.small,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${product.recycledCount}',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.yellowDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActivityAndActions(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return isDesktop
        ? Row(
          children: [
            Expanded(flex: 2, child: _buildRecentActivityFeed()),
            const SizedBox(width: 24),
            Expanded(child: _buildQuickActions()),
          ],
        )
        : Column(
          children: [
            _buildRecentActivityFeed(),
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
        );
  }

  Widget _buildRecentActivityFeed() {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.history,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Activity',
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Track your latest business activities',
                        style: AppTextStyles.muted,
                      ),
                    ],
                  ),
                ),
                ShadButton.outline(
                  onPressed: () => _showAllActivity(),
                  size: ShadButtonSize.sm,
                  child: Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...List.generate(5, (index) {
              final activities = [
                {
                  'title': 'New product added',
                  'subtitle': 'Recycled Plastic Bottle',
                  'time': '2 hours ago',
                  'icon': Icons.add_circle,
                  'color': AppColors.success,
                },
                {
                  'title': 'Recycling completed',
                  'subtitle': 'Paper Waste - 45 items',
                  'time': '4 hours ago',
                  'icon': Icons.recycling,
                  'color': AppColors.primary,
                },
                {
                  'title': 'Customer milestone',
                  'subtitle': 'EcoUser123 - 100 items recycled',
                  'time': '6 hours ago',
                  'icon': Icons.emoji_events,
                  'color': AppColors.warning,
                },
                {
                  'title': 'Rule updated',
                  'subtitle': 'Plastic recycling rules modified',
                  'time': '1 day ago',
                  'icon': Icons.rule,
                  'color': AppColors.secondary,
                },
                {
                  'title': 'Monthly report',
                  'subtitle': 'Environmental impact report generated',
                  'time': '2 days ago',
                  'icon': Icons.assessment,
                  'color': AppColors.success,
                },
              ];

              final activity = activities[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index < 4 ? 16 : 0),
                child: _buildActivityItem(
                  activity['title'] as String,
                  activity['subtitle'] as String,
                  activity['time'] as String,
                  activity['icon'] as IconData,
                  activity['color'] as Color,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                subtitle,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: AppTextStyles.small.copyWith(color: AppColors.mutedForeground),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.bolt, color: AppColors.secondary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Streamline your workflow',
                        style: AppTextStyles.muted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildQuickActionButton(
              'Add New Product',
              'Create a new recyclable product',
              Icons.add_box,
              AppColors.primary,
              () => businessController.navigateToPage(
                AppRoutes.productManagement,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickActionButton(
              'Create Reward',
              'Set up a new customer reward',
              Icons.card_giftcard,
              AppColors.success,
              () => businessController.navigateToPage(
                AppRoutes.marketplaceProducts,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickActionButton(
              'Manage Rules',
              'Update recycling rules',
              Icons.settings,
              AppColors.warning,
              () => businessController.navigateToPage(AppRoutes.rules),
            ),
            const SizedBox(height: 12),
            _buildQuickActionButton(
              'View Reports',
              'Generate business analytics',
              Icons.analytics,
              AppColors.secondary,
              () => _showReportsMenu(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.card,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.mutedForeground,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAllActivity() {
    Get.snackbar(
      'Activity Feed',
      'Complete activity history coming soon!',
      backgroundColor: AppColors.primary.withOpacity(0.1),
      colorText: AppColors.primary,
    );
  }

  void _showReportsMenu() {
    Get.snackbar(
      'Reports',
      'Business analytics and reports coming soon!',
      backgroundColor: AppColors.secondary.withOpacity(0.1),
      colorText: AppColors.secondary,
    );
  }
}
