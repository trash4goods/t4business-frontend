/// Custom exceptions for profile delete account feature
/// Provides specific error types for better error handling and user feedback

/// Base exception class for profile delete account operations
abstract class ProfileDeleteAccountException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const ProfileDeleteAccountException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'ProfileDeleteAccountException: $message';
}

/// Exception thrown when network-related errors occur
class NetworkException extends ProfileDeleteAccountException {
  const NetworkException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when authentication-related errors occur
class AuthenticationException extends ProfileDeleteAccountException {
  const AuthenticationException(
    super.message, {
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Exception thrown when server-related errors occur
class ServerException extends ProfileDeleteAccountException {
  const ServerException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when Firebase-related errors occur
class ProfileFirebaseException extends ProfileDeleteAccountException {
  const ProfileFirebaseException(
    super.message, {
    super.code,
    super.originalError,
  });

  @override
  String toString() => 'ProfileFirebaseException: $message';
}

/// Exception thrown when validation-related errors occur
class ValidationException extends ProfileDeleteAccountException {
  const ValidationException(super.message, {super.code, super.originalError});

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when rollback operations are needed
class RollbackException extends ProfileDeleteAccountException {
  final String rollbackReason;

  const RollbackException(
    super.message,
    this.rollbackReason, {
    super.code,
    super.originalError,
  });

  @override
  String toString() =>
      'RollbackException: $message (Rollback: $rollbackReason)';
}
