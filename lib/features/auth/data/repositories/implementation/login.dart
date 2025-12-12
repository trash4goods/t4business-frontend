// features/auth/data/repositories/auth_repository_impl.dart
import 'package:t4g_for_business/features/auth/data/models/firebase_user_pending_task_model.dart';

import '../../datasources/interface/login_remote_datasource_interface.dart';
import '../../models/user_auth/user_auth_model.dart';
import '../interface/login.dart';

class LoginRepositoryImpl implements LoginRepositoryInterface {
  final LoginRemoteDatasourceInterface _remoteDataSource;

  LoginRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserAuthModel?> login(String email, String password) async {
    try {
      // api sign in first - must succeed before Firebase
      final userAuth = await _remoteDataSource.signIn(email, password);
      if (userAuth != null && userAuth.accessToken != null) {
        return userAuth;
      }
      // API authentication failed or returned no token
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await _remoteDataSource.verifyEmail(token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await _remoteDataSource.logout(token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkEmailVerification(String token, String email) async {
    try {
      return await _remoteDataSource.checkEmailVerification(token, email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<FirebaseUserPendingTaskModel>?> checkFirebasePendingTask(
    String uid,
  ) async {
    try {
      return await _remoteDataSource.checkFirebasePendingTask(uid);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createPendingTask(
    String uid,
    FirebaseUserPendingTaskModel task,
  ) async {
    try {
      return await _remoteDataSource.createPendingTask(uid, task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePendingTask(
    String uid,
    FirebaseUserPendingTaskModel task,
  ) async {
    try {
      return await _remoteDataSource.updatePendingTask(uid, task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool?> anyTaskPending(String uid) async {
    try {
      return await _remoteDataSource.anyTaskPending(uid);
    } catch (e) {
      rethrow;
    }
  }

  /* 
  @override
  Future<UserEntity?> signInWithGoogle() async {
    final userCredential = await _dataSource.signInWithGoogle();
    if (userCredential != null) {
      return UserEntity(
        email: userCredential.user?.email ?? '',
        token: await userCredential.user?.getIdToken(),
      );
    }
    return null;
  }
  */

  /*
  @override
  Future<UserEntity?> register(
    String email,
    String password,
    String name,
  ) async {
    final userCredential = await _dataSource.createUserWithEmailAndPassword(
      email,
      password,
      name,
    );
    if (userCredential != null) {
      return UserEntity(
        email: userCredential.user?.email ?? '',
        token: await userCredential.user?.getIdToken(),
      );
    }
    return null;
  }
  */
}
