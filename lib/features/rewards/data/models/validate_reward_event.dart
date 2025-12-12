import 'reward_result_file.dart';
import 'validate_reward_event_statistics.dart';

class ValidateRewardEventModel {
  final String? description;
  final DateTime? endDate;
  final String? eventType;
  final List<RewardResultFileModel>? files;
  final int? id;
  final String? name;
  final String? partnerName;
  final String? partnerUrl;
  final double? payout;
  final DateTime? startDate;
  final ValidateRewardEventStatisticsModel? statistics;
  final String? status;
  final String? tag;
  final List<String>? trashTypeList;

  ValidateRewardEventModel({
    this.description,
    this.endDate,
    this.eventType,
    this.files,
    this.id,
    this.name,
    this.partnerName,
    this.partnerUrl,
    this.payout,
    this.startDate,
    this.statistics,
    this.status,
    this.tag,
    this.trashTypeList,
  });

  factory ValidateRewardEventModel.fromJson(Map<String, dynamic> json) {
    return ValidateRewardEventModel(
      description: json['description'] as String?,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      eventType: json['event_type'] as String?,
      files: json['files'] != null
          ? List<RewardResultFileModel>.from(
              json['files'].map((x) => RewardResultFileModel.fromJson(x)),
            )
          : null,
      id: json['id'] as int?,
      name: json['name'] as String?,
      partnerName: json['partner_name'] as String?,
      partnerUrl: json['partner_url'] as String?,
      payout: json['payout'] as double?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      statistics: json['statistics'] != null
          ? ValidateRewardEventStatisticsModel.fromJson(json['statistics'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String?,
      tag: json['tag'] as String?,
      trashTypeList: json['trash_type_list'] != null
          ? List<String>.from(json['trash_type_list'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (description != null) 'description': description,
    if (endDate != null) 'end_date': endDate?.toIso8601String(),
    if (eventType != null) 'event_type': eventType,
    if (files != null) 'files': files?.map((x) => x.toJson()).toList(),
    if (id != null) 'id': id,
    if (name != null) 'name': name,
    if (partnerName != null) 'partner_name': partnerName,
    if (partnerUrl != null) 'partner_url': partnerUrl,
    if (payout != null) 'payout': payout,
    if (startDate != null) 'start_date': startDate?.toIso8601String(),
    if (statistics != null) 'statistics': statistics?.toJson(),
    if (status != null) 'status': status,
    if (tag != null) 'tag': tag,
    if (trashTypeList != null) 'trash_type_list': trashTypeList,
  };
}