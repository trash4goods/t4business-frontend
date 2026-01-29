import 'package:hive_flutter/hive_flutter.dart';

part 'barcode_pagination.g.dart';

@HiveType(typeId: 12)
class BarcodePaginationModel {
  @HiveField(0)
  final int? count;
  @HiveField(1)
  final bool? hasNext;
  @HiveField(2)
  final int? page;
  @HiveField(3)
  final int? perPage;

  BarcodePaginationModel({this.count, this.hasNext, this.page, this.perPage});

  factory BarcodePaginationModel.fromJson(Map<String, dynamic> json) =>
      BarcodePaginationModel(
        count: json['count'] as int?,
        hasNext: json['has_next'] as bool?,
        page: json['page'] as int?,
        perPage: json['per_page'] as int?,
      );

  Map<String, dynamic> toJson() => {
    'count': count,
    'has_next': hasNext,
    'page': page,
    'per_page': perPage,
  };
}
