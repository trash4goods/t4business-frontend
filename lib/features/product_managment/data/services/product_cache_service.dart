import 'dart:async';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result_file.dart';
import 'package:t4g_for_business/features/product_managment/data/models/barcode/barcode_result_file_createdby.dart';

import '../models/barcode/barcode.dart';
import '../models/barcode/barcode_pagination.dart';
import '../models/barcode/barcode_result.dart';

class ProductCacheService {
  // Singleton pattern
  ProductCacheService._internal();
  static ProductCacheService? _instance;
  static ProductCacheService get instance {
    _instance ??= ProductCacheService._internal();
    return _instance!;
  }

  // Constants
  static const String boxName = 'productsBox';
  static const int hiveTypeId = 11;

  // State management
  Box<dynamic>? _box;
  bool _isInitialized = false;
  bool _isInitializing = false;
  Completer<void>? _initializationCompleter;

  // Memory cache (two-tier caching)
  final Map<String, BarcodeModel> _memoryCache = {};

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

      // Step 1: Register adapter if not already registered
      if (!Hive.isAdapterRegistered(hiveTypeId)) {
        Hive.registerAdapter(BarcodeModelAdapter());
      }
      if (!Hive.isAdapterRegistered(12)) {
        Hive.registerAdapter(BarcodePaginationModelAdapter());
      }
      if (!Hive.isAdapterRegistered(13)) {
        Hive.registerAdapter(BarcodeResultModelAdapter());
      }
      if (!Hive.isAdapterRegistered(20)) {
        Hive.registerAdapter(BarcodeResultFileModelAdapter());
      }
      if (!Hive.isAdapterRegistered(21)) {
        Hive.registerAdapter(BarcodeResultFileCreatedByModelAdapter());
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
      log('[ProductCache] Initialized successfully with ${_box!.length} entries');
    } catch (e) {
      log('[ProductCache] Initialization failed: $e');
      _initializationCompleter!.completeError(e);
      throw Exception(e);
    } finally {
      _isInitializing = false;
    }
  }

  /// Ensure box is ready before any operation
  Future<void> _ensureInitialized() async {
    if (!_isInitialized && !_isInitializing) {
      log('[ProductCache] Auto-initializing...');
      await initialize();
    }

    // Wait for initialization to complete if it's in progress
    while (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    if (!_isInitialized) {
      throw Exception('[ProductCache] Failed to initialize');
    }
  }

  /// Safe box access with error handling
  Box<dynamic> get _safeBox {
    if (_box == null || !_isInitialized) {
      throw Exception('[ProductCache] Not initialized. Call initialize() first.');
    }
    return _box!;
  }

  /// Build cache key from page and perPage
  String _buildCacheKey(int page, int perPage) {
    return 'page_${page}_perPage_$perPage';
  }

  /// Get products with smart two-tier caching
  Future<BarcodeModel?> getProducts(int page, int perPage) async {
    try {
      await _ensureInitialized();

      final cacheKey = _buildCacheKey(page, perPage);

      // Smart memory management: only keep current page in memory
      if (_currentPageKey != null && _currentPageKey != cacheKey) {
        // Clear previous page from memory
        _memoryCache.remove(_currentPageKey!);
        log('[ProductCache] Cleared memory for previous page: $_currentPageKey');
      }
      _currentPageKey = cacheKey;

      // Layer 1: Memory cache (only current page)
      if (_memoryCache.containsKey(cacheKey)) {
        log('[ProductCache] Memory cache HIT for page $page');
        return _memoryCache[cacheKey]!;
      }

      // Layer 2: Hive cache
      final rawData = _safeBox.get(cacheKey);
      if (rawData != null) {
        final data = rawData as BarcodeModel;
        _memoryCache[cacheKey] = data; // Cache current page only
        log('[ProductCache] Hive cache HIT for page $page');
        return data;
      }

      log('[ProductCache] Cache MISS for page $page');
      return null;
    } catch (e) {
      log('[ProductCache] Error getting products: $e');
      return null;
    }
  }

  /// Save products (update current page tracking)
  Future<void> saveProducts(int page, int perPage, BarcodeModel data) async {
    try {
      await _ensureInitialized();

      final cacheKey = _buildCacheKey(page, perPage);

      await _safeBox.put(cacheKey, data);

      // Only cache in memory if it's the current page
      if (_currentPageKey == cacheKey) {
        _memoryCache[cacheKey] = data;
      }

      log('[ProductCache] Saved page $page to Hive');
    } catch (e) {
      log('[ProductCache] Error saving products: $e');
      throw Exception(e);
    }
  }

  /// Clear all cached products
  Future<void> clearCache() async {
    try {
      await _ensureInitialized();

      final count = _safeBox.length;
      await _safeBox.clear();
      _memoryCache.clear();
      _currentPageKey = null;

      log('[ProductCache] Cleared all cache ($count entries)');
    } catch (e) {
      log('[ProductCache] Error clearing cache: $e');
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
      log('[ProductCache] Disposed successfully');
    } catch (e) {
      log('[ProductCache] Error during dispose: $e');
      throw Exception(e);
    }
  }
}
