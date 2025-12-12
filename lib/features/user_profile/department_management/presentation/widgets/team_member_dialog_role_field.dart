import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/manage_team.dart';
import '../presenter/department_management_presenter.interface.dart';
import 'team_member_dialog_field_label.dart';

/// Role selection field for the team member dialog
class TeamMemberDialogRoleField extends StatelessWidget {
  /// The presenter instance for form state management
  final DepartmentManagementPresenterInterface presenter;
  final ManageTeamModel? member;

  const TeamMemberDialogRoleField({super.key, required this.presenter, required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TeamMemberDialogFieldLabel(label: 'Role'),
        const SizedBox(height: 8),
        ShadSelect<String>(
          placeholder: Text((member?.roleName ?? '') =='admin' ? 'Admin' : 'Member'),
          options: const [
            ShadOption(value: 'member', child: Text('Member')),
            ShadOption(value: 'admin', child: Text('Admin')),
          ],
          enabled: true,
          selectedOptionBuilder:
              (context, value) => Text(value == 'admin' ? 'Admin' : 'Member'),
          onChanged: (value) {
            if (value != null) {
              presenter.selectedRole = value;
              member?.roleName = value;
            }
          },
        ),
      ],
    );
  }
}
