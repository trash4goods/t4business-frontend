import '../models/delete_account_model.dart';

/// Interface for use case operations related to account deletion
abstract class ProfileDeleteAccountUseCaseInterface {
  /// Deletes the user account with business logic validation
  ///
  /// Performs business validation, coordinates repository calls,
  /// and handles Firebase Auth deletion after successful API call.
  /// Implements proper error handling and rollback logic.
  ///
  /// Throws [Exception] if validation fails or deletion process fails.
  Future<void> deleteAccount(DeleteAccountModel model);
}
