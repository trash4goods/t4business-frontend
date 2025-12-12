import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../presenter/department_management_presenter.interface.dart';

/// Action buttons section for the team member dialog (Cancel and Save/Invite)
class TeamMemberDialogActions extends StatelessWidget {
  /// Whether this dialog is for adding a new member (true) or editing existing (false)
  final bool isAddingMember;

  /// The presenter instance for accessing loading and validation state
  final DepartmentManagementPresenterInterface presenter;

  /// Callback when save/invite is pressed
  final VoidCallback onSave;

  /// Callback when cancel is pressed
  final VoidCallback onCancel;

  const TeamMemberDialogActions({
    super.key,
    required this.isAddingMember,
    required this.presenter,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Cancel button
        ShadButton.outline(
          onPressed: presenter.isDialogLoading ? null : onCancel,
          child: const Text('Cancel'),
        ),

        const SizedBox(width: 12),

        // Save/Invite button
        Obx(
          () => ShadButton(
            onPressed:
                presenter.isDialogLoading || !presenter.isFormValid
                    ? null
                    : onSave,
            child:
                presenter.isDialogLoading
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(isAddingMember ? 'Invite' : 'Save'),
          ),
        ),
      ],
    );
  }
}
