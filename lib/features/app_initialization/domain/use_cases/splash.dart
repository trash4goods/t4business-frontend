// features/app_initialization/domain/use_cases/splash_use_case.dart
import '../entities/auth_status.dart';
import '../repositories/splash.dart';

abstract class SplashUseCaseInterface {
  Future<AuthStatusEntity> checkUserAuthentication();
  Future<String?> getAuthToken();
  Future<bool> validateAuthToken(String token);
}

class SplashUseCaseImpl implements SplashUseCaseInterface {
  final SplashRepositoryInterface _repository;

  SplashUseCaseImpl(this._repository);

  @override
  Future<AuthStatusEntity> checkUserAuthentication() async {
    return await _repository.checkAuthenticationStatus();
  }

  @override
  Future<String?> getAuthToken() async {
    return await _repository.getAuthToken();
  }

  @override
  Future<bool> validateAuthToken(String token) async {
    return await _repository.validateAuthToken(token);
  }
}
