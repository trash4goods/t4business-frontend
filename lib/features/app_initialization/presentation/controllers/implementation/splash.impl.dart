// features/app_initialization/presentation/controllers/splash_controller_impl.dart
import 'package:get/get.dart';

import '../../../../../core/app/app_routes.dart';
import '../../../../../core/services/navigation.dart';
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
      navigateToDashboard();
    } else {
      navigateToLogin();
    }
  }

  @override
  void navigateToLogin() {
    NavigationService.offAll(AppRoutes.login);
  }

  @override
  void navigateToDashboard() {
    NavigationService.offAll(AppRoutes.dashboard);
  }

  @override
  void initializeApp() async {
    // SECURITY FIX: Check if user is trying to access protected route directly
    final currentRoute = Get.currentRoute;
    print('SplashController: App initialized with route: $currentRoute');

    // Define protected routes
    const protectedRoutes = ['/dashboard', '/products', '/profile'];
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
      }
    }

    // Normal splash flow with delay
    Future.delayed(const Duration(seconds: 1), () async {
      final isLoggedIn = await checkUserLoggedIn();
      navigateToNextScreen(isLoggedIn);
    });
  }
}
