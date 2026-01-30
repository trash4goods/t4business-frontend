import 'dart:developer';

import 'package:t4g_for_business/features/rewards/data/models/reward.dart';

import '../../../rules_v2/data/models/rules_result.dart';
import '../../../rules_v2/data/models/selection_result.dart';
import '../models/reward_result.dart';
import '../models/validate_reward.dart';
import '../repository/rewards_repository.interface.dart';
import 'rewards_usecase.interface.dart';

class RewardsUsecaseImpl implements RewardsUseCaseInterface {
  final RewardsRepositoryInterface repository;

  RewardsUsecaseImpl(this.repository);

  @override
  Future<void> createReward(
    RewardResultModel product, {
    String token = '',
  }) async {
    try {
      return await repository.createReward(product, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] createReward error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteReward(int id, {String token = ''}) async {
    try {
      return await repository.deleteReward(id, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] deleteReward error: $e');
      rethrow;
    }
  }

  @override
  Future<RewardResultModel?> getRewardById(int id, {String token = ''}) async {
    try {
      return await repository.getRewardById(id, token: token);
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
    bool forceRefresh = false,
  }) async {
    try {
      return await repository.getRewards(
        perPage: perPage,
        page: page,
        search: search,
        token: token,
        forceRefresh: forceRefresh,
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
      return await repository.updateReward(id, product, token: token);
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
  }) {
    try {
      return repository.fetchRules(
        page: page,
        pageSize: pageSize,
        search: search,
        token: token,
      );
    } catch (e) {
      log('[RewardsRepositoryImpl] fetchRules error: $e');
      rethrow;
    }
  }

  @override
  Future<ValidateRewardModel?> invalidateReward(
    String rewardId, {
    String token = '',
  }) async {
    try {
      return await repository.invalidateReward(rewardId, token: token);
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
      return await repository.validateReward(rewardId, token: token);
    } catch (e) {
      log('[RewardsRepositoryImpl] updateReward error: $e');
      rethrow;
    }
  }
}
