import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../controllers/interface/pending_task_controller_interface.dart';
import '../presenters/interface/pending_task_presenter_interface.dart';
import 'pending_task_header.dart';
import 'pending_task_list.dart';
import 'pending_task_logout_fab.dart';

class PendingTaskMobileLayout extends StatelessWidget {
  final PendingTaskControllerInterface businessController;
  final PendingTaskPresenterInterface presenter;

  const PendingTaskMobileLayout({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            PendingTaskHeader(isMobile: true),

            // Tasks List
            Expanded(
              child: Container(
                color: AppColors.surface,
                child: PendingTaskList(
                  businessController: businessController,
                  presenter: presenter,
                ),
              ),
            ),
          ],
        ),

        // Floating logout button
        PendingTaskLogoutFab(
          businessController: businessController,
          presenter: presenter,
        ),
      ],
    );
  }
}
