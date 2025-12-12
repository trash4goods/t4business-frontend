import '../../../auth/data/models/firebase_user_pending_task_model.dart';

abstract class PendingTaskRemoteDataSourceInterface {
  Stream<List<FirebaseUserPendingTaskModel>> getPendingTasksStream(String uid);
  Future<void> updateTaskStatus(
    String uid,
    String taskType,
    PendingTaskStatus status,
  );
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String token,
  );
  Future<void> logout();
}
