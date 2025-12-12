import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';

class CategorySelectionComponent extends StatelessWidget {
  final List<String> availableCategories;
  final List<String> selectedCategories;
  final Function(List<String>) onSelectionChanged;

  const CategorySelectionComponent({
    super.key,
    required this.availableCategories,
    required this.selectedCategories,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children:
            availableCategories.map((category) {
              final isSelected = selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  final updatedCategories = selectedCategories.toList();
                  if (selected) {
                    updatedCategories.add(category);
                  } else {
                    updatedCategories.remove(category);
                  }
                  onSelectionChanged(updatedCategories);
                },
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.primary.withOpacity(0.1),
                checkmarkColor: AppColors.primary,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.fieldBorder,
                ),
                labelStyle: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              );
            }).toList(),
      ),
    );
  }
}
