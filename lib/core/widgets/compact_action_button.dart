// lib/core/components/profile/compact_action_button.dart
import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';
import '../app/themes/app_text_styles.dart';

enum CompactButtonVariant { primary, secondary, outline, ghost }

class CompactActionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final CompactButtonVariant variant;
  final double? width;

  const CompactActionButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.variant = CompactButtonVariant.primary,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 36,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _getForegroundColor(),
                ),
              ),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              Icon(icon, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w500,
                color: _getForegroundColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (variant) {
      case CompactButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        );
      case CompactButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.secondaryForeground,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        );
      case CompactButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          elevation: 0,
          side: BorderSide(color: AppColors.fieldBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        );
      case CompactButtonVariant.ghost:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        );
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case CompactButtonVariant.primary:
        return AppColors.primaryForeground;
      case CompactButtonVariant.secondary:
        return AppColors.secondaryForeground;
      case CompactButtonVariant.outline:
      case CompactButtonVariant.ghost:
        return AppColors.primary;
    }
  }
}
