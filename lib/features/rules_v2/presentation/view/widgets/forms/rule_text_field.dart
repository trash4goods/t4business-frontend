import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class RuleTextField extends StatelessWidget {
  final String label;
  final String? value;
  final String? placeholder;
  final ValueChanged<String> onChanged;
  final String? errorText;
  final bool enabled;
  final bool isRequired;
  final TextEditingController controller;

  const RuleTextField({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    this.isRequired = false,
    required this.controller,
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
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ShadInput(
          controller: controller,
          enabled: enabled,
          placeholder: Text(placeholder ?? 'Enter $label'),
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}