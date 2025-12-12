import '../../../../auth/data/models/firebase_user_pending_task_model.dart';
import '../../datasources/pending_task_remote_datasource_interface.dart';
import '../interface/pending_task_repository_interface.dart';

class PendingTaskRepositoryImpl implements PendingTaskRepositoryInterface {
  final PendingTaskRemoteDataSourceInterface _remoteDataSource;

  const PendingTaskRepositoryImpl({
    required PendingTaskRemoteDataSourceInterface remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Stream<List<FirebaseUserPendingTaskModel>> getPendingTasksStream(String uid) {
    return _remoteDataSource.getPendingTasksStream(uid);
  }

  @override
  Future<void> updateTaskStatus(
    String uid,
    String taskType,
    PendingTaskStatus status,
  ) async {
    await _remoteDataSource.updateTaskStatus(uid, taskType, status);
  }

  @override
  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String token,
  ) async {
    await _remoteDataSource.changePassword(oldPassword, newPassword, token);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }
}
