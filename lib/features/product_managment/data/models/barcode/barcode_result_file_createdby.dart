import 'package:hive_flutter/hive_flutter.dart';

part 'barcode_result_file_createdby.g.dart';

@HiveType(typeId: 21)
class BarcodeResultFileCreatedByModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;

  BarcodeResultFileCreatedByModel({this.id, this.name});

  factory BarcodeResultFileCreatedByModel.fromJson(Map<String, dynamic> json) =>
      BarcodeResultFileCreatedByModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
