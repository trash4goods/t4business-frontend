import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/app/themes/app_text_styles.dart';

class RewardViewSectionHeader extends StatelessWidget {
  final String title;
  const RewardViewSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
