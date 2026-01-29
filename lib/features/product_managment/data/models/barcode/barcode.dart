import 'package:hive_flutter/hive_flutter.dart';

import 'barcode_pagination.dart';
import 'barcode_result.dart';

part 'barcode.g.dart';

@HiveType(typeId: 11)
class BarcodeModel {
  @HiveField(0)
  final BarcodePaginationModel? pagination;
  @HiveField(1)
  final List<BarcodeResultModel>? result;

  BarcodeModel({this.pagination, this.result});

  factory BarcodeModel.fromJson(Map<String, dynamic> json) => BarcodeModel(
    pagination:
        json['pagination'] != null
            ? BarcodePaginationModel.fromJson(json['pagination'])
            : null,
    result:
        json['result'] != null
            ? List<BarcodeResultModel>.from(
              json['result'].map((x) => BarcodeResultModel.fromJson(x)),
            )
            : null,
  );

  Map<String, dynamic> toJson() => {
    'pagination': pagination?.toJson(),
    'result': result?.map((value) => value.toJson()).toList(),
  };
}
