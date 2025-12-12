/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/animated_content_wrapper.dart';
import '../../../../core/widgets/modern_text_field.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../../../../core/widgets/divider_with_text.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/interface/login.presenter.dart';

class SignUpContent extends StatelessWidget {
  final LoginControllerInterface businessController;
  final LoginPresenterInterface presenter;

  const SignUpContent({
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
                  onPressed: businessController.onBackToLoginFromSignUpPressed,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Check if sign up was successful
              if (presenter.isSignUpSuccessful) ...[
                // Success state
                const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Account created!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your account has been created successfully. You can now sign in with your credentials.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedGradientButton(
                  text: 'Sign In',
                  padding: const EdgeInsets.all(0),
                  icon: Icons.login,
                  onPressed: businessController.onBackToLoginFromSignUpPressed,
                ),
              ] else ...[
                // Sign up form
                const Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join us and start managing your business rewards',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Google Sign In Button
                GoogleSignInButton(
                  onPressed: businessController.onSignInWithGooglePressed,
                  isLoading: presenter.isLoading,
                ),
                const SizedBox(height: 20),

                // Divider
                const DividerWithText(text: 'or'),
                const SizedBox(height: 20),

                // Email field
                ModernTextField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  controller: presenter.signUpEmailController,
                  focusNode: presenter.signUpEmailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: businessController.onSignUpEmailChanged,
                  onSubmitted: (_) => presenter.onSignUpEmailSubmitted(),
                  isRequired: true,
                ),
                const SizedBox(height: 16),

                // Name field
                ModernTextField(
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  controller: presenter.nameController,
                  focusNode: presenter.nameFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: businessController.onNameChanged,
                  onSubmitted: (_) => presenter.onNameSubmitted(),
                  isRequired: true,
                ),
                const SizedBox(height: 16),

                // Password field
                ModernTextField(
                  label: 'Password',
                  hintText: 'Enter your password (min 8 characters)',
                  obscureText: presenter.obscurePassword,
                  controller: presenter.signUpPasswordController,
                  focusNode: presenter.signUpPasswordFocusNode,
                  textInputAction: TextInputAction.next,
                  onChanged: businessController.onSignUpPasswordChanged,
                  onSubmitted: (_) => presenter.onSignUpPasswordSubmitted(),
                  isRequired: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      presenter.obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.lightTextSecondary,
                      size: 20,
                    ),
                    onPressed: presenter.togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password field
                ModernTextField(
                  label: 'Confirm Password',
                  hintText: 'Confirm your password',
                  obscureText: presenter.obscurePassword,
                  controller: presenter.confirmPasswordController,
                  focusNode: presenter.confirmPasswordFocusNode,
                  textInputAction: TextInputAction.done,
                  onChanged: businessController.onConfirmPasswordChanged,
                  onSubmitted: (_) {
                    presenter.onConfirmPasswordSubmitted();
                    businessController.onCreateAccountPressed();
                  },
                  isRequired: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      presenter.obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.lightTextSecondary,
                      size: 20,
                    ),
                    onPressed: presenter.togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: 24),

                // Create account button
                AnimatedGradientButton(
                  text: 'Create Account',
                  padding: const EdgeInsets.all(0),
                  icon: Icons.person_add,
                  isLoading: presenter.isLoading,
                  onPressed: businessController.onCreateAccountPressed,
                ),
                const SizedBox(height: 16),

                // Already have account link
                Center(
                  child: TextButton(
                    onPressed:
                        businessController.onBackToLoginFromSignUpPressed,
                    child: const Text(
                      'Already have an account? Sign In',
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
*/