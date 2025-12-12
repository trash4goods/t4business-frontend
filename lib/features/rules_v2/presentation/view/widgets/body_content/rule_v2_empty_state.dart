import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../../../core/app/themes/app_colors.dart';
import '../../../../../../core/app/themes/app_text_styles.dart';

class RulesV2ViewEmptyState extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const RulesV2ViewEmptyState({
    super.key,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShadCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadBadge(
              backgroundColor: AppColors.surfaceContainer,
              child: Icon(
                Icons.card_giftcard_outlined,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No rules found',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Create your first rule to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ShadButton(
              onPressed: onCreatePressed,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 8),
                  Text('Create First Rule'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
