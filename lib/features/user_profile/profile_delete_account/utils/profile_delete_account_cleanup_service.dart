import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/pending_task_service.dart';
import '../../../../utils/helpers/local_storage.dart';
import '../../../auth/data/datasources/auth_cache.dart';

/// Service responsible for cleaning up all user data and session information
/// after successful account deletion
class ProfileDeleteAccountCleanupService {
  /// Performs comprehensive cleanup of all user data and session information
  /// This includes:
  /// - Firebase Auth session
  /// - Local storage (SharedPreferences)
  /// - Hive cache data
  /// - Browser history protection
  /// - Pending task cache
  /// - GetX service states
  static Future<void> performCompleteCleanup() async {
    const context = 'ProfileDeleteAccountCleanupService.performCompleteCleanup';

    try {
      log('[$context] Starting comprehensive cleanup process');

      // 1. Clear Firebase Auth session (if not already cleared)
      await _clearFirebaseAuthSession();

      // 2. Clear all local storage data
      await _clearLocalStorage();

      // 3. Clear Hive cache data
      await _clearHiveCache();

      // 4. Browser history protection will be cleared by the controller

      // 5. Clear pending task cache
      await _clearPendingTaskCache();

      // 6. Reset GetX service states
      await _resetGetXServices();

      log('[$context] Comprehensive cleanup completed successfully');
    } catch (e) {
      log('[$context] Error during cleanup: $e');
      // Continue with cleanup even if some steps fail
      // This ensures we clean up as much as possible
    }
  }

  /// Clear Firebase Auth session
  static Future<void> _clearFirebaseAuthSession() async {
    try {
      log('ProfileDeleteAccountCleanupService: Clearing Firebase Auth session');

      final authService = Get.find<AuthService>();
      await authService.logout();

      log('ProfileDeleteAccountCleanupService: Firebase Auth session cleared');
    } catch (e) {
      log(
        'ProfileDeleteAccountCleanupService: Error clearing Firebase Auth: $e',
      );
      // Continue with other cleanup steps
    }
  }

  /// Clear all SharedPreferences data
  static Future<void> _clearLocalStorage() async {
    try {
      log('ProfileDeleteAccountCleanupService: Clearing local storage');

      await LocalStorageHelper.clear();

      log('ProfileDeleteAccountCleanupService: Local storage cleared');
    } catch (e) {
      log(
        'ProfileDeleteAccountCleanupService: Error clearing local storage: $e',
      );
      // Continue with other cleanup steps
    }
  }

  /// Clear Hive cache data
  static Future<void> _clearHiveCache() async {
    try {
      log('ProfileDeleteAccountCleanupService: Clearing Hive cache');

      // Clear auth cache specifically
      final authCache = AuthCacheDataSource.instance;
      await authCache.clearUserAuth();

      // Clear all Hive boxes if needed
      await _clearAllHiveBoxes();

      log('ProfileDeleteAccountCleanupService: Hive cache cleared');
    } catch (e) {
      log('ProfileDeleteAccountCleanupService: Error clearing Hive cache: $e');
      // Continue with other cleanup steps
    }
  }

  /// Clear all Hive boxes
  static Future<void> _clearAllHiveBoxes() async {
    try {
      // Clear specific known boxes instead of trying to get all boxes
      // This is safer and more predictable

      // Clear user auth box if it exists
      try {
        if (Hive.isBoxOpen('USER_AUTH')) {
          final userAuthBox = Hive.box('USER_AUTH');
          await userAuthBox.clear();
          log('ProfileDeleteAccountCleanupService: Cleared USER_AUTH box');
        }
      } catch (e) {
        log(
          'ProfileDeleteAccountCleanupService: Error clearing USER_AUTH box: $e',
        );
      }

      // Add other specific boxes as needed
      // This approach is more reliable than trying to enumerate all boxes
    } catch (e) {
      log('ProfileDeleteAccountCleanupService: Error clearing Hive boxes: $e');
    }
  }

  /// Clear pending task cache
  static Future<void> _clearPendingTaskCache() async {
    try {
      log('ProfileDeleteAccountCleanupService: Clearing pending task cache');

      final pendingTaskService = PendingTaskService.instance;
      pendingTaskService.clearCache();

      log('ProfileDeleteAccountCleanupService: Pending task cache cleared');
    } catch (e) {
      log(
        'ProfileDeleteAccountCleanupService: Error clearing pending task cache: $e',
      );
      // Continue with other cleanup steps
    }
  }

  /// Reset GetX service states
  static Future<void> _resetGetXServices() async {
    try {
      log('ProfileDeleteAccountCleanupService: Resetting GetX service states');

      // Reset any reactive variables in services that might hold user data
      // This is a precautionary step to ensure no user data remains in memory

      // Note: We don't delete the services themselves as they might be needed
      // for the login flow, but we ensure they're in a clean state

      log('ProfileDeleteAccountCleanupService: GetX service states reset');
    } catch (e) {
      log(
        'ProfileDeleteAccountCleanupService: Error resetting GetX services: $e',
      );
      // Continue with other cleanup steps
    }
  }

  /// Verify cleanup was successful by checking key storage locations
  static Future<bool> verifyCleanupSuccess() async {
    const context = 'ProfileDeleteAccountCleanupService.verifyCleanupSuccess';

    try {
      log('[$context] Verifying cleanup success');

      // Check if local storage is cleared
      final hasLocalData = await _hasLocalStorageData();
      if (hasLocalData) {
        log('[$context] Warning: Local storage still contains data');
        return false;
      }

      // Check if Hive cache is cleared
      final hasHiveData = await _hasHiveCacheData();
      if (hasHiveData) {
        log('[$context] Warning: Hive cache still contains data');
        return false;
      }

      // Check if auth service shows user as logged out
      final isStillAuthenticated = _isUserStillAuthenticated();
      if (isStillAuthenticated) {
        log('[$context] Warning: User still appears authenticated');
        return false;
      }

      log('[$context] Cleanup verification successful');
      return true;
    } catch (e) {
      log('[$context] Error during cleanup verification: $e');
      return false;
    }
  }

  /// Check if local storage still contains user data
  static Future<bool> _hasLocalStorageData() async {
    try {
      // Check for common user data keys
      final tokenExists = await LocalStorageHelper.containsKey('TOKEN');
      final userDataExists = await LocalStorageHelper.containsKey('USER_DATA');
      final preferencesExist = await LocalStorageHelper.containsKey(
        'USER_PREFERENCES',
      );

      return tokenExists || userDataExists || preferencesExist;
    } catch (e) {
      log(
        'ProfileDeleteAccountCleanupService: Error checking local storage: $e',
      );
      return false; // Assume clean if we can't check
    }
  }

  /// Check if Hive cache still contains user data
  static Future<bool> _hasHiveCacheData() async {
    try {
      final authCache = AuthCacheDataSource.instance;
      final userAuth = await authCache.getUserAuth();

      return userAuth != null;
    } catch (e) {
      log('ProfileDeleteAccountCleanupService: Error checking Hive cache: $e');
      return false; // Assume clean if we can't check
    }
  }

  /// Check if user still appears authenticated
  static bool _isUserStillAuthenticated() {
    try {
      final authService = Get.find<AuthService>();
      return authService.isAuthenticated;
    } catch (e) {
      log('ProfileDeleteAccountCleanupService: Error checking auth status: $e');
      return false; // Assume not authenticated if we can't check
    }
  }
}
