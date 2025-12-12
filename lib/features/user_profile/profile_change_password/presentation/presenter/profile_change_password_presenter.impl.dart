import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'profile_change_password_presenter.interface.dart';

class ProfileChangePasswordPresenterImpl
    extends ProfileChangePasswordPresenterInterface {
  ProfileChangePasswordPresenterImpl();

  final _isLoading = RxBool(false);
  final _error = RxString('');
  final _currentPasswordError = RxString('');
  final _newPasswordError = RxString('');
  final _confirmPasswordError = RxString('');
  final _isFormValid = RxBool(false);
  final _isCurrentPasswordVisible = RxBool(false);
  final _isConfirmPasswordVisible = RxBool(false);
  final _passwordStrength = RxDouble(0.0);

  @override
  final currentPasswordController = TextEditingController();

  @override
  final newPasswordController = TextEditingController();

  @override
  final confirmPasswordController = TextEditingController();

  @override
  String get confirmPasswordError => _confirmPasswordError.value;
  @override
  set confirmPasswordError(String value) => _confirmPasswordError.value = value;

  @override
  String get currentPasswordError => _currentPasswordError.value;
  @override
  set currentPasswordError(String value) => _currentPasswordError.value = value;

  @override
  String get error => _error.value;
  @override
  set error(String value) => _error.value = value;

  @override
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;
  @override
  set isConfirmPasswordVisible(bool value) => _isConfirmPasswordVisible.value = value;

  @override
  bool get isCurrentPasswordVisible => _isCurrentPasswordVisible.value;
  @override
  set isCurrentPasswordVisible(bool value) => _isCurrentPasswordVisible.value = value;

  @override
  bool get isFormValid => _isFormValid.value;
  @override
  set isFormValid(bool value) => _isFormValid.value = value;

  @override
  bool get isLoading => _isLoading.value;
  @override
  set isLoading(bool value) => _isLoading.value = value;

  @override
  String get newPasswordError => _newPasswordError.value;
  @override
  set newPasswordError(String value) => _newPasswordError.value = value;

  @override
  double get passwordStrength => _passwordStrength.value;
  @override
  set passwordStrength(double value) => _passwordStrength.value = value;

  @override
  void refreshIsFormValid() => _isFormValid.refresh();
}
