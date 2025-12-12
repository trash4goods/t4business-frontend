// features/auth/presentation/presenters/login_presenter_impl.dart
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../interface/login.presenter.dart';

class LoginPresenterImpl extends LoginPresenterInterface {
  final _isLoading = RxBool(false);
  final _obscurePassword = RxBool(true);
  final _isPasswordValid = RxBool(true);
  final _isEmailValid = RxBool(true);
  final _isForgotPasswordMode = RxBool(false);
  final _isResetEmailSent = RxBool(false);
  final _resetEmail = RxString('');

  @override
  bool get isEmailValid => _isEmailValid.value;
  @override
  set isEmailValid(bool value) => _isEmailValid.value = value;

  @override
  bool get isPasswordValid => _isPasswordValid.value;
  @override
  set isPasswordValid(bool value) => _isPasswordValid.value = value;

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
  FocusNode emailFocusNode = FocusNode();
  @override
  FocusNode passwordFocusNode = FocusNode();
  @override
  FocusNode resetEmailFocusNode = FocusNode();

  @override
  bool get isLoading => _isLoading.value;
  @override
  set isLoading(bool value) => _isLoading.value = value;

  @override
  bool get obscurePassword => _obscurePassword.value;
  @override
  set obscurePassword(bool value) => _obscurePassword.value = value;

  @override
  void togglePasswordVisibility() => _obscurePassword.toggle();

  @override
  bool validateForm(String email, String password) =>
      email.isNotEmpty && password.length >= 8;

  @override
  bool validateEmail(String email) {
    return GetUtils.isEmail(email);
  }

  @override
  void resetToLoginMode() {
    isForgotPasswordMode = false;
    isResetEmailSent = false;
    resetEmail = '';
    resetEmailController.clear();
  }
  
  @override
  void focusEmailField() {
    emailFocusNode.requestFocus();
  }
  
  @override
  void focusPasswordField() {
    passwordFocusNode.requestFocus();
  }
  
  @override
  void focusResetEmailField() {
    resetEmailFocusNode.requestFocus();
  }
  
  @override
  void unfocusAllFields() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    resetEmailFocusNode.unfocus();
  }
  
  @override
  void onEmailSubmitted() {
    if (isForgotPasswordMode) {
      return;
    }
    focusPasswordField();
  }
  
  @override
  void onPasswordSubmitted() {
    unfocusAllFields();
  }
  
  @override
  void onResetEmailSubmitted() {
    unfocusAllFields();
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    resetEmailFocusNode.dispose();
    super.onClose();
  }
}
