import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/delete_account_confirmation.dart';
import '../../utils/profile_delete_account_error_handler.dart';
import 'profile_delete_account_presenter.interface.dart';

/// Implementation of presenter for account deletion operations
class ProfileDeleteAccountPresenterImpl
    extends ProfileDeleteAccountPresenterInterface {
  ProfileDeleteAccountPresenterImpl();

  // Reactive state properties using GetX
  final _isLoading = RxBool(false);
  final _error = RxString('');
  final _confirmationText = RxString('');
  final _confirmationError = RxString('');
  final _isConfirmationValid = RxBool(false);

  // Text editing controller for confirmation input
  @override
  final confirmationController = TextEditingController();

  @override
  bool get isLoading => _isLoading.value;
  @override
  set isLoading(bool value) => _isLoading.value = value;

  @override
  String get error => _error.value;
  @override
  set error(String value) => _error.value = value;

  @override
  String get confirmationText => _confirmationText.value;
  @override
  set confirmationText(String value) {
    _confirmationText.value = value;
    // Trigger validation when text changes
    validateConfirmation();
  }

  @override
  String get confirmationError => _confirmationError.value;
  @override
  set confirmationError(String value) => _confirmationError.value = value;

  @override
  bool get isConfirmationValid => _isConfirmationValid.value;
  @override
  set isConfirmationValid(bool value) => _isConfirmationValid.value = value;

  @override
  void validateConfirmation() {
    try {
      final validation = DeleteAccountConfirmation.validate(confirmationText);

      isConfirmationValid = validation.isValid;
      confirmationError = validation.errorMessage ?? '';
    } catch (e) {
      log('ProfileDeleteAccountPresenter: Error during validation: $e');
      ProfileDeleteAccountErrorHandler.logError(
        e,
        'ProfileDeleteAccountPresenter.validateConfirmation',
      );

      isConfirmationValid = false;
      confirmationError = 'Validation error occurred. Please try again.';
    }
  }

  @override
  void resetState() {
    isLoading = false;
    error = '';
    confirmationText = '';
    confirmationError = '';
    isConfirmationValid = false;

    confirmationController.clear();
  }

  @override
  void onClose() {
    // Clean up the text controller when the presenter is disposed
    confirmationController.dispose();
    super.onClose();
  }
}
