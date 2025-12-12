import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../../../../core/app/themes/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String label;
  final bool loading;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
    this.loading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else if (icon != null)
              Icon(icon, size: 16),
            if (icon != null || loading) const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.buttonMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
