import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class RewardViewLoadingState extends StatelessWidget {
  const RewardViewLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShadCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ShadProgress(),
            const SizedBox(height: 16),
            Text(
              'Loading rewards...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
