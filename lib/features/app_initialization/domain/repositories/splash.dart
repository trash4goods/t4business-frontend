// features/app_initialization/domain/repositories/splash_repository_interface.dart
import '../entities/auth_status.dart';

abstract class SplashRepositoryInterface {
  Future<AuthStatusEntity> checkAuthenticationStatus();
  Future<String?> getAuthToken();
  Future<bool> validateAuthToken(String token);
}
