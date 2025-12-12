import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RedeemCodeInputField extends StatelessWidget {
  final String value;
  final bool isEnabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const RedeemCodeInputField({
    super.key,
    required this.value,
    required this.isEnabled,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Redeem Code',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ShadInput(
          placeholder: const Text('Enter redeem code'),
          enabled: isEnabled,
          initialValue: value,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: const TextStyle(
            fontFamily: 'monospace',
            letterSpacing: 1.2,
          ),
          decoration: const ShadDecoration(
            border: ShadBorder(),
          ),
        ),
      ],
    );
  }
}