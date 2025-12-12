import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../presenters/interface/profile.dart';
import '../controllers/interface/profile.dart';

class StatisticsOverviewCard extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const StatisticsOverviewCard({
    super.key,
    required this.businessController,
    required this.presenter,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: AppColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Statistics',
                        style: ShadTheme.of(context).textTheme.h4,
                      ),
                      Text(
                        'Your activity and performance metrics',
                        style: ShadTheme.of(context).textTheme.muted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Statistics Grid
            Obx(() {
              final stats = presenter.userAuth?.profile?.statistics;
              if (stats == null) {
                return _buildEmptyState(context);
              }

              return Column(
                children: [
                  // Primary Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total Actions',
                          stats.totalActions?.toString() ?? '0',
                          Icons.flash_on_outlined,
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'CO2 Reduced',
                          '${stats.totalCO2 ?? 0}kg',
                          Icons.eco_outlined,
                          AppColors.success,
                        ),
                      ),
                      if (isDesktop) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Products',
                            stats.totalProducts?.toString() ?? '0',
                            Icons.inventory_2_outlined,
                            AppColors.info,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Secondary Stats Row
                  Row(
                    children: [
                      if (!isDesktop)
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Products',
                            stats.totalProducts?.toString() ?? '0',
                            Icons.inventory_2_outlined,
                            AppColors.info,
                          ),
                        ),
                      if (!isDesktop) const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Reports',
                          stats.totalReports?.toString() ?? '0',
                          Icons.description_outlined,
                          AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Events',
                          stats.totalEvents?.toString() ?? '0',
                          Icons.event_outlined,
                          AppColors.purple,
                        ),
                      ),
                      if (isDesktop) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Total Scans',
                            stats.totalScans?.toString() ?? '0',
                            Icons.qr_code_scanner_outlined,
                            AppColors.orange,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  if (!isDesktop) ...[
                    const SizedBox(height: 12),
                    // Third Row for Mobile/Tablet
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Scans',
                            stats.totalScans?.toString() ?? '0',
                            Icons.qr_code_scanner_outlined,
                            AppColors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Bins',
                            stats.totalBins?.toString() ?? '0',
                            Icons.delete_outline,
                            AppColors.destructive,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    // Desktop - Final Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Bins Used',
                            stats.totalBins?.toString() ?? '0',
                            Icons.delete_outline,
                            AppColors.destructive,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            'Prizes',
                            stats.totalPrizes?.toString() ?? '0',
                            Icons.emoji_events_outlined,
                            AppColors.yellow,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 20),
                  
                  // Info Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.info.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Statistics are updated in real-time as you use the platform',
                            style: ShadTheme.of(context).textTheme.small.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: ShadTheme.of(context).textTheme.h4.copyWith(
              color: ShadTheme.of(context).colorScheme.foreground,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: ShadTheme.of(context).textTheme.small.copyWith(
              color: ShadTheme.of(context).colorScheme.mutedForeground,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ShadTheme.of(context).colorScheme.muted.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: 32,
              color: ShadTheme.of(context).colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Statistics Available',
            style: ShadTheme.of(context).textTheme.h4,
          ),
          const SizedBox(height: 4),
          Text(
            'Start using the platform to see your statistics',
            style: ShadTheme.of(context).textTheme.muted,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}