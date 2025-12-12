// features/app_initialization/presentation/views/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/custom_getview.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/app_logo.dart';
import '../controllers/interface/splash.interface.dart';
import '../presenters/interface/splash.interface.dart';

class SplashView
    extends CustomGetView<SplashControllerInterface, SplashPresenterInterface> {
  const SplashView({super.key});

  @override
  Widget buildView(BuildContext context) {
    businessController.initializeApp();

    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Obx(
            () => AnimatedOpacity(
              opacity: presenter.logoOpacity,
              duration: const Duration(milliseconds: 500),
              child: AnimatedScale(
                scale: presenter.logoScale,
                duration: const Duration(milliseconds: 300),
                child: const AppLogo(
                  width: 200,
                  height: 200,
                  showBusinessText: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
