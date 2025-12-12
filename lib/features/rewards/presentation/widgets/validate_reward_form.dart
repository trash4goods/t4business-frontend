import 'package:flutter/material.dart';
import 'redeem_code_input_field.dart';
import 'validation_status_message.dart';

class ValidateRewardForm extends StatelessWidget {
  final String redeemCode;
  final bool isValidating;
  final String? errorMessage;
  final String? successMessage;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onValidate;

  const ValidateRewardForm({
    super.key,
    required this.redeemCode,
    required this.isValidating,
    this.errorMessage,
    this.successMessage,
    required this.onCodeChanged,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        RedeemCodeInputField(
          value: redeemCode,
          isEnabled: !isValidating,
          onChanged: onCodeChanged,
          onSubmitted: (_) => onValidate(),
        ),
        const SizedBox(height: 8),
        ValidationStatusMessage(
          errorMessage: errorMessage,
          successMessage: successMessage,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}