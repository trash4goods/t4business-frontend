import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/card_container.dart';
import 'login_map_section.dart';
import 'login_form_content.dart';
import 'forgot_password_content.dart';
import 'sign_up_content.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/interface/login.presenter.dart';

class LoginMobileLayout extends StatelessWidget {
  final LoginControllerInterface businessController;
  final LoginPresenterInterface presenter;

  const LoginMobileLayout({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Map section (smaller on mobile)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(height: 200, child: LoginMapSection()),
            ),
            const SizedBox(height: 24),
            // Login form
            CardContainer(
              padding: const EdgeInsets.all(24),
              child: Obx(() {
                if (presenter.isForgotPasswordMode) {
                  return ForgotPasswordContent(
                    businessController: businessController,
                    presenter: presenter,
                  );
                } 
                /* SIGN UP COMMENTED  
                else if (presenter.isSignUpMode) {
                  return SignUpContent(
                    businessController: businessController,
                    presenter: presenter,
                  );
                } */ else {
                  return LoginFormContent(
                    businessController: businessController,
                    presenter: presenter,
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
