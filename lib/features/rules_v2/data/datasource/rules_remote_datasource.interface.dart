import '../models/rules.dart';
import '../models/rules_result.dart';

abstract class RulesV2RemoteDataSourceInterface {
  Future<RulesModel?> getRules({
    int perPage = 10,
    int page = 1,
    String search = '',
    String token = '',
  });
    Future<RulesResultModel?> getRuleById(
    int id, {
    String token = '',
  });
  
  Future<void> createRule(
    RulesResultModel rule, {
    String token = '',
  });
  
  Future<void> updateRule(
    int id,
    RulesResultModel rule, {
    String token = '',
  });
  
  Future<void> deleteRule(
    int id, {
    String token = '',
  });
}