import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class RuleStatusToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const RuleStatusToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ShadSwitch(
              value: value,
              onChanged: enabled ? onChanged : null,
            ),
            const SizedBox(width: 8),
            Text(
              value ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 14,
                color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}