import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../../core/app/themes/app_colors.dart';

/// Action buttons section for the delete account dialog (Cancel and Confirm)
class DeleteAccountDialogActions extends StatelessWidget {
  final bool isLoading;
  final bool isConfirmationValid;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const DeleteAccountDialogActions({
    super.key,
    required this.isLoading,
    required this.isConfirmationValid,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Cancel button
        ShadButton.outline(
          onPressed: isLoading ? null : onCancel,
          child: const Text('Cancel'),
        ),

        const SizedBox(width: 12),

        // Confirm button
        ShadButton(
          enabled: isConfirmationValid && !isLoading ? true : false,
          onPressed: isConfirmationValid && !isLoading ? onConfirm : null,
          backgroundColor: AppColors.destructive,
          foregroundColor: AppColors.destructiveForeground,
          child:
              isLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.destructiveForeground,
                      ),
                    ),
                  )
                  : const Text('Confirm'),
        ),
      ],
    );
  }
}
