// features/auth/presentation/controllers/login_controller_impl.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/navigation.dart';
import 'package:t4g_for_business/utils/helpers/validators.dart';
import '../../../../../core/app/app_routes.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../utils/helpers/snackbar_service.dart';
import '../../../domain/usecases/interface/login.dart';
import '../../presenters/interface/login.presenter.dart';
import '../interface/login.controller.dart';

class LoginControllerImpl implements LoginControllerInterface {
  final LoginUseCaseInterface useCase;
  final LoginPresenterInterface presenter;

  LoginControllerImpl({required this.useCase, required this.presenter});

  @override
  Future<void> login(String email, String password) async {
    try {
      final user = await AuthService.instance.execute(email, password);
      if (user?.token != null) {
        navigateToDashboard();
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  @override
  void navigateToDashboard() => NavigationService.offAll(AppRoutes.dashboard);

  @override
  void navigateToResetPassword() =>
      NavigationService.offAll(AppRoutes.forgotPassword);

  @override
  void showError(String message) => SnackbarServiceHelper.showError(
    message,
    position: SnackPosition.TOP,
    actionLabel: 'Dismiss',
    onActionPressed: () => Get.back(),
  );

  @override
  void showSuccess(String message) => SnackbarServiceHelper.showSuccess(
    message,
    position: SnackPosition.TOP,
    actionLabel: 'OK',
  );

  @override
  bool onEmailChanged(String value) {
    // verify if the email is valid then update the isEmailValid state
    presenter.isEmailValid =
        ValidatorsHelper.email(value) == null ? true : false;
    return presenter.isEmailValid;
  }

  @override
  bool onPasswordChanged(String value) {
    // verify if the password is valid and then checks isEmailValid if true then update the ifFormValid state
    presenter.isPasswordValid =
        ValidatorsHelper.password(value) == null ? true : false;
    return presenter.isPasswordValid;
  }

  @override
  bool onResetEmailChanged(String value) {
    // verify if the email is valid for reset password
    final isValid = presenter.validateEmail(value);
    presenter.isEmailValid = isValid;
    return isValid;
  }

  @override
  void togglePasswordVisibility() {
    presenter.obscurePassword = !presenter.obscurePassword;
  }

  @override
  Future<void> onLoginButtonPressed() async {
    if ((!presenter.isEmailValid) || (!presenter.isPasswordValid)) {
      showError('Please fill out all fields correctly');
      return;
    }

    presenter.isLoading = true;

    try {
      await login(
        presenter.emailController.text,
        presenter.passwordController.text,
      );
    } finally {
      presenter.isLoading = false;
    }
  }

  @override
  void onForgotPasswordPressed() {
    // Pre-fill reset email with login email if available
    if (presenter.emailController.text.isNotEmpty &&
        presenter.emailController.text.isEmail) {
      presenter.resetEmailController.text = presenter.emailController.text;
    }

    // Switch to forgot password mode
    presenter.isForgotPasswordMode = true;
    presenter.isResetEmailSent = false;
  }

  @override
  void onBackToLoginPressed() {
    presenter.resetToLoginMode();
  }

  @override
  Future<void> onResetPasswordPressed() async {
    final email = presenter.resetEmailController.text;

    if (email.isEmpty || !presenter.validateEmail(email)) {
      showError('Please enter a valid email address');
      return;
    }

    presenter.isLoading = true;

    try {
      // Call the actual Firebase password reset API
      final success = await AuthService.instance.requestPasswordReset(email);

      if (success) {
        presenter.resetEmail = email;
        presenter.isResetEmailSent = true;
      } else {
        showError(
          'Failed to send reset instructions. Please check the email address and try again.',
        );
      }
    } catch (e) {
      showError('Failed to send reset instructions. Please try again.');
    } finally {
      presenter.isLoading = false;
    }
  }

  @override
  Future<void> onSignInWithGooglePressed() async {
    try {
      presenter.isLoading = true;
      log('🚀 Starting Google Sign-In...');
      
      final user = await AuthService.instance.signInWithGoogle('');
      log('🔑 Google Sign-In response: ${user?.user?.uid}');
      
      if (user?.user != null) {
        log('✅ User authenticated, waiting for state update...');
        // Wait a bit for the authentication state to be updated
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Check if authentication state is properly updated
        log('🔍 Checking auth state: ${AuthService.instance.isAuthenticated}');
        
        if (AuthService.instance.isAuthenticated) {
          log('🎉 Auth state confirmed, navigating to dashboard...');
          showSuccess('Successfully signed in with Google');
          navigateToDashboard();
        } else {
          log('❌ Auth state not updated properly');
          showError('Authentication state not updated. Please try again.');
        }
      } else {
        log('❌ Google Sign-In failed - no user returned');
        showError('Google Sign-In failed. Please try again.');
      }
    } catch (e) {
      log('💥 Google Sign-In error: $e');
      showError(e.toString());
    } finally {
      presenter.isLoading = false;
    }
  }
}
