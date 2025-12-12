// features/auth/domain/repositories/auth_repository_interface.dart
import '../../models/firebase_user_pending_task_model.dart';
import '../../models/user_auth/user_auth_model.dart';

abstract class LoginRepositoryInterface {
  Future<UserAuthModel?> login(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> verifyEmail(String token);
  Future<void> logout(String token);
  Future<bool> checkEmailVerification(String token, String email);
  // Future<UserEntity?> signInWithGoogle();
  // Future<UserEntity?> register(String email, String password, String name);

  Future<void> createPendingTask(String uid, FirebaseUserPendingTaskModel task);
  Future<List<FirebaseUserPendingTaskModel>?> checkFirebasePendingTask(
    String uid,
  );
  Future<void> updatePendingTask(String uid, FirebaseUserPendingTaskModel task);
  Future<bool?> anyTaskPending(String uid);
}
