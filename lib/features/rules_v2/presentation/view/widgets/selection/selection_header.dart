import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class SelectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onCancel;

  const SelectionHeader({
    super.key,
    required this.title,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ShadButton.ghost(
            onPressed: onCancel,
            size: ShadButtonSize.sm,
            child: const Icon(
              Icons.close,
              size: 18,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}