import 'package:flutter/material.dart';
import '../../../../../../core/app/themes/app_colors.dart';
import 'selection_item_image.dart';
import 'selection_item_content.dart';
import 'selection_item_indicator.dart';

class SelectionItem extends StatelessWidget {
  final bool isSelected;
  final String displayName;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback onTap;

  const SelectionItem({
    super.key,
    required this.isSelected,
    required this.displayName,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: isSelected 
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.card,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected 
                    ? AppColors.primary
                    : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SelectionItemImage(imageUrl: imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: SelectionItemContent(
                    displayName: displayName,
                    subtitle: subtitle,
                  ),
                ),
                SelectionItemIndicator(isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}