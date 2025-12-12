import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';

class RewardViewIconButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;

  const RewardViewIconButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        color: color ?? AppColors.textSecondary,
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }
}
