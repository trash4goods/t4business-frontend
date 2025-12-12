// core/services/snackbar_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarService {
  SnackbarService._(); // Prevent instantiation

  static void showSuccess(String message, {String title = 'Success'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showError(
    String message, {
    String title = 'Error',
    SnackPosition position = SnackPosition.BOTTOM,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
      mainButton:
          actionLabel != null && onActionPressed != null
              ? TextButton(
                onPressed: onActionPressed,
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
    );
  }

  static void showInfo(String message, {String title = 'Info'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarning(String message, {String title = 'Warning'}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void dismiss() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
  }
}
