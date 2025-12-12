import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/animated_content_wrapper.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../../../../core/widgets/divider_with_text.dart';
import '../../../../core/widgets/modern_text_field.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/interface/login.presenter.dart';

class LoginFormContent extends StatelessWidget {
  final LoginControllerInterface businessController;
  final LoginPresenterInterface presenter;

  const LoginFormContent({
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
              // Welcome back title
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to your account',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),

              /* FOR NOW WE'LL HAVE ONLY LOGIN AND FORGOT PASSWORD
              // Google Sign In Button
              GoogleSignInButton(
                onPressed: businessController.onSignInWithGooglePressed,
                isLoading: presenter.isLoading,
              ),
              const SizedBox(height: 20),

              // Divider
              const DividerWithText(text: 'or'),
              const SizedBox(height: 20),
              */

              // Email field
              ModernTextField(
                label: 'Email',
                hintText: 'Enter your email address',
                controller: presenter.emailController,
                focusNode: presenter.emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: businessController.onEmailChanged,
                onSubmitted: (_) => presenter.onEmailSubmitted(),
                isRequired: true,
              ),
              const SizedBox(height: 16),

              // Password field
              ModernTextField(
                label: 'Password',
                hintText: 'Enter your password',
                obscureText: presenter.obscurePassword,
                controller: presenter.passwordController,
                focusNode: presenter.passwordFocusNode,
                textInputAction: TextInputAction.done,
                onChanged: businessController.onPasswordChanged,
                onSubmitted: (_) {
                  presenter.onPasswordSubmitted();
                  businessController.onLoginButtonPressed();
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

              // Sign in button
              AnimatedGradientButton(
                text: 'Sign in',
                padding: const EdgeInsets.all(0),
                icon: Icons.arrow_forward,
                isLoading: presenter.isLoading,
                onPressed: businessController.onLoginButtonPressed,
              ),
              const SizedBox(height: 16),

              // Forgot password link
              Center(
                child: TextButton(
                  onPressed: businessController.onForgotPasswordPressed,
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              /* FOR NOW WE'LL HAVE ONLY LOGIN AND FORGOT PASSWORD
              // Sign up link
              Center(
                child: TextButton(
                  onPressed: businessController.onSignUpPressed,
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
