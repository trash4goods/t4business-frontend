// lib/features/rewards/presentation/components/reward_category_selection_component.dart
import 'package:flutter/material.dart';

class RewardCategorySelectionComponent extends StatelessWidget {
  final List<String> availableCategories;
  final List<String> selectedCategories;
  final Function(List<String>) onSelectionChanged;

  const RewardCategorySelectionComponent({
    super.key,
    required this.availableCategories,
    required this.selectedCategories,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            availableCategories.map((category) {
              final isSelected = selectedCategories.contains(category);
              return GestureDetector(
                onTap: () {
                  final updatedCategories = selectedCategories.toList();
                  if (isSelected) {
                    updatedCategories.remove(category);
                  } else {
                    updatedCategories.add(category);
                  }
                  onSelectionChanged(updatedCategories);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xFF0F172A)
                            : Colors.transparent,
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFE2E8F0),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isSelected ? Colors.white : const Color(0xFF374151),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
