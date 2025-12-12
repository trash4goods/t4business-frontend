import '../models/delete_account_model.dart';

/// Interface for repository operations related to account deletion
abstract class ProfileDeleteAccountRepositoryInterface {
  /// Deletes the user account
  ///
  /// Coordinates with remote data source to perform account deletion.
  /// Throws [Exception] if the deletion fails.
  Future<void> deleteAccount(DeleteAccountModel model);
}
