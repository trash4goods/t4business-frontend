import 'package:flutter/material.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../controllers/interface/pending_task_controller_interface.dart';
import '../presenters/interface/pending_task_presenter_interface.dart';
import 'pending_task_header.dart';
import 'pending_task_list.dart';
import 'pending_task_logout_fab.dart';

class PendingTaskDesktopLayout extends StatelessWidget {
  final PendingTaskControllerInterface businessController;
  final PendingTaskPresenterInterface presenter;

  const PendingTaskDesktopLayout({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            PendingTaskHeader(isMobile: false),

            // Main content area
            Expanded(
              child: Container(
                color: AppColors.surface,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PendingTaskList(
                      businessController: businessController,
                      presenter: presenter,
                    ),
                  ),
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
