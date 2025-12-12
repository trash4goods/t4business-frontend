import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../data/models/manage_team.dart';
import '../../utils/department_managment_utils.dart';

/// Confirmation dialog for transferring ownership/role to another team member
///
/// This dialog displays a confirmation message with the user's role and email,
/// and provides Confirm and Cancel buttons for the transfer action.
class TransferOwnershipDialog extends StatelessWidget {
  /// The team member to transfer ownership/role to
  final ManageTeamModel member;

  /// Callback when the transfer is confirmed
  final VoidCallback onConfirm;

  /// Callback when the transfer is cancelled
  final VoidCallback onCancel;

  /// Whether the transfer operation is in progress
  final bool isLoading;

  final String roleNameToTransfer;

  const TransferOwnershipDialog({
    super.key,
    required this.member,
    required this.onConfirm,
    required this.onCancel,
    this.isLoading = false,
    required this.roleNameToTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      title: const Text('Transfer Ownership'),
      actions: [
        ShadButton.outline(
          onPressed: isLoading ? null : onCancel,
          child: const Text('Cancel'),
        ),
        ShadButton(
          onPressed: isLoading ? null : onConfirm,
          child:
              isLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : const Text('Confirm'),
        ),
      ],
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning icon and message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ownership Transfer Confirmation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            children: [
                              const TextSpan(
                                text: 'If you wish to transfer \'',
                              ),
                              TextSpan(
                                text: DepartmentManagmentUtils.formatRole(
                                  roleNameToTransfer,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const TextSpan(text: '\' ownership to '),
                              TextSpan(
                                text: member.displayEmail,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const TextSpan(
                                text: ', please click \'Confirm\'.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Additional information
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What happens next:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• ${member.name ?? 'This user'} will receive the ${DepartmentManagmentUtils.formatRole(member.roleName ?? 'member')} role\n'
                    '• They will gain administrative privileges\n'
                    '• This action cannot be undone automatically',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
