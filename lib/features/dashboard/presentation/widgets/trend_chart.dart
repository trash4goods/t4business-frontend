import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/interactive_line_chart.dart';
import '../../../../core/data/sample_chart_data.dart';
import '../../../auth/data/models/user_auth/user_auth_model.dart';
import '../presenters/implementation/dashboard.dart';
import '../../../auth/data/models/user_auth/user_statistics_model.dart';

class TrendChart extends StatelessWidget {
  final UserAuthModel? user;
  const TrendChart({super.key, required this.user});

  List<ChartDataPoint> _buildChartDataFromStatistics(
    UserStatisticsModel? statistics,
  ) {
    final List<ChartDataPoint> dataPoints = [];

    if (statistics == null || statistics.years == null) {
      return SampleChartData.getRecyclingTrendData();
    }

    final years = statistics.years!;

    // Process all years and months
    for (final yearData in years) {
      final year = yearData.year;
      final months = yearData.months;

      if (year == null || months == null) continue;

      for (final monthData in months) {
        final month = monthData.month;
        final actions = monthData.actions ?? 0;

        if (month == null) continue;

        // Create a date for this month
        final date = DateTime(year, month, 15); // Using 15th as middle of month

        // Create ChartDataPoint
        // Using actions as the total value (desktop + mobile)
        // We'll split it arbitrarily for now since the data doesn't differentiate
        dataPoints.add(
          ChartDataPoint(
            date: date,
            desktop: actions * 0.6, // 60% as desktop
            mobile: actions * 0.4, // 40% as mobile
          ),
        );
      }
    }

    // Sort by date
    dataPoints.sort((a, b) => a.date.compareTo(b.date));

    // If we have data, return it; otherwise return sample data
    return dataPoints.isNotEmpty
        ? dataPoints
        : SampleChartData.getRecyclingTrendData();
  }

  @override
  Widget build(BuildContext context) {
    final statistics = user?.profile?.statistics;

    final chartData = _buildChartDataFromStatistics(statistics);

    // Calculate total actions from statistics
    final totalActions = statistics?.totalActions ?? 0;

    return InteractiveLineChart(
      data: chartData,
      title: 'Monthly Activity Trend',
      description: 'Total actions performed over time (Total: $totalActions)',
    );
  }
}
