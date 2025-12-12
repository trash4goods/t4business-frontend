import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../app/themes/app_colors.dart';
import '../app/themes/app_text_styles.dart';
import 'package:intl/intl.dart';

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

class InteractiveAreaChart extends StatefulWidget {
  final List<ChartDataPoint> data;
  final String title;
  final String description;

  const InteractiveAreaChart({
    super.key,
    required this.data,
    this.title = 'Area Chart - Interactive',
    this.description = 'Showing total visitors for the last 3 months',
  });

  @override
  State<InteractiveAreaChart> createState() => _InteractiveAreaChartState();
}

class _InteractiveAreaChartState extends State<InteractiveAreaChart> {
  String _timeRange = '90d';
  
  List<ChartDataPoint> get filteredData {
    if (widget.data.isEmpty) return [];
    
    final referenceDate = widget.data.last.date;
    int daysToSubtract = 90;
    
    if (_timeRange == '30d') {
      daysToSubtract = 30;
    } else if (_timeRange == '7d') {
      daysToSubtract = 7;
    }
    
    final startDate = referenceDate.subtract(Duration(days: daysToSubtract));
    
    return widget.data.where((item) => item.date.isAfter(startDate) || item.date.isAtSameMomentAs(startDate)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ShadSelect<String>(
                  placeholder: const Text('Last 3 months'),
                  options: const [
                    ShadOption(value: '90d', child: Text('Last 3 months')),
                    ShadOption(value: '30d', child: Text('Last 30 days')),
                    ShadOption(value: '7d', child: Text('Last 7 days')),
                  ],
                  selectedOptionBuilder: (context, value) => Text(
                    value == '90d' ? 'Last 3 months' : 
                    value == '30d' ? 'Last 30 days' : 'Last 7 days',
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _timeRange = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          // Chart Content
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 24, 24),
            height: 300,
            child: filteredData.isEmpty 
                ? _buildEmptyState()
                : _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            'No data available',
            style: AppTextStyles.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final data = filteredData;
    if (data.isEmpty) return _buildEmptyState();

    // Convert data to FlSpot format
    final desktopSpots = <FlSpot>[];
    final mobileSpots = <FlSpot>[];
    
    for (int i = 0; i < data.length; i++) {
      desktopSpots.add(FlSpot(i.toDouble(), data[i].desktop));
      mobileSpots.add(FlSpot(i.toDouble(), data[i].mobile));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: null,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.border,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: (data.length / 6).ceilToDouble(),
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final date = data[index].date;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      DateFormat('MMM d').format(date),
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.mutedForeground,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: data.map((e) => (e.desktop + e.mobile)).reduce((a, b) => a > b ? a : b) * 1.1,
        lineBarsData: [
          // Mobile area (bottom layer)
          LineChartBarData(
            spots: mobileSpots,
            isCurved: true,
            color: AppColors.chart2,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.chart2.withOpacity(0.8),
                  AppColors.chart2.withOpacity(0.1),
                ],
              ),
            ),
          ),
          // Desktop area (top layer, stacked)
          LineChartBarData(
            spots: List.generate(data.length, (index) {
              return FlSpot(
                index.toDouble(),
                data[index].desktop + data[index].mobile,
              );
            }),
            isCurved: true,
            color: AppColors.chart1,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.chart1.withOpacity(0.8),
                  AppColors.chart1.withOpacity(0.1),
                ],
              ),
              cutOffY: data.isNotEmpty ? data.map((e) => e.mobile).reduce((a, b) => a > b ? a : b) : 0,
              applyCutOffY: true,
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => AppColors.popover,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final index = barSpot.x.toInt();
                if (index >= 0 && index < data.length) {
                  final dataPoint = data[index];
                  final dateStr = DateFormat('MMM d').format(dataPoint.date);
                  
                  if (barSpot.barIndex == 0) {
                    // Mobile tooltip
                    return LineTooltipItem(
                      '$dateStr\nMobile: ${dataPoint.mobile.toInt()}',
                      TextStyle(
                        color: AppColors.popoverForeground,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    );
                  } else {
                    // Desktop tooltip
                    return LineTooltipItem(
                      'Desktop: ${dataPoint.desktop.toInt()}',
                      TextStyle(
                        color: AppColors.popoverForeground,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    );
                  }
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
