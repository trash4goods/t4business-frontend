import 'package:hive_flutter/hive_flutter.dart';

import 'department_file_model.dart';
part 'department_model.g.dart';

// DepartmentModel - Department information
@HiveType(typeId: 7)
class DepartmentModel {
  @HiveField(0)
  final String? departmentType;
  @HiveField(1)
  final String? departmentUrl;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final String? domain;
  @HiveField(4)
  final List<DepartmentFileModel>? files;
  @HiveField(5)
  final int? id;
  @HiveField(6)
  final String? name;
  @HiveField(7)
  final String? status;
  @HiveField(8)
  final String? t4bTier;

  DepartmentModel({
    this.departmentType,
    this.departmentUrl,
    this.description,
    this.domain,
    this.files,
    this.id,
    this.name,
    this.status,
    this.t4bTier,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentType: json['department_type'] as String?,
      departmentUrl: json['department_url'] as String?,
      description: json['description'] as String?,
      domain: json['domain'] as String?,
      files: json['files'] != null
          ? List<DepartmentFileModel>.from(
              json['files'].map(
                (item) => DepartmentFileModel.fromJson(item),
              ),
            )
          : null,
      id: json['id'] as int?,
      name: json['name'] as String?,
      status: json['status'] as String?,
      t4bTier: json['t4b_tier'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'department_type': departmentType,
        'department_url': departmentUrl,
        'description': description,
        'domain': domain,
        'files': files?.map((file) => file.toJson()).toList(),
        'id': id,
        'name': name,
        'status': status,
        't4b_tier': t4bTier,
      };
}