import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/modern_text_field.dart';

class PasswordChangeDialog extends StatefulWidget {
  final Function(String oldPassword, String newPassword) onChangePassword;

  const PasswordChangeDialog({super.key, required this.onChangePassword});

  @override
  State<PasswordChangeDialog> createState() => _PasswordChangeDialogState();
}

class _PasswordChangeDialogState extends State<PasswordChangeDialog> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _oldPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your current password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.destructive,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a new password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.destructive,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.length < 8) {
      Get.snackbar(
        'Error',
        'New password must be at least 8 characters long',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.destructive,
        colorText: Colors.white,
      );
      return;
    }

    if (oldPassword == newPassword) {
      Get.snackbar(
        'Error',
        'New password must be different from current password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.destructive,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onChangePassword(oldPassword, newPassword);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Error handling is done by the controller
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Set Your Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please enter your current password and choose a new password.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Current Password Field
            ModernTextField(
              label: 'Current Password',
              hintText: 'Enter your current password',
              controller: _oldPasswordController,
              focusNode: _oldPasswordFocusNode,
              obscureText: _obscureOldPassword,
              textInputAction: TextInputAction.next,
              onChanged: (_) {},
              onSubmitted: (_) => _newPasswordFocusNode.requestFocus(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureOldPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _obscureOldPassword = !_obscureOldPassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // New Password Field
            ModernTextField(
              label: 'New Password',
              hintText: 'Enter your new password',
              controller: _newPasswordController,
              focusNode: _newPasswordFocusNode,
              obscureText: _obscureNewPassword,
              textInputAction: TextInputAction.done,
              onChanged: (_) {},
              onSubmitted: (_) => _handleSave(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),

            // Password requirements
            Text(
              'Password must be at least 8 characters long',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed:
                      _isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: _isLoading ? null : _handleSave,
                  child:
                      _isLoading
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
                          : Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
