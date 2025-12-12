import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/app/constants.dart';
import '../../../../../core/app/custom_getview.dart';
import '../../../profile_settings/presentation/widgets/profile_settings_header.dart';
import '../controller/profile_change_password_controller.interface.dart';
import '../presenter/profile_change_password_presenter.interface.dart';
import '../widgets/change_password_card_header.dart';
import '../widgets/change_password_error_display.dart';
import '../widgets/change_password_field.dart';
import '../widgets/change_password_security_tips.dart';
import '../widgets/change_password_submit_button.dart';

class ProfileChangePasswordView
    extends
        CustomGetView<
          ProfileChangePasswordControllerInterface,
          ProfileChangePasswordPresenterInterface
        > {
  const ProfileChangePasswordView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop =
              constraints.maxWidth > AppConstants.tabletBreakpoint;

          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: isDesktop ? 800 : double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      // header
                      ProfileSettingsHeader(
                        onBack: businessController.onBack,
                        title: 'Change Password',
                      ),
                      const SizedBox(height: 24),

                      // Main form card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header section
                              ChangePasswordCardHeader(),

                              const SizedBox(height: 24),

                              // Current Password Field
                              ChangePasswordField(
                                label: 'Current Password',
                                controller:
                                    presenter.currentPasswordController,
                                hint: 'Enter your current password',
                                showStrengthIndicator: false,
                                isVisible: presenter.isCurrentPasswordVisible,
                                onToggleVisibility:
                                    businessController
                                        .toggleCurrentPasswordVisibility,
                                onChanged:
                                    (value) => businessController
                                        .validateCurrentPassword(value),
                                error: presenter.currentPasswordError ?? '',
                                passwordStrength: presenter.passwordStrength,
                              ),

                              const SizedBox(height: 8),

                              ChangePasswordField(
                                label: 'New Password',
                                controller:
                                    presenter.newPasswordController,
                                hint: 'Enter your new password',
                                showStrengthIndicator: true,
                                isVisible: presenter.isConfirmPasswordVisible,
                                onToggleVisibility:
                                    businessController
                                        .toggleNewPasswordVisibility,
                                onChanged:
                                    (value) => businessController
                                        .validateNewPassword(value),
                                error: presenter.newPasswordError,
                                passwordStrength: presenter.passwordStrength,
                              ),

                              const SizedBox(height: 8),

                              ChangePasswordField(
                                label: 'Confirm New Password',
                                controller:
                                    presenter
                                        .confirmPasswordController,
                                hint: 'Confirm your new password',
                                showStrengthIndicator: false,
                                isVisible: presenter.isConfirmPasswordVisible,
                                onToggleVisibility:
                                    businessController
                                        .toggleConfirmPasswordVisibility,
                                onChanged:
                                    (value) => businessController
                                        .validateConfirmPassword(
                                          value,
                                          presenter
                                              .newPasswordController
                                              .text,
                                        ),
                                error: presenter.confirmPasswordError,
                                passwordStrength: presenter.passwordStrength,
                              ),

                              const SizedBox(height: 32),

                              ChangePasswordSubmitButton(
                                handleSubmit:
                                    () async =>
                                        await businessController
                                            .changePassword(),
                                isLoading: presenter.isLoading,
                                isFormValid: presenter.isFormValid,
                              ),

                              const SizedBox(height: 16),

                              if(presenter.error.isNotEmpty)
                              ChangePasswordErrorDisplay(
                                error: presenter.error,
                              ),

                               const SizedBox(height: 8),

                              ChangePasswordSecurityTips(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
