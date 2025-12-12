// UserPreferencesModel - User preferences
import 'package:hive_flutter/hive_flutter.dart';

part 'user_preferences_model.g.dart';

@HiveType(typeId: 3)
class UserPreferencesModel {
  @HiveField(0)
  final String? language;
  @HiveField(1)
  final bool? reportingFlag;
  @HiveField(2)
  final int? userId;

  UserPreferencesModel({this.language, this.reportingFlag, this.userId});

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      language: json['language'] as String?,
      reportingFlag: json['reporting_flag'] as bool?,
      userId: json['user_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language,
    'reporting_flag': reportingFlag,
    'user_id': userId,
  };
}
