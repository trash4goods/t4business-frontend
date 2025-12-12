import 'package:flutter/widgets.dart';

abstract class ProfileChangePasswordControllerInterface {  
  // methods
  void setLoading(bool loading);
  void setError(String? error);
  void setCurrentPasswordError(String? error);
  void setNewPasswordError(String? error);
  void setConfirmPasswordError(String? error);
  void setPasswordStrength(double strength);
  void setFormValid(bool valid);
  void toggleCurrentPasswordVisibility();
  void toggleNewPasswordVisibility();
  void toggleConfirmPasswordVisibility();
  void clearErrors();
  void clearForm();
  void onPasswordChangeSuccess();
  void onBack();

  Future<void> changePassword();
  void validateCurrentPassword(String password);
  void validateNewPassword(String password);
  void validateConfirmPassword(String password, String newPassword);
}