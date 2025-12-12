// features/app_initialization/presentation/presenters/splash_presenter_interface.dart
import 'package:get/get.dart';

abstract class SplashPresenterInterface extends GetxController {
  bool get isAnimating;
  double get logoOpacity;
  double get logoScale;
  bool get showContinueButton;

  void onAnimationComplete();
  void onContinuePressed();
  void onTokenCheckComplete(bool isLoggedIn);
}
