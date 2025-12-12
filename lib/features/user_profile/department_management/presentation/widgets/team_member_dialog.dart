import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/manage_team.dart';
import '../presenter/department_management_presenter.interface.dart';
import 'team_member_dialog_content.dart';
import 'team_member_dialog_actions.dart';

/// Reusable dialog component for adding and editing team members
///
/// This widget supports two modes:
/// - Add mode (isAddingMember: true): Shows only email field with "Invite" button
/// - Edit mode (isAddingMember: false): Shows name, email, and role fields with "Save" button
class TeamMemberDialog extends StatelessWidget {
  /// Whether this dialog is for adding a new member (true) or editing existing (false)
  final bool isAddingMember;

  /// The member to edit (only used when isAddingMember is false)
  final ManageTeamModel? member;

  /// Callback when save/invite is pressed
  final Future Function() onSave;

  /// Callback when cancel is pressed
  final VoidCallback onCancel;

  /// The presenter instance for form state management
  final DepartmentManagementPresenterInterface presenter;

  const TeamMemberDialog({
    super.key,
    this.isAddingMember = true,
    this.member,
    required this.onSave,
    required this.onCancel,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: Text(isAddingMember ? 'Add Member' : 'Edit Member'),
      actions: [
        TeamMemberDialogActions(
          isAddingMember: isAddingMember,
          presenter: presenter,
          onSave: () async => await onSave(),
          onCancel: onCancel,
        ),
      ],
      child: SizedBox(
        width: 400,
        child: TeamMemberDialogContent(
          isAddingMember: isAddingMember,
          member: member,
          presenter: presenter,
        ),
      ),
    );
  }
}
