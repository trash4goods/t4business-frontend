import 'package:flutter_test/flutter_test.dart';
import 'package:t4g_for_business/features/auth/data/repositories/implementation/login.dart';
import 'package:t4g_for_business/features/auth/domain/usecases/implementation/login.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:t4g_for_business/features/auth/data/datasources/firebase_auth.dart';

import 'password_reset_working_test.mocks.dart';

@GenerateMocks([FirebaseAuthDataSource])
void main() {
  group('Password Reset Working Integration Tests', () {
    test('should integrate repository and use case layers correctly', () {
      // Arrange
      final mockDataSource = MockFirebaseAuthDataSource();
      final repository = LoginRepositoryImpl(mockDataSource);
      final useCase = LoginUseCaseImpl(repository);

      // Assert - verify layers can be composed together
      expect(repository, isA<LoginRepositoryImpl>());
      expect(useCase, isA<LoginUseCaseImpl>());
    });

    test('should propagate method calls through all layers', () async {
      // Arrange
      final mockDataSource = MockFirebaseAuthDataSource();
      final repository = LoginRepositoryImpl(mockDataSource);
      final useCase = LoginUseCaseImpl(repository);
      const email = 'test@example.com';

      when(
        mockDataSource.sendPasswordResetEmail(email),
      ).thenAnswer((_) async => {});

      // Act
      final result = await useCase.requestPasswordReset(email);

      // Assert
      expect(result, true);
      verify(mockDataSource.sendPasswordResetEmail(email)).called(1);
    });

    test('should handle errors across all layers', () async {
      // Arrange
      final mockDataSource = MockFirebaseAuthDataSource();
      final repository = LoginRepositoryImpl(mockDataSource);
      final useCase = LoginUseCaseImpl(repository);
      const email = 'test@example.com';

      when(
        mockDataSource.sendPasswordResetEmail(email),
      ).thenThrow(Exception('Firebase error'));

      // Act
      final result = await useCase.requestPasswordReset(email);

      // Assert
      expect(result, false);
      verify(mockDataSource.sendPasswordResetEmail(email)).called(1);
    });
  });
}
