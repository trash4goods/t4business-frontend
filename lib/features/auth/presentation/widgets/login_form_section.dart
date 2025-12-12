import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_form_content.dart';
import 'forgot_password_content.dart';
import 'sign_up_content.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/interface/login.presenter.dart';

class LoginFormSection extends StatelessWidget {
  final LoginControllerInterface businessController;
  final LoginPresenterInterface presenter;

  const LoginFormSection({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Obx(() {
        if (presenter.isForgotPasswordMode) {
          return ForgotPasswordContent(
            businessController: businessController,
            presenter: presenter,
          );
        } 
        /* FOR NOW WE'LL HAVE ONLY LOGIN AND FORGOT PASSWORD
        else if (presenter.isSignUpMode) {
          return SignUpContent(
            businessController: businessController,
            presenter: presenter,
          );
        } 
        */
        else {
          return LoginFormContent(
            businessController: businessController,
            presenter: presenter,
          );
        }
      }),
    );
  }
}
