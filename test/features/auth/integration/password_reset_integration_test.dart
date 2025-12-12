import 'package:flutter_test/flutter_test.dart';
import 'package:t4g_for_business/features/auth/data/datasources/firebase_auth.dart';
import 'package:t4g_for_business/features/auth/data/repositories/implementation/login.dart';
import 'package:t4g_for_business/features/auth/domain/usecases/implementation/login.dart';

void main() {
  group('Password Reset Integration Tests', () {
    test('should create all layers without throwing errors', () {
      // Arrange & Act
      final dataSource = FirebaseAuthDataSource();
      final repository = LoginRepositoryImpl(dataSource);
      final useCase = LoginUseCaseImpl(repository);

      // Assert - just verifying that all classes can be instantiated
      expect(dataSource, isA<FirebaseAuthDataSource>());
      expect(repository, isA<LoginRepositoryImpl>());
      expect(useCase, isA<LoginUseCaseImpl>());
    });

    test('should have correct method signatures', () {
      // Arrange
      final dataSource = FirebaseAuthDataSource();
      final repository = LoginRepositoryImpl(dataSource);
      final useCase = LoginUseCaseImpl(repository);

      // Act & Assert - verify methods exist and return correct types
      expect(
        dataSource.sendPasswordResetEmail('test@example.com'),
        isA<Future<void>>(),
      );
      expect(repository.resetPassword('test@example.com'), isA<Future<void>>());
      expect(
        useCase.requestPasswordReset('test@example.com'),
        isA<Future<bool>>(),
      );
    });
  });
}
