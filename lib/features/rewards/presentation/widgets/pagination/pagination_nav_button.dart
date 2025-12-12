import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';

/// Navigation button for pagination (Previous/Next)
class RewardsViewPaginationNavButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final bool iconRight;

  const RewardsViewPaginationNavButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.iconRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(
          color: onPressed == null 
            ? AppColors.borderColor.withValues(alpha: 0.3)
            : AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(6),
        color: onPressed == null 
          ? AppColors.muted.withValues(alpha: 0.5)
          : AppColors.surfaceColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: label != null ? 12 : 8,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!iconRight) Icon(
                  icon, 
                  size: 16, 
                  color: onPressed == null 
                    ? AppColors.textSecondary.withValues(alpha: 0.5)
                    : AppColors.textPrimary,
                ),
                if (label != null) ...[
                  if (!iconRight) const SizedBox(width: 4),
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: onPressed == null 
                        ? AppColors.textSecondary.withValues(alpha: 0.5)
                        : AppColors.textPrimary,
                    ),
                  ),
                  if (iconRight) const SizedBox(width: 4),
                ],
                if (iconRight) Icon(
                  icon, 
                  size: 16, 
                  color: onPressed == null 
                    ? AppColors.textSecondary.withValues(alpha: 0.5)
                    : AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}