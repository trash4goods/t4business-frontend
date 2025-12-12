import 'dart:developer';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/app/app_routes.dart';
import '../../features/auth/data/datasources/interface/login_remote_datasource_interface.dart';

// Cache entry with timestamp for expiration
class _CacheEntry {
  final bool hasPendingTasks;
  final DateTime cachedAt;
  
  _CacheEntry(this.hasPendingTasks) : cachedAt = DateTime.now();
  
  bool get isExpired => DateTime.now().difference(cachedAt).inSeconds > 30;
}

/// Service for managing pending task status with caching for middleware
class PendingTaskService extends GetxService {
  static PendingTaskService get instance => Get.find<PendingTaskService>();

  final Map<String, _CacheEntry> _cache = {};
  bool _isChecking = false;

  /// Synchronous method for middleware - returns cached result or safe default
  bool hasPendingTasksCached(String uid) {
    final cached = _cache[uid];
    
    if (cached != null && !cached.isExpired) {
      log('[PendingTaskService] Using cached result for $uid: ${cached.hasPendingTasks}');
      return cached.hasPendingTasks;
    }
    
    // If no cache or expired, trigger background refresh but return safe default
    if (!_isChecking) {
      _refreshCacheInBackground(uid);
    }
    
    log('[PendingTaskService] No valid cache for $uid, returning safe default: false');
    return false; // Safe default - allow navigation, pending tasks will redirect if needed
  }

  /// Async method for comprehensive checking - updates cache
  Future<bool> checkAndCachePendingTasks(String uid) async {
    log('[PendingTaskService] Checking pending tasks for $uid');
    _isChecking = true;
    
    try {
      // Get the login datasource to check pending tasks
      final loginDataSource = Get.find<LoginRemoteDatasourceInterface>();
      final pendingTasks = await loginDataSource.checkFirebasePendingTask(uid);
      
      final hasPendingTasks = pendingTasks != null && pendingTasks.isNotEmpty;
      
      // Update cache
      _cache[uid] = _CacheEntry(hasPendingTasks);
      
      log('[PendingTaskService] Updated cache for $uid: $hasPendingTasks');
      return hasPendingTasks;
    } catch (e) {
      log('[PendingTaskService] Error checking pending tasks: $e');
      // Keep existing cache if available, otherwise assume no pending tasks
      if (!_cache.containsKey(uid)) {
        _cache[uid] = _CacheEntry(false);
      }
      return _cache[uid]?.hasPendingTasks ?? false;
    } finally {
      _isChecking = false;
    }
  }

  /// Background cache refresh (fire-and-forget)
  void _refreshCacheInBackground(String uid) {
    checkAndCachePendingTasks(uid).catchError((error) {
      log('[PendingTaskService] Background refresh failed: $error');
      return false; // Return default value for error case
    });
  }

  /// Get route destination based on pending tasks (for authenticated users)
  String getAuthenticatedUserRoute(String uid) {
    if (hasPendingTasksCached(uid)) {
      return AppRoutes.pendingTasks;
    }
    return AppRoutes.dashboardShell;
  }

  /// Clear cache when user completes tasks or logs out
  void clearCache([String? uid]) {
    if (uid != null) {
      _cache.remove(uid);
      log('[PendingTaskService] Cleared cache for $uid');
    } else {
      _cache.clear();
      log('[PendingTaskService] Cleared all cache');
    }
  }

  /// Manually update cache when task status changes
  void updateCache(String uid, bool hasPendingTasks) {
    _cache[uid] = _CacheEntry(hasPendingTasks);
    log('[PendingTaskService] Manually updated cache for $uid: $hasPendingTasks');
  }
}