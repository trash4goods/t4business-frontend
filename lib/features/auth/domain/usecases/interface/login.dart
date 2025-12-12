// features/auth/domain/use_cases/login_usecase.dart
import '../../entities/user.dart';

abstract class LoginUseCaseInterface {
  Future<UserEntity?> execute(String email, String password);
  Future<UserEntity?> signInWithGoogle(String email, String password);

  /// Requests password reset for a given email
  /// Returns a Future with a boolean indicating success or failure
  Future<bool> requestPasswordReset(String email);

  /* 
    /// Checks if there is a current user signed in
    Future<bool> isUserSignedIn();

    /// Returns the current user's email if signed in
    String? getCurrentUserEmail();
  */
}
