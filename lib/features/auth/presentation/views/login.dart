import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/custom_getview.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/animated_gradient_button.dart';
import '../../../../core/widgets/animated_world_map.dart';
import '../../../../core/widgets/google_sign_in_button.dart';
import '../../../../core/widgets/modern_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/app_logo.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/interface/login.presenter.dart';
import 'dart:html' as html;

class LoginView
    extends CustomGetView<LoginControllerInterface, LoginPresenterInterface> {
  const LoginView({super.key});

  @override
  Widget buildView(BuildContext context) {
    html.document.title = 'Trash4Business - Login';
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 768;

              if (isWideScreen) {
                return _buildWideScreenLayout(context);
              } else {
                return _buildMobileLayout(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWideScreenLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side - Animated Map
            Expanded(child: _buildMapSection(context)),
            // Right side - Login Form
            Expanded(child: _buildLoginForm(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Map section (smaller on mobile)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(height: 200, child: _buildMapSection(context)),
            ),
            const SizedBox(height: 24),
            // Login form
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(
                () => presenter.isForgotPasswordMode
                    ? _buildForgotPasswordContent(context)
                    : _buildLoginFormContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          // Animated world map
          const Positioned.fill(child: AnimatedWorldMap()),
          // Overlay content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: const AppLogo(width: 300, height: 100),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Title
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: const Text(
                          'Trash4Goods',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Subtitle
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1200),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: const Text(
                          'Create. Monitor. Reward. \n All-in-one platform for your business',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryDark,
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Obx(
        () => presenter.isForgotPasswordMode
            ? _buildForgotPasswordContent(context)
            : _buildLoginFormContent(context),
      ),
    );
  }

  Widget _buildLoginFormContent(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
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

                    // Google Sign In Button
                    GoogleSignInButton(
                      onPressed: businessController.onSignInWithGooglePressed,
                      isLoading: presenter.isLoading,
                    ),
                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.lightBorder,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: AppColors.lightTextSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppColors.lightBorder,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPasswordContent(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
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
          ),
        );
      },
    );
  }
}
