import 'package:flutter/material.dart';
import '../../../../core/app/custom_getview.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/interface/login.presenter.dart';
import '../widgets/login_wide_screen_layout.dart';
import '../widgets/login_mobile_layout.dart';

class LoginView
    extends CustomGetView<LoginControllerInterface, LoginPresenterInterface> {
  const LoginView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 768;

              if (isWideScreen) {
                return LoginWideScreenLayout(
                  businessController: businessController,
                  presenter: presenter,
                );
              } else {
                return LoginMobileLayout(
                  businessController: businessController,
                  presenter: presenter,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}