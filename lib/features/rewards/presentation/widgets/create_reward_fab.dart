import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RewardFAButton extends StatelessWidget {
  final BoxConstraints constraints;
  final VoidCallback onPressed;
  final String? label;

  const RewardFAButton({
    super.key,
    required this.constraints,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = constraints.maxWidth < 768;
    final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1200;

    return ShadButton(
      onPressed: onPressed,
      size: isMobile
          ? ShadButtonSize.sm
          : (isTablet ? ShadButtonSize.regular : ShadButtonSize.lg),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: isMobile ? 16 : (isTablet ? 18 : 20)),
          SizedBox(width: isMobile ? 4 : 8),
          Text(
            isMobile ? 'Create' : label ?? 'Create Reward',
            style: TextStyle(fontSize: isMobile ? 12 : (isTablet ? 14 : 16)),
          ),
        ],
      ),
    );
  }
}
