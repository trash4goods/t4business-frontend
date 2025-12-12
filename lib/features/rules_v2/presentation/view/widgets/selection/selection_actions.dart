import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class SelectionActions extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SelectionActions({
    super.key,
    required this.selectedCount,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShadButton.outline(
              onPressed: onCancel,
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ShadButton(
              onPressed: onConfirm,
              child: Text('Confirm ($selectedCount)'),
            ),
          ),
        ],
      ),
    );
  }
}