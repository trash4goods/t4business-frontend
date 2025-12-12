/// Data model for account deletion requests
class DeleteAccountModel {
  final String userId;
  final String confirmationText;
  final DateTime requestedAt;

  const DeleteAccountModel({
    required this.userId,
    required this.confirmationText,
    required this.requestedAt,
  });

  /// Creates a model from JSON data
  factory DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    return DeleteAccountModel(
      userId: json['user_id'] as String,
      confirmationText: json['confirmation_text'] as String,
      requestedAt: DateTime.parse(json['requested_at'] as String),
    );
  }

  /// Converts the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'confirmation_text': confirmationText,
      'requested_at': requestedAt.toIso8601String(),
    };
  }

  /// Creates a copy with updated fields
  DeleteAccountModel copyWith({
    String? userId,
    String? confirmationText,
    DateTime? requestedAt,
  }) {
    return DeleteAccountModel(
      userId: userId ?? this.userId,
      confirmationText: confirmationText ?? this.confirmationText,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeleteAccountModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          confirmationText == other.confirmationText &&
          requestedAt == other.requestedAt;

  @override
  int get hashCode =>
      userId.hashCode ^ confirmationText.hashCode ^ requestedAt.hashCode;

  @override
  String toString() =>
      'DeleteAccountModel(userId: [HIDDEN], confirmationText: [HIDDEN], requestedAt: $requestedAt)';
}
