import 'dart:developer';

import 'package:t4g_for_business/features/rewards/data/models/reward.dart';
import 'package:t4g_for_business/features/rewards/data/models/reward_result.dart';
import 'package:t4g_for_business/features/rewards/data/models/validate_reward.dart';

import '../../../rules_v2/data/datasource/rules_remote_datasource.interface.dart';
import '../../../rules_v2/data/models/rules_result.dart';
import '../../../rules_v2/data/models/selection_result.dart';
import '../datasource/rewards_remote_datasource.interface.dart';
import 'rewards_repository.interface.dart';

class RewardsRepositoryImpl implements RewardsRepositoryInterface {
  final RewardsRemoteDataSourceInterface remoteDataSource;
  final RulesV2RemoteDataSourceInterface rulesRemoteDatasource;

  RewardsRepositoryImpl({
    required this.remoteDataSource,
    required this.rulesRemoteDatasource,
  });

  @override
  Future<void> createReward(
    RewardResultModel product, {
    String token = '',
  }) async {
    try {
      return await remoteDataSource.createReward(product, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] createReward error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteReward(int id, {String token = ''}) async {
    try {
      return await remoteDataSource.deleteReward(id, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] deleteReward error: $e');
      rethrow;
    }
  }

  @override
  Future<RewardResultModel?> getRewardById(int id, {String token = ''}) async {
    try {
      return await remoteDataSource.getRewardById(id, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] getRewardById error: $e');
      rethrow;
    }
  }

  @override
  Future<RewardModel?> getRewards({
    int perPage = 10,
    int page = 1,
    String search = '',
    String token = '',
  }) async {
    try {
      return await remoteDataSource.getRewards(
        perPage: perPage,
        page: page,
        search: search,
        token: token,
      );
    } catch (e) {
      log('[RewardsRepositoryImpl] getRewards error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateReward(
    int id,
    RewardResultModel product, {
    String token = '',
  }) async {
    try {
      return await remoteDataSource.updateReward(id, product, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] updateReward error: $e');
      rethrow;
    }
  }

  @override
  Future<SelectionResult<RulesResultModel>> fetchRules({
    int page = 1,
    int pageSize = 20,
    String search = '',
    required String token,
  }) async {
    try {
      final result = await rulesRemoteDatasource.getRules(
        token: token,
        page: page,
        perPage: pageSize,
      );

      // Filter by search if needed (since API might not support search)
      final filteredItems =
          search.isEmpty
              ? result?.result ?? []
              : (result?.result ?? [])
                  .where(
                    (item) =>
                        (item.name?.toLowerCase().contains(
                              search.toLowerCase(),
                            ) ??
                            false),
                  )
                  .toList();

      return SelectionResult<RulesResultModel>(
        items: filteredItems,
        totalCount: result?.pagination?.count ?? 0,
        hasMore: (result?.result?.length ?? 0) >= pageSize,
        currentPage: page,
      );
    } catch (e) {
      log('[RewardsRepositoryImpl] fetchRules error: $e');
      return SelectionResult<RulesResultModel>(
        items: [],
        totalCount: 0,
        hasMore: false,
        currentPage: page,
      );
    }
  }

  @override
  Future<ValidateRewardModel?> invalidateReward(
    String rewardId, {
    String token = '',
  }) async {
    try {
      return await remoteDataSource.invalidateReward(rewardId, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] updateReward error: $e');
      rethrow;
    }
  }

  @override
  Future<ValidateRewardModel?> validateReward(
    String rewardId, {
    String token = '',
  }) async {
    try {
      return await remoteDataSource.validateReward(rewardId, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] updateReward error: $e');
      rethrow;
    }
  }
}
