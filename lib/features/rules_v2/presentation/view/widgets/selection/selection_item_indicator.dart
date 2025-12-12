import 'package:flutter/material.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class SelectionItemIndicator extends StatelessWidget {
  final bool isSelected;

  const SelectionItemIndicator({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected 
              ? AppColors.primary
              : AppColors.border,
          width: 2,
        ),
        color: isSelected 
            ? AppColors.primary
            : AppColors.card,
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 14,
              color: AppColors.onPrimary,
            )
          : null,
    );
  }
}