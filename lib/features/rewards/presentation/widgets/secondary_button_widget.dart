import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';

class RewardViewSecondaryButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String label;
  final bool compact;
  final Color? color;

  const RewardViewSecondaryButtonWidget({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
    this.compact = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.textPrimary;
    final borderColor = color == AppColors.error
        ? AppColors.error.withOpacity(0.3)
        : AppColors.fieldBorder;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        side: BorderSide(color: borderColor),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 16,
          vertical: compact ? 8 : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: compact ? 12 : 16),
          if (icon != null) SizedBox(width: compact ? 3 : 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: compact ? 12 : 14, color: buttonColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
