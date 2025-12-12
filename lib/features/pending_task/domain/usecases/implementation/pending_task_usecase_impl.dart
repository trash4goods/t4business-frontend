import '../../../../auth/data/models/firebase_user_pending_task_model.dart';
import '../../../data/repositories/interface/pending_task_repository_interface.dart';
import '../interface/pending_task_usecase_interface.dart';

class PendingTaskUsecaseImpl implements PendingTaskUsecaseInterface {
  final PendingTaskRepositoryInterface _repository;

  const PendingTaskUsecaseImpl({
    required PendingTaskRepositoryInterface repository,
  }) : _repository = repository;

  @override
  Stream<List<FirebaseUserPendingTaskModel>> getPendingTasksStream(String uid) {
    return _repository.getPendingTasksStream(uid);
  }

  @override
  Future<void> updateTaskStatus(
    String uid,
    String taskType,
    PendingTaskStatus status,
  ) async {
    await _repository.updateTaskStatus(uid, taskType, status);
  }

  @override
  Future<void> completeTask(String uid, String taskType) async {
    await _repository.updateTaskStatus(
      uid,
      taskType,
      PendingTaskStatus.completed,
    );
  }

  @override
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    await _repository.changePassword(oldPassword, newPassword, token);
  }

  @override
  Future<void> logout() async {
    await _repository.logout();
  }
}
