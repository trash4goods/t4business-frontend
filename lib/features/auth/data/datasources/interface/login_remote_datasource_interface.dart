import 'package:t4g_for_business/features/auth/data/models/firebase_user_pending_task_model.dart';

import '../../models/user_auth/user_auth_model.dart';

abstract class LoginRemoteDatasourceInterface {
  Future<UserAuthModel?> signIn(String email, String password);
  Future<void> verifyEmail(String token);
  Future<void> forgotPassword(String email);
  Future<void> logout(String token);
  Future<bool> checkEmailVerification(String token, String email);
  Future<void> createPendingTask(String uid, FirebaseUserPendingTaskModel task);
  Future<List<FirebaseUserPendingTaskModel>?> checkFirebasePendingTask(
    String uid,
  );
  Future<void> updatePendingTask(String uid, FirebaseUserPendingTaskModel task);
  Future<bool?> anyTaskPending(String uid);
}
