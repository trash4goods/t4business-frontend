import 'package:hive_flutter/hive_flutter.dart';

import 'reward_pagination.dart';
import 'reward_result.dart';

part 'reward.g.dart';

@HiveType(typeId: 17)
class RewardModel {
  @HiveField(0)
  final RewardPaginationModel? pagination;
  @HiveField(1)
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