import 'package:flutter/material.dart';
import '../../../auth/data/models/firebase_user_pending_task_model.dart';
import '../controllers/interface/pending_task_controller_interface.dart';
import '../presenters/interface/pending_task_presenter_interface.dart';
import 'pending_task_card.dart';

class PendingTaskList extends StatelessWidget {
  final PendingTaskControllerInterface businessController;
  final PendingTaskPresenterInterface presenter;

  const PendingTaskList({
    super.key,
    required this.businessController,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FirebaseUserPendingTaskModel>>(
      stream: businessController.pendingTasksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'Error loading tasks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please try again later',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final tasks = snapshot.data ?? [];

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Colors.green.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'All tasks completed!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You can now access the dashboard',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          children:
              tasks
                  .map(
                    (task) => PendingTaskCard(
                      task: task,
                      businessController: businessController,
                      presenter: presenter,
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}
