// features/auth/presentation/controllers/login_controller_interface.dart
abstract class LoginControllerInterface {
  Future<void> login(String email, String password);
  void navigateToDashboard();
  void navigateToResetPassword();
  void showError(String message);
  void showSuccess(String message);

  // Form methods
  bool onEmailChanged(String value);
  bool onPasswordChanged(String value);
  bool onResetEmailChanged(String value);
  void togglePasswordVisibility();

  // Authentication methods
  Future<void> onLoginButtonPressed();
  Future<void> onSignInWithGooglePressed();
  void onForgotPasswordPressed();
  void onBackToLoginPressed();
  Future<void> onResetPasswordPressed();
}
