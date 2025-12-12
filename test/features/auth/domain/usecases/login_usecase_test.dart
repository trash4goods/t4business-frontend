import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:t4g_for_business/features/auth/data/repositories/interface/login.dart';
import 'package:t4g_for_business/features/auth/domain/usecases/implementation/login.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([LoginRepositoryInterface])
void main() {
  late LoginUseCaseImpl useCase;
  late MockLoginRepositoryInterface mockRepository;

  setUp(() {
    mockRepository = MockLoginRepositoryInterface();
    useCase = LoginUseCaseImpl(mockRepository);
  });

  group('LoginUseCase Password Reset Tests', () {
    test(
      'should return true when repository successfully sends password reset email',
      () async {
        // Arrange
        const email = 'test@example.com';
        when(mockRepository.resetPassword(email)).thenAnswer((_) async => {});

        // Act
        final result = await useCase.requestPasswordReset(email);

        // Assert
        expect(result, true);
        verify(mockRepository.resetPassword(email)).called(1);
      },
    );

    test('should return false when repository throws an exception', () async {
      // Arrange
      const email = 'test@example.com';
      when(
        mockRepository.resetPassword(email),
      ).thenThrow(Exception('Firebase error'));

      // Act
      final result = await useCase.requestPasswordReset(email);

      // Assert
      expect(result, false);
      verify(mockRepository.resetPassword(email)).called(1);
    });

    test('should return false when repository throws any error', () async {
      // Arrange
      const email = 'test@example.com';
      when(mockRepository.resetPassword(email)).thenThrow('Network error');

      // Act
      final result = await useCase.requestPasswordReset(email);

      // Assert
      expect(result, false);
      verify(mockRepository.resetPassword(email)).called(1);
    });
  });
}
