import 'package:get/get.dart';

import '../../../../../core/services/snackbar.dart';
import '../../data/models/change_password_model.dart';
import '../../data/usecase/profile_change_password_usecase.interface.dart';
import '../../utils/profile_change_settings_utils.dart';
import '../presenter/profile_change_password_presenter.interface.dart';
import 'profile_change_password_controller.interface.dart';

class ProfileChangePasswordControllerImpl
    implements ProfileChangePasswordControllerInterface {
  ProfileChangePasswordControllerImpl(this._presenter, this._useCase);

  final ProfileChangePasswordPresenterInterface _presenter;
  final ProfileChangePasswordUseCaseInterface _useCase;

  @override
  Future<void> changePassword() async {
    try {
      _presenter.isLoading = true;
      _presenter.error = '';

      final model = ChangePasswordModel(
        oldPassword: _presenter.currentPasswordController.text,
        newPassword: _presenter.newPasswordController.text,
      );

      await _useCase.changePassword(model);

      onPasswordChangeSuccess();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  @override
  void clearErrors() {
    _presenter.error = '';
    _presenter.currentPasswordError = '';
    _presenter.newPasswordError = '';
    _presenter.confirmPasswordError = '';
  }

  @override
  void clearForm() {
    clearErrors();
    _presenter.passwordStrength = 0.0;
    _presenter.isFormValid = false;
    _presenter.isCurrentPasswordVisible = false;
    _presenter.isConfirmPasswordVisible = false;
  }

  @override
  void onBack() => Get.back();

  @override
  void onPasswordChangeSuccess() {
    // show success message
    clearForm();
    onBack();
    SnackbarService.showSuccess('Password changed successfully');
  }

  @override
  void setConfirmPasswordError(String? error) =>
      _presenter.confirmPasswordError = error ?? '';

  @override
  void setError(String? error) => _presenter.error = error ?? '';

  @override
  void setFormValid(bool valid) => _presenter.isFormValid = valid;

  @override
  void setLoading(bool loading) => _presenter.isLoading = loading;

  @override
  void setNewPasswordError(String? error) =>
      _presenter.newPasswordError = error ?? '';

  @override
  void setPasswordStrength(double strength) =>
      _presenter.passwordStrength = strength;

  @override
  void toggleConfirmPasswordVisibility() =>
      _presenter.isConfirmPasswordVisible =
          !_presenter.isConfirmPasswordVisible;

  @override
  void toggleCurrentPasswordVisibility() =>
      _presenter.isCurrentPasswordVisible =
          !_presenter.isCurrentPasswordVisible;

  @override
  void toggleNewPasswordVisibility() =>
      _presenter.isConfirmPasswordVisible =
          !_presenter.isConfirmPasswordVisible;

  @override
  void validateConfirmPassword(String password, String newPassword) {
    if (password.isEmpty) {
      _presenter.confirmPasswordError = 'Please confirm your password';
    } else if (password != newPassword) {
      _presenter.confirmPasswordError = 'Passwords do not match';
    } else if (newPassword.isEmpty) {
      _presenter.confirmPasswordError = 'Please enter a new password first';
    } else {
      _presenter.confirmPasswordError = '';
    }
    _updateFormValidity();
  }

  @override
  void validateCurrentPassword(String password) {
    if (password.isEmpty) {
      _presenter.currentPasswordError = 'Current password is required';
    } else if (password.length < 6) {
      _presenter.currentPasswordError =
          'Password must be at least 6 characters';
    } else if (password.length > 128) {
      _presenter.currentPasswordError =
          'Password is too long (max 128 characters)';
    } else {
      _presenter.currentPasswordError = '';
    }
    _updateFormValidity();
  }

  @override
  void validateNewPassword(String password) {
    if (password.isEmpty) {
      _presenter.newPasswordError = 'New password is required';
      _presenter.passwordStrength = 0.0;
      _updateFormValidity();
      return;
    }

    // Length validation
    if (password.length < 8) {
      _presenter.newPasswordError = 'Password must be at least 8 characters';
      _presenter.passwordStrength = 0.1;
      _updateFormValidity();
      return;
    }

    if (password.length > 128) {
      _presenter.newPasswordError = 'Password is too long (max 128 characters)';
      _presenter.passwordStrength = 0.0;
      _updateFormValidity();
      return;
    }

    // Common password validation
    if (ProfileChangeSettingsUtils.isCommonPassword(password)) {
      _presenter.newPasswordError =
          'This password is too common. Please choose a more unique password';
      _presenter.passwordStrength = 0.2;
      _updateFormValidity();
      return;
    }

    // Sequential characters validation
    if (ProfileChangeSettingsUtils.hasSequentialCharacters(password)) {
      _presenter.newPasswordError =
          'Avoid sequential characters (e.g., 123, abc)';
      _presenter.passwordStrength = 0.3;
      _updateFormValidity();
      return;
    }

    // Repeated characters validation
    if (ProfileChangeSettingsUtils.hasTooManyRepeatedCharacters(password)) {
      _presenter.newPasswordError =
          'Avoid repeating the same character multiple times';
      _presenter.passwordStrength = 0.3;
      _updateFormValidity();
      return;
    }

    // All validations passed
    _presenter.newPasswordError = '';
    _presenter.passwordStrength =
        ProfileChangeSettingsUtils.calculatePasswordStrength(password);
    _updateFormValidity();
  }

  void _updateFormValidity() {
    final hasCurrentPassword = _presenter.currentPasswordError.isEmpty;
    final hasValidNewPassword =
        _presenter.newPasswordError.isEmpty &&
        _presenter.passwordStrength >= 0.5;
    final hasMatchingConfirmPassword = _presenter.confirmPasswordError.isEmpty;

    final isValid =
        hasCurrentPassword && hasValidNewPassword && hasMatchingConfirmPassword;
    _presenter.isFormValid = isValid;
    _presenter.refreshIsFormValid();
  }

  @override
  void setCurrentPasswordError(String? error) =>
      _presenter.currentPasswordError = error ?? '';
}
