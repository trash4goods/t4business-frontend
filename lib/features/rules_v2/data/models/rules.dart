import 'rules_pagination.dart';
import 'rules_result.dart';

class RulesModel {
  final RulesPaginationModel? pagination;
  final List<RulesResultModel>? result;

  RulesModel({
    this.pagination,
    this.result,
  });

  factory RulesModel.fromJson(Map<String, dynamic> json) {
    return RulesModel(
      pagination: json['pagination'] != null
          ? RulesPaginationModel.fromJson(json['pagination'])
          : null,
      result: json['result'] != null
          ? List<RulesResultModel>.from(
              json['result']?.map((x) => RulesResultModel.fromJson(x)) ?? []) : null 
          ,
    );
  }

  Map<String, dynamic> toJson() => {
        'pagination': pagination?.toJson(),
        'result': result?.map((x) => x.toJson()).toList(),
      };
}