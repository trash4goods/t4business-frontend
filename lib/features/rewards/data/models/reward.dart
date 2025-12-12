import 'reward_pagination.dart';
import 'reward_result.dart';

class RewardModel {
  final RewardPaginationModel? pagination;
  final List<RewardResultModel>? result;

  RewardModel({
    this.pagination,
    this.result,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      pagination: json['pagination'] != null
          ? RewardPaginationModel.fromJson(json['pagination'])
          : null,
      result: json['result'] != null
          ? List<RewardResultModel>.from(
              json['result']?.map((x) => RewardResultModel.fromJson(x)) ?? []) : null 
          ,
    );
  }

  Map<String, dynamic> toJson() => {
        'pagination': pagination?.toJson(),
        'result': result?.map((x) => x.toJson()).toList(),
      };
}