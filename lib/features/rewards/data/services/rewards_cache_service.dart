import 'dart:async';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:t4g_for_business/features/rewards/data/models/reward_pagination.dart';
import 'package:t4g_for_business/features/rewards/data/models/reward_result.dart';

import '../models/reward.dart';
import '../models/reward_result_file.dart';
import '../models/reward_result_file_createdby.dart';

class RewardsCacheService {
  // Singleton pattern
  RewardsCacheService._internal();
  static RewardsCacheService? _instance;
  static RewardsCacheService get instance {
    _instance ??= RewardsCacheService._internal();
    return _instance!;
  }

  // Constants
  static const String boxName = 'rewardsBox';
  static const int hiveTypeId = 17;

  // State management
  Box<dynamic>? _box;
  bool _isInitialized = false;
  bool _isInitializing = false;
  Completer<void>? _initializationCompleter;

  // Memory cache (two-tier caching)
  final Map<String, RewardModel> _memoryCache = {};

  // Current page tracking for smart memory management
  String? _currentPageKey;

  /// Thread-safe initialization (call once at app startup)
  Future<void> initialize() async {
    // Prevent multiple initialization attempts
    if (_isInitialized) return;
    if (_isInitializing) {
      await _initializationCompleter?.future;
      return;
    }

    try {
      _isInitializing = true;
      _initializationCompleter = Completer<void>();

      // Step 1: Register adapters if not already registered
      if (!Hive.isAdapterRegistered(hiveTypeId)) {
        Hive.registerAdapter(RewardModelAdapter());
      }
      if (!Hive.isAdapterRegistered(18)) {
        Hive.registerAdapter(RewardPaginationModelAdapter());
      }
      if (!Hive.isAdapterRegistered(19)) {
        Hive.registerAdapter(RewardResultModelAdapter());
      }
      if (!Hive.isAdapterRegistered(22)) {
        Hive.registerAdapter(RewardResultFileModelAdapter());
      }
      if (!Hive.isAdapterRegistered(23)) {
        Hive.registerAdapter(RewardResultFileCreatedByModelAdapter());
      }

      // Step 2: Check if box is already open
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box(boxName);
      } else {
        // Step 3: Open box safely
        _box = await Hive.openBox(boxName);
      }

      _isInitialized = true;
      _initializationCompleter!.complete();
      log('[RewardsCache] Initialized successfully with ${_box!.length} entries');
    } catch (e) {
      log('[RewardsCache] Initialization failed: $e');
      _initializationCompleter!.completeError(e);
      throw Exception(e);
    } finally {
      _isInitializing = false;
    }
  }

  /// Ensure box is ready before any operation
  Future<void> _ensureInitialized() async {
    if (!_isInitialized && !_isInitializing) {
      log('[RewardsCache] Auto-initializing...');
      await initialize();
    }

    // Wait for initialization to complete if it's in progress
    while (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (!_isInitialized) {
      throw Exception('[RewardsCache] Failed to initialize');
    }
  }

  /// Safe box access with error handling
  Box<dynamic> get _safeBox {
    if (_box == null || !_isInitialized) {
      throw Exception('[RewardsCache] Not initialized. Call initialize() first.');
    }
    return _box!;
  }

  /// Build cache key from page and perPage
  String _buildCacheKey(int page, int perPage) {
    return 'page_${page}_perPage_$perPage';
  }

  /// Get rewards with smart two-tier caching
  Future<RewardModel?> getRewards(int page, int perPage) async {
    try {
      await _ensureInitialized();

      final cacheKey = _buildCacheKey(page, perPage);

      // Smart memory management: only keep current page in memory
      if (_currentPageKey != null && _currentPageKey != cacheKey) {
        // Clear previous page from memory
        _memoryCache.remove(_currentPageKey!);
        log('[RewardsCache] Cleared memory for previous page: $_currentPageKey');
      }
      _currentPageKey = cacheKey;

      // Layer 1: Memory cache (only current page)
      if (_memoryCache.containsKey(cacheKey)) {
        log('[RewardsCache] Memory cache HIT for page $page');
        return _memoryCache[cacheKey]!;
      }

      // Layer 2: Hive cache
      final rawData = _safeBox.get(cacheKey);
      if (rawData != null) {
        final data = rawData as RewardModel;
        _memoryCache[cacheKey] = data; // Cache current page only
        log('[RewardsCache] Hive cache HIT for page $page');
        return data;
      }

      log('[RewardsCache] Cache MISS for page $page');
      return null;
    } catch (e) {
      log('[RewardsCache] Error getting rewards: $e');
      return null;
    }
  }

  /// Save rewards (update current page tracking)
  Future<void> saveRewards(int page, int perPage, RewardModel data) async {
    try {
      await _ensureInitialized();

      final cacheKey = _buildCacheKey(page, perPage);

      await _safeBox.put(cacheKey, data);

      // Only cache in memory if it's the current page
      if (_currentPageKey == cacheKey) {
        _memoryCache[cacheKey] = data;
      }

      log('[RewardsCache] Saved page $page to Hive');
    } catch (e) {
      log('[RewardsCache] Error saving rewards: $e');
      throw Exception(e);
    }
  }

  /// Clear all cached rewards
  Future<void> clearCache() async {
    try {
      await _ensureInitialized();

      final count = _safeBox.length;
      await _safeBox.clear();
      _memoryCache.clear();
      _currentPageKey = null;

      log('[RewardsCache] Cleared all cache ($count entries)');
    } catch (e) {
      log('[RewardsCache] Error clearing cache: $e');
      throw Exception(e);
    }
  }

  /// Clean shutdown (call on app exit)
  Future<void> dispose() async {
    try {
      _memoryCache.clear();
      if (_box != null && _box!.isOpen) {
        await _box!.close();
      }
      _isInitialized = false;
      _currentPageKey = null;
      log('[RewardsCache] Disposed successfully');
    } catch (e) {
      log('[RewardsCache] Error during dispose: $e');
      throw Exception(e);
    }
  }
}
