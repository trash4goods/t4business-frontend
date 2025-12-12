import 'package:flutter/material.dart';
import '../../data/models/manage_team.dart';
import '../presenter/department_management_presenter.interface.dart';
import 'team_member_dialog_description.dart';
import 'team_member_dialog_error.dart';
import 'team_member_dialog_form.dart';

/// Content section for the team member dialog containing description, error display, and form
class TeamMemberDialogContent extends StatelessWidget {
  /// Whether this dialog is for adding a new member (true) or editing existing (false)
  final bool isAddingMember;

  /// The member to edit (only used when isAddingMember is false)
  final ManageTeamModel? member;

  /// The presenter instance for form state management
  final DepartmentManagementPresenterInterface presenter;

  const TeamMemberDialogContent({
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
        // Description text
        TeamMemberDialogDescription(isAddingMember: isAddingMember),

        const SizedBox(height: 24),

        // Show error if any
        TeamMemberDialogError(presenter: presenter),

        // Form fields
        TeamMemberDialogForm(
          isAddingMember: isAddingMember,
          member: member,
          presenter: presenter,
        ),
      ],
    );
  }
}
