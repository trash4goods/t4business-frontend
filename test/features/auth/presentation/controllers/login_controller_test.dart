import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:t4g_for_business/features/auth/domain/usecases/interface/login.dart';
import 'package:t4g_for_business/features/auth/presentation/controllers/implementation/login.controller.dart';
import 'package:t4g_for_business/features/auth/presentation/presenters/interface/login.presenter.dart';

import 'login_controller_test.mocks.dart';

@GenerateMocks([
  LoginUseCaseInterface,
  LoginPresenterInterface,
  TextEditingController,
])
void main() {
  late LoginControllerImpl controller;
  late MockLoginUseCaseInterface mockUseCase;
  late MockLoginPresenterInterface mockPresenter;
  late MockTextEditingController mockTextController;

  setUp(() {
    mockUseCase = MockLoginUseCaseInterface();
    mockPresenter = MockLoginPresenterInterface();
    mockTextController = MockTextEditingController();
    controller = LoginControllerImpl(
      useCase: mockUseCase,
      presenter: mockPresenter,
    );
  });

  group('LoginController Password Reset Tests', () {
    test(
      'should call requestPasswordReset when onResetPasswordPressed is called with valid email',
      () async {
        // Arrange
        const email = 'test@example.com';
        when(mockTextController.text).thenReturn(email);
        when(mockPresenter.resetEmailController).thenReturn(mockTextController);
        when(mockPresenter.validateEmail(email)).thenReturn(true);
        when(
          mockUseCase.requestPasswordReset(email),
        ).thenAnswer((_) async => true);

        // Act
        await controller.onResetPasswordPressed();

        // Assert
        verify(mockUseCase.requestPasswordReset(email)).called(1);
        verify(mockPresenter.resetEmail = email).called(1);
        verify(mockPresenter.isResetEmailSent = true).called(1);
      },
    );

    test('should show error when requestPasswordReset fails', () async {
      // Arrange
      const email = 'test@example.com';
      when(mockTextController.text).thenReturn(email);
      when(mockPresenter.resetEmailController).thenReturn(mockTextController);
      when(mockPresenter.validateEmail(email)).thenReturn(true);
      when(
        mockUseCase.requestPasswordReset(email),
      ).thenAnswer((_) async => false);

      // Act
      await controller.onResetPasswordPressed();

      // Assert
      verify(mockUseCase.requestPasswordReset(email)).called(1);
      // Should not set success states
      verifyNever(mockPresenter.resetEmail = email);
      verifyNever(mockPresenter.isResetEmailSent = true);
    });

    test('should show error when email is invalid', () async {
      // Arrange
      const email = 'invalid-email';
      when(mockTextController.text).thenReturn(email);
      when(mockPresenter.resetEmailController).thenReturn(mockTextController);
      when(mockPresenter.validateEmail(email)).thenReturn(false);

      // Act
      await controller.onResetPasswordPressed();

      // Assert
      verifyNever(mockUseCase.requestPasswordReset(any));
    });

    test('should show error when email is empty', () async {
      // Arrange
      const email = '';
      when(mockTextController.text).thenReturn(email);
      when(mockPresenter.resetEmailController).thenReturn(mockTextController);
      when(mockPresenter.validateEmail(email)).thenReturn(false);

      // Act
      await controller.onResetPasswordPressed();

      // Assert
      verifyNever(mockUseCase.requestPasswordReset(any));
    });

    test('should set loading states correctly during password reset', () async {
      // Arrange
      const email = 'test@example.com';
      when(mockTextController.text).thenReturn(email);
      when(mockPresenter.resetEmailController).thenReturn(mockTextController);
      when(mockPresenter.validateEmail(email)).thenReturn(true);
      when(
        mockUseCase.requestPasswordReset(email),
      ).thenAnswer((_) async => true);

      // Act
      await controller.onResetPasswordPressed();

      // Assert
      // Verify loading was set to true at start and false at end
      final verification = verify(mockPresenter.isLoading = captureAny);
      verification.called(2);
      expect(verification.captured, [true, false]);
    });
  });
}
