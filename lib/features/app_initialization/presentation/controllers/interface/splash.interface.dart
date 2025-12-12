// features/app_initialization/presentation/controllers/splash_controller_interface.dart
abstract class SplashControllerInterface {
  void animateLogo();
  Future<bool> checkUserLoggedIn();
  void navigateToNextScreen(bool isLoggedIn);
  void navigateToLogin();
  void navigateToDashboard();
  void initializeApp();
}
