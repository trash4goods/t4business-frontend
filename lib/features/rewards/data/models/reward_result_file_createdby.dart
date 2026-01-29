import 'package:hive_flutter/hive_flutter.dart';

part 'reward_result_file_createdby.g.dart';

@HiveType(typeId: 23)
class RewardResultFileCreatedByModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;

  RewardResultFileCreatedByModel({this.id, this.name});

  factory RewardResultFileCreatedByModel.fromJson(Map<String, dynamic> json) =>
      RewardResultFileCreatedByModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
