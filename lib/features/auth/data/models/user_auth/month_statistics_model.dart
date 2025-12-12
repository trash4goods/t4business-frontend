// MonthStatisticsModel - Monthly statistics
import 'package:hive_flutter/hive_flutter.dart';

part 'month_statistics_model.g.dart';

@HiveType(typeId: 8)
class MonthStatisticsModel {
  @HiveField(0)
  final int? actions;
  @HiveField(1)
  final int? month;
  @HiveField(2)
  final List<int>? metal;
  @HiveField(3)
  final List<int>? plastic;

  MonthStatisticsModel({this.actions, this.month, this.metal, this.plastic});

  factory MonthStatisticsModel.fromJson(Map<String, dynamic> json) {
    return MonthStatisticsModel(
      actions: json['actions'] as int?,
      month: json['month'] as int?,
      metal:
          json['metal'] != null
              ? List<int>.from(json['metal'] as List<dynamic>)
              : null,
      plastic:
          json['plastic'] != null
              ? List<int>.from(json['plastic'] as List<dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'actions': actions,
    'month': month,
    'metal': metal,
    'plastic': plastic,
  };
}
