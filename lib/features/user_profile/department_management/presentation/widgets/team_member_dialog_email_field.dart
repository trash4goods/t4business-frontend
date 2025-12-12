import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../data/models/manage_team.dart';
import '../presenter/department_management_presenter.interface.dart';
import 'team_member_dialog_field_label.dart';

/// Email input field for the team member dialog
class TeamMemberDialogEmailField extends StatelessWidget {
  /// Whether this dialog is for adding a new member (true) or editing existing (false)
  final bool isAddingMember;

  /// The member to edit (only used when isAddingMember is false)
  final ManageTeamModel? member;

  /// The presenter instance for form state management
  final DepartmentManagementPresenterInterface presenter;

  const TeamMemberDialogEmailField({
    super.key,
    required this.isAddingMember,
    this.member,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TeamMemberDialogFieldLabel(label: 'Email'),
        const SizedBox(height: 8),
        ShadInput(
          readOnly: isAddingMember ? false : true,
          enabled: isAddingMember ? true : false,
          controller: presenter.emailController,
          placeholder: const Text('Enter email address'),
          keyboardType: TextInputType.emailAddress,
          onChanged:
              (value) => presenter.validateEmail(
                value,
                excludeMemberId: isAddingMember ? null : member?.userId,
              ),
        ),
        Obx(() {
          if (presenter.emailError.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                presenter.emailError,
                style: const TextStyle(fontSize: 12, color: AppColors.error),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
