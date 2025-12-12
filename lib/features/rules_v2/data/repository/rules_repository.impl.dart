import 'dart:developer';

import '../datasource/rules_remote_datasource.interface.dart';
import '../models/rules.dart';
import '../models/rules_result.dart';
import '../models/selection_result.dart';
import '../../../rewards/data/models/reward_result.dart';
import '../../../rewards/data/datasource/rewards_remote_datasource.interface.dart';
import '../../../product_managment/data/models/barcode/barcode_result.dart';
import '../../../product_managment/data/datasource/remote/product_management_remote_datasource.interface.dart';
import 'rules_repository.interface.dart';

class RulesV2RepositoryImpl implements RulesV2RepositoryInterface {
  final RulesV2RemoteDataSourceInterface remoteDataSource;
  final ProductManagementRemoteDatasourceInterface productManagementRemoteDatasource;
  final RewardsRemoteDataSourceInterface rewardsRemoteDataSource;

  RulesV2RepositoryImpl({required this.remoteDataSource, required this.productManagementRemoteDatasource, required this.rewardsRemoteDataSource});

  @override
  Future<void> createRule(RulesResultModel rule, {String token = ''}) async {
    try {
      return await remoteDataSource.createRule(rule, token: token);
    } catch (e) {
      log('[RulesV2RepositoryImpl] createRule error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteRule(int id, {String token = ''}) async {
    try {
      return await remoteDataSource.deleteRule(id, token: token);
    } catch (e) {
      log('[RulesV2RepositoryImpl] deleteRule error: $e');
      rethrow;
    }
  }

  @override
  Future<RulesResultModel?> getRuleById(int id, {String token = ''}) async {
    try {
      return await remoteDataSource.getRuleById(id, token: token);
    } catch (e) {
      log('[RulesV2RepositoryImpl] getRuleById error: $e');
      rethrow;
    }
  }

  @override
  Future<RulesModel?> getRules({int perPage = 10, int page = 1, String search = '', String token = ''}) async {
    try {
      return await remoteDataSource.getRules(perPage: perPage, page: page, search: search, token: token);
    } catch (e) {
      log('[RulesV2RepositoryImpl] getRules error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateRule(int id, RulesResultModel rule, {String token = ''}) async {
    try {
      return await remoteDataSource.updateRule(id, rule, token: token);
    } catch (e) {
      log('[RulesV2RepositoryImpl] updateRule error: $e');
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
      final result = await rewardsRemoteDataSource.getRewards(
        page: page,
        perPage: pageSize,
        search: search,
        token: token,
      );
      
      return SelectionResult<RewardResultModel>(
        items: result?.result ?? [],
        totalCount: result?.pagination?.count ?? 0,
        hasMore: (result?.result?.length ?? 0) >= pageSize,
        currentPage: page,
      );
    } catch (e) {
      log('[RulesV2RepositoryImpl] fetchRewards error: $e');
      return SelectionResult<RewardResultModel>(
        items: [],
        totalCount: 0,
        hasMore: false,
        currentPage: page,
      );
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
      final result = await productManagementRemoteDatasource.getProducts(
        token,
        page: page,
        perPage: pageSize,
      );
      
      // Filter by search if needed (since API might not support search)
      final filteredItems = search.isEmpty 
        ? result.result ?? []
        : (result.result ?? []).where((item) => 
            (item.name?.toLowerCase().contains(search.toLowerCase()) ?? false) ||
            (item.brand?.toLowerCase().contains(search.toLowerCase()) ?? false)
          ).toList();
      
      return SelectionResult<BarcodeResultModel>(
        items: filteredItems,
        totalCount: result.pagination?.count ?? 0,
        hasMore: (result.result?.length ?? 0) >= pageSize,
        currentPage: page,
      );
    } catch (e) {
      log('[RulesV2RepositoryImpl] fetchBarcodes error: $e');
      return SelectionResult<BarcodeResultModel>(
        items: [],
        totalCount: 0,
        hasMore: false,
        currentPage: page,
      );
    }
  }
}