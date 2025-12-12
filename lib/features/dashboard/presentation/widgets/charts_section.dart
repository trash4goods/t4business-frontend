import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../../../../core/widgets/charts/recycling_pie_chart.dart';
import '../../data/models/chart_data.dart';
import '../../data/models/chart_config.dart';
import '../../../../core/app/constants.dart';

class ChartsSection extends StatelessWidget {
  final BoxConstraints constraints;
  final List<ChartData> data;
  final void Function(ChartData) onSectionTapped;
  final String title;
  final String subtitle;

  const ChartsSection({
    super.key,
    required this.constraints,
    required this.data,
    required this.onSectionTapped,
    this.title = 'Product Performance',
    this.subtitle = 'Track your products recycling trends over time',
  });

  bool get isDesktop => constraints.maxWidth > AppConstants.tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
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
                      title,
                      style: isDesktop ? AppTextStyles.h4 : AppTextStyles.large,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.muted,
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text('View Report', style: AppTextStyles.smallGreen),
                ),
              ],
            ],
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          SizedBox(
            height: isDesktop ? 400 : 300,
            child: RecyclingPieChart(
              data: data,
              config: const ChartConfig(
                title: 'Most Recycled Products',
                subtitle: 'Jan - Jun 2024',
                showTooltip: true,
                showLegend: true,
              ),
              onSectionTapped: onSectionTapped,
            ),
          ),
        ],
      ),
    );
  }
}
