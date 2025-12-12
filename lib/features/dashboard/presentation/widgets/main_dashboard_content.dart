import 'package:flutter/material.dart';
import '../../../../core/app/constants.dart';

class MainDashboardContent extends StatelessWidget {
  final BoxConstraints constraints;
  final Widget Function(BuildContext, BoxConstraints) buildBusinessOverviewCards;
  final Widget Function(BuildContext, BoxConstraints) buildMetricsGrid;
  final Widget Function(BuildContext, BoxConstraints) buildAnalyticsRow;
  final Widget Function(BuildContext, BoxConstraints) buildPerformanceDashboard;
  final Widget Function(BuildContext, BoxConstraints) buildChartsSection;
  final Widget Function(BuildContext, BoxConstraints) buildRecentActivity;
  final Widget Function(BuildContext, BoxConstraints) buildActivityAndActions;

  const MainDashboardContent({
    super.key,
    required this.constraints,
    required this.buildBusinessOverviewCards,
    required this.buildMetricsGrid,
    required this.buildAnalyticsRow,
    required this.buildPerformanceDashboard,
    required this.buildChartsSection,
    required this.buildRecentActivity,
    required this.buildActivityAndActions,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business Overview Cards
          buildBusinessOverviewCards(context, constraints),
          const SizedBox(height: 24),

          // Key Metrics Grid
          buildMetricsGrid(context, constraints),
          const SizedBox(height: 24),

          // Analytics & Insights Row
          buildAnalyticsRow(context, constraints),
          const SizedBox(height: 24),

          // Performance Dashboard
          buildPerformanceDashboard(context, constraints),
          const SizedBox(height: 24),

          // Charts and Recent Activity Layout
          if (isDesktop)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: buildChartsSection(context, constraints),
                ),
                const SizedBox(width: 24),
                Expanded(child: buildRecentActivity(context, constraints)),
              ],
            )
          else ...[
            buildChartsSection(context, constraints),
            const SizedBox(height: 24),
            buildRecentActivity(context, constraints),
          ],
          const SizedBox(height: 24),

          // Recent Activity & Quick Actions
          buildActivityAndActions(context, constraints),
        ],
      ),
    );
  }
}
