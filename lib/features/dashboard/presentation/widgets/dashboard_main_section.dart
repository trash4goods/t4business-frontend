import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:t4g_for_business/core/app/app_routes.dart';
import '../controllers/interface/dashboard.dart';
import '../presenters/interface/dashboard.dart';
import 'main_dashboard_content.dart';
import 'business_overview_cards.dart';
import 'metrics_grid.dart';
import 'analytics_row.dart';
import 'performance_dashboard.dart';
import 'dashboard_charts_section.dart';
import 'recent_activity.dart';
import 'recent_activity_feed.dart';
import 'activity_and_actions.dart';
import 'quick_actions.dart';
import '../../data/models/chart_data.dart';

class DashboardMainSection extends StatelessWidget {
  final DashboardControllerInterface businessController;
  final DashboardPresenterInterface presenter;
  final BoxConstraints constraints;

  const DashboardMainSection({
    super.key,
    required this.businessController,
    required this.presenter,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return MainDashboardContent(
      constraints: constraints,
      buildBusinessOverviewCards:
          (ctx, cons) => BusinessOverviewCards(constraints: cons),
      buildMetricsGrid:
          (ctx, cons) => MetricsGrid(
            constraints: cons,
            totalProducts: presenter.totalProducts,
            totalRecycled: presenter.totalRecycled,
            onShowDetails: businessController.onShowMetricsDetails,
          ),
      buildAnalyticsRow:
          (ctx, cons) => AnalyticsRow(
            constraints: cons,
            user: presenter.user,
            onViewAllTopPerformers: businessController.onShowAllPerformers,
          ),
      buildPerformanceDashboard:
          (ctx, cons) => PerformanceDashboard(
            constraints: cons,
            onExport: businessController.downloadReport,
          ),
      buildChartsSection:
          (ctx, cons) => DashboardChartsSection(
            constraints: cons,
            data: businessController.getPieChartData(),
            onSectionTapped: (ChartData data) {
              log('Tapped on ${data.label}: ${data.value}');
            },
            title: 'Product Performance',
            subtitle: 'Track your products recycling trends over time',
          ),
      buildRecentActivity: (ctx, cons) {
        final items =
            presenter.mostRecycledProducts
                .map(
                  (p) => RecentItem(
                    title: p.title,
                    categories: p.category,
                    count: p.recycledCount,
                  ),
                )
                .toList();
        return RecentActivity(constraints: cons, items: items);
      },
      buildActivityAndActions:
          (ctx, cons) => ActivityAndActions(
            constraints: cons,
            recentActivityFeed: RecentActivityFeed(
              onViewAll: businessController.onShowAllActivity,
            ),
            quickActions: QuickActions(
              onAddProduct:
                  () => businessController.navigateToPage(
                    AppRoutes.productManagement,
                  ),
              onCreateReward:
                  () => businessController.navigateToPage(
                    AppRoutes.rewards,
                  ),
              onManageRules:
                  () => businessController.navigateToPage(AppRoutes.rulesV2),
              onViewReports: businessController.onShowReportsMenu,
            ),
          ),
    );
  }
}
