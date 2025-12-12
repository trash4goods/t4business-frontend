import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../presenters/interface/profile.dart';
import '../controllers/interface/profile.dart';

class SubscriptionStatusCard extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const SubscriptionStatusCard({
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
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.workspace_premium_outlined,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subscription & Credits',
                        style: ShadTheme.of(context).textTheme.h4,
                      ),
                      Text(
                        'Your current plan and available credits',
                        style: ShadTheme.of(context).textTheme.muted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // Subscription Tier Section
            Obx(() {
              final tier = presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.t4bTier?.toUpperCase() ?? 'UNKNOWN';
              final tierColor = _getTierColor(tier);
              
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      tierColor.withValues(alpha: 0.1),
                      tierColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: tierColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: tierColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getTierIcon(tier),
                            color: tierColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Plan',
                                style: ShadTheme.of(context).textTheme.small.copyWith(
                                  color: tierColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tier,
                                style: ShadTheme.of(context).textTheme.h3.copyWith(
                                  color: tierColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if ((tier == 'FREE' || tier == 'UNKNOWN') && (isDesktop || isTablet))
                          ShadButton.outline(
                            onPressed: () {
                              // TODO: Navigate to upgrade page
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.upgrade_outlined, size: 16),
                                SizedBox(width: 6),
                                Text('Upgrade'),
                              ],
                            ),
                          ),
                      ],
                    ),
                    
                    if ((tier == 'FREE' || tier == 'UNKNOWN') && !isDesktop && !isTablet) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ShadButton.outline(
                          onPressed: () {
                            // TODO: Navigate to upgrade page
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upgrade_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Upgrade Plan'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
            
            const SizedBox(height: 20),

            // Credits Section
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Credits',
                  style: ShadTheme.of(context).textTheme.large.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildCreditCard(
                        context,
                        'Primary Credits',
                        presenter.userAuth?.profile?.credits1?.toString() ?? 'N/A',
                        Icons.star_outlined,
                        AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCreditCard(
                        context,
                        'Bonus Credits',
                        presenter.userAuth?.profile?.credits2?.toString() ?? 'N/A',
                        Icons.card_giftcard_outlined,
                        AppColors.info,
                      ),
                    ),
                  ],
                ),
              ],
            )),
            
            const SizedBox(height: 20),

            // User Roles Section
            Obx(() {
              final roles = presenter.userAuth?.profile?.fullRoles ?? [];
              if (roles.isEmpty) return const SizedBox.shrink();
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Roles',
                    style: ShadTheme.of(context).textTheme.large.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: roles.map((role) {
                      return ShadBadge.secondary(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              role.name?.toUpperCase() ?? 'unknown',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard(
    BuildContext context,
    String title,
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
            style: ShadTheme.of(context).textTheme.h3.copyWith(
              color: ShadTheme.of(context).colorScheme.foreground,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
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

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'free':
        return AppColors.mutedForeground;
      case 'premium':
        return AppColors.warning;
      case 'enterprise':
        return AppColors.info;
      case 'pro':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  IconData _getTierIcon(String tier) {
    switch (tier.toLowerCase()) {
      case 'free':
        return Icons.account_circle_outlined;
      case 'premium':
        return Icons.workspace_premium;
      case 'enterprise':
        return Icons.business_center;
      case 'pro':
        return Icons.verified;
      default:
        return Icons.help_outline;
    }
  }
}