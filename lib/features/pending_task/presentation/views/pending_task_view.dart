import 'package:flutter/material.dart';
import '../../../../core/app/custom_getview.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../controllers/interface/pending_task_controller_interface.dart';
import '../presenters/interface/pending_task_presenter_interface.dart';
import '../widgets/pending_task_desktop_layout.dart';
import '../widgets/pending_task_mobile_layout.dart';

class PendingTaskView
    extends
        CustomGetView<
          PendingTaskControllerInterface,
          PendingTaskPresenterInterface
        > {
  const PendingTaskView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideScreen = constraints.maxWidth > 768;

              if (isWideScreen) {
                return PendingTaskDesktopLayout(
                  businessController: businessController,
                  presenter: presenter,
                );
              } else {
                return PendingTaskMobileLayout(
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
