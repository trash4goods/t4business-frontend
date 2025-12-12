import 'package:hive_flutter/hive_flutter.dart';

import 'month_statistics_model.dart';
part 'year_statistics_model.g.dart';

// YearStatisticsModel - Yearly statistics
@HiveType(typeId: 6)
class YearStatisticsModel {
  @HiveField(0)
  final int? co2;
  @HiveField(1)
  final int? bins;
  @HiveField(2)
  final int? events;
  @HiveField(3)
  final List<MonthStatisticsModel>? months;
  @HiveField(4)
  final int? podiums;
  @HiveField(5)
  final int? prizes;
  @HiveField(6)
  final int? products;
  @HiveField(7)
  final int? reports;
  @HiveField(8)
  final int? scans;
  @HiveField(9)
  final int? year;

  YearStatisticsModel({
    this.co2,
    this.bins,
    this.events,
    this.months,
    this.podiums,
    this.prizes,
    this.products,
    this.reports,
    this.scans,
    this.year,
  });

  factory YearStatisticsModel.fromJson(Map<String, dynamic> json) {
    return YearStatisticsModel(
      co2: json['CO2'] as int?,
      bins: json['bins'] as int?,
      events: json['events'] as int?,
      months:
          json['months'] != null
              ? (json['months'] as List<dynamic>)
                  .map(
                    (month) => MonthStatisticsModel.fromJson(
                      month as Map<String, dynamic>,
                    ),
                  )
                  .toList()
              : null,
      podiums: json['podiums'] as int?,
      prizes: json['prizes'] as int?,
      products: json['products'] as int?,
      reports: json['reports'] as int?,
      scans: json['scans'] as int?,
      year: json['year'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'CO2': co2,
    'bins': bins,
    'events': events,
    'months': months?.map((month) => month.toJson()).toList(),
    'podiums': podiums,
    'prizes': prizes,
    'products': products,
    'reports': reports,
    'scans': scans,
    'year': year,
  };
}
