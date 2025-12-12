import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../app/themes/app_colors.dart';

class ChartDataPoint {
  final DateTime date;
  final double desktop;
  final double mobile;

  ChartDataPoint({
    required this.date,
    required this.desktop,
    required this.mobile,
  });
}

class InteractiveLineChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final String title;
  final String description;
  final Animation<double>? animation;
  final double? maxHeight;
  final double? maxWidth;

  const InteractiveLineChart({
    super.key,
    required this.data,
    required this.title,
    required this.description,
    this.animation,
    this.maxHeight,
    this.maxWidth,
  });

  int get totalValue => data.fold(
    0,
    (sum, point) => sum + (point.desktop + point.mobile).toInt(),
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? double.infinity,
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 768;
          final isMobile = constraints.maxWidth < 640;
          final availableHeight =
              constraints.maxHeight.isFinite
                  ? constraints.maxHeight
                  : MediaQuery.of(context).size.height * 0.6;

          // Calculate header height to ensure chart doesn't overlap
          final headerHeight =
              (isMobile ? 16 : 24) * 2 + // padding
              (isMobile ? 18 : 24) + // title height
              (isMobile ? 2 : 4) + // spacing
              (isMobile ? 12 : 14) + // description height
              (isMobile ? 12 : 20) * 2 + // stats padding
              (isMobile
                  ? 20
                  : isDesktop
                  ? 32
                  : 24) + // stats value height
              2; // border

          final chartHeight = (availableHeight -
                  headerHeight -
                  (isMobile ? 16 : 32))
              .clamp(150.0, 400.0);

          return ShadCard(
            padding: EdgeInsets.zero,
            child: SizedBox(
              height: availableHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title and description
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            isMobile ? 16 : 24,
                            isMobile ? 16 : 24,
                            isMobile ? 16 : 24,
                            isMobile ? 12 : 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isMobile ? 18 : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: isMobile ? 2 : 4),
                              Text(
                                description,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  fontSize: isMobile ? 12 : null,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Total Recycles section with ShadCN styling
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            color: Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.5),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 16 : 24,
                            vertical: isMobile ? 12 : 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Actions',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                        fontSize: isMobile ? 10 : 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: isMobile ? 2 : 4),
                                    Text(
                                      NumberFormat(
                                        '#,###',
                                      ).format(totalValue),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                        fontSize:
                                            isMobile
                                                ? 20
                                                : isDesktop
                                                ? 32
                                                : 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Add a subtle icon or indicator
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.trending_up,
                                  color: AppColors.success,
                                  size: isMobile ? 16 : 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Chart content with responsive sizing
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
                      child: SizedBox(
                        height: chartHeight,
                        child:
                            animation != null
                                ? AnimatedBuilder(
                                  animation: animation!,
                                  builder: (context, child) {
                                    return LineChart(
                                      _buildLineChartData(context),
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    );
                                  },
                                )
                                : LineChart(
                                  _buildLineChartData(context),
                                  duration: const Duration(milliseconds: 300),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  LineChartData _buildLineChartData(BuildContext context) {
    final spots =
        data.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final point = entry.value;
          final totalValue = point.desktop + point.mobile;
          return FlSpot(index, totalValue);
        }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: null,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: _calculateInterval(),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < data.length) {
                final date = data[index].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _formatDateLabel(date, index, data.length),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.4,
          color: AppColors.success,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.success.withValues(alpha: 0.15),
                AppColors.success.withValues(alpha: 0.08),
                AppColors.success.withValues(alpha: 0.02),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor:
              (touchedSpot) =>
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          tooltipRoundedRadius: 8,
          tooltipPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          tooltipMargin: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final index = barSpot.x.toInt();
              if (index >= 0 && index < data.length) {
                final point = data[index];
                final date = DateFormat('MMM d, yyyy').format(point.date);
                final totalValue = (point.desktop + point.mobile).toInt();

                return LineTooltipItem(
                  '$date\n${NumberFormat('#,###').format(totalValue)} actions',
                  TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                );
              }
              return null;
            }).toList();
          },
        ),
        touchSpotThreshold: 20,
        getTouchedSpotIndicator: (
          LineChartBarData barData,
          List<int> spotIndexes,
        ) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: AppColors.success.withValues(alpha: 0.8),
                strokeWidth: 2,
                dashArray: [3, 3],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.success,
                    strokeWidth: 2,
                    strokeColor: Theme.of(context).colorScheme.surface,
                  );
                },
              ),
            );
          }).toList();
        },
        handleBuiltInTouches: true,
      ),
      minX: 0,
      maxX: data.length.toDouble() - 1,
      minY: 0,
      maxY: _calculateMaxY(),
    );
  }

  double _calculateInterval() {
    final dataLength = data.length;
    if (dataLength <= 12) return 1; // Show every month for up to 1 year
    if (dataLength <= 24) return 2; // Show every 2 months for up to 2 years
    if (dataLength <= 36) return 3; // Show every 3 months for up to 3 years
    return 6; // Show every 6 months for longer periods
  }

  double _calculateMaxY() {
    double maxValue = 0;
    for (final point in data) {
      final totalValue = point.desktop + point.mobile;
      if (totalValue > maxValue) maxValue = totalValue;
    }
    return maxValue * 1.1;
  }

  String _formatDateLabel(DateTime date, int index, int totalPoints) {
    // For monthly data, show month abbreviation
    if (totalPoints <= 24) { // Less than 2 years of monthly data
      return DateFormat('MMM').format(date);
    }
    // For longer periods, show month and year
    return DateFormat('MMM yy').format(date);
  }
}
