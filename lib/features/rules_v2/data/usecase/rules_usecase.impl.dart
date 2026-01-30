import 'dart:developer';

import '../models/rules.dart';
import '../models/rules_result.dart';
import '../models/selection_result.dart';
import '../../../rewards/data/models/reward_result.dart';
import '../../../product_managment/data/models/barcode/barcode_result.dart';
import '../repository/rules_repository.interface.dart';
import 'rules_usecase.interface.dart';

class RulesV2UseCaseImpl implements RulesV2UseCaseInterface {
  final RulesV2RepositoryInterface repository;

  RulesV2UseCaseImpl({required this.repository});

  @override
  Future<void> createRule(RulesResultModel rule, {String token = ''}) async {
    try {
      return await repository.createRule(rule, token: token);
    } catch (e) {
      log('[RulesV2UsecaseImpl] createRule error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteRule(int id, {String token = ''}) async {
    try {
      return await repository.deleteRule(id, token: token);
    } catch (e) {
      log('[RulesV2UsecaseImpl] deleteRule error: $e');
      rethrow;
    }
  }

  @override
  Future<RulesResultModel?> getRuleById(int id, {String token = ''}) async {
    try {
      return await repository.getRuleById(id, token: token);
    } catch (e) {
      log('[RulesV2UsecaseImpl] getRuleById error: $e');
      rethrow;
    }
  }

  @override
  Future<RulesModel?> getRules({int perPage = 10, int page = 1, String search = '', String token = '', bool forceRefresh = false}) async {
    try {
      return await repository.getRules(perPage: perPage, page: page, search: search, token: token, forceRefresh: forceRefresh);
    } catch (e) {
      log('[RulesV2UsecaseImpl] getRules error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateRule(int id, RulesResultModel rule, {String token = ''}) async {
    try {
      return await repository.updateRule(id, rule, token: token);
    } catch (e) {
      log('[RulesV2UsecaseImpl] updateRule error: $e');
      rethrow;
    }
  }

  @override
  Future<SelectionResult<RewardResultModel>> fetchRewards({
    int page = 1,
    int pageSize = 20,
    String search = '',
    required String token,
  }) async {
    try {
      return await repository.fetchRewards(
        page: page,
        pageSize: pageSize,
        search: search,
        token: token,
      );
    } catch (e) {
      log('[RulesV2UsecaseImpl] fetchRewards error: $e');
      rethrow;
    }
  }

  @override
  Future<SelectionResult<BarcodeResultModel>> fetchBarcodes({
    int page = 1,
    int pageSize = 20,
    String search = '',
    required String token,
  }) async {
    try {
      return await repository.fetchBarcodes(
        page: page,
        pageSize: pageSize,
        search: search,
        token: token,
      );
    } catch (e) {
      log('[RulesV2UsecaseImpl] fetchBarcodes error: $e');
      rethrow;
    }
  }
}