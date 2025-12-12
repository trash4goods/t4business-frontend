// features/auth/domain/repositories/auth_repository_interface.dart
import '../../../domain/entities/user.dart';

abstract class LoginRepositoryInterface {
  Future<UserEntity?> login(String email, String password);
  Future<UserEntity?> signInWithGoogle();

  /// Sends a password reset email to the specified email address
  Future<void> resetPassword(String email);
}
