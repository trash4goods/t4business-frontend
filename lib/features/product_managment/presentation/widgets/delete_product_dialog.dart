import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DeleteProductDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteProductDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('Confirm Delete'),
      actions: [
        ShadButton.outline(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        ShadButton.destructive(
          onPressed: onConfirm,
          child: const Text('Delete'),
        ),
      ],
      child: const SizedBox(
        width: 400,
        child: Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
        ),
      ),
    );
  }
}