// features/app_initialization/data/datasources/firebase_auth_datasource.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_status.dart';

abstract class AuthDataSource {
  Future<AuthStatusEntity> checkAuthStatus();
  Future<String?> getIdToken();
  Future<bool> validateToken(String token);
}

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSource(this._firebaseAuth);

  @override
  Future<AuthStatusEntity> checkAuthStatus() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        return token != null
            ? AuthStatusEntity.authenticated(token: token)
            : AuthStatusEntity.unauthenticated();
      }
      return AuthStatusEntity.unauthenticated();
    } catch (e) {
      return AuthStatusEntity.unauthenticated();
    }
  }

  @override
  Future<String?> getIdToken() async {
    try {
      return await _firebaseAuth.currentUser?.getIdToken(true);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> validateToken(String token) async {
    try {
      final currentToken = await getIdToken();
      return currentToken == token;
    } catch (e) {
      return false;
    }
  }
}
