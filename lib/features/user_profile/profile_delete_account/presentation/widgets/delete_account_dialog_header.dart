import 'package:flutter/material.dart';

import '../../../../../core/app/themes/app_colors.dart';

/// Header section for the delete account dialog with warning icon and title
class DeleteAccountDialogHeader extends StatelessWidget {
  const DeleteAccountDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.destructive.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.warning_rounded,
            color: AppColors.destructive,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'This action cannot be undone',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
