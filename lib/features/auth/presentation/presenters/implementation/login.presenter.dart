// features/auth/presentation/presenters/login_presenter_impl.dart
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/features/auth/data/datasources/auth_cache.dart';
import 'package:t4g_for_business/features/auth/data/models/user_auth/user_auth_model.dart';
import '../interface/login.presenter.dart';

class LoginPresenterImpl extends LoginPresenterInterface {
  final _isLoading = RxBool(false);
  final _obscurePassword = RxBool(true);
  final _isPasswordValid = RxBool(true);
  final _isEmailValid = RxBool(true);
  final _isForgotPasswordMode = RxBool(false);
  final _isResetEmailSent = RxBool(false);
  final _resetEmail = RxString('');
  final _isSignUpMode = RxBool(false);
  final _isSignUpSuccessful = RxBool(false);
  final _isNameValid = RxBool(true);
  final _isConfirmPasswordValid = RxBool(true);

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
  bool get isSignUpMode => _isSignUpMode.value;
  @override
  set isSignUpMode(bool value) => _isSignUpMode.value = value;

  @override
  bool get isSignUpSuccessful => _isSignUpSuccessful.value;
  @override
  set isSignUpSuccessful(bool value) => _isSignUpSuccessful.value = value;

  @override
  bool get isNameValid => _isNameValid.value;
  @override
  set isNameValid(bool value) => _isNameValid.value = value;

  @override
  bool get isConfirmPasswordValid => _isConfirmPasswordValid.value;
  @override
  set isConfirmPasswordValid(bool value) =>
      _isConfirmPasswordValid.value = value;

  @override
  TextEditingController emailController = TextEditingController();
  @override
  TextEditingController passwordController = TextEditingController();
  @override
  TextEditingController resetEmailController = TextEditingController();
  @override
  TextEditingController signUpEmailController = TextEditingController();
  @override
  TextEditingController signUpPasswordController = TextEditingController();
  @override
  TextEditingController nameController = TextEditingController();
  @override
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  FocusNode emailFocusNode = FocusNode();
  @override
  FocusNode passwordFocusNode = FocusNode();
  @override
  FocusNode resetEmailFocusNode = FocusNode();
  @override
  FocusNode signUpEmailFocusNode = FocusNode();
  @override
  FocusNode signUpPasswordFocusNode = FocusNode();
  @override
  FocusNode nameFocusNode = FocusNode();
  @override
  FocusNode confirmPasswordFocusNode = FocusNode();

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
  bool validateName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2;
  }

  @override
  bool validateConfirmPassword(String password, String confirmPassword) {
    return password == confirmPassword && password.length >= 8;
  }

  @override
  void resetToLoginMode() {
    isForgotPasswordMode = false;
    isResetEmailSent = false;
    resetEmail = '';
    resetEmailController.clear();
    isSignUpMode = false;
    isSignUpSuccessful = false;
    _clearSignUpFields();
  }

  @override
  void resetToSignUpMode() {
    isSignUpMode = false;
    isSignUpSuccessful = false;
    isNameValid = true;
    isConfirmPasswordValid = true;
    _clearSignUpFields();
  }

  void _clearSignUpFields() {
    signUpEmailController.clear();
    signUpPasswordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
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
  void focusSignUpEmailField() {
    signUpEmailFocusNode.requestFocus();
  }

  @override
  void focusSignUpPasswordField() {
    signUpPasswordFocusNode.requestFocus();
  }

  @override
  void focusNameField() {
    nameFocusNode.requestFocus();
  }

  @override
  void focusConfirmPasswordField() {
    confirmPasswordFocusNode.requestFocus();
  }

  @override
  void onSignUpEmailSubmitted() {
    focusNameField();
  }

  @override
  void onNameSubmitted() {
    focusSignUpPasswordField();
  }

  @override
  void onSignUpPasswordSubmitted() {
    focusConfirmPasswordField();
  }

  @override
  void onConfirmPasswordSubmitted() {
    unfocusAllFields();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    resetEmailFocusNode.dispose();
    signUpEmailFocusNode.dispose();
    signUpPasswordFocusNode.dispose();
    nameFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}
