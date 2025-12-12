import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';

/// Field label component for team member dialog form fields
class TeamMemberDialogFieldLabel extends StatelessWidget {
  /// The label text to display
  final String label;

  const TeamMemberDialogFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}
