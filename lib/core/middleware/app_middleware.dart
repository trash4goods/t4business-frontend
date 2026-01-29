import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/app/app_routes.dart';

import '../services/auth_service.dart';
import '../services/pending_task_service.dart';

/// Unified middleware for handling all route protection
/// Priority: 0 - Executes first to handle all routing logic
class AppMiddleware extends GetMiddleware {
  @override
  int get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    try {
      final authService = Get.find<AuthService>();

      // Normalize route (remove any leading slashes and fragments)
      final normalizedRoute = _normalizeRoute(route);

      debugPrint(
        'AppMiddleware: Processing route "$route" (normalized: "$normalizedRoute"), authenticated: ${authService.isAuthenticated}',
      );

      // SECURITY FIX: Special handling for direct URL access
      // If user tries to access protected route directly, always check auth first
      final currentUri = Uri.parse(Get.currentRoute);
      final requestedUri = Uri.parse(route ?? '');

      debugPrint(
        'AppMiddleware: Current URI: ${currentUri.path}, Requested URI: ${requestedUri.path}',
      );

      // Define protected routes that require authentication
      const protectedRoutes = [
        AppRoutes.dashboardShell,
        AppRoutes.dashboard,
        AppRoutes.productManagement,
        AppRoutes.profile,
        AppRoutes.rulesV2,
        AppRoutes.pendingTasks,
        // AppRoutes.marketplaceProducts,
        AppRoutes.rewards,
      ];

      // Define guest-only routes (authenticated users shouldn't access)
      const guestOnlyRoutes = [
        AppRoutes.login,
        AppRoutes.signup,
        AppRoutes.forgotPassword,
      ];

      // Allow splash route without restriction (it handles its own logic)
      if (normalizedRoute == AppRoutes.splash) {
        debugPrint('AppMiddleware: Allowing access to splash route');
        return null;
      }

      // Check if current route is protected
      final isProtectedRoute = protectedRoutes.any(
        (protectedRoute) => normalizedRoute == protectedRoute,
      );

      final isGuestOnlyRoute = guestOnlyRoutes.any(
        (guestRoute) => normalizedRoute == guestRoute,
      );

      // CRITICAL SECURITY CHECK: Protected routes
      if (isProtectedRoute && !authService.isAuthenticated) {
        debugPrint(
          'AppMiddleware: SECURITY VIOLATION - Blocking unauthenticated access to protected route $normalizedRoute',
        );
        return const RouteSettings(name: AppRoutes.login);
      }

      // Guest-only route handling
      if (isGuestOnlyRoute && authService.isAuthenticated) {
        final uid = authService.user?.uid;
        if (uid != null) {
          try {
            final pendingTaskService = Get.find<PendingTaskService>();
            final targetRoute = pendingTaskService.getAuthenticatedUserRoute(uid);
            debugPrint(
              'AppMiddleware: Redirecting authenticated user from guest route $normalizedRoute to $targetRoute',
            );
            return RouteSettings(name: targetRoute);
          } catch (e) {
            debugPrint('AppMiddleware: PendingTaskService error: $e, defaulting to dashboard');
            return const RouteSettings(name: AppRoutes.dashboardShell);
          }
        } else {
          debugPrint('AppMiddleware: No user UID available, defaulting to dashboard');
          return const RouteSettings(name: AppRoutes.dashboardShell);
        }
      }

      debugPrint('AppMiddleware: Allowing access to route $normalizedRoute');
      return null;
    } catch (e) {
      // If AuthService is not available, default to secure behavior
      debugPrint(
        'AppMiddleware: ERROR - AuthService not available ($e), defaulting to login',
      );
      return const RouteSettings(name: AppRoutes.login);
    }
  }

  /// Normalizes route by removing fragments and ensuring proper format
  String _normalizeRoute(String? route) {
    if (route == null || route.isEmpty) {
      return AppRoutes.splash;
    }

    // Remove any hash fragments and extra slashes
    String normalized = route.split('#').first;

    // Ensure it starts with a single slash
    if (!normalized.startsWith('/')) {
      normalized = '/$normalized';
    }

    // Remove trailing slashes except for root
    if (normalized.length > 1 && normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }

    return normalized;
  }
}
