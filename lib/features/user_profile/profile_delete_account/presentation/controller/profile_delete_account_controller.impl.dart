import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../../core/app/app_routes.dart';
import '../../../../../core/services/browser_history_service.dart';
import '../../../../../core/services/navigation.dart';
import '../../../../../core/services/snackbar.dart';
import '../../data/models/delete_account_model.dart';
import '../../data/usecase/profile_delete_account_usecase.interface.dart';
import '../../utils/profile_delete_account_cleanup_service.dart';
import '../../utils/profile_delete_account_error_handler.dart';
import '../../utils/profile_delete_account_exceptions.dart';
import '../presenter/profile_delete_account_presenter.interface.dart';
import '../widgets/delete_account_dialog.dart';
import 'profile_delete_account_controller.interface.dart';

/// Implementation of controller for account deletion operations
class ProfileDeleteAccountControllerImpl
    implements ProfileDeleteAccountControllerInterface {
  final ProfileDeleteAccountPresenterInterface presenter;
  final ProfileDeleteAccountUseCaseInterface useCase;

  ProfileDeleteAccountControllerImpl({
    required this.presenter,
    required this.useCase,
  });

  @override
  Future<void> showDeleteDialog() async {
    try {
      log('ProfileDeleteAccountController: Showing delete dialog');

      // Reset state before showing dialog
      presenter.resetState();

      // Set up listener for confirmation text changes
      presenter.confirmationController.addListener(() {
        onConfirmationTextChanged(presenter.confirmationController.text);
      });

      // Show the dialog using GetX dialog system
      await Get.dialog(
        Obx(
          () => DeleteAccountDialog(
            isLoading: presenter.isLoading,
            confirmationError: presenter.confirmationError,
            isConfirmationValid: presenter.isConfirmationValid,
            confirmationController: presenter.confirmationController,
            onConfirmationTextChanged: onConfirmationTextChanged,
            onConfirmDelete: confirmDelete,
            onCancelDelete: cancelDelete,
          ),
        ),
        barrierDismissible: false, // Prevent dismissing by tapping outside
      );

      log('ProfileDeleteAccountController: Delete dialog shown successfully');
    } catch (e) {
      log('ProfileDeleteAccountController: Error showing dialog: $e');
      presenter.error = 'Failed to show delete dialog. Please try again.';
      SnackbarService.showError(
        'Failed to show delete dialog. Please try again.',
        title: 'Error',
      );
    }
  }

  @override
  Future<void> confirmDelete() async {
    const context = 'ProfileDeleteAccountController.confirmDelete';

    try {
      log('[$context] Starting account deletion process');

      // Validate confirmation text before proceeding
      validateConfirmation();

      if (!presenter.isConfirmationValid) {
        log('[$context] Invalid confirmation text');
        _showValidationError(
          'Please type exactly "Delete" to confirm account deletion.',
        );
        return;
      }

      // Set loading state
      presenter.isLoading = true;
      presenter.error = '';

      // Get current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw AuthenticationException('No authenticated user found');
      }

      // Create delete account model
      final deleteModel = DeleteAccountModel(
        userId: currentUser.uid,
        confirmationText: presenter.confirmationText,
        requestedAt: DateTime.now(),
      );

      // Call use case to delete account
      await useCase.deleteAccount(deleteModel);

      log('[$context] Account deletion completed successfully');

      // Handle successful deletion
      await _handleSuccessfulDeletion();
    } catch (e) {
      ProfileDeleteAccountErrorHandler.logError(e, context);
      await _handleDeletionError(e);
    }
  }

  /// Handles successful account deletion with comprehensive cleanup
  Future<void> _handleSuccessfulDeletion() async {
    const context = 'ProfileDeleteAccountController._handleSuccessfulDeletion';

    try {
      log('[$context] Starting post-deletion cleanup and navigation');

      // Close dialog first
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Show success message with longer duration to give user time to read
      SnackbarService.showSuccess(
        'Your account has been deleted successfully. You will be redirected to the login screen.',
        title: 'Account Deleted',
      );

      // Reset presenter state
      presenter.resetState();

      // Wait a moment for the success message to be visible
      await Future.delayed(const Duration(milliseconds: 1500));

      // Perform comprehensive cleanup of all user data and session
      log('[$context] Starting comprehensive cleanup');
      await ProfileDeleteAccountCleanupService.performCompleteCleanup();

      // Clear browser history protection (handled separately due to web-only dependency)
      try {
        final browserHistoryService = BrowserHistoryService.to;
        browserHistoryService.resetProtection();
        log('[$context] Browser history protection cleared');
      } catch (e) {
        log('[$context] Error clearing browser history protection: $e');
        // Continue with cleanup
      }

      // Verify cleanup was successful
      final cleanupSuccess =
          await ProfileDeleteAccountCleanupService.verifyCleanupSuccess();
      if (!cleanupSuccess) {
        log(
          '[$context] Warning: Cleanup verification failed, but proceeding with navigation',
        );
      }

      // Show additional feedback about cleanup completion
      SnackbarService.showInfo(
        'All your data has been cleared from this device.',
        title: 'Cleanup Complete',
      );

      // Wait a moment for cleanup feedback
      await Future.delayed(const Duration(milliseconds: 1000));

      // Navigate to login screen and clear all previous routes
      log('[$context] Navigating to login screen');
      await NavigationService.offAll(AppRoutes.login);

      log('[$context] Post-deletion process completed successfully');
    } catch (e) {
      log('[$context] Error during post-deletion process: $e');

      // Even if cleanup or navigation fails, ensure we try to get to a clean state
      try {
        // Ensure dialog is closed
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        // Reset presenter state
        presenter.resetState();

        // Try basic cleanup
        await ProfileDeleteAccountCleanupService.performCompleteCleanup();

        // Force navigation to login
        await NavigationService.offAll(AppRoutes.login);

        // Show error message about cleanup issues
        SnackbarService.showWarning(
          'Account deleted but some cleanup steps failed. Please clear your browser data manually.',
          title: 'Partial Cleanup',
        );
      } catch (fallbackError) {
        log('[$context] Fallback cleanup also failed: $fallbackError');

        // Last resort: show error and try to navigate
        SnackbarService.showError(
          'Account deleted but cleanup failed. Please clear your browser data and refresh the page.',
          title: 'Cleanup Error',
        );

        // Try to navigate anyway
        try {
          await NavigationService.offAll(AppRoutes.login);
        } catch (navError) {
          log('[$context] Even navigation failed: $navError');
        }
      }
    }
  }

  /// Handles deletion errors with appropriate user feedback
  Future<void> _handleDeletionError(dynamic error) async {
    // Set error state
    presenter.isLoading = false;

    // Get user-friendly error message
    final errorMessage =
        ProfileDeleteAccountErrorHandler.getUserFriendlyMessage(error);
    presenter.error = errorMessage;

    // Determine if error is retryable
    final isRetryable = ProfileDeleteAccountErrorHandler.isRetryable(error);

    // Handle specific error types
    if (error is AuthenticationException) {
      await _handleAuthenticationError(error, errorMessage);
    } else if (error is RollbackException) {
      await _handleRollbackError(error, errorMessage);
    } else if (isRetryable) {
      await _handleRetryableError(errorMessage);
    } else {
      await _handleNonRetryableError(errorMessage);
    }
  }

  /// Handles authentication-related errors
  Future<void> _handleAuthenticationError(
    AuthenticationException error,
    String message,
  ) async {
    SnackbarService.showError(
      message,
      title: 'Authentication Required',
      actionLabel: 'Login',
      onActionPressed: () {
        SnackbarService.dismiss();
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        NavigationService.offAll(AppRoutes.login);
      },
    );
  }

  /// Handles rollback errors (when API succeeds but Firebase fails)
  Future<void> _handleRollbackError(
    RollbackException error,
    String message,
  ) async {
    SnackbarService.showError(
      'Account deletion partially failed. Please contact support for assistance.',
      title: 'Rollback Required',
      actionLabel: 'Contact Support',
      onActionPressed: () {
        SnackbarService.dismiss();
        // Could open support contact or email
      },
    );
  }

  /// Handles retryable errors
  Future<void> _handleRetryableError(String message) async {
    SnackbarService.showError(
      message,
      title: 'Deletion Failed',
      actionLabel: 'Retry',
      onActionPressed: () {
        SnackbarService.dismiss();
        confirmDelete();
      },
    );
  }

  /// Handles non-retryable errors
  Future<void> _handleNonRetryableError(String message) async {
    SnackbarService.showError(
      message,
      title: 'Deletion Failed',
      actionLabel: 'Close',
      onActionPressed: () {
        SnackbarService.dismiss();
      },
    );
  }

  /// Shows validation error message
  void _showValidationError(String message) {
    SnackbarService.showError(message, title: 'Invalid Confirmation');
  }

  @override
  void cancelDelete() {
    try {
      log('ProfileDeleteAccountController: Cancelling account deletion');

      // Close dialog using GetX
      Get.back();

      // Reset all state
      presenter.resetState();

      log(
        'ProfileDeleteAccountController: Account deletion cancelled successfully',
      );
    } catch (e) {
      log('ProfileDeleteAccountController: Error cancelling deletion: $e');
      // Even if there's an error, ensure dialog is closed
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      presenter.resetState();
    }
  }

  @override
  void onConfirmationTextChanged(String text) {
    const context = 'ProfileDeleteAccountController.onConfirmationTextChanged';

    try {
      // Update presenter state
      presenter.confirmationText = text;

      // Clear any previous errors when user starts typing
      if (presenter.error.isNotEmpty) {
        presenter.error = '';
      }

      // Trigger validation (this is handled automatically in the presenter
      // when confirmationText is set, but we call it explicitly for clarity)
      validateConfirmation();
    } catch (e) {
      ProfileDeleteAccountErrorHandler.logError(e, context);
      presenter.confirmationError =
          'Validation error occurred. Please try again.';
    }
  }

  @override
  void validateConfirmation() {
    const context = 'ProfileDeleteAccountController.validateConfirmation';

    try {
      // Delegate validation to presenter
      presenter.validateConfirmation();
    } catch (e) {
      ProfileDeleteAccountErrorHandler.logError(e, context);
      presenter.confirmationError =
          'Validation error occurred. Please try again.';
      presenter.isConfirmationValid = false;
    }
  }
}
