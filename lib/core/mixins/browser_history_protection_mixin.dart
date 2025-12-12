import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../services/browser_history_service.dart';

/// Mixin to add browser back button protection to controllers
/// Use this mixin in controllers for protected routes (dashboard, profile, products)
mixin BrowserHistoryProtectionMixin on GetxController {
  @override
  void onReady() {
    super.onReady();
    _enableHistoryProtection();
  }

  /// Enable browser history protection for this route
  void _enableHistoryProtection() {
    if (!kIsWeb) return;

    try {
      final historyService = BrowserHistoryService.to;
      historyService.enableBackButtonProtection();

      print('$runtimeType: Browser history protection enabled');
    } catch (e) {
      print('$runtimeType: Failed to enable history protection: $e');
    }
  }

  @override
  void onClose() {
    _disableHistoryProtection();
    super.onClose();
  }

  /// Disable browser history protection when leaving this route
  void _disableHistoryProtection() {
    if (!kIsWeb) return;

    try {
      final historyService = BrowserHistoryService.to;
      historyService.resetProtection();

      print('$runtimeType: Browser history protection disabled');
    } catch (e) {
      print('$runtimeType: Failed to disable history protection: $e');
    }
  }
}
