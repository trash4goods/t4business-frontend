import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:t4g_for_business/features/auth/data/datasources/firebase_auth.dart';
import 'package:t4g_for_business/features/auth/data/repositories/implementation/login.dart';

import 'login_repository_test.mocks.dart';

@GenerateMocks([FirebaseAuthDataSource])
void main() {
  late LoginRepositoryImpl repository;
  late MockFirebaseAuthDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockFirebaseAuthDataSource();
    repository = LoginRepositoryImpl(mockDataSource);
  });

  group('LoginRepository Password Reset Tests', () {
    test(
      'should call sendPasswordResetEmail when resetPassword is called',
      () async {
        // Arrange
        const email = 'test@example.com';
        when(
          mockDataSource.sendPasswordResetEmail(email),
        ).thenAnswer((_) async => {});

        // Act
        await repository.resetPassword(email);

        // Assert
        verify(mockDataSource.sendPasswordResetEmail(email)).called(1);
      },
    );

    test('should propagate exception when Firebase throws error', () async {
      // Arrange
      const email = 'test@example.com';
      final exception = Exception('Firebase Auth error');
      when(mockDataSource.sendPasswordResetEmail(email)).thenThrow(exception);

      // Act & Assert
      expect(() => repository.resetPassword(email), throwsA(exception));
      verify(mockDataSource.sendPasswordResetEmail(email)).called(1);
    });
  });
}
