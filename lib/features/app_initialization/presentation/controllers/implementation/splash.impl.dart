// features/app_initialization/presentation/controllers/splash_controller_impl.dart
import 'dart:developer';

import 'package:get/get.dart';

import '../../../../../core/app/app_routes.dart';
import '../../../../../core/utils/municipality_utils.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/services/navigation.dart';
import '../../../../../core/services/pending_task_service.dart';
import '../../../../../core/services/snackbar.dart';
import '../../../domain/use_cases/splash.dart';
import '../../presenters/interface/splash.interface.dart';
import '../interface/splash.interface.dart';

class SplashControllerImpl implements SplashControllerInterface {
  final SplashPresenterInterface presenter;
  final SplashUseCaseInterface useCase;

  SplashControllerImpl({required this.presenter, required this.useCase});

  @override
  void animateLogo() {
    // Animation is handled in the presenter's onInit
  }

  @override
  Future<bool> checkUserLoggedIn() async {
    try {
      final authStatus = await useCase.checkUserAuthentication();
      presenter.onTokenCheckComplete(authStatus.isAuthenticated);
      return authStatus.isAuthenticated;
    } catch (e) {
      presenter.onTokenCheckComplete(false);
      SnackbarService.showError(
        'Failed to check authentication status',
        position: SnackPosition.TOP,
        actionLabel: 'Retry',
        onActionPressed: () => checkUserLoggedIn(),
      );
      return false;
    }
  }

  @override
  void navigateToNextScreen(bool isLoggedIn) {
    if (isLoggedIn) {
      _navigateToAuthenticatedRoute();
    } else {
      navigateToLogin();
    }
  }

  @override
  void navigateToLogin() {
    NavigationService.offAll(AppRoutes.login);
  }

  @override
  void navigateToDashboard() async {
    final isMunicipality = await MunicipalityUtils.isMunicipalityUser();
    if (isMunicipality) {
      NavigationService.offAll(AppRoutes.rewards);
    } else {
      NavigationService.offAll(AppRoutes.dashboard);
    }
  }

  /// Navigate authenticated users to the appropriate route based on pending tasks
  void _navigateToAuthenticatedRoute() async {
    try {
      final authService = Get.find<AuthService>();
      final uid = authService.user?.uid;
      
      if (uid != null) {
        final pendingTaskService = Get.find<PendingTaskService>();
        
        // Check and cache pending tasks
        final hasPendingTasks = await pendingTaskService.checkAndCachePendingTasks(uid);
        
        if (hasPendingTasks) {
          print('SplashController: User has pending tasks, navigating to pending tasks');
          NavigationService.offAll(AppRoutes.pendingTasks);
        } else {
          print('SplashController: No pending tasks, navigating to dashboard');
          navigateToDashboard();
        }
      } else {
        print('SplashController: No user UID available, navigating to login');
        navigateToLogin();
      }
    } catch (e) {
      print('SplashController: Error checking pending tasks: $e, defaulting to dashboard');
      navigateToDashboard();
    }
  }

  @override
  void initializeApp() async {
    // SECURITY FIX: Check if user is trying to access protected route directly
    final currentRoute = Get.currentRoute;
    log('SplashController: App initialized with route: $currentRoute');

    // Define protected routes
    const protectedRoutes = [AppRoutes.dashboardShell, AppRoutes.dashboard, AppRoutes.productManagement, AppRoutes.rewards, AppRoutes.rulesV2, AppRoutes.profile];
    final isAccessingProtectedRoute = protectedRoutes.any(
      (route) => currentRoute.contains(route),
    );

    if (isAccessingProtectedRoute) {
      print(
        'SplashController: SECURITY CHECK - User attempting direct access to protected route: $currentRoute',
      );
      // Force authentication check immediately for protected routes
      final isLoggedIn = await checkUserLoggedIn();
      if (!isLoggedIn) {
        print(
          'SplashController: SECURITY BLOCK - Redirecting unauthenticated user to login',
        );
        navigateToLogin();
        return;
      } else {
        // User is authenticated, check for pending tasks
        _navigateToAuthenticatedRoute();
        return;
      }
    }

    // Normal splash flow with delay
    Future.delayed(const Duration(seconds: 1), () async {
      final isLoggedIn = await checkUserLoggedIn();
      navigateToNextScreen(isLoggedIn);
    });
  }
}
