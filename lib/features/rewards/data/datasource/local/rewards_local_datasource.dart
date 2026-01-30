import 'dart:developer';

import '../../models/reward.dart';
import '../../services/rewards_cache_service.dart';

class RewardsLocalDataSource {
  // Singleton pattern
  RewardsLocalDataSource._internal();
  static RewardsLocalDataSource? _instance;
  static RewardsLocalDataSource get instance {
    _instance ??= RewardsLocalDataSource._internal();
    return _instance!;
  }

  final RewardsCacheService _cacheService = RewardsCacheService.instance;

  /// Get rewards from cache
  Future<RewardModel?> getRewards({
    required int page,
    required int perPage,
  }) async {
    try {
      return await _cacheService.getRewards(page, perPage);
    } catch (e) {
      log('[RewardsLocalDS] Error getting rewards: $e');
      return null;
    }
  }

  /// Save rewards to cache
  Future<void> saveRewards({
    required int page,
    required int perPage,
    required RewardModel data,
  }) async {
    try {
      await _cacheService.saveRewards(page, perPage, data);
    } catch (e) {
      log('[RewardsLocalDS] Error saving rewards: $e');
    }
  }

  /// Clear all cached rewards
  Future<void> clearCache() async {
    try {
      await _cacheService.clearCache();
    } catch (e) {
      log('[RewardsLocalDS] Error clearing cache: $e');
    }
  }
}
