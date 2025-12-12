// lib/features/rewards/presentation/components/reward_form_field_component.dart
import 'package:flutter/material.dart';

class RewardFormFieldComponent extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;
  final String? helpText;

  const RewardFormFieldComponent({
    super.key,
    required this.label,
    this.required = false,
    required this.child,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        child,
        if (helpText != null) ...[
          const SizedBox(height: 4),
          Text(
            helpText!,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ],
    );
  }
}
