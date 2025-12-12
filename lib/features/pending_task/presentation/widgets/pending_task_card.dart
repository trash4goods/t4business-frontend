import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../auth/data/models/firebase_user_pending_task_model.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../controllers/interface/pending_task_controller_interface.dart';
import '../presenters/interface/pending_task_presenter_interface.dart';
import 'password_change_dialog.dart';

class PendingTaskCard extends StatelessWidget {
  final FirebaseUserPendingTaskModel task;
  final PendingTaskControllerInterface businessController;
  final PendingTaskPresenterInterface presenter;

  const PendingTaskCard({
    super.key,
    required this.task,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == PendingTaskStatus.completed;
    final taskTypeString = task.type?.name ?? 'unknown';

    return Obx(() {
      final isLoading = presenter.isTaskLoading(taskTypeString);

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.onPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isCompleted
                    ? AppColors.success.withValues(alpha: 0.3)
                    : AppColors.border,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.success : AppColors.warning,
                ),
              ),

              // Task info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.text ?? _getTaskTitle(task.type),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.text != null && task.text!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        task.text!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Action area
              if (isCompleted) ...[
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
              ] else ...[
                ShadButton(
                  size: ShadButtonSize.sm,
                  onPressed:
                      isLoading
                          ? null
                          : () => _handleTaskAction(
                            context,
                            task.type,
                            taskTypeString,
                          ),
                  child:
                      isLoading
                          ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            _getActionButtonText(task.type),
                            style: TextStyle(fontSize: 12),
                          ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  void _handleTaskAction(
    BuildContext context,
    PendingTaskType? taskType,
    String taskTypeString,
  ) {
    if (taskType == PendingTaskType.setPassword) {
      _showPasswordChangeDialog(context);
    } else {
      businessController.completeTask(taskTypeString);
    }
  }

  void _showPasswordChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => PasswordChangeDialog(
            onChangePassword: (oldPassword, newPassword) async {
              await businessController.changePassword(oldPassword, newPassword);
            },
          ),
    );
  }

  String _getTaskTitle(PendingTaskType? type) {
    switch (type) {
      case PendingTaskType.setPassword:
        return 'Set Your Password';
      case PendingTaskType.unknown:
      case null:
        return 'Unknown Task';
    }
  }

  String _getActionButtonText(PendingTaskType? type) {
    switch (type) {
      case PendingTaskType.setPassword:
        return 'Set Password';
      case PendingTaskType.unknown:
      case null:
        return 'Complete';
    }
  }
}
