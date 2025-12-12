/// Entity representing the confirmation state for account deletion
///
/// This entity encapsulates the validation logic for the confirmation text
/// that users must type to confirm account deletion. It ensures that users
/// type exactly "Delete" (case-sensitive) to proceed with the deletion.
class DeleteAccountConfirmation {
  /// The confirmation text entered by the user
  final String confirmationText;

  /// Whether the confirmation text is valid
  final bool isValid;

  /// Error message if validation fails, null if valid
  final String? errorMessage;

  const DeleteAccountConfirmation({
    required this.confirmationText,
    required this.isValid,
    this.errorMessage,
  });

  /// The exact text that must be typed to confirm deletion
  static const String requiredText = 'Delete';

  /// Validates the confirmation text input
  ///
  /// Returns a [DeleteAccountConfirmation] with validation results.
  /// The text must exactly match "Delete" (case-sensitive) to be valid.
  ///
  /// Validation rules:
  /// - Empty input: Invalid with appropriate error message
  /// - Non-matching text: Invalid with specific error message
  /// - Exact match "Delete": Valid with no error message
  static DeleteAccountConfirmation validate(String input) {
    // Handle empty input
    if (input.isEmpty) {
      return const DeleteAccountConfirmation(
        confirmationText: '',
        isValid: false,
        errorMessage: 'Please type "Delete" to confirm',
      );
    }

    // Handle non-matching text (case-sensitive)
    if (input != requiredText) {
      return DeleteAccountConfirmation(
        confirmationText: input,
        isValid: false,
        errorMessage: 'Please type exactly "Delete" to confirm',
      );
    }

    // Valid confirmation
    return DeleteAccountConfirmation(
      confirmationText: input,
      isValid: true,
      errorMessage: null,
    );
  }

  /// Creates a copy of this confirmation with updated values
  DeleteAccountConfirmation copyWith({
    String? confirmationText,
    bool? isValid,
    Object? errorMessage = _undefined,
  }) {
    return DeleteAccountConfirmation(
      confirmationText: confirmationText ?? this.confirmationText,
      isValid: isValid ?? this.isValid,
      errorMessage:
          errorMessage == _undefined
              ? this.errorMessage
              : errorMessage as String?,
    );
  }

  static const Object _undefined = Object();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeleteAccountConfirmation &&
        other.confirmationText == confirmationText &&
        other.isValid == isValid &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return confirmationText.hashCode ^ isValid.hashCode ^ errorMessage.hashCode;
  }

  @override
  String toString() {
    return 'DeleteAccountConfirmation('
        'confirmationText: $confirmationText, '
        'isValid: $isValid, '
        'errorMessage: $errorMessage'
        ')';
  }
}
