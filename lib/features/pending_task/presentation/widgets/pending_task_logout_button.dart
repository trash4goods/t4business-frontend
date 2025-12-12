import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../controllers/interface/pending_task_controller_interface.dart';
import '../presenters/interface/pending_task_presenter_interface.dart';

class PendingTaskLogoutButton extends StatelessWidget {
  final PendingTaskControllerInterface businessController;
  final PendingTaskPresenterInterface presenter;

  const PendingTaskLogoutButton({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = presenter.isLogoutLoading.value;
      
      return ShadCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sign Out',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Sign out from your account to switch users or exit the application',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ShadButton.destructive(
                onPressed: isLoading ? null : () => _showLogoutDialog(context),
                child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('Signing Out...'),
                      ],
                    )
                  : Text('Sign Out'),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showShadDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ShadDialog.alert(
        title: Text('Confirm Sign Out'),
        description: Text(
          'Are you sure you want to sign out? You will need to sign in again to access your account.',
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ShadButton.destructive(
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