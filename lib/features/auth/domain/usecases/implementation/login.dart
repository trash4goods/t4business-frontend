// features/auth/domain/use_cases/login_usecase_impl.dart
import '../../../data/repositories/interface/login.dart';
import '../../entities/user.dart';
import '../interface/login.dart';

class LoginUseCaseImpl implements LoginUseCaseInterface {
  final LoginRepositoryInterface _repository;

  LoginUseCaseImpl(this._repository);

  @override
  Future<UserEntity?> execute(String email, String password) async {
    try {
      return await _repository.login(email, password);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> signInWithGoogle(String email, String password) async {
    try {
      return await _repository.signInWithGoogle();
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> requestPasswordReset(String email) async {
    try {
      await _repository.resetPassword(email);
      return true;
    } catch (e) {
      return false;
    }
  }

  /*
  @override
  Future<bool> isUserSignedIn() async {
    try {
      // This would need to be implemented in the repository
      // For now, return false as placeholder
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  String? getCurrentUserEmail() {
    // This would need to be implemented in the repository
    // For now, return null as placeholder
    return null;
  }
  */
}
