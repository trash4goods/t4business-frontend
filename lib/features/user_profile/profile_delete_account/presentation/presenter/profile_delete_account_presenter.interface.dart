import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Interface for presenter operations related to account deletion
abstract class ProfileDeleteAccountPresenterInterface extends GetxController {
  // State properties
  bool get isLoading;
  set isLoading(bool value);

  String get error;
  set error(String value);

  String get confirmationText;
  set confirmationText(String value);

  String get confirmationError;
  set confirmationError(String value);

  bool get isConfirmationValid;
  set isConfirmationValid(bool value);

  // Controllers
  TextEditingController get confirmationController;

  // Methods
  void validateConfirmation();
  void resetState();
}
