import 'package:hive_flutter/hive_flutter.dart';

import 'created_by_model.dart';
part 'department_file_model.g.dart';

// DepartmentFileModel - File within a department
@HiveType(typeId: 9)
class DepartmentFileModel {
  @HiveField(0)
  final CreatedByModel? createdBy;
  @HiveField(1)
  final String? fileName;
  @HiveField(2)
  final int? id;
  @HiveField(3)
  final String? mimeType;
  @HiveField(4)
  final int? size;
  @HiveField(5)
  final String? url;

  DepartmentFileModel({
    this.createdBy,
    this.fileName,
    this.id,
    this.mimeType,
    this.size,
    this.url,
  });

  factory DepartmentFileModel.fromJson(Map<String, dynamic> json) {
    return DepartmentFileModel(
      createdBy: json['created_by'] != null
          ? CreatedByModel.fromJson(json['created_by'] as Map<String, dynamic>)
          : null,
      fileName: json['file_name'] as String?,
      id: json['id'] as int?,
      mimeType: json['mime_type'] as String?,
      size: json['size'] as int?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'created_by': createdBy?.toJson(),
        'file_name': fileName,
        'id': id,
        'mime_type': mimeType,
        'size': size,
        'url': url,
      };
}