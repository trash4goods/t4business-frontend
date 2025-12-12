import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../presenters/interface/profile.dart';
import '../controllers/interface/profile.dart';

class BusinessStatisticsSection extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const BusinessStatisticsSection({
    super.key,
    required this.businessController,
    required this.presenter,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 12)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Business Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            final stats = presenter.userAuth?.profile?.statistics;
            if (stats == null) {
              return Center(
                child: Text(
                  'No statistics available',
                  style: TextStyle(
                    color: AppColors.mutedForeground,
                    fontSize: 14,
                  ),
                ),
              );
            }

            // Use a more compact layout for mobile
            if (!isDesktop && !isTablet) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCompactStatCard(
                    icon: Icons.flash_on_outlined,
                    label: 'Actions',
                    value: stats.totalActions?.toString() ?? '0',
                    color: AppColors.primary,
                  ),
                  _buildCompactStatCard(
                    icon: Icons.eco_outlined,
                    label: 'CO2',
                    value: '${stats.totalCO2 ?? 0}kg',
                    color: AppColors.success,
                  ),
                  _buildCompactStatCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Products',
                    value: stats.totalProducts?.toString() ?? '0',
                    color: AppColors.info,
                  ),
                  _buildCompactStatCard(
                    icon: Icons.description_outlined,
                    label: 'Reports',
                    value: stats.totalReports?.toString() ?? '0',
                    color: AppColors.warning,
                  ),
                ],
              );
            }
            
            // Desktop and Tablet grid layout
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isDesktop ? 4 : 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: isDesktop ? 1.1 : 0.9,
              children: [
                _buildStatCard(
                  icon: Icons.flash_on_outlined,
                  label: 'Total Actions',
                  value: stats.totalActions?.toString() ?? '0',
                  color: AppColors.primary,
                ),
                _buildStatCard(
                  icon: Icons.eco_outlined,
                  label: 'CO2 Reduced',
                  value: '${stats.totalCO2 ?? 0} kg',
                  color: AppColors.success,
                ),
                _buildStatCard(
                  icon: Icons.inventory_2_outlined,
                  label: 'Products',
                  value: stats.totalProducts?.toString() ?? '0',
                  color: AppColors.info,
                ),
                _buildStatCard(
                  icon: Icons.description_outlined,
                  label: 'Reports',
                  value: stats.totalReports?.toString() ?? '0',
                  color: AppColors.warning,
                ),
                _buildStatCard(
                  icon: Icons.qr_code_scanner_outlined,
                  label: 'Total Scans',
                  value: stats.totalScans?.toString() ?? '0',
                  color: AppColors.purple,
                ),
                _buildStatCard(
                  icon: Icons.delete_outline,
                  label: 'Bins Used',
                  value: stats.totalBins?.toString() ?? '0',
                  color: AppColors.destructive,
                ),
                _buildStatCard(
                  icon: Icons.event_outlined,
                  label: 'Events',
                  value: stats.totalEvents?.toString() ?? '0',
                  color: AppColors.orange,
                ),
                _buildStatCard(
                  icon: Icons.emoji_events_outlined,
                  label: 'Prizes',
                  value: stats.totalPrizes?.toString() ?? '0',
                  color: AppColors.yellow,
                ),
              ],
            );
          }),
          const SizedBox(height: 16),
          if (isDesktop || isTablet)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.mutedForeground.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Statistics are updated in real-time as you use the platform',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const Spacer(flex: 1),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.mutedForeground,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  // Compact card for mobile
  Widget _buildCompactStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: (MediaQuery.of(context).size.width - 48) / 2,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}