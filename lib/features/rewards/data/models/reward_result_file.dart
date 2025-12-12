import 'reward_result_file_createdby.dart';

class RewardResultFileModel {
  final RewardResultFileCreatedByModel? createdBy;
  final String? fileName;
  final int? id;
  final String? mimeType;
  final int? size;
  final String? url;

  RewardResultFileModel({
    this.createdBy,
    this.fileName,
    this.id,
    this.mimeType,
    this.size,
    this.url,
  });

  factory RewardResultFileModel.fromJson(Map<String, dynamic> json) =>
      RewardResultFileModel(
        createdBy: json['created_by'] != null
            ? RewardResultFileCreatedByModel.fromJson(json['created_by'])
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