import 'package:hive_flutter/hive_flutter.dart';

part 'rules_pagination.g.dart';

@HiveType(typeId: 15)
class RulesPaginationModel {
  @HiveField(0)
  final int? count;
  @HiveField(1)
  final bool? hasNext;
  @HiveField(2)
  final int? page;
  @HiveField(3)
  final int? perPage;

  RulesPaginationModel({this.count, this.hasNext, this.page, this.perPage});

  factory RulesPaginationModel.fromJson(Map<String, dynamic> json) {
    return RulesPaginationModel(
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
