import '../../models/delete_account_model.dart';

/// Interface for remote data source operations related to account deletion
abstract class ProfileDeleteAccountRemoteDataSourceInterface {
  /// Deletes the user account via API call
  ///
  /// Throws [Exception] if the deletion fails or user is not authenticated
  Future<void> deleteAccount(DeleteAccountModel model);
}
