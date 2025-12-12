import 'package:flutter/material.dart';
import '../../data/models/manage_team.dart';
import '../presenter/department_management_presenter.interface.dart';
import 'team_member_dialog_name_field.dart';
import 'team_member_dialog_email_field.dart';
import 'team_member_dialog_role_field.dart';

/// Form section for the team member dialog containing all input fields
class TeamMemberDialogForm extends StatelessWidget {
  /// Whether this dialog is for adding a new member (true) or editing existing (false)
  final bool isAddingMember;

  /// The member to edit (only used when isAddingMember is false)
  final ManageTeamModel? member;

  /// The presenter instance for form state management
  final DepartmentManagementPresenterInterface presenter;

  const TeamMemberDialogForm({
    super.key,
    required this.isAddingMember,
    this.member,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name field (only shown when editing)
        if (!isAddingMember) ...[
          TeamMemberDialogNameField(presenter: presenter),
          const SizedBox(height: 16),
        ],

        // Email field (always shown)
        TeamMemberDialogEmailField(
          isAddingMember: isAddingMember,
          member: member,
          presenter: presenter,
        ),
        const SizedBox(height: 16),

        // Role field (only shown when editing)
        if (!isAddingMember) ...[
          TeamMemberDialogRoleField(presenter: presenter, member: member),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
