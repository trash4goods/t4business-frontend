import 'package:flutter/material.dart';
import 'package:t4g_for_business/features/rewards/data/models/reward_result.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import 'reward_card_image.dart';
import 'reward_card_actions.dart';

class RewardViewCardWidget extends StatelessWidget {
  final RewardResultModel reward;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RewardViewCardWidget({
    super.key,
    required this.reward,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: RewardViewCardImage(
                headerImage: reward.headerImage as String?,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth;
                final isVerySmallCard = cardWidth < 160;
                final isSmallCard = cardWidth < 200;
                final padding =
                    isVerySmallCard ? 6.0 : (isSmallCard ? 8.0 : 12.0);

                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reward.name ?? 'Reward Title',
                              style: (isVerySmallCard
                                      ? AppTextStyles.titleSmall
                                      : (isSmallCard
                                          ? AppTextStyles.titleMedium
                                          : AppTextStyles.titleLarge))
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isSmallCard)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (reward.canCheckout)
                                        ? AppColors.success.withOpacity(0.1)
                                        : AppColors.textSecondary.withOpacity(
                                          0.1,
                                        ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (reward.canCheckout) ? 'Active' : 'Archived',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color:
                                      (reward.canCheckout)
                                          ? AppColors.success
                                          : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 2 : (isSmallCard ? 4 : 6),
                      ),
                      Flexible(
                        child: Text(
                          reward.description ?? 'Reward description',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 4 : (isSmallCard ? 6 : 8),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.card_giftcard_outlined,
                            size: isSmallCard ? 12 : 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Available',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    isVerySmallCard
                                        ? 10
                                        : (isSmallCard ? 11 : null),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if ((reward.categories ?? []).isNotEmpty &&
                              !isSmallCard) ... {
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                reward.categories?.first ?? '',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                              }
                        ],
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 4 : (isSmallCard ? 6 : 8),
                      ),
                      RewardViewCardActions(
                        isVerySmallCard: isVerySmallCard,
                        isSmallCard: isSmallCard,
                        onEdit: onEdit,
                        onDelete: onDelete,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
