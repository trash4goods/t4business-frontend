import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/middleware/app_middleware.dart';
import 'package:t4g_for_business/features/product_managment/presentation/bindings/product.dart';
import 'package:t4g_for_business/features/marketplace_products/presentation/bindings/product.dart'
    as marketplace_binding;
import 'package:t4g_for_business/features/marketplace_products/presentation/view/product.dart'
    as marketplace_view;

import '../../features/app_initialization/presentation/bindings/splash.dart';
import '../../features/app_initialization/presentation/views/splash.dart';
import '../../features/auth/presentation/bindings/login.dart';
import '../../features/auth/presentation/views/login.dart';
import '../../features/dashboard/presentation/bindings/dashboard.dart';
import '../../features/dashboard/views/dashboard.dart';

import '../../features/profile/presentation/views/profile.dart';
import '../../features/product_managment/presentation/view/product.dart';
import '../../features/profile/presentation/bindings/profile.dart';
import '../../features/rules/presentation/bindings/rule.dart' as rules_binding;
import '../../features/rules/presentation/view/rule.dart' as rules_view;
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static final List<GetPage> routes = [
    // Splash route - ALWAYS accessible and handles authentication checks
    // This is critical for security - all app access should go through splash first
    GetPage(
      title: 'Trash4Business',
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
    ),

    // Guest-only route - protected by AppMiddleware
    GetPage(
      title: 'Trash4Business - Login',
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Protected route - requires authentication
    GetPage(
      title: 'Trash4Business - Dashboard',
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Additional protected routes
    // Products management route - requires authentication
    GetPage(
      title: 'Trash4Business - Products Management',
      name: AppRoutes.productManagement,
      page: () => const ProductsPage(), // import at top if not present
      binding: ProductsBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),
    // Marketplace products route - requires authentication
    GetPage(
      title: 'Trash4Business - Marketplace Products',
      name: AppRoutes.marketplaceProducts,
      page: () => const marketplace_view.RewardsPage(),
      binding: marketplace_binding.MarketplaceProductsBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),
    // Rules route - requires authentication
    GetPage(
      title: 'Trash4Business - Rules',
      name: AppRoutes.rules,
      page: () => const rules_view.RulesPage(),
      binding: rules_binding.RulesBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Profile route - requires authentication
    GetPage(
      title: 'Trash4Business - Profile',
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Guest routes for future implementation
    GetPage(
      title: 'Trash4Business - Signup',
      name: AppRoutes.signup,
      page: () => const Scaffold(
        body: Center(child: Text('Signup Page - Coming Soon')),
      ),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    GetPage(
      title: 'Trash4Business - Forgot Password',
      name: AppRoutes.forgotPassword,
      page: () => const Scaffold(
        body: Center(child: Text('Forgot Password - Coming Soon')),
      ),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Root route - redirect to splash for proper flow
    GetPage(
      title: 'Trash4Business',
      name: '/',
      page: () => const SplashView(),
      binding: SplashBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
    ),
  ];
}
