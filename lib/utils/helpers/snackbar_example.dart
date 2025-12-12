// Example usage of the enhanced SnackbarServiceHelper

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'snackbar_service.dart';

/// Example class demonstrating the usage of the enhanced SnackbarServiceHelper
class SnackbarExampleHelper {
  // Basic Success Example
  static void showSuccessExample() {
    SnackbarServiceHelper.showSuccess(
      'Your changes have been saved successfully',
    );
  }

  // Error Example
  static void showErrorExample() {
    SnackbarServiceHelper.showError(
      'Failed to upload your file. Please try again.',
    );
  }

  // Info Example
  static void showInfoExample() {
    SnackbarServiceHelper.showInfo('Your session will expire in 10 minutes');
  }

  // Warning Example
  static void showWarningExample() {
    SnackbarServiceHelper.showWarning(
      'You have unsaved changes that may be lost',
    );
  }

  // Example with Custom Title
  static void showCustomTitleExample() {
    SnackbarServiceHelper.showSuccess(
      'Your document has been shared',
      title: 'Share Complete',
    );
  }

  // Example with Action Button
  static void showWithActionExample() {
    SnackbarServiceHelper.showError(
      'Connection lost. Please check your network.',
      actionLabel: 'Retry',
      onActionPressed: () {
        // Retry connection logic here
        // print('Retrying connection...');
        // Show success after "retrying"
        SnackbarServiceHelper.showSuccess('Connection restored!');
      },
    );
  }

  // Example with Tap Callback
  static void showTapCallbackExample() {
    SnackbarServiceHelper.showInfo(
      'New message received. Tap to view.',
      onTap: () {
        // Navigate to message or perform action
        // print('Snackbar tapped, navigating to message...');
        // Example navigation
        // Get.toNamed('/messages');
      },
    );
  }

  // Example with Custom Duration
  static void showLongDurationExample() {
    SnackbarServiceHelper.showWarning(
      'Battery is low. Connect your device to power.',
      duration: const Duration(seconds: 6),
    );
  }

  // Example with Position (Top)
  static void showTopPositionExample() {
    SnackbarServiceHelper.showSuccess(
      'New update available',
      position: SnackPosition.TOP,
      actionLabel: 'Update Now',
      onActionPressed: () {
        // print('Starting update process...');
      },
    );
  }

  // Example with Form Validation and Focus Management
  static void showFormValidationExample(FocusNode focusNode) {
    SnackbarServiceHelper.showError(
      'Please enter a valid email address',
      title: 'Validation Error',
      actionLabel: 'Fix',
      onActionPressed: () => focusNode.requestFocus(),
    );
  }
}
