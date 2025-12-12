import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/constants.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class PerformanceDashboard extends StatelessWidget {
  final BoxConstraints constraints;
  final VoidCallback onExport;

  const PerformanceDashboard({
    super.key,
    required this.constraints,
    required this.onExport,
  });

  bool get isDesktop => constraints.maxWidth > AppConstants.tabletBreakpoint;

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
                  onPressed: onExport,
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
            if (isDesktop)
              Row(
                children: const [
                  Expanded(
                    child: _ImpactCard(
                      title: 'CO₂ Reduced',
                      value: '1,247 kg',
                      description: 'Equivalent to 15 trees planted',
                      icon: Icons.park,
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ImpactCard(
                      title: 'Water Saved',
                      value: '3,420 L',
                      description: 'Equivalent to 68 showers',
                      icon: Icons.water_drop,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ImpactCard(
                      title: 'Energy Saved',
                      value: '847 kWh',
                      description: 'Powers 12 homes for 1 day',
                      icon: Icons.bolt,
                      color: AppColors.warning,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _ImpactCard(
                      title: 'Waste Diverted',
                      value: '2.3 tons',
                      description: 'From landfills this month',
                      icon: Icons.delete_sweep,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: const [
                  Row(
                    children: [
                      Expanded(
                        child: _ImpactCard(
                          title: 'CO₂ Reduced',
                          value: '1,247 kg',
                          description: 'Equiv. to 15 trees',
                          icon: Icons.park,
                          color: AppColors.success,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _ImpactCard(
                          title: 'Water Saved',
                          value: '3,420 L',
                          description: 'Equiv. to 68 showers',
                          icon: Icons.water_drop,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ImpactCard(
                          title: 'Energy Saved',
                          value: '847 kWh',
                          description: '12 homes for 1 day',
                          icon: Icons.bolt,
                          color: AppColors.warning,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _ImpactCard(
                          title: 'Waste Diverted',
                          value: '2.3 tons',
                          description: 'From landfills',
                          icon: Icons.delete_sweep,
                          color: AppColors.secondary,
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
}

class _ImpactCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final IconData icon;
  final Color color;

  const _ImpactCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.mutedForeground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 4),
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
}
