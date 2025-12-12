import 'package:flutter/material.dart';

class PriorityIndicator extends StatelessWidget {
  const PriorityIndicator({super.key, required this.priority, required this.isVerySmall});

  final String priority;
  final bool isVerySmall;

  Color _colorForPriority(String p) {
    switch (p.toLowerCase()) {
      case 'high':
        return const Color(0xFFDC2626);
      case 'medium':
        return const Color(0xFFD97706);
      case 'low':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForPriority(priority);
    return Container(
      width: isVerySmall ? 6 : 8,
      height: isVerySmall ? 6 : 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
