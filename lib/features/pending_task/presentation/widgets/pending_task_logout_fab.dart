import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../controllers/interface/pending_task_controller_interface.dart';
import '../presenters/interface/pending_task_presenter_interface.dart';

class PendingTaskLogoutFab extends StatelessWidget {
  final PendingTaskControllerInterface businessController;
  final PendingTaskPresenterInterface presenter;

  const PendingTaskLogoutFab({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: Obx(() {
        final isLoading = presenter.isLogoutLoading.value;
        
        return Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: isLoading ? null : () => _showLogoutDialog(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.destructive,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.logout,
                      size: 16,
                      color: AppColors.destructive,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    isLoading ? 'Signing out...' : 'Sign Out',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.destructive,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showShadDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ShadDialog.alert(
        title: Text('Sign Out'),
        description: Text(
          'Are you sure you want to sign out? You will need to sign in again to access your account.',
        ),
        actions: [
          ShadButton.outline(
            size: ShadButtonSize.sm,
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ShadButton.destructive(
            size: ShadButtonSize.sm,
            onPressed: () {
              Navigator.of(context).pop();
              businessController.logout();
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}