import 'package:flutter/material.dart';
import 'category_chip.dart';

class ResponsiveCategoryChips extends StatelessWidget {
  const ResponsiveCategoryChips({
    super.key,
    required this.categories,
    required this.isCompact,
    required this.isVerySmall,
  });

  final List<String> categories;
  final bool isCompact;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    final hasMoreThanOne = categories.length > 1;

    return Wrap(
      spacing: isVerySmall ? 2 : 4,
      runSpacing: 2,
      alignment: WrapAlignment.end,
      children: [
        CategoryChip(
          category: categories.first,
          isCompact: isCompact,
          isVerySmall: isVerySmall,
        ),
        if (hasMoreThanOne)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isVerySmall ? 4 : 6,
              vertical: isVerySmall ? 1 : 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF6B7280).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isVerySmall ? 3 : 4),
            ),
            child: Text(
              '+${categories.length - 1} more',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: isVerySmall ? 8 : 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
