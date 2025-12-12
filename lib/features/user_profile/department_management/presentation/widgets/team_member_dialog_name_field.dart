import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../presenter/department_management_presenter.interface.dart';
import 'team_member_dialog_field_label.dart';

/// Name input field for the team member dialog
class TeamMemberDialogNameField extends StatelessWidget {
  /// The presenter instance for form state management
  final DepartmentManagementPresenterInterface presenter;

  const TeamMemberDialogNameField({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TeamMemberDialogFieldLabel(label: 'Name'),
        const SizedBox(height: 8),
        ShadInput(
          readOnly: true,
          enabled: false,
          controller: presenter.nameController,
          placeholder: const Text('Enter member name'),
          onChanged: (value) => presenter.validateName(value),
        ),
        Obx(() {
          if (presenter.nameError.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                presenter.nameError,
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
