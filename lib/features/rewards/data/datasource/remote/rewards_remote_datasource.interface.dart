import '../../models/reward.dart';
import '../../models/reward_result.dart';
import '../../models/validate_reward.dart';

abstract class RewardsRemoteDataSourceInterface {
  Future<RewardModel?> getRewards({
    int perPage = 10,
    int page = 1,
    String search = '',
    String token = '',
  });
  Future<RewardResultModel?> getRewardById(int id, {String token = ''});

  Future<void> createReward(RewardResultModel product, {String token = ''});

  Future<void> updateReward(
    int id,
    RewardResultModel product, {
    String token = '',
  });

  Future<void> deleteReward(int id, {String token = ''});

  Future<ValidateRewardModel?> validateReward(
    String rewardId, {
    String token = '',
  });

  Future<ValidateRewardModel?> invalidateReward(
    String rewardId, {
    String token = '',
  });
}
