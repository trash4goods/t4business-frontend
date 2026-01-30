import 'dart:developer';

import 'package:get/get.dart';

import '../../../../../core/app/api_endpoints.dart';
import '../../../../../core/app/api_method.dart';
import '../../../../../core/services/http_interface.dart';
import '../../models/rules.dart';
import '../../models/rules_result.dart';
import 'rules_remote_datasource.interface.dart';

class RulesV2RemoteDataSourceImpl implements RulesV2RemoteDataSourceInterface {
  final IHttp http;

  RulesV2RemoteDataSourceImpl({required this.http});

  @override
  Future<RulesModel?> getRules({
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

      final endpoint = '${ApiEndpoints.rulesBase}?$queryString';

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
        '[RulesV2RemoteDataSourceImpl] getRules response: ${response.response}',
      );

      if (response.statusCode == 200) {
        return RulesModel.fromJson(response.response);
      }

      return null;
    } catch (e) {
      log('[RulesV2RemoteDataSourceImpl] getRules error: $e');
      return null;
    }
  }

  @override
  Future<RulesResultModel?> getRuleById(
    int id, {
    String token = '',
  }) async {
    try {
      final endpoint = '${ApiEndpoints.rulesBase}/$id';

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
        '[RulesV2RemoteDataSourceImpl] getRuleById response: ${response.response}',
      );

      if (response.statusCode == 200) {
        final data = response.response['data'] ?? response.response;
        return RulesResultModel.fromJson(data);
      }

      throw Exception('Failed to get rule by id: $id');
    } catch (e) {
      log(
        '[RulesV2RemoteDataSourceImpl] getRuleById error: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> createRule(
    RulesResultModel rule, {
    String token = '',
  }) async {
    try {
      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.post,
        endpoint: ApiEndpoints.rulesBase,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: rule.toJson(),
      );

      log(
        '[RulesV2RemoteDataSourceImpl] createRule response: ${response.response}',
      );
    } catch (e) {
      log(
        '[RulesV2RemoteDataSourceImpl] createRule error: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> updateRule(
    int id,
    RulesResultModel rule, {
    String token = '',
  }) async {
    try {
      final endpoint = '${ApiEndpoints.rulesBase}/$id';

      final response = await http.requestHttp(
        context: Get.context!,
        method: APIMethod.put,
        endpoint: endpoint,
        headers: {
          'Content-Type': 'application/json',
          if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: rule.toJson(),
      );

      log(
        '[RulesV2RemoteDataSourceImpl] updateRule response: ${response.response}',
      );
    } catch (e) {
      log(
        '[RulesV2RemoteDataSourceImpl] updateRule error: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteRule(
    int id, {
    String token = '',
  }) async {
    try {
      final endpoint = '${ApiEndpoints.rulesBase}/$id';

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
        '[RulesV2RemoteDataSourceImpl] deleteRule response: ${response.response}',
      );
    } catch (e) {
      log(
        '[RulesV2RemoteDataSourceImpl] deleteRule error: $e',
      );
      rethrow;
    }
  }
}