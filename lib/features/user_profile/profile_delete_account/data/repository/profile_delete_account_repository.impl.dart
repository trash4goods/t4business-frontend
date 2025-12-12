import 'package:t4g_for_business/features/user_profile/profile_delete_account/data/datasource/remote/profile_delete_account_remote_datasource.interface.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/utils/profile_delete_account_error_handler.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/utils/profile_delete_account_exceptions.dart';
import '../models/delete_account_model.dart';
import 'profile_delete_account_repository.interface.dart';

/// Implementation of repository for account deletion operations
class ProfileDeleteAccountRepositoryImpl
    implements ProfileDeleteAccountRepositoryInterface {
  ProfileDeleteAccountRepositoryImpl(this._remoteDataSource);

  final ProfileDeleteAccountRemoteDataSourceInterface _remoteDataSource;

  @override
  Future<void> deleteAccount(DeleteAccountModel model) async {
    const context = 'ProfileDeleteAccountRepository';

    try {
      // Validate model before proceeding
      _validateDeleteAccountModel(model);

      // Delegate to remote data source
      await _remoteDataSource.deleteAccount(model);
    } catch (e) {
      ProfileDeleteAccountErrorHandler.logError(e, context);

      // Re-throw ProfileDeleteAccountException as-is
      if (e is ProfileDeleteAccountException) {
        rethrow;
      }

      // Convert other exceptions to appropriate types
      throw ServerException(
        'Repository error during account deletion',
        originalError: e,
      );
    }
  }

  /// Validates the delete account model
  void _validateDeleteAccountModel(DeleteAccountModel model) {
    if (model.userId.isEmpty) {
      throw ValidationException('User ID cannot be empty');
    }

    if (model.confirmationText.isEmpty) {
      throw ValidationException('Confirmation text cannot be empty');
    }

    if (model.confirmationText != 'Delete') {
      throw ValidationException('Confirmation text must be exactly "Delete"');
    }
  }
}
