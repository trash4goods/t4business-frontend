import 'package:flutter/material.dart';

class RuleStatusChip extends StatelessWidget {
  const RuleStatusChip({
    super.key,
    required this.isActive,
    required this.isCompact,
    required this.isVerySmall,
  });

  final bool isActive;
  final bool isCompact;
  final bool isVerySmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 4 : (isCompact ? 6 : 8),
        vertical: isVerySmall ? 1 : (isCompact ? 2 : 3),
      ),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF059669).withValues(alpha: 0.1)
            : const Color(0xFF6B7280).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isVerySmall ? 4 : 6),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: isVerySmall ? 9 : (isCompact ? 10 : 11),
          color: isActive ? const Color(0xFF059669) : const Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
