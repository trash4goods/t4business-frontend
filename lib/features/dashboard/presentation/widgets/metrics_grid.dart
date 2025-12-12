import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/constants.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class MetricsGrid extends StatelessWidget {
  final BoxConstraints constraints;
  final int totalProducts;
  final int totalRecycled;
  final VoidCallback onShowDetails;

  const MetricsGrid({
    super.key,
    required this.constraints,
    required this.totalProducts,
    required this.totalRecycled,
    required this.onShowDetails,
  });

  bool get isDesktop => constraints.maxWidth > AppConstants.tabletBreakpoint;

  @override
  Widget build(BuildContext context) {
    final rate = totalProducts > 0
        ? ((totalRecycled / totalProducts) * 100).toStringAsFixed(1)
        : '0';

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
              onPressed: onShowDetails,
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
        if (isDesktop)
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Products',
                  value: totalProducts.toString(),
                  change: '+12%',
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.primary,
                  hint: 'Total products in catalog',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricCard(
                  title: 'Recycled',
                  value: totalRecycled.toString(),
                  change: '+8%',
                  icon: Icons.recycling_outlined,
                  color: AppColors.success,
                  hint: 'Items successfully recycled',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricCard(
                  title: 'Rate',
                  value: '$rate%',
                  change: '+2.5%',
                  icon: Icons.trending_up_outlined,
                  color: AppColors.warning,
                  hint: 'Recycling efficiency rate',
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: _MetricCard(
                  title: 'Rewards',
                  value: '43',
                  change: '+18%',
                  icon: Icons.card_giftcard_outlined,
                  color: AppColors.secondary,
                  hint: 'Active reward programs',
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Products',
                      value: totalProducts.toString(),
                      change: '+12%',
                      icon: Icons.inventory_2_outlined,
                      color: AppColors.primary,
                      hint: 'Total products',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'Recycled',
                      value: totalRecycled.toString(),
                      change: '+8%',
                      icon: Icons.recycling_outlined,
                      color: AppColors.success,
                      hint: 'Items successfully recycled',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Rate',
                      value: '$rate%',
                      change: '+2.5%',
                      icon: Icons.trending_up_outlined,
                      color: AppColors.warning,
                      hint: 'Recycling efficiency rate',
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: _MetricCard(
                      title: 'Rewards',
                      value: '43',
                      change: '+18%',
                      icon: Icons.card_giftcard_outlined,
                      color: AppColors.secondary,
                      hint: 'Active reward programs',
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
  final String hint;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 4),
          Text(
            hint,
            style: AppTextStyles.small.copyWith(color: AppColors.mutedForeground),
          )
        ],
      ),
    );
  }
}
