import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RewardViewFilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSmall;
  final bool expandContent;

  const RewardViewFilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isSmall = false,
    this.expandContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: expandContent ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: expandContent ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(label),
      ],
    );

    return ShadButton.outline(
      onPressed: onPressed,
      size: isSmall ? ShadButtonSize.sm : ShadButtonSize.regular,
      child: child,
    );
  }
}
