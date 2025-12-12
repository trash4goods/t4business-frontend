import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/middleware/app_middleware.dart';
import 'package:t4g_for_business/features/product_managment/presentation/bindings/product.dart';
import 'package:t4g_for_business/features/user_profile/profile/presentation/views/profile.dart';

import '../../features/app_initialization/presentation/bindings/splash.dart';
import '../../features/app_initialization/presentation/views/splash.dart';
import '../../features/auth/presentation/bindings/login.dart';
import '../../features/auth/presentation/views/login.dart';
import '../../features/dashboard/presentation/bindings/dashboard.dart';
import '../../features/dashboard/views/dashboard.dart';

import '../../features/dashboard_shell/presentation/bindings/dashboard_shell_binding.dart';
import '../../features/dashboard_shell/presentation/view/dashboard_shell_view.dart';
import '../../features/product_managment/presentation/view/product.dart';
import '../../features/rewards/presentation/bindings/rewards.dart';
import '../../features/rewards/presentation/views/rewards.dart';
import '../../features/rules_v2/presentation/binding/rules_v2_binding.dart';
import '../../features/rules_v2/presentation/view/rules_v2.dart';
import '../../features/user_profile/profile/presentation/bindings/profile.dart';
import '../../features/pending_task/presentation/bindings/pending_task_binding.dart';
import '../../features/pending_task/presentation/views/pending_task_view.dart';
import '../../features/user_profile/profile_change_password/presentation/bindings/profile_change_password_bindings.dart';
import '../../features/user_profile/profile_change_password/presentation/views/profile_change_password.dart';
import '../../features/user_profile/profile_settings/presentation/bindings/profile_settings_binding.dart';
import '../../features/user_profile/profile_settings/presentation/views/profile_settings.dart';
import '../../features/user_profile/department_management/presentation/bindings/department_management_bindings.dart';
import '../../features/user_profile/department_management/presentation/views/manage_team_view.dart';
import 'app_routes.dart';

class AppPages {
  const AppPages._();

  static final List<GetPage> routes = [
    // Splash route - ALWAYS accessible and handles authentication checks
    // This is critical for security - all app access should go through splash first
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
    ),

    // Guest-only route - protected by AppMiddleware
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Protected route - requires authentication
    GetPage(
      name: AppRoutes.dashboardShell,
      page: () => const DashboardShellView(),
      binding: DashboardShellBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
      children: [
        GetPage(
          name: AppRoutes.dashboard,
          page: () => const DashboardView(),
          binding: DashboardBinding(),
          preventDuplicates: true,
          participatesInRootNavigator: true,
          middlewares: [AppMiddleware()],
        ),
        GetPage(
          name: AppRoutes.productManagement,
          page: () => const ProductsPage(), // import at top if not present
          binding: ProductsBinding(),
          preventDuplicates: true,
          participatesInRootNavigator: true,
          middlewares: [AppMiddleware()],
        ),
        /*GetPage(
          name: AppRoutes.marketplaceProducts,
          page: () => const marketplace_view.RewardsPage(),
          binding: marketplace_binding.MarketplaceProductsBinding(),
          preventDuplicates: true,
          participatesInRootNavigator: true,
          middlewares: [AppMiddleware()],
        ),*/
        GetPage(
          name: AppRoutes.rewards,
          page: () => const RewardsView(),
          binding: RewardsBinding(),
          preventDuplicates: true,
          participatesInRootNavigator: true,
          middlewares: [AppMiddleware()],
        ),
        /*GetPage(
          name: AppRoutes.rules,
          page: () => const rules_view.RulesPage(),
          binding: rules_binding.RulesBinding(),
          preventDuplicates: true,
          participatesInRootNavigator: true,
          middlewares: [AppMiddleware()],
        ),*/
        GetPage(
          name: AppRoutes.rulesV2,
          page: () => const RulesV2View(),
          binding: RulesV2Binding(),
          preventDuplicates: true,
          participatesInRootNavigator: true,
          middlewares: [AppMiddleware()],
        ),
        GetPage(
          name: AppRoutes.profile,
          page: () => const ProfileView(),
          binding: ProfileBinding(),
          preventDuplicates: true,
          participatesInRootNavigator: true,
          middlewares: [AppMiddleware()],
        ),
      ],
    ),
    GetPage(
      name: AppRoutes.profileSettings,
      page: () => const ProfileSettingsView(),
      binding: ProfileSettingsBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Settings sub-routes
    GetPage(
      name: AppRoutes.profileChangePassword,
      page: () => const ProfileChangePasswordView(),
      binding: ProfileChangePasswordBindings(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Department Management route
    GetPage(
      name: AppRoutes.manageTeam,
      page: () => const ManageTeamView(),
      binding: DepartmentManagementBindings(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),
    // Pending tasks route - requires authentication
    GetPage(
      name: AppRoutes.pendingTasks,
      page: () => const PendingTaskView(),
      binding: PendingTaskBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Guest routes for future implementation
    GetPage(
      name: AppRoutes.signup,
      page:
          () => const Scaffold(
            body: Center(child: Text('Signup Page - Coming Soon')),
          ),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page:
          () => const Scaffold(
            body: Center(child: Text('Forgot Password - Coming Soon')),
          ),
      preventDuplicates: true,
      participatesInRootNavigator: true,
      middlewares: [AppMiddleware()],
    ),

    // Root route - redirect to splash for proper flow
    GetPage(
      name: '/',
      page: () => const SplashView(),
      binding: SplashBinding(),
      preventDuplicates: true,
      participatesInRootNavigator: true,
    ),
  ];
}
