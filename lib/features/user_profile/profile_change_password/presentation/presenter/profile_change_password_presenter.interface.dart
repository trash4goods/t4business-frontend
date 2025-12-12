import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class ProfileChangePasswordPresenterInterface extends GetxController {
  // variables
  bool get isLoading;
  set isLoading(bool value);
  String get error;
  set error(String value);
  String get currentPasswordError;
  set currentPasswordError(String value);
  String get newPasswordError;
  set newPasswordError(String value);
  String get confirmPasswordError;
  set confirmPasswordError(String value);
  double get passwordStrength;
  set passwordStrength(double value);
  bool get isFormValid;
  set isFormValid(bool value);
  bool get isCurrentPasswordVisible;
  set isCurrentPasswordVisible(bool value);
  bool get isConfirmPasswordVisible;
  set isConfirmPasswordVisible(bool value);
  TextEditingController get currentPasswordController;
  TextEditingController get newPasswordController;
  TextEditingController get confirmPasswordController;

  // methods
  void refreshIsFormValid();
}
