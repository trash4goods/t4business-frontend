import 'dart:developer';

import '../../models/barcode/barcode.dart';
import '../../services/product_cache_service.dart';

class ProductLocalDataSource {
  // Singleton pattern
  ProductLocalDataSource._internal();
  static ProductLocalDataSource? _instance;
  static ProductLocalDataSource get instance {
    _instance ??= ProductLocalDataSource._internal();
    return _instance!;
  }

  final ProductCacheService _cacheService = ProductCacheService.instance;

  /// Get products from cache
  Future<BarcodeModel?> getProducts({
    required int page,
    required int perPage,
  }) async {
    try {
      return await _cacheService.getProducts(page, perPage);
    } catch (e) {
      log('[ProductLocalDS] Error getting products: $e');
      return null;
    }
  }

  /// Save products to cache
  Future<void> saveProducts({
    required int page,
    required int perPage,
    required BarcodeModel data,
  }) async {
    try {
      await _cacheService.saveProducts(page, perPage, data);
    } catch (e) {
      log('[ProductLocalDS] Error saving products: $e');
    }
  }

  /// Clear all cached products
  Future<void> clearCache() async {
    try {
      await _cacheService.clearCache();
    } catch (e) {
      log('[ProductLocalDS] Error clearing cache: $e');
    }
  }
}
