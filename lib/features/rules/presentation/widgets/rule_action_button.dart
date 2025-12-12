import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RuleActionButton extends StatelessWidget {
  const RuleActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isDestructive
          ? ShadButton.destructive(
              onPressed: onPressed,
              child: Row(
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(width: 12),
                  Text(label),
                ],
              ),
            )
          : ShadButton.outline(
              onPressed: onPressed,
              child: Row(
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(width: 12),
                  Text(label),
                ],
              ),
            ),
    );
  }
}
