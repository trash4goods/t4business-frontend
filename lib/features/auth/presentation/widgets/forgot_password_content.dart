import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/animated_content_wrapper.dart';
import '../../../../core/widgets/modern_text_field.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/interface/login.presenter.dart';

class ForgotPasswordContent extends StatelessWidget {
  final LoginControllerInterface businessController;
  final LoginPresenterInterface presenter;

  const ForgotPasswordContent({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContentWrapper(
      child: Obx(
        () => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: businessController.onBackToLoginPressed,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Check if reset email was sent
              if (presenter.isResetEmailSent) ...[
                // Success state
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Instructions sent!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Instructions sent to "${presenter.resetEmail}". If the email is not registered, it will not work. Contact the support team at support@trash4goods.com',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedGradientButton(
                  text: 'Back to Sign In',
                  padding: const EdgeInsets.all(0),
                  icon: Icons.arrow_back,
                  onPressed: businessController.onBackToLoginPressed,
                ),
              ] else ...[
                // Reset password form
                const Text(
                  'Reset password',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your email address and we\'ll send you instructions to reset your password',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Email field
                ModernTextField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  controller: presenter.resetEmailController,
                  focusNode: presenter.resetEmailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onChanged: businessController.onResetEmailChanged,
                  onSubmitted: (_) {
                    presenter.onResetEmailSubmitted();
                    businessController.onResetPasswordPressed();
                  },
                  isRequired: true,
                ),
                const SizedBox(height: 24),

                // Reset password button
                AnimatedGradientButton(
                  text: 'Reset Password',
                  padding: const EdgeInsets.all(0),
                  icon: Icons.email_outlined,
                  isLoading: presenter.isLoading,
                  onPressed: businessController.onResetPasswordPressed,
                ),
                const SizedBox(height: 16),

                // Back to login link
                Center(
                  child: TextButton(
                    onPressed: businessController.onBackToLoginPressed,
                    child: const Text(
                      'Back to Sign In',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}