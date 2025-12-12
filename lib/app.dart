import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:t4g_for_business/features/app_initialization/presentation/bindings/splash.dart';

import 'core/app/app_pages.dart';
import 'core/app/app_routes.dart';
import 'core/services/auth_service.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      appBuilder: (context) {
        return GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
          getPages: AppPages.routes,
          initialBinding: SplashBinding(),
          // SECURITY FIX: Handle direct URL access to protected routes
          routingCallback: (routing) {
            print(
              'App Routing: ${routing?.current} -> Previous: ${routing?.previous}',
            );

            // Check for direct access to protected routes
            _handleDirectRouteAccess(routing?.current);
          },
          // Handle unknown routes securely
          unknownRoute: GetPage(
            name: '/notfound',
            page:
                () =>
                    const Scaffold(body: Center(child: Text('Page not found'))),
          ),
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
        );
      },
    );
  }

  /// SECURITY METHOD: Handles direct URL access to protected routes
  void _handleDirectRouteAccess(String? route) {
    if (route == null) return;

    // Define protected routes
    const protectedRoutes = [
      AppRoutes.dashboardShell,
      AppRoutes.dashboard,
      AppRoutes.productManagement,
      AppRoutes.profile,
      AppRoutes.profileSettings,
      AppRoutes.rewards,
      AppRoutes.rulesV2,
      AppRoutes.pendingTasks,
    ];

    final isProtectedRoute = protectedRoutes.any(
      (protectedRoute) => route.contains(protectedRoute),
    );

    if (isProtectedRoute) {
      print('App: SECURITY CHECK - Direct access attempted to: $route');

      // Check if user is authenticated
      try {
        final authService = Get.find<AuthService>();
        if (!authService.isAuthenticated) {
          print(
            'App: SECURITY BLOCK - Redirecting unauthenticated user to splash',
          );
          // Force redirect to splash for authentication check
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(AppRoutes.splash);
          });
        }
      } catch (e) {
        print('App: AuthService not ready, forcing splash redirect');
        // If AuthService isn't ready, redirect to splash
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(AppRoutes.splash);
        });
      }
    }
  }
}
