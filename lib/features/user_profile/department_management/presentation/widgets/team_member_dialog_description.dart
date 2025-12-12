import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';

/// Description section for the team member dialog explaining the action
class TeamMemberDialogDescription extends StatelessWidget {
  /// Whether this dialog is for adding a new member (true) or editing existing (false)
  final bool isAddingMember;

  const TeamMemberDialogDescription({super.key, required this.isAddingMember});

  @override
  Widget build(BuildContext context) {
    return Text(
      isAddingMember
          ? 'Invite a new team member by entering their email address.'
          : 'Update the team member\'s information.',
      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
    );
  }
}
