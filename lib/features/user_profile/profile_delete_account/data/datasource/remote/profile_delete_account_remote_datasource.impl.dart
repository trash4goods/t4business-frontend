import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/app/api_endpoints.dart';
import 'package:t4g_for_business/core/app/api_method.dart';
import 'package:t4g_for_business/core/app/constants.dart';
import 'package:t4g_for_business/core/services/http_interface.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/data/datasource/remote/profile_delete_account_remote_datasource.interface.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/data/models/delete_account_model.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/utils/profile_delete_account_error_handler.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/utils/profile_delete_account_exceptions.dart';
import 'package:t4g_for_business/features/user_profile/profile_delete_account/utils/profile_delete_account_retry_handler.dart';
import 'package:t4g_for_business/utils/helpers/local_storage.dart';

/// Implementation of remote data source for account deletion operations
class ProfileDeleteAccountRemoteDataSourceImpl
    implements ProfileDeleteAccountRemoteDataSourceInterface {
  ProfileDeleteAccountRemoteDataSourceImpl(this._iHttp);

  final IHttp _iHttp;

  @override
  Future<void> deleteAccount(DeleteAccountModel model) async {
    const context = 'ProfileDeleteAccountRemoteDataSource';

    try {
      // Execute the deletion process with retry logic
      await ProfileDeleteAccountRetryHandler.executeSequentialWithRetry([
        () => _deleteAccountFromAPI(model),
        () => _deleteFirebaseUser(),
      ], context: context);

      log('[$context] Account deletion completed successfully');
    } catch (e) {
      ProfileDeleteAccountErrorHandler.logError(e, context);

      // Convert to appropriate exception type
      if (e is ProfileDeleteAccountException) {
        rethrow;
      }

      if (e is FirebaseAuthException) {
        throw ProfileDeleteAccountErrorHandler.createExceptionFromFirebaseError(
          e,
        );
      }

      // Handle other error types
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('user not authenticated') ||
          errorString.contains('authentication token')) {
        throw AuthenticationException(
          'Authentication required for account deletion',
          originalError: e,
        );
      }

      if (errorString.contains('network') ||
          errorString.contains('connection')) {
        throw NetworkException(
          'Network error during account deletion',
          originalError: e,
        );
      }

      throw ServerException(
        'Failed to delete account: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Deletes account from API with comprehensive error handling
  Future<void> _deleteAccountFromAPI(DeleteAccountModel model) async {
    const context =
        'ProfileDeleteAccountRemoteDataSource._deleteAccountFromAPI';

    try {
      // Verify user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw AuthenticationException('User not authenticated');
      }

      // Get authentication token
      final token =
          await LocalStorageHelper.getString(AppConstants.tokenKey) ?? '';
      if (token.isEmpty) {
        throw AuthenticationException('Authentication token not found');
      }

      // Prepare request body
      final body = model.toJson();

      log('[$context] Attempting to delete account for user: ${model.userId}');

      // Make API call to delete account with circuit breaker
      final response =
          await ProfileDeleteAccountRetryHandler.executeWithCircuitBreaker(
            () => _iHttp.requestHttp(
              context: Get.context!,
              method: APIMethod.delete,
              endpoint: ApiEndpoints.deleteAccount,
              body: body,
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              isDevEnv: true,
              isAuthenticationRequired: true,
            ),
            operationId: 'delete_account_api',
            context: context,
          );

      // Handle response based on status code
      if (response.statusCode == 200 || response.statusCode == 204) {
        log('[$context] API account deletion successful');
        return;
      }

      // Handle error responses
      if (response.statusCode == -1) {
        throw NetworkException('Format exception in server response');
      }

      if (response.statusCode == -2) {
        throw NetworkException('HTTP client exception occurred');
      }

      if (response.statusCode == -3) {
        throw NetworkException('Network connection failed');
      }

      // Handle HTTP error status codes
      throw ProfileDeleteAccountErrorHandler.createExceptionFromHttpResponse(
        response.statusCode,
        response.response,
      );
    } catch (e) {
      if (e is ProfileDeleteAccountException) {
        rethrow;
      }

      ProfileDeleteAccountErrorHandler.logError(e, context);

      // Convert generic errors to specific exceptions
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('format')) {
        throw NetworkException(
          'Invalid server response format',
          originalError: e,
        );
      }

      if (errorString.contains('client') || errorString.contains('http')) {
        throw NetworkException('HTTP request failed', originalError: e);
      }

      throw NetworkException('API request failed', originalError: e);
    }
  }

  /// Deletes the user from Firebase Authentication with comprehensive error handling
  Future<void> _deleteFirebaseUser() async {
    const context = 'ProfileDeleteAccountRemoteDataSource._deleteFirebaseUser';

    try {
      log('[$context] Attempting to delete Firebase user');

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log('[$context] No Firebase user found, skipping Firebase deletion');
        return; // User might already be logged out
      }

      // Delete the user from Firebase Auth with retry logic
      await ProfileDeleteAccountRetryHandler.executeWithRetry(
        () => user.delete(),
        context: context,
        shouldRetry: (error) {
          if (error is FirebaseAuthException) {
            // Only retry for network-related Firebase errors
            return error.code == 'network-request-failed' ||
                error.code == 'too-many-requests';
          }
          return false;
        },
      );

      log('[$context] Firebase user deleted successfully');
    } catch (e) {
      ProfileDeleteAccountErrorHandler.logError(e, context);

      // Handle specific Firebase errors
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'requires-recent-login':
            throw AuthenticationException(
              'Recent authentication required. Please log in again and try deleting your account.',
              code: e.code,
              originalError: e,
            );
          case 'user-not-found':
            log(
              '[$context] Firebase user not found, considering deletion successful',
            );
            return; // User already deleted or doesn't exist
          case 'network-request-failed':
            throw NetworkException(
              'Network error during Firebase deletion. Please check your connection and try again.',
              code: e.code,
              originalError: e,
            );
          case 'too-many-requests':
            throw ServerException(
              'Too many requests to Firebase. Please wait a moment and try again.',
              code: e.code,
              originalError: e,
            );
          case 'user-disabled':
            throw AuthenticationException(
              'User account is disabled and cannot be deleted.',
              code: e.code,
              originalError: e,
            );
          case 'invalid-user-token':
          case 'user-token-expired':
            throw AuthenticationException(
              'Authentication session expired. Please log in again and try deleting your account.',
              code: e.code,
              originalError: e,
            );
          default:
            throw ProfileFirebaseException(
              e.message ?? 'Firebase Auth deletion failed',
              code: e.code,
              originalError: e,
            );
        }
      }

      // Handle non-Firebase errors
      throw ProfileFirebaseException(
        'Firebase Auth deletion failed: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
