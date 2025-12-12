import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class RuleNumericField extends StatelessWidget {
  final String label;
  final int? value;
  final String? placeholder;
  final ValueChanged<int?> onChanged;
  final String? errorText;
  final bool enabled;
  final bool isRequired;
  final TextEditingController controller;

  const RuleNumericField({
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
    if (value != null) {
      controller.text = value!.toString();
    }
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
          // initialValue: value?.toString() ?? '',
          placeholder: Text(placeholder ?? 'Enter $label'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (val) {
            if (val.isEmpty) {
              onChanged(null);
            } else {
              final numValue = int.tryParse(val);
              onChanged(numValue);
            }
          },
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