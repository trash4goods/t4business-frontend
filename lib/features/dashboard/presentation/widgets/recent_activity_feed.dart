import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class RecentActivityFeed extends StatelessWidget {
  final VoidCallback onViewAll;

  const RecentActivityFeed({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
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
                  onPressed: onViewAll,
                  size: ShadButtonSize.sm,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Static sample list, matching previous implementation
            ...List.generate(5, (index) {
              final activities = [
                {
                  'title': 'Order Processed',
                  'subtitle': 'Order #1234 has been processed',
                  'time': '2 min ago',
                  'icon': Icons.shopping_cart,
                  'color': AppColors.primary,
                },
                {
                  'title': 'New Customer',
                  'subtitle': 'John Doe signed up',
                  'time': '1 hour ago',
                  'icon': Icons.person_add,
                  'color': AppColors.secondary,
                },
                {
                  'title': 'Product Recycled',
                  'subtitle': 'Eco Bottle recycled 50 times',
                  'time': '3 hours ago',
                  'icon': Icons.recycling,
                  'color': AppColors.success,
                },
                {
                  'title': 'Low Stock Alert',
                  'subtitle': 'Eco Paper stock is running low',
                  'time': '1 day ago',
                  'icon': Icons.warning_amber_rounded,
                  'color': AppColors.warning,
                },
                {
                  'title': 'Impact Report Ready',
                  'subtitle': 'Environmental impact report generated',
                  'time': '2 days ago',
                  'icon': Icons.assessment,
                  'color': AppColors.success,
                },
              ];

              final activity = activities[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index < 4 ? 16 : 0),
                child: _ActivityItem(
                  title: activity['title'] as String,
                  subtitle: activity['subtitle'] as String,
                  time: activity['time'] as String,
                  icon: activity['icon'] as IconData,
                  color: activity['color'] as Color,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}
