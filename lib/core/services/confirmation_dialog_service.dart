import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConfirmationDialogService {
  static void showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
    required String itemType,
    required Future<void> Function() onConfirm,
  }) {
    showShadDialog(
      context: context,
      builder: (ctx) => ShadDialog(
        title: Text('Delete $itemType'),
        description: Text(
          'Are you sure you want to delete "$itemName" ? This action cannot be undone.',
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await onConfirm();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}