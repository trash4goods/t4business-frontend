import 'package:flutter/material.dart';

import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/widgets/modern_text_field.dart';

/// Input section for the delete account dialog with confirmation text field
class DeleteAccountDialogInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;

  const DeleteAccountDialogInput({
    super.key,
    required this.controller,
    this.errorText,
    required this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return ModernTextField(
      label: 'Type "Delete" to confirm',
      hintText: 'Delete',
      controller: controller,
      onChanged: onChanged,
      errorText: errorText,
      borderColor: errorText != null ? AppColors.destructive : null,
      textInputAction: TextInputAction.done,
      onSubmitted: onSubmitted,
    );
  }
}
