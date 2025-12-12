import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'delete_account_dialog_header.dart';
import 'delete_account_dialog_description.dart';
import 'delete_account_dialog_input.dart';
import 'delete_account_dialog_actions.dart';

/// Dialog widget for account deletion confirmation
///
/// This widget provides a secure confirmation dialog that requires users
/// to type "Delete" to confirm account deletion. It follows shadcn UI
/// design principles for a clean, professional interface.
class DeleteAccountDialog extends StatelessWidget {
  final bool isLoading;
  final String confirmationError;
  final bool isConfirmationValid;
  final TextEditingController confirmationController;
  final Function(String) onConfirmationTextChanged;
  final VoidCallback onConfirmDelete;
  final VoidCallback onCancelDelete;

  const DeleteAccountDialog({
    super.key,
    required this.isLoading,
    required this.confirmationError,
    required this.isConfirmationValid,
    required this.confirmationController,
    required this.onConfirmationTextChanged,
    required this.onConfirmDelete,
    required this.onCancelDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('Delete account'),
      child: ShadCard(
        width: 450,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with warning icon and title
            const DeleteAccountDialogHeader(),

            const SizedBox(height: 16),

            // Description text
            const DeleteAccountDialogDescription(),

            const SizedBox(height: 20),

            // Confirmation text input
            DeleteAccountDialogInput(
              controller: confirmationController,
              errorText: confirmationError.isEmpty ? null : confirmationError,
              onChanged: onConfirmationTextChanged,
              onSubmitted: (_) {
                if (isConfirmationValid && !isLoading) {
                  onConfirmDelete();
                }
              },
            ),

            const SizedBox(height: 24),

            // Action buttons
            DeleteAccountDialogActions(
              isLoading: isLoading,
              isConfirmationValid: isConfirmationValid,
              onCancel: onCancelDelete,
              onConfirm: onConfirmDelete,
            ),
          ],
        ),
      ),
    );
  }
}
