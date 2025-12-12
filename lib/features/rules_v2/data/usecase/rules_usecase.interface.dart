import '../models/rules.dart';
import '../models/rules_result.dart';
import '../models/selection_result.dart';
import '../../../rewards/data/models/reward_result.dart';
import '../../../product_managment/data/models/barcode/barcode_result.dart';

abstract class RulesV2UseCaseInterface {
  Future<RulesModel?> getRules({
    int perPage = 10,
    int page = 1,
    String search = '',
    String token = '',
  });
  Future<RulesResultModel?> getRuleById(int id, {String token = ''});

  Future<void> createRule(RulesResultModel rule, {String token = ''});

  Future<void> updateRule(int id, RulesResultModel rule, {String token = ''});

  Future<void> deleteRule(int id, {String token = ''});

  Future<SelectionResult<RewardResultModel>> fetchRewards({
    int page = 1,
    int pageSize = 20,
    String search = '',
    required String token,
  });

  Future<SelectionResult<BarcodeResultModel>> fetchBarcodes({
    int page = 1,
    int pageSize = 20,
    String search = '',
    required String token,
  });
}
