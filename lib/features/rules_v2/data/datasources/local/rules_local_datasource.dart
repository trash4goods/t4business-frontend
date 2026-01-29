import 'dart:developer';

import '../../models/rules.dart';
import '../../services/rules_cache_service.dart';

class RulesLocalDataSource {
  // Singleton pattern
  RulesLocalDataSource._internal();
  static RulesLocalDataSource? _instance;
  static RulesLocalDataSource get instance {
    _instance ??= RulesLocalDataSource._internal();
    return _instance!;
  }

  final RulesCacheService _cacheService = RulesCacheService.instance;

  /// Get rules from cache
  Future<RulesModel?> getRules({
    required int page,
    required int perPage,
  }) async {
    try {
      return await _cacheService.getRules(page, perPage);
    } catch (e) {
      log('[RulesLocalDS] Error getting rules: $e');
      return null;
    }
  }

  /// Save rules to cache
  Future<void> saveRules({
    required int page,
    required int perPage,
    required RulesModel data,
  }) async {
    try {
      await _cacheService.saveRules(page, perPage, data);
    } catch (e) {
      log('[RulesLocalDS] Error saving rules: $e');
    }
  }

  /// Clear all cached rules
  Future<void> clearCache() async {
    try {
      await _cacheService.clearCache();
    } catch (e) {
      log('[RulesLocalDS] Error clearing cache: $e');
    }
  }
}
