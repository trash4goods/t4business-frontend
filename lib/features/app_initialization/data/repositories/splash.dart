// features/app_initialization/data/repositories/splash_repository_impl.dart
import '../../domain/entities/auth_status.dart';
import '../../domain/repositories/splash.dart';
import '../datasources/firebase_auth.dart';

class SplashRepositoryImpl implements SplashRepositoryInterface {
  final AuthDataSource _dataSource;

  SplashRepositoryImpl(this._dataSource);

  @override
  Future<AuthStatusEntity> checkAuthenticationStatus() async {
    return await _dataSource.checkAuthStatus();
  }

  @override
  Future<String?> getAuthToken() async {
    return await _dataSource.getIdToken();
  }

  @override
  Future<bool> validateAuthToken(String token) async {
    return await _dataSource.validateToken(token);
  }
}
