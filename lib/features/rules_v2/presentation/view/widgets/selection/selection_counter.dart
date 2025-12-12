import 'package:flutter/material.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class SelectionCounter extends StatelessWidget {
  final int selectedCount;

  const SelectionCounter({
    super.key,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: selectedCount > 0 
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.muted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selectedCount > 0 
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Text(
        selectedCount == 0
            ? 'No items selected'
            : '$selectedCount item${selectedCount == 1 ? '' : 's'} selected',
        style: TextStyle(
          color: selectedCount > 0 
              ? AppColors.primary 
              : AppColors.mutedForeground,
          fontWeight: selectedCount > 0 
              ? FontWeight.w500 
              : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}