import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'profile_delete_account_exceptions.dart';

/// Comprehensive error handler for profile delete account operations
/// Provides error mapping, user-friendly messages, and retry logic
class ProfileDeleteAccountErrorHandler {
  /// Maps various error types to user-friendly messages
  static String getUserFriendlyMessage(dynamic error) {
    if (error is ProfileDeleteAccountException) {
      return _handleCustomException(error);
    }

    if (error is FirebaseAuthException) {
      return _handleFirebaseAuthException(error);
    }

    if (error is SocketException) {
      return _handleNetworkException(error);
    }

    if (error is http.ClientException) {
      return _handleHttpException(error);
    }

    if (error is FormatException) {
      return _handleFormatException(error);
    }

    // Generic error handling
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return 'Network connection error. Please check your internet connection and try again.';
    }

    if (errorString.contains('unauthorized') ||
        errorString.contains('authentication') ||
        errorString.contains('token')) {
      return 'Authentication error. Please log in again and try deleting your account.';
    }

    if (errorString.contains('server') ||
        errorString.contains('500') ||
        errorString.contains('internal')) {
      return 'Server error occurred. Please try again in a few minutes.';
    }

    if (errorString.contains('validation') || errorString.contains('invalid')) {
      return 'Invalid input provided. Please check your information and try again.';
    }

    return 'An unexpected error occurred. Please try again or contact support if the problem persists.';
  }

  /// Handles custom ProfileDeleteAccountException types
  static String _handleCustomException(ProfileDeleteAccountException error) {
    switch (error.runtimeType) {
      case NetworkException:
        return 'Network error: ${error.message}';
      case AuthenticationException:
        return 'Authentication error: ${error.message}';
      case ServerException:
        return 'Server error: ${error.message}';
      case ProfileFirebaseException:
        return 'Firebase error: ${error.message}';
      case ValidationException:
        return 'Validation error: ${error.message}';
      case RollbackException:
        final rollbackError = error as RollbackException;
        return 'Operation failed and was rolled back: ${rollbackError.message}';
      default:
        return error.message;
    }
  }

  /// Handles Firebase Authentication exceptions
  static String _handleFirebaseAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'requires-recent-login':
        return 'For security reasons, please log in again before deleting your account.';
      case 'user-not-found':
        return 'User account not found. The account may have already been deleted.';
      case 'network-request-failed':
        return 'Network error occurred. Please check your connection and try again.';
      case 'too-many-requests':
        return 'Too many requests. Please wait a moment before trying again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support for assistance.';
      case 'invalid-user-token':
      case 'user-token-expired':
        return 'Your session has expired. Please log in again and try deleting your account.';
      default:
        return 'Authentication error: ${error.message ?? error.code}';
    }
  }

  /// Handles network-related exceptions
  static String _handleNetworkException(SocketException error) {
    if (error.message.contains('Failed host lookup')) {
      return 'Unable to connect to the server. Please check your internet connection.';
    }
    if (error.message.contains('Connection timed out')) {
      return 'Connection timed out. Please try again.';
    }
    if (error.message.contains('Connection refused')) {
      return 'Unable to connect to the server. Please try again later.';
    }
    return 'Network connection error. Please check your internet connection and try again.';
  }

  /// Handles HTTP client exceptions
  static String _handleHttpException(http.ClientException error) {
    if (error.message.contains('Connection closed')) {
      return 'Connection was interrupted. Please try again.';
    }
    if (error.message.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    return 'Network request failed. Please check your connection and try again.';
  }

  /// Handles format exceptions
  static String _handleFormatException(FormatException error) {
    return 'Invalid server response format. Please try again or contact support.';
  }

  /// Determines if an error is retryable
  static bool isRetryable(dynamic error) {
    if (error is ProfileDeleteAccountException) {
      return error is NetworkException || error is ServerException;
    }

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'network-request-failed':
        case 'too-many-requests':
          return true;
        case 'requires-recent-login':
        case 'user-not-found':
        case 'user-disabled':
        case 'invalid-user-token':
        case 'user-token-expired':
          return false;
        default:
          return false;
      }
    }

    if (error is SocketException || error is http.ClientException) {
      return true;
    }

    final errorString = error.toString().toLowerCase();
    return errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('server') ||
        errorString.contains('500');
  }

  /// Gets retry delay based on error type
  static Duration getRetryDelay(dynamic error, int attemptNumber) {
    // Exponential backoff with jitter
    final baseDelay = Duration(seconds: 2 * attemptNumber);

    if (error is FirebaseAuthException && error.code == 'too-many-requests') {
      return Duration(seconds: 30 + (attemptNumber * 10));
    }

    if (error is ProfileDeleteAccountException && error is ServerException) {
      return Duration(seconds: 5 + (attemptNumber * 5));
    }

    return baseDelay;
  }

  /// Logs error with appropriate level and context
  static void logError(
    dynamic error,
    String context, {
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  }) {
    final errorType = error.runtimeType.toString();
    final errorMessage = error.toString();

    log(
      '[$context] Error occurred: $errorType - $errorMessage',
      error: error,
      stackTrace: stackTrace,
    );

    if (additionalData != null) {
      log('[$context] Additional data: $additionalData');
    }

    // Log specific error details for debugging
    if (error is ProfileDeleteAccountException) {
      log('[$context] Custom error code: ${error.code}');
      log('[$context] Original error: ${error.originalError}');
    }

    if (error is FirebaseAuthException) {
      log('[$context] Firebase error code: ${error.code}');
      log('[$context] Firebase error message: ${error.message}');
    }
  }

  /// Creates appropriate exception from HTTP response
  static ProfileDeleteAccountException createExceptionFromHttpResponse(
    int statusCode,
    Map<String, dynamic>? response,
  ) {
    final message =
        response?['message'] ?? response?['error'] ?? 'Unknown server error';

    switch (statusCode) {
      case 400:
        return ValidationException(
          'Invalid request: $message',
          code: 'INVALID_REQUEST',
          originalError: response,
        );
      case 401:
        return AuthenticationException(
          'Authentication failed: $message',
          code: 'UNAUTHORIZED',
          originalError: response,
        );
      case 403:
        return AuthenticationException(
          'Access forbidden: $message',
          code: 'FORBIDDEN',
          originalError: response,
        );
      case 404:
        return ServerException(
          'Resource not found: $message',
          code: 'NOT_FOUND',
          originalError: response,
        );
      case 429:
        return ServerException(
          'Too many requests: $message',
          code: 'RATE_LIMITED',
          originalError: response,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          'Server error: $message',
          code: 'SERVER_ERROR',
          originalError: response,
        );
      default:
        return ServerException(
          'HTTP error ($statusCode): $message',
          code: 'HTTP_ERROR',
          originalError: response,
        );
    }
  }

  /// Creates appropriate exception from Firebase error
  static ProfileDeleteAccountException createExceptionFromFirebaseError(
    FirebaseAuthException error,
  ) {
    switch (error.code) {
      case 'requires-recent-login':
        return AuthenticationException(
          'Recent authentication required for account deletion',
          code: error.code,
          originalError: error,
        );
      case 'user-not-found':
        return AuthenticationException(
          'User account not found',
          code: error.code,
          originalError: error,
        );
      case 'network-request-failed':
        return NetworkException(
          'Network error during Firebase operation',
          code: error.code,
          originalError: error,
        );
      case 'too-many-requests':
        return ServerException(
          'Too many requests to Firebase',
          code: error.code,
          originalError: error,
        );
      default:
        return ProfileFirebaseException(
          error.message ?? 'Firebase operation failed',
          code: error.code,
          originalError: error,
        );
    }
  }
}
