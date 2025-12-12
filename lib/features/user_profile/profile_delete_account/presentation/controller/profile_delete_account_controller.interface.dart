/// Interface for controller operations related to account deletion
abstract class ProfileDeleteAccountControllerInterface {
  /// Shows the delete account confirmation dialog
  ///
  /// Displays the dialog with proper state initialization
  /// and sets up real-time validation for confirmation text.
  Future<void> showDeleteDialog();

  /// Confirms the account deletion process
  ///
  /// Validates the confirmation text, calls the use case to delete
  /// the account, handles success/error states, and navigates to
  /// login screen upon successful deletion.
  Future<void> confirmDelete();

  /// Cancels the delete account process
  ///
  /// Closes the dialog and resets all state without performing
  /// any deletion operations.
  void cancelDelete();

  /// Handles confirmation text input changes
  ///
  /// Updates the presenter state and triggers real-time validation
  /// to provide immediate feedback to the user.
  ///
  /// [text] The current text in the confirmation input field
  void onConfirmationTextChanged(String text);

  /// Validates the confirmation text input
  ///
  /// Performs validation using the domain entity and updates
  /// the presenter state with validation results.
  void validateConfirmation();
}
