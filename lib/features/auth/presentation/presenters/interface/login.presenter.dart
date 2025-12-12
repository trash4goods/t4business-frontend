// features/auth/presentation/presenters/login_presenter_interface.dart
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class LoginPresenterInterface extends GetxController {
  bool get isLoading;
  set isLoading(bool value);

  bool get isEmailValid;
  set isEmailValid(bool value);

  bool get isPasswordValid;
  set isPasswordValid(bool value);

  bool get obscurePassword;
  set obscurePassword(bool value);

  // Forgot password state
  bool get isForgotPasswordMode;
  set isForgotPasswordMode(bool value);

  bool get isResetEmailSent;
  set isResetEmailSent(bool value);

  String get resetEmail;
  set resetEmail(String value);

  void togglePasswordVisibility();
  bool validateForm(String email, String password);
  bool validateEmail(String email);
  void resetToLoginMode();

  TextEditingController get emailController;
  TextEditingController get passwordController;
  TextEditingController get resetEmailController;
  
  FocusNode get emailFocusNode;
  FocusNode get passwordFocusNode;
  FocusNode get resetEmailFocusNode;
  
  void focusEmailField();
  void focusPasswordField();
  void focusResetEmailField();
  void unfocusAllFields();
  void onEmailSubmitted();
  void onPasswordSubmitted();
  void onResetEmailSubmitted();
}
