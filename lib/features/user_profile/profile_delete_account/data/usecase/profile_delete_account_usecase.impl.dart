import 'package:t4g_for_business/features/user_profile/profile_delete_account/data/repository/profile_delete_account_repository.interface.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/data/usecase/profile_delete_account_usecase.interface.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/utils/profile_delete_account_error_handler.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/utils/profile_delete_account_exceptions.dart';
import '../models/delete_account_model.dart';

/// Implementation of use case for account deletion operations
class ProfileDeleteAccountUseCaseImpl
    implements ProfileDeleteAccountUseCaseInterface {
  ProfileDeleteAccountUseCaseImpl(this._repository);

  final ProfileDeleteAccountRepositoryInterface _repository;

  @override
  Future<void> deleteAccount(DeleteAccountModel model) async {
    const context = 'ProfileDeleteAccountUseCase';

    try {
      // Perform business logic validation
      _validateBusinessRules(model);

      // Execute the deletion through repository
      await _repository.deleteAccount(model);
    } catch (e) {
      ProfileDeleteAccountErrorHandler.logError(e, context);

      // Re-throw ProfileDeleteAccountException as-is
      if (e is ProfileDeleteAccountException) {
        rethrow;
      }

      // Convert other exceptions
      throw ServerException(
        'Use case error during account deletion',
        originalError: e,
      );
    }
  }

  /// Validates business rules for account deletion
  void _validateBusinessRules(DeleteAccountModel model) {
    // Validate confirmation text matches exactly
    if (model.confirmationText != 'Delete') {
      throw ValidationException(
        'Confirmation text must be exactly "Delete" (case-sensitive)',
        code: 'INVALID_CONFIRMATION',
      );
    }

    // Validate user ID is not empty
    if (model.userId.trim().isEmpty) {
      throw ValidationException(
        'User ID is required for account deletion',
        code: 'MISSING_USER_ID',
      );
    }

    // Validate request timestamp is recent (within last 5 minutes)
    final now = DateTime.now();
    final requestAge = now.difference(model.requestedAt);
    if (requestAge.inMinutes > 5) {
      throw ValidationException(
        'Delete request has expired. Please try again.',
        code: 'REQUEST_EXPIRED',
      );
    }
  }
}
