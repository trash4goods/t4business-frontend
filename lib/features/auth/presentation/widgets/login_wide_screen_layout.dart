import 'package:flutter/material.dart';
import '../../../../core/widgets/card_container.dart';
import 'login_map_section.dart';
import 'login_form_section.dart';
import '../controllers/interface/login.controller.dart';
import '../presenters/interface/login.presenter.dart';

class LoginWideScreenLayout extends StatelessWidget {
  final LoginControllerInterface businessController;
  final LoginPresenterInterface presenter;

  const LoginWideScreenLayout({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CardContainer(
        constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 600),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        child: Row(
          children: [
            // Left side - Animated Map
            const Expanded(child: LoginMapSection()),
            // Right side - Login Form
            Expanded(
              child: LoginFormSection(
                businessController: businessController,
                presenter: presenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}