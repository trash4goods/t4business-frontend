import 'package:hive_flutter/hive_flutter.dart';

import 'year_statistics_model.dart';
part 'user_statistics_model.g.dart';

// UserStatisticsModel - User statistics
@HiveType(typeId: 4)
class UserStatisticsModel {
  @HiveField(0)
  final int? totalActions;
  @HiveField(1)
  final int? totalBins;
  @HiveField(2)
  final int? totalCO2;
  @HiveField(3)
  final int? totalEvents;
  @HiveField(4)
  final int? totalPodiums;
  @HiveField(5)
  final int? totalPrizes;
  @HiveField(6)
  final int? totalProducts;
  @HiveField(7)
  final int? totalReports;
  @HiveField(8)
  final int? totalScans;
  @HiveField(9)
  final List<YearStatisticsModel>? years;

  UserStatisticsModel({
    this.totalActions,
    this.totalBins,
    this.totalCO2,
    this.totalEvents,
    this.totalPodiums,
    this.totalPrizes,
    this.totalProducts,
    this.totalReports,
    this.totalScans,
    this.years,
  });

  factory UserStatisticsModel.fromJson(Map<String, dynamic> json) {
    return UserStatisticsModel(
      totalActions: json['totalActions'] as int?,
      totalBins: json['totalBins'] as int?,
      totalCO2: json['totalCO2'] as int?,
      totalEvents: json['totalEvents'] as int?,
      totalPodiums: json['totalPodiums'] as int?,
      totalPrizes: json['totalPrizes'] as int?,
      totalProducts: json['totalProducts'] as int?,
      totalReports: json['totalReports'] as int?,
      totalScans: json['totalScans'] as int?,
      years:
          json['years'] != null
              ? (json['years'] as List<dynamic>)
                  .map(
                    (year) => YearStatisticsModel.fromJson(
                      year as Map<String, dynamic>,
                    ),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalActions': totalActions,
    'totalBins': totalBins,
    'totalCO2': totalCO2,
    'totalEvents': totalEvents,
    'totalPodiums': totalPodiums,
    'totalPrizes': totalPrizes,
    'totalProducts': totalProducts,
    'totalReports': totalReports,
    'totalScans': totalScans,
    'years': years?.map((year) => year.toJson()).toList(),
  };
}
