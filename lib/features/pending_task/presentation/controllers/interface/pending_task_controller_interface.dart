import '../../../../auth/data/models/firebase_user_pending_task_model.dart';

abstract class PendingTaskControllerInterface {
  Future<void> completeTask(String taskType);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> logout();
  Stream<List<FirebaseUserPendingTaskModel>> get pendingTasksStream;
}
