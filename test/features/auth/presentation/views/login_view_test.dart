import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/features/auth/presentation/controllers/interface/login.controller.dart';
import 'package:t4g_for_business/features/auth/presentation/presenters/interface/login.presenter.dart';
import 'package:t4g_for_business/features/auth/presentation/views/login.dart';

// Mock implementations for testing
class MockLoginController implements LoginControllerInterface {
  @override
  Future<void> login(String email, String password) async {}

  @override
  void navigateToDashboard() {}

  @override
  void navigateToResetPassword() {}

  @override
  void showError(String message) {}

  @override
  void showSuccess(String message) {}

  @override
  bool onEmailChanged(String value) => true;

  @override
  bool onPasswordChanged(String value) => true;

  @override
  bool onResetEmailChanged(String value) => true;

  @override
  void togglePasswordVisibility() {}

  @override
  Future<void> onLoginButtonPressed() async {}

  @override
  void onForgotPasswordPressed() {
    Get.find<LoginPresenterInterface>().isForgotPasswordMode = true;
  }

  @override
  void onBackToLoginPressed() {
    Get.find<LoginPresenterInterface>().isForgotPasswordMode = false;
  }

  @override
  Future<void> onResetPasswordPressed() async {
    final presenter = Get.find<LoginPresenterInterface>();
    presenter.resetEmail = presenter.resetEmailController.text;
    presenter.isResetEmailSent = true;
  }

  @override
  Future<void> onSignInWithGooglePressed() async {}
}

class MockLoginPresenter extends GetxController
    implements LoginPresenterInterface {
  final _isLoading = false.obs;
  final _isEmailValid = true.obs;
  final _isPasswordValid = true.obs;
  final _obscurePassword = true.obs;
  final _isForgotPasswordMode = false.obs;
  final _isResetEmailSent = false.obs;
  final _resetEmail = ''.obs;

  @override
  bool get isLoading => _isLoading.value;
  @override
  set isLoading(bool value) => _isLoading.value = value;

  @override
  bool get isEmailValid => _isEmailValid.value;
  @override
  set isEmailValid(bool value) => _isEmailValid.value = value;

  @override
  bool get isPasswordValid => _isPasswordValid.value;
  @override
  set isPasswordValid(bool value) => _isPasswordValid.value = value;

  @override
  bool get obscurePassword => _obscurePassword.value;
  @override
  set obscurePassword(bool value) => _obscurePassword.value = value;

  @override
  bool get isForgotPasswordMode => _isForgotPasswordMode.value;
  @override
  set isForgotPasswordMode(bool value) => _isForgotPasswordMode.value = value;

  @override
  bool get isResetEmailSent => _isResetEmailSent.value;
  @override
  set isResetEmailSent(bool value) => _isResetEmailSent.value = value;

  @override
  String get resetEmail => _resetEmail.value;
  @override
  set resetEmail(String value) => _resetEmail.value = value;

  @override
  TextEditingController emailController = TextEditingController();
  @override
  TextEditingController passwordController = TextEditingController();
  @override
  TextEditingController resetEmailController = TextEditingController();

  @override
  void togglePasswordVisibility() => _obscurePassword.toggle();

  @override
  bool validateForm(String email, String password) =>
      email.isNotEmpty && password.length >= 8;

  @override
  bool validateEmail(String email) => GetUtils.isEmail(email);

  @override
  void resetToLoginMode() {
    isForgotPasswordMode = false;
    isResetEmailSent = false;
    resetEmail = '';
    resetEmailController.clear();
  }

  @override
  // TODO: implement emailFocusNode
  FocusNode get emailFocusNode => throw UnimplementedError();

  @override
  void focusEmailField() {
    // TODO: implement focusEmailField
  }

  @override
  void focusPasswordField() {
    // TODO: implement focusPasswordField
  }

  @override
  void focusResetEmailField() {
    // TODO: implement focusResetEmailField
  }

  @override
  void onEmailSubmitted() {
    // TODO: implement onEmailSubmitted
  }

  @override
  void onPasswordSubmitted() {
    // TODO: implement onPasswordSubmitted
  }

  @override
  void onResetEmailSubmitted() {
    // TODO: implement onResetEmailSubmitted
  }

  @override
  // TODO: implement passwordFocusNode
  FocusNode get passwordFocusNode => throw UnimplementedError();

  @override
  // TODO: implement resetEmailFocusNode
  FocusNode get resetEmailFocusNode => throw UnimplementedError();

  @override
  void unfocusAllFields() {
    // TODO: implement unfocusAllFields
  }
}

void main() {
  group('LoginView Forgot Password Tests', () {
    late MockLoginController mockController;
    late MockLoginPresenter mockPresenter;

    setUp(() {
      mockController = MockLoginController();
      mockPresenter = MockLoginPresenter();

      Get.testMode = true;
      Get.put<LoginControllerInterface>(mockController);
      Get.put<LoginPresenterInterface>(mockPresenter);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('should display login form by default', (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: const LoginView()));

      // Should show login form elements
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);

      // Should not show forgot password form
      expect(find.text('Reset password'), findsNothing);
    });

    testWidgets('should switch to forgot password mode when link is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(GetMaterialApp(home: const LoginView()));

      // Tap the forgot password link
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      // Should show forgot password form
      expect(find.text('Reset password'), findsOneWidget);
      expect(
        find.text(
          'Enter your email address and we\'ll send you instructions to reset your password',
        ),
        findsOneWidget,
      );
      expect(find.text('Reset Password'), findsOneWidget);

      // Should not show login form elements
      expect(find.text('Welcome back'), findsNothing);
    });

    testWidgets('should show success message after reset password', (
      tester,
    ) async {
      await tester.pumpWidget(GetMaterialApp(home: const LoginView()));

      // Switch to forgot password mode
      mockPresenter.isForgotPasswordMode = true;
      await tester.pumpAndSettle();

      // Enter email and submit
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.text('Reset Password'));
      await tester.pumpAndSettle();

      // Should show success message
      expect(find.text('Instructions sent!'), findsOneWidget);
      expect(
        find.textContaining('Instructions sent to "test@example.com"'),
        findsOneWidget,
      );
      expect(find.textContaining('support@trash4goods.com'), findsOneWidget);
    });

    testWidgets('should return to login when back button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(GetMaterialApp(home: const LoginView()));

      // Switch to forgot password mode
      mockPresenter.isForgotPasswordMode = true;
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should show login form again
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Reset password'), findsNothing);
    });
  });
}
