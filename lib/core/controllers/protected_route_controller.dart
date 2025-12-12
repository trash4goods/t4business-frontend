import 'package:get/get.dart';

import '../mixins/browser_history_protection_mixin.dart';

/// Base controller for protected routes with browser history protection
/// This controller automatically enables/disables back button protection
/// for authenticated users on protected routes
class ProtectedRouteController extends GetxController
    with BrowserHistoryProtectionMixin {
  /// Override this method in child controllers for route-specific initialization
  void onProtectedRouteReady() {}

  @override
  void onReady() {
    super.onReady();
    onProtectedRouteReady();
  }
}
