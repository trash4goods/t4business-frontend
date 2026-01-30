import 'dart:developer';

import 'package:get/get.dart';
import 'package:t4g_for_business/features/rewards/data/models/reward.dart';
import 'package:t4g_for_business/features/rewards/data/models/validate_reward.dart';

import '../../../../../core/app/api_endpoints.dart';
import '../../../../../core/app/api_method.dart';
import '../../../../../core/services/http_interface.dart';
import '../../models/reward_result.dart';
import 'rewards_remote_datasource.interface.dart';

class RewardsRemoteDataSourceImpl implements RewardsRemoteDataSourceInterface {
  final IHttp http;

  RewardsRemoteDataSourceImpl(this.http);

  @override
  Future<RewardModel?> getRewards({
    int perPage = 10,
    int page = 1,
    String search = '',
    String token = '',
  }) async {
    try {
      final queryParams = {
        'perPage': perPage.toString(),
        'page': page.toString(),
        if (search.isNotEmpty) 'search': search,
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final endpoint = '${ApiEndpoints.marketplaceProductsBase}?$queryString';

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.get,
        endpoint: endpoint,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      log(
        '[RewardsRemoteDataSourceImpl] getRewards response: ${response.response}',
      );

      if (response.statusCode == 200) {
        return RewardModel.fromJson(response.response);
      }

      return null;
    } catch (e) {
      log('[RewardsRemoteDataSourceImpl] getRewards error: $e');
      return null;
    }
  }

  @override
  Future<RewardResultModel?> getRewardById(int id, {String token = ''}) async {
    try {
      final endpoint = '${ApiEndpoints.marketplaceProductsBase}/$id';

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.get,
        endpoint: endpoint,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      log(
        '[RewardsRemoteDataSourceImpl] getRewardById response: ${response.response}',
      );

      if (response.statusCode == 200) {
        final data = response.response['data'] ?? response.response;
        return RewardResultModel.fromJson(data);
      }

      throw Exception('Failed to get marketplace product by id: $id');
    } catch (e) {
      log('[RewardsRemoteDataSourceImpl] getRewardById error: $e');
      rethrow;
    }
  }

  @override
  Future<void> createReward(
    RewardResultModel product, {
    String token = '',
  }) async {
    try {
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.post,
        endpoint: ApiEndpoints.marketplaceProductsBase,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: product.toJson(),
      );

      log(
        '[RewardsRemoteDataSourceImpl] createReward response: ${response.response}',
      );
    } catch (e) {
      log('[RewardsRemoteDataSourceImpl] createReward error: $e');
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
      final endpoint = '${ApiEndpoints.marketplaceProductsBase}/$id';

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.put,
        endpoint: endpoint,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: product.toJson(),
      );

      log(
        '[RewardsRemoteDataSourceImpl] updateReward response: ${response.response}',
      );
    } catch (e) {
      log('[RewardsRemoteDataSourceImpl] updateReward error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteReward(int id, {String token = ''}) async {
    try {
      final endpoint = '${ApiEndpoints.marketplaceProductsBase}/$id';

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.delete,
        endpoint: endpoint,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      log(
        '[RewardsRemoteDataSourceImpl] deleteReward response: ${response.response}',
      );
    } catch (e) {
      log('[RewardsRemoteDataSourceImpl] deleteReward error: $e');
      rethrow;
    }
  }

  @override
  Future<ValidateRewardModel?> invalidateReward(
    String rewardId, {
    String token = '',
  }) async {
    try {
      final endpoint = '${ApiEndpoints.rewardsValidation}/$rewardId';

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.put,
        endpoint: endpoint,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      log(
        '[RewardsRemoteDataSourceImpl] invalidateReward response: ${response.response}',
      );

      return ValidateRewardModel.fromJson(response.response);
    } catch (e) {
      log('[RewardsRemoteDataSourceImpl] invalidateReward error: $e');
      rethrow;
    }
  }

  @override
  Future<ValidateRewardModel?> validateReward(
    String rewardId, {
    String token = '',
  }) async {
    try {
      final endpoint = '${ApiEndpoints.rewardsValidation}/$rewardId';

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.get,
        endpoint: endpoint,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      );

      log(
        '[RewardsRemoteDataSourceImpl] validateReward response: ${response.response}',
      );

      return ValidateRewardModel.fromJson(response.response);
    } catch (e) {
      log('[RewardsRemoteDataSourceImpl] validateReward error: $e');
      rethrow;
    }
  }
}
