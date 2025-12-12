import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProfileSettingsHeader extends StatelessWidget {
  final VoidCallback onBack;
  final String title;
  const ProfileSettingsHeader({super.key, required this.onBack, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShadButton.outline(
          onPressed: onBack,
          size: ShadButtonSize.sm,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 16),
              SizedBox(width: 4),
              Text('Back'),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(title, style: ShadTheme.of(context).textTheme.h3),
      ],
    );
  }
}
