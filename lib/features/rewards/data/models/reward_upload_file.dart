

import 'package:hive_flutter/hive_flutter.dart';

part 'reward_upload_file.g.dart';

@HiveType(typeId: 24)
class RewardUploadFileModel {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final String? base64;

  RewardUploadFileModel({
    this.name,
    this.base64,
  });

  factory RewardUploadFileModel.fromJson(Map<String, dynamic> json) {
    return RewardUploadFileModel(
      name: json['name'] as String?,
      base64: json['base64'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (base64 != null) 'base64': base64,
  };
}