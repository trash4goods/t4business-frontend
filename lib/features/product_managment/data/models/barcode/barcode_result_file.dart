import 'package:hive_flutter/hive_flutter.dart';

import 'barcode_result_file_createdby.dart';

part 'barcode_result_file.g.dart';

@HiveType(typeId: 20)
class BarcodeResultFileModel {
  @HiveField(0)
  final BarcodeResultFileCreatedByModel? createdBy;
  @HiveField(1)
  final String? fileName;
  @HiveField(2)
  final int? id;
  @HiveField(3)
  final String? mimeType;
  @HiveField(4)
  final int? size;
  @HiveField(5)
  String? url;

  BarcodeResultFileModel({
    this.createdBy,
    this.fileName,
    this.id,
    this.mimeType,
    this.size,
    this.url,
  });

  factory BarcodeResultFileModel.fromJson(Map<String, dynamic> json) =>
      BarcodeResultFileModel(
        createdBy:
            json['created_by'] != null
                ? BarcodeResultFileCreatedByModel.fromJson(json['created_by'])
                : null,
        fileName: json['file_name'] as String?,
        id: json['id'] as int?,
        mimeType: json['mime_type'] as String?,
        size: json['size'] as int?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'created_by': createdBy?.toJson(),
    'file_name': fileName,
    'id': id,
    'mime_type': mimeType,
    'size': size,
    'url': url,
  };
}
