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

  // Sign up state
  bool get isSignUpMode;
  set isSignUpMode(bool value);

  bool get isSignUpSuccessful;
  set isSignUpSuccessful(bool value);

  bool get isNameValid;
  set isNameValid(bool value);

  bool get isConfirmPasswordValid;
  set isConfirmPasswordValid(bool value);

  void togglePasswordVisibility();
  bool validateForm(String email, String password);
  bool validateEmail(String email);
  bool validateName(String name);
  bool validateConfirmPassword(String password, String confirmPassword);
  void resetToLoginMode();
  void resetToSignUpMode();

  TextEditingController get emailController;
  TextEditingController get passwordController;
  TextEditingController get resetEmailController;
  TextEditingController get signUpEmailController;
  TextEditingController get signUpPasswordController;
  TextEditingController get nameController;
  TextEditingController get confirmPasswordController;

  FocusNode get emailFocusNode;
  FocusNode get passwordFocusNode;
  FocusNode get resetEmailFocusNode;
  FocusNode get signUpEmailFocusNode;
  FocusNode get signUpPasswordFocusNode;
  FocusNode get nameFocusNode;
  FocusNode get confirmPasswordFocusNode;

  void focusEmailField();
  void focusPasswordField();
  void focusResetEmailField();
  void focusSignUpEmailField();
  void focusSignUpPasswordField();
  void focusNameField();
  void focusConfirmPasswordField();
  void unfocusAllFields();
  void onEmailSubmitted();
  void onPasswordSubmitted();
  void onResetEmailSubmitted();
  void onSignUpEmailSubmitted();
  void onSignUpPasswordSubmitted();
  void onNameSubmitted();
  void onConfirmPasswordSubmitted();
}
