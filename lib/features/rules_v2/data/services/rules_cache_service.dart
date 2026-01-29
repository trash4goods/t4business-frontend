import 'dart:async';
import 'dart:developer';

import 'package:hive/hive.dart';

import '../models/rules.dart';
import '../models/rules_pagination.dart';
import '../models/rules_result.dart';

class RulesCacheService {
  // Singleton pattern
  RulesCacheService._internal();
  static RulesCacheService? _instance;
  static RulesCacheService get instance {
    _instance ??= RulesCacheService._internal();
    return _instance!;
  }

  // Constants
  static const String boxName = 'rulesBox';
  static const int hiveTypeId = 14;

  // State management
  Box<dynamic>? _box;
  bool _isInitialized = false;
  bool _isInitializing = false;
  Completer<void>? _initializationCompleter;

  // Memory cache (two-tier caching)
  final Map<String, RulesModel> _memoryCache = {};

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
        Hive.registerAdapter(RulesModelAdapter());
      }
      if (!Hive.isAdapterRegistered(15)) {
        Hive.registerAdapter(RulesPaginationModelAdapter());
      }
      if (!Hive.isAdapterRegistered(16)) {
        Hive.registerAdapter(RulesResultModelAdapter());
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
      log('[RulesCache] Initialized successfully with ${_box!.length} entries');
    } catch (e) {
      log('[RulesCache] Initialization failed: $e');
      _initializationCompleter!.completeError(e);
      throw Exception(e);
    } finally {
      _isInitializing = false;
    }
  }

  /// Ensure box is ready before any operation
  Future<void> _ensureInitialized() async {
    if (!_isInitialized && !_isInitializing) {
      log('[RulesCache] Auto-initializing...');
      await initialize();
    }

    // Wait for initialization to complete if it's in progress
    while (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (!_isInitialized) {
      throw Exception('[RulesCache] Failed to initialize');
    }
  }

  /// Safe box access with error handling
  Box<dynamic> get _safeBox {
    if (_box == null || !_isInitialized) {
      throw Exception('[RulesCache] Not initialized. Call initialize() first.');
    }
    return _box!;
  }

  /// Build cache key from page and perPage
  String _buildCacheKey(int page, int perPage) {
    return 'page_${page}_perPage_$perPage';
  }

  /// Get rules with smart two-tier caching
  Future<RulesModel?> getRules(int page, int perPage) async {
    try {
      await _ensureInitialized();

      final cacheKey = _buildCacheKey(page, perPage);

      // Smart memory management: only keep current page in memory
      if (_currentPageKey != null && _currentPageKey != cacheKey) {
        // Clear previous page from memory
        _memoryCache.remove(_currentPageKey!);
        log('[RulesCache] Cleared memory for previous page: $_currentPageKey');
      }
      _currentPageKey = cacheKey;

      // Layer 1: Memory cache (only current page)
      if (_memoryCache.containsKey(cacheKey)) {
        log('[RulesCache] Memory cache HIT for page $page');
        return _memoryCache[cacheKey]!;
      }

      // Layer 2: Hive cache
      final rawData = _safeBox.get(cacheKey);
      if (rawData != null) {
        final data = rawData as RulesModel;
        _memoryCache[cacheKey] = data; // Cache current page only
        log('[RulesCache] Hive cache HIT for page $page');
        return data;
      }

      log('[RulesCache] Cache MISS for page $page');
      return null;
    } catch (e) {
      log('[RulesCache] Error getting rules: $e');
      return null;
    }
  }

  /// Save rules (update current page tracking)
  Future<void> saveRules(int page, int perPage, RulesModel data) async {
    try {
      await _ensureInitialized();

      final cacheKey = _buildCacheKey(page, perPage);

      await _safeBox.put(cacheKey, data);

      // Only cache in memory if it's the current page
      if (_currentPageKey == cacheKey) {
        _memoryCache[cacheKey] = data;
      }

      log('[RulesCache] Saved page $page to Hive');
    } catch (e) {
      log('[RulesCache] Error saving rules: $e');
      throw Exception(e);
    }
  }

  /// Clear all cached rules
  Future<void> clearCache() async {
    try {
      await _ensureInitialized();

      final count = _safeBox.length;
      await _safeBox.clear();
      _memoryCache.clear();
      _currentPageKey = null;

      log('[RulesCache] Cleared all cache ($count entries)');
    } catch (e) {
      log('[RulesCache] Error clearing cache: $e');
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
      log('[RulesCache] Disposed successfully');
    } catch (e) {
      log('[RulesCache] Error during dispose: $e');
      throw Exception(e);
    }
  }
}
