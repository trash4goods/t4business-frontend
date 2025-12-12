import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/widgets/compact_action_button.dart';
import '../presenters/interface/profile.dart';
import '../controllers/interface/profile.dart';

class SubscriptionTierSection extends StatelessWidget {
  final ProfileControllerInterface businessController;
  final ProfilePresenterInterface presenter;
  final bool isDesktop;
  final bool isTablet;

  const SubscriptionTierSection({
    super.key,
    required this.businessController,
    required this.presenter,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
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
                Icons.workspace_premium_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Subscription & Credits',
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
            final tier = presenter.userAuth?.profile?.userPartnersDepartments?.first.department?.t4bTier?.toUpperCase() ?? 'UNKNOWN';
            final tierColor = _getTierColor(tier);
            
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    tierColor.withValues(alpha: 0.05),
                    tierColor.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: tierColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isDesktop ? 12 : 8),
                        decoration: BoxDecoration(
                          color: tierColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getTierIcon(tier),
                          color: tierColor,
                          size: isDesktop ? 32 : 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Plan',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tier,
                              style: TextStyle(
                                fontSize: isDesktop ? 24 : 20,
                                fontWeight: FontWeight.w700,
                                color: tierColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if ((tier == 'FREE' || tier == 'UNKNOWN') && (isDesktop || isTablet))
                        CompactActionButton(
                          text: 'Upgrade',
                          onPressed: () {
                            // TODO: Navigate to upgrade page
                          },
                          variant: CompactButtonVariant.primary,
                        ),
                    ],
                  ),
                  if ((tier == 'FREE' || tier == 'UNKNOWN') && !isDesktop && !isTablet) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: CompactActionButton(
                        text: 'Upgrade Plan',
                        onPressed: () {
                          // TODO: Navigate to upgrade page
                        },
                        variant: CompactButtonVariant.primary,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          if (isDesktop || isTablet)
            Row(
              children: [
                Expanded(
                  child: _buildCreditCard(
                    title: 'Primary Credits',
                    value: presenter.userAuth?.profile?.credits1?.toString() ?? 'N/A',
                    icon: Icons.star_outline,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCreditCard(
                    title: 'Bonus Credits',
                    value: presenter.userAuth?.profile?.credits2?.toString() ?? 'N/A',
                    icon: Icons.card_giftcard_outlined,
                    color: AppColors.info,
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildCreditCard(
                  title: 'Primary Credits',
                  value: presenter.userAuth?.profile?.credits1?.toString() ?? 'N/A',
                  icon: Icons.star_outline,
                  color: AppColors.warning,
                ),
                const SizedBox(height: 12),
                _buildCreditCard(
                  title: 'Bonus Credits',
                  value: presenter.userAuth?.profile?.credits2?.toString() ?? 'N/A',
                  icon: Icons.card_giftcard_outlined,
                  color: AppColors.info,
                ),
              ],
            ),
          const SizedBox(height: 20),
          Obx(() {
            final roles = presenter.userAuth?.profile?.fullRoles ?? [];
            if (roles.isEmpty) return const SizedBox.shrink();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Roles',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: roles.map((role) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
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
    );
  }

  Widget _buildCreditCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        color: AppColors.mutedForeground.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.fieldBorder.withValues(alpha: 0.5),
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
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.foreground,
              ),
            ),
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