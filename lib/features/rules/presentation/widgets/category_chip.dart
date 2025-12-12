import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.isCompact,
    required this.isVerySmall,
  });

  final String category;
  final bool isCompact;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 4 : 6,
        vertical: isVerySmall ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(isVerySmall ? 3 : 4),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: const Color(0xFF0F172A),
          fontSize: isVerySmall ? 8 : (isCompact ? 9 : 10),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
