import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PresetButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PresetButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
      onPressed: onPressed,
      size: ShadButtonSize.sm,
      child: Text(label),
    );
  }
}
