// features/auth/presentation/controllers/login_controller_interface.dart
abstract class LoginControllerInterface {
  Future<void> login(String email, String password);
  // Future<void> register(String email, String password, String name);
  void navigateToDashboard();
  void navigateToResetPassword();
  void showError(String message);
  void showSuccess(String message);

  // Form methods
  bool onEmailChanged(String value);
  bool onPasswordChanged(String value);
  bool onResetEmailChanged(String value);
  // bool onSignUpEmailChanged(String value);
  // bool onSignUpPasswordChanged(String value);
  // bool onNameChanged(String value);
  // bool onConfirmPasswordChanged(String value);
  void togglePasswordVisibility();

  // Authentication methods
  Future<void> onLoginButtonPressed();
  // Future<void> onSignInWithGooglePressed();
  void onForgotPasswordPressed();
  // void onSignUpPressed();
  void onBackToLoginPressed();
  void onBackToLoginFromSignUpPressed();
  Future<void> onResetPasswordPressed();
  // Future<void> onCreateAccountPressed();
}
