// features/auth/domain/use_cases/login_usecase.dart
import '../../../data/models/firebase_user_pending_task_model.dart';
import '../../../data/models/user_auth/user_auth_model.dart';

abstract class LoginUseCaseInterface {
  Future<UserAuthModel?> execute(String email, String password);
  Future<bool> requestPasswordReset(String email);
  Future<void> verifyEmail(String token);
  Future<void> logout(String token);
  Future<bool> checkEmailVerification(String token, String email);

  // Future<UserEntity?> register(String email, String password, String name);
  // Future<UserEntity?> signInWithGoogle(String email, String password);
  /* 
    /// Checks if there is a current user signed in
    Future<bool> isUserSignedIn();

    /// Returns the current user's email if signed in
    String? getCurrentUserEmail();
  */

  Future<void> createPendingTask(String uid, FirebaseUserPendingTaskModel task);
  Future<List<FirebaseUserPendingTaskModel>?> checkFirebasePendingTask(
    String uid,
  );
  Future<void> updatePendingTask(String uid, FirebaseUserPendingTaskModel task);
  Future<bool?> anyTaskPending(String uid);
}
