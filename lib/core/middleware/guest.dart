import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../app/app_routes.dart';
import '../services/auth_service.dart';

/// Middleware for guest-only routes (login, signup, etc.)
/// Priority: 1 - Executes first
class GuestMiddleware extends GetMiddleware {
  @override
  int get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    try {
      final authService = Get.find<AuthService>();

      // If user is authenticated, redirect to dashboard
      if (authService.isAuthenticated) {
        print(
          'GuestMiddleware: User authenticated, redirecting to dashboard from $route',
        );
        return const RouteSettings(name: AppRoutes.dashboardShell);
      }

      print(
        'GuestMiddleware: User not authenticated, allowing access to $route',
      );
      return null;
    } catch (e) {
      // If AuthService is not found, allow access to guest routes
      print(
        'GuestMiddleware: AuthService not found, allowing access to $route',
      );
      return null;
    }
  }
}
