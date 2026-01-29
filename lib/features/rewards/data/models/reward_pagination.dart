import 'package:hive_flutter/hive_flutter.dart';

part 'reward_pagination.g.dart';

@HiveType(typeId: 18)
class RewardPaginationModel {
  @HiveField(0)
  final int? count;
  @HiveField(1)
  final bool? hasNext;
  @HiveField(2)
  final int? page;
  @HiveField(3)
  final int? perPage;

  RewardPaginationModel({this.count, this.hasNext, this.page, this.perPage});

  factory RewardPaginationModel.fromJson(Map<String, dynamic> json) {
    return RewardPaginationModel(
      count: json['count'] as int?,
      hasNext: json['has_next'] as bool?,
      page: json['page'] as int?,
      perPage: json['per_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'has_next': hasNext,
    'page': page,
    'per_page': perPage,
  };
}
