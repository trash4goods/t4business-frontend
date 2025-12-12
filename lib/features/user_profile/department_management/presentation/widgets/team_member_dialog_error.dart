import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../presenter/department_management_presenter.interface.dart';

/// Error display section for the team member dialog
class TeamMemberDialogError extends StatelessWidget {
  /// The presenter instance for accessing error state
  final DepartmentManagementPresenterInterface presenter;

  const TeamMemberDialogError({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (presenter.dialogError.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.errorLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.errorLight.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  presenter.dialogError,
                  style: const TextStyle(fontSize: 12, color: AppColors.error),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
