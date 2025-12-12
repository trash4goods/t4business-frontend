import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/auth_service.dart';

import '../app/app_routes.dart';

/// Middleware for protecting routes that require authentication
/// Priority: 2 - Executes after GuestMiddleware (priority 1)
class AuthMiddleware extends GetMiddleware {
  @override
  int get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    try {
      final authService = Get.find<AuthService>();

      // If user is not authenticated, redirect to login
      if (!authService.isAuthenticated) {
        print(
          'AuthMiddleware: User not authenticated, redirecting to login from $route',
        );
        return const RouteSettings(name: AppRoutes.login);
      }

      print('AuthMiddleware: User authenticated, allowing access to $route');
      return null;
    } catch (e) {
      // If AuthService is not found, redirect to login as safety measure
      print('AuthMiddleware: AuthService not found, redirecting to login');
      return const RouteSettings(name: AppRoutes.login);
    }
  }
}
