import 'dart:async';
import 'dart:developer';

import 'profile_delete_account_error_handler.dart';
import 'profile_delete_account_exceptions.dart';

/// Retry handler for profile delete account operations
/// Provides configurable retry logic with exponential backoff
class ProfileDeleteAccountRetryHandler {
  static const int defaultMaxRetries = 3;
  static const Duration defaultInitialDelay = Duration(seconds: 1);

  /// Executes a function with retry logic
  ///
  /// [operation] - The async function to execute
  /// [maxRetries] - Maximum number of retry attempts (default: 3)
  /// [initialDelay] - Initial delay between retries (default: 1 second)
  /// [context] - Context string for logging
  /// [shouldRetry] - Optional custom retry condition function
  static Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = defaultMaxRetries,
    Duration initialDelay = defaultInitialDelay,
    String context = 'ProfileDeleteAccount',
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attemptNumber = 0;
    dynamic lastError;

    while (attemptNumber <= maxRetries) {
      try {
        log('[$context] Attempt ${attemptNumber + 1}/${maxRetries + 1}');
        return await operation();
      } catch (error) {
        lastError = error;
        attemptNumber++;

        ProfileDeleteAccountErrorHandler.logError(
          error,
          '$context - Attempt $attemptNumber',
        );

        // Check if we should retry
        final customShouldRetry =
            shouldRetry?.call(error) ??
            ProfileDeleteAccountErrorHandler.isRetryable(error);

        if (attemptNumber > maxRetries || !customShouldRetry) {
          log(
            '[$context] Max retries reached or error not retryable. Throwing error.',
          );
          rethrow;
        }

        // Calculate delay for next attempt
        final delay = ProfileDeleteAccountErrorHandler.getRetryDelay(
          error,
          attemptNumber,
        );

        log('[$context] Retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
      }
    }

    // This should never be reached, but just in case
    throw lastError ?? Exception('Unknown error during retry operation');
  }

  /// Executes multiple operations in sequence with individual retry logic
  /// Useful for operations that need to be performed in order (e.g., API call then Firebase)
  static Future<void> executeSequentialWithRetry(
    List<Future<void> Function()> operations, {
    int maxRetries = defaultMaxRetries,
    String context = 'ProfileDeleteAccount',
    bool Function(dynamic error)? shouldRetry,
  }) async {
    for (int i = 0; i < operations.length; i++) {
      try {
        await executeWithRetry(
          operations[i],
          maxRetries: maxRetries,
          context: '$context - Operation ${i + 1}',
          shouldRetry: shouldRetry,
        );
      } catch (error) {
        // If any operation fails, we need to handle rollback
        log('[$context] Operation ${i + 1} failed. Considering rollback...');

        // If this is not the first operation, we might need rollback
        if (i > 0) {
          throw RollbackException(
            'Operation ${i + 1} failed after operation ${i} succeeded',
            'Previous operations may need to be reversed',
            originalError: error,
          );
        }

        rethrow;
      }
    }
  }

  /// Executes an operation with circuit breaker pattern
  /// Prevents repeated attempts when service is known to be down
  static Future<T> executeWithCircuitBreaker<T>(
    Future<T> Function() operation, {
    required String operationId,
    int failureThreshold = 5,
    Duration recoveryTimeout = const Duration(minutes: 5),
    String context = 'ProfileDeleteAccount',
  }) async {
    final circuitState = _CircuitBreakerState.getInstance(operationId);

    // Check if circuit is open
    if (circuitState.isOpen) {
      if (DateTime.now().difference(circuitState.lastFailureTime!) <
          recoveryTimeout) {
        throw ServerException(
          'Service temporarily unavailable. Please try again later.',
          code: 'CIRCUIT_BREAKER_OPEN',
        );
      } else {
        // Try to close the circuit (half-open state)
        circuitState.halfOpen();
      }
    }

    try {
      final result = await operation();
      circuitState.recordSuccess();
      return result;
    } catch (error) {
      circuitState.recordFailure();

      if (circuitState.failureCount >= failureThreshold) {
        circuitState.open();
        log('[$context] Circuit breaker opened for $operationId');
      }

      rethrow;
    }
  }
}

/// Internal circuit breaker state management
class _CircuitBreakerState {
  static final Map<String, _CircuitBreakerState> _instances = {};

  int failureCount = 0;
  DateTime? lastFailureTime;
  bool isOpen = false;
  bool isHalfOpen = false;

  static _CircuitBreakerState getInstance(String operationId) {
    return _instances.putIfAbsent(operationId, () => _CircuitBreakerState());
  }

  void recordSuccess() {
    failureCount = 0;
    lastFailureTime = null;
    isOpen = false;
    isHalfOpen = false;
  }

  void recordFailure() {
    failureCount++;
    lastFailureTime = DateTime.now();
    isHalfOpen = false;
  }

  void open() {
    isOpen = true;
    isHalfOpen = false;
  }

  void halfOpen() {
    isOpen = false;
    isHalfOpen = true;
  }
}
