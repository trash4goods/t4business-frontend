// features/auth/data/repositories/auth_repository_impl.dart
import '../../../domain/entities/user.dart';
import '../../datasources/firebase_auth.dart';
import '../interface/login.dart';

class LoginRepositoryImpl implements LoginRepositoryInterface {
  final FirebaseAuthDataSource _dataSource;

  LoginRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity?> login(String email, String password) async {
    final userCredential = await _dataSource.signIn(email, password);
    if (userCredential != null) {
      return UserEntity(
        email: userCredential.user?.email ?? '',
        token: await userCredential.user?.getIdToken(),
      );
    }
    return null;
  }

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

  @override
  Future<void> resetPassword(String email) async {
    await _dataSource.sendPasswordResetEmail(email);
  }
}
