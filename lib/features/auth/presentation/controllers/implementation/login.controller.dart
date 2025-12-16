// features/auth/presentation/controllers/login_controller_impl.dart
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/core/services/navigation.dart';
import 'package:t4g_for_business/core/utils/municipality_utils.dart';
import 'package:t4g_for_business/features/auth/data/datasources/auth_cache.dart';
import 'package:t4g_for_business/utils/helpers/validators.dart';
import '../../../../../core/app/app_routes.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../utils/helpers/snackbar_service.dart';
import '../../../data/models/firebase_user_pending_task_model.dart';
import '../../../data/models/user_auth/user_auth_model.dart';
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
      final user = await useCase.execute(email, password);
      if (user?.profile?.emailVerifiedAt != null &&
          (user?.profile?.emailVerifiedAt ?? '').isNotEmpty) {
        // proceed and login with firebase
        await AuthService.instance.execute(email, password);
        await AuthCacheDataSource.instance.saveUserAuth(user!);
        navigateToDashboard();
      } else {
        showEmailNotVerifiedCard(user!.accessToken!, email, password, user);
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  void showEmailNotVerifiedCard(
    String token,
    String email,
    String password,
    UserAuthModel? user,
  ) {
    if (user == null) return;

    // Timer for resend email functionality
    int secondsRemaining = 30;
    Timer? resendTimer;

    showShadDialog(
      context: Get.context!,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Start timer when dialog shows
            if (resendTimer == null && secondsRemaining > 0) {
              resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                setState(() {
                  secondsRemaining--;
                  if (secondsRemaining <= 0) {
                    timer.cancel();
                  }
                });
              });
            }

            return ShadDialog(
              title: const Text('Email Not Verified'),
              description: const Text(
                'Please check your inbox for the verification email.',
              ),
              actions: [
                ShadButton.outline(
                  onPressed: () async {
                    resendTimer?.cancel();
                    Navigator.of(context).pop();

                    // Logout from API and clear cached token
                    presenter.isLoading = true;
                    try {
                      await useCase.logout(token);
                      await AuthService.instance.logout();
                      NavigationService.offAll(AppRoutes.login);
                    } catch (e) {
                      showError('Failed to logout. Please try again.');
                    } finally {
                      presenter.isLoading = false;
                    }
                  },
                  child: const Text('Cancel'),
                ),
                ShadButton(
                  onPressed: () async {
                    // Check if email is verified
                    presenter.isLoading = true;
                    try {
                      final isVerified = await useCase.checkEmailVerification(
                        token,
                        email,
                      );
                      if (isVerified) {
                        Navigator.of(Get.context!).pop();
                        // login with firebase
                        await AuthService.instance.execute(email, password);
                        // check if must create pending task
                        final mustCreatePendingTask =
                            await checkIfMustCreatePendingTask(
                              AuthService.instance.user?.uid ?? '',
                            );
                        // create pending task if needed
                        if (mustCreatePendingTask) {
                          await createPendingTask(
                            AuthService.instance.user?.uid ?? '',
                          );
                        }
                        // check if there are any pending tasks
                        final anyTaskPending = await useCase
                            .checkFirebasePendingTask(
                              AuthService.instance.user?.uid ?? '',
                            );
                        if (anyTaskPending != null &&
                            anyTaskPending.isNotEmpty) {
                          // navigate to pending tasks screen
                          log(
                            '--> there are pending tasks - navigating to pending tasks screen',
                          );
                          NavigationService.offAll(AppRoutes.pendingTasks);
                        } else {
                          // navigate to dashboard
                          await AuthCacheDataSource.instance.saveUserAuth(user);
                          navigateToDashboard();
                        }
                      } else {
                        showError(
                          'Email not verified yet. Please check your inbox.',
                        );
                      }
                    } catch (e) {
                      showError('Failed to verify email. Please try again.');
                    } finally {
                      presenter.isLoading = false;
                    }
                  },
                  child: const Text('Done'),
                ),
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (secondsRemaining > 0)
                    Text(
                      'Send email again in $secondsRemaining seconds',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  else
                    ShadButton.ghost(
                      onPressed: () async {
                        // Resend verification email
                        try {
                          // TODO: Implement resend verification email
                          // await useCase.resendVerificationEmail();
                          showSuccess('Verification email sent successfully');
                          setState(() {
                            secondsRemaining = 30;
                            resendTimer = Timer.periodic(
                              const Duration(seconds: 1),
                              (timer) {
                                setState(() {
                                  secondsRemaining--;
                                  if (secondsRemaining <= 0) {
                                    timer.cancel();
                                  }
                                });
                              },
                            );
                          });
                        } catch (e) {
                          showError('Failed to send verification email');
                        }
                      },
                      child: const Text('Send email again'),
                    ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // Cleanup timer when dialog is closed
      resendTimer?.cancel();
    });
  }

  Future<bool> checkIfMustCreatePendingTask(String uid) async {
    try {
      final tasks = await useCase.checkFirebasePendingTask(uid);
      if (tasks != null && tasks.isNotEmpty) {
        // There are pending tasks && user signed in before
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPendingTask(String uid) async {
    try {
      final pendingTask = FirebaseUserPendingTaskModel(
        type: PendingTaskType.setPassword,
        status: PendingTaskStatus.pending,
        text: 'Please set up your password',
      );
      await useCase.createPendingTask(uid, pendingTask);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void navigateToDashboard() async {
    final isMunicipality = await MunicipalityUtils.isMunicipalityUser();
    if (isMunicipality) {
      NavigationService.offAll(AppRoutes.rewards);
    } else {
      NavigationService.offAll(AppRoutes.dashboardShell);
    }
  }

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
  void onBackToLoginFromSignUpPressed() {
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

  /* 
  ---------- REGISTER, GOOGLE SIGN AND SIGN UP COMMENTED ------
  
  @override
  Future<void> register(String email, String password, String name) async {
    try {
      final user = await useCase.register(email, password, name);
      if (user?.token != null) {
        presenter.isSignUpSuccessful = true;
      }
    } catch (e) {
      showError(e.toString());
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

  @override
  Future<void> onCreateAccountPressed() async {
    final email = presenter.signUpEmailController.text;
    final password = presenter.signUpPasswordController.text;
    final name = presenter.nameController.text;
    final confirmPassword = presenter.confirmPasswordController.text;

    // Validate all fields
    if (!presenter.validateEmail(email)) {
      showError('Please enter a valid email address');
      return;
    }

    if (!presenter.validateName(name)) {
      showError('Please enter a valid name (at least 2 characters)');
      return;
    }

    if (password.length < 8) {
      showError('Password must be at least 8 characters long');
      return;
    }

    if (!presenter.validateConfirmPassword(password, confirmPassword)) {
      showError('Passwords do not match');
      return;
    }

    presenter.isLoading = true;

    try {
      await register(email, password, name);
    } finally {
      presenter.isLoading = false;
    }
  }

  @override
  void onSignUpPressed() {
    // Pre-fill sign up email with login email if available
    if (presenter.emailController.text.isNotEmpty &&
        presenter.emailController.text.isEmail) {
      presenter.signUpEmailController.text = presenter.emailController.text;
    }

    // Switch to sign up mode
    presenter.isSignUpMode = true;
    presenter.isSignUpSuccessful = false;
  }

  @override
  bool onNameChanged(String value) {
    // verify if the name is valid
    presenter.isNameValid = presenter.validateName(value);
    return presenter.isNameValid;
  }

  @override
  bool onConfirmPasswordChanged(String value) {
    // verify if the confirm password matches the password
    presenter.isConfirmPasswordValid = presenter.validateConfirmPassword(
      presenter.signUpPasswordController.text,
      value,
    );
    return presenter.isConfirmPasswordValid;
  }

  @override
  bool onSignUpEmailChanged(String value) {
    // verify if the email is valid for sign up
    final isValid = presenter.validateEmail(value);
    presenter.isEmailValid = isValid;
    return isValid;
  }

  @override
  bool onSignUpPasswordChanged(String value) {
    // verify if the password is valid for sign up
    presenter.isPasswordValid =
        ValidatorsHelper.password(value) == null ? true : false;
    // Also validate confirm password if it's not empty
    if (presenter.confirmPasswordController.text.isNotEmpty) {
      presenter.isConfirmPasswordValid = presenter.validateConfirmPassword(
        value,
        presenter.confirmPasswordController.text,
      );
    }
    return presenter.isPasswordValid;
  }

  @override
  Future<void> register(String email, String password, String name) async {
    try {
      final user = await useCase.register(email, password, name);
      if (user?.token != null) {
        presenter.isSignUpSuccessful = true;
      }
    } catch (e) {
      showError(e.toString());
    }
  }
  */
}
