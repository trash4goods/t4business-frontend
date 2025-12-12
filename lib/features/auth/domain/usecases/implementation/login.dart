// features/auth/domain/use_cases/login_usecase_impl.dart
import 'package:t4g_for_business/features/auth/data/models/firebase_user_pending_task_model.dart';

import '../../../data/models/user_auth/user_auth_model.dart';
import '../../../data/repositories/interface/login.dart';
import '../interface/login.dart';

class LoginUseCaseImpl implements LoginUseCaseInterface {
  final LoginRepositoryInterface _repository;

  LoginUseCaseImpl(this._repository);

  @override
  Future<UserAuthModel?> execute(String email, String password) async {
    try {
      return await _repository.login(email, password);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
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

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await _repository.verifyEmail(token);
    } catch (e) {
      throw Exception('Email verification failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await _repository.logout(token);
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkEmailVerification(String token, String email) async {
    try {
      return await _repository.checkEmailVerification(token, email);
    } catch (e) {
      throw Exception('Email verification check failed: ${e.toString()}');
    }
  }

  @override
  Future<List<FirebaseUserPendingTaskModel>?> checkFirebasePendingTask(
    String uid,
  ) async {
    try {
      return await _repository.checkFirebasePendingTask(uid);
    } catch (e) {
      throw Exception('Check Firebase pending task failed: ${e.toString()}');
    }
  }

  @override
  Future<void> createPendingTask(
    String uid,
    FirebaseUserPendingTaskModel task,
  ) async {
    try {
      await _repository.createPendingTask(uid, task);
    } catch (e) {
      throw Exception('Create Firebase pending task failed: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePendingTask(
    String uid,
    FirebaseUserPendingTaskModel task,
  ) async {
    try {
      await _repository.updatePendingTask(uid, task);
    } catch (e) {
      throw Exception('Update Firebase pending task failed: ${e.toString()}');
    }
  }

  @override
  Future<bool?> anyTaskPending(String uid) async {
    try {
      return await _repository.anyTaskPending(uid);
    } catch (e) {
      throw Exception('Check any task pending failed: ${e.toString()}');
    }
  }

  /*
  @override
  Future<UserEntity?> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      return await _repository.register(email, password, name);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }
  */

  /*
  @override
  Future<UserEntity?> signInWithGoogle(String email, String password) async {
    try {
      return await _repository.signInWithGoogle();
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }
  */

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
