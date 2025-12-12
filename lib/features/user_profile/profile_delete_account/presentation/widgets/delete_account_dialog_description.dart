import 'package:flutter/material.dart';

import '../../../../../core/app/themes/app_colors.dart';

/// Description section for the delete account dialog explaining the deletion process
class DeleteAccountDialogDescription extends StatelessWidget {
  const DeleteAccountDialogDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'In order to proceed with your account deletion, please type "Delete"',
      style: TextStyle(
        fontSize: 14,
        color: AppColors.lightTextSecondary,
        height: 1.5,
      ),
    );
  }
}
