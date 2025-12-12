import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import 'compact_icon_button.dart';
import 'icon_button_widget.dart';
import 'secondary_button_widget.dart';

class RewardViewCardActions extends StatelessWidget {
  final bool isVerySmallCard;
  final bool isSmallCard;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RewardViewCardActions({
    super.key,
    required this.isVerySmallCard,
    required this.isSmallCard,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isVerySmallCard) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RewardViewCompactIconButton(
            onPressed: onEdit,
            icon: Icons.edit_outlined,
          ),
          RewardViewCompactIconButton(
            onPressed: onDelete,
            icon: Icons.delete_outline,
            color: AppColors.error,
          ),
        ],
      );
    } else if (isSmallCard) {
      return Row(
        children: [
          Expanded(
            child: RewardViewSecondaryButtonWidget(
              onPressed: onEdit,
              icon: Icons.edit_outlined,
              label: 'Edit',
              compact: true,
            ),
          ),
          const SizedBox(width: 4),
          RewardViewCompactIconButton(
            onPressed: onDelete,
            icon: Icons.delete_outline,
            color: AppColors.error,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: RewardViewSecondaryButtonWidget(
              onPressed: onEdit,
              icon: Icons.edit_outlined,
              label: 'Edit',
              compact: false,
            ),
          ),
          const SizedBox(width: 6),
          RewardViewIconButtonWidget(
            onPressed: onDelete,
            icon: Icons.delete_outline,
            color: AppColors.error,
          ),
        ],
      );
    }
  }
}
