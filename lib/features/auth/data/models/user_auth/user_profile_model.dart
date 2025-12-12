import 'package:hive_flutter/hive_flutter.dart';

import 'user_preferences_model.dart';
import 'user_profile_full_roles.dart';
import 'user_profile_partners_departments.dart';
import 'user_statistics_model.dart';

part 'user_profile_model.g.dart'; 

// UserProfileModel - User profile information
@HiveType(typeId: 1)
class UserProfileModel {
  @HiveField(0)
  int? credits1;
  @HiveField(1)
  int? credits2;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? emailVerifiedAt;
  @HiveField(4)
  String? expoToken;
  @HiveField(5)
  String? fcmToken;
  @HiveField(6)
  String? firstName;
  @HiveField(7)
  List<UserProfileFullRolesModel>? fullRoles;
  @HiveField(8)
  String? googleToken;
  @HiveField(9)
  int? id;
  @HiveField(10)
  String? insertedAt;
  @HiveField(11)
  bool? isAdmin;
  @HiveField(12)
  String? lastName;
  @HiveField(13)
  String? name;
  @HiveField(14)
  String? phoneIndicative;
  @HiveField(15)
  String? phoneNumber;
  @HiveField(16)
  UserPreferencesModel? preferences;
  @HiveField(17)
  List<String>? roles;
  @HiveField(18)
  UserStatisticsModel? statistics;
  @HiveField(19)
  String? status;
  @HiveField(20)
  List<UserPartnersDepartmentModel>? userPartnersDepartments;
  @HiveField(21)
  String? username;
  @HiveField(22)
  int? utcOffsetH;
  @HiveField(23)
  int? utcOffsetM;

  UserProfileModel({
    this.credits1,
    this.credits2,
    this.email,
    this.emailVerifiedAt,
    this.expoToken,
    this.fcmToken,
    this.firstName,
    this.fullRoles,
    this.googleToken,
    this.id,
    this.insertedAt,
    this.isAdmin,
    this.lastName,
    this.name,
    this.phoneIndicative,
    this.phoneNumber,
    this.preferences,
    this.roles,
    this.statistics,
    this.status,
    this.userPartnersDepartments,
    this.username,
    this.utcOffsetH,
    this.utcOffsetM,
  });


  bool get isUserAdmin => fullRoles?.any((role) => role.name == 'owner') ?? false;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      credits1: json['credits1'] as int?,
      credits2: json['credits2'] as int?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      expoToken: json['expo_token'] as String?,
      fcmToken: json['fcm_token'] as String?,
      firstName: json['first_name'] as String?,
      fullRoles:
          json['full_roles'] != null
              ? List<UserProfileFullRolesModel>.from(
                json['full_roles'].map(
                  (item) => UserProfileFullRolesModel.fromJson(item),
                ),
              )
              : null,
      googleToken: json['google_token'] as String?,
      id: json['id'] as int?,
      insertedAt: json['inserted_at'] as String?,
      isAdmin: json['is_admin'] as bool?,
      lastName: json['last_name'] as String?,
      name: json['name'] as String?,
      phoneIndicative: json['phone_indicative'] as String?,
      phoneNumber: json['phone_number'] as String?,
      preferences:
          json['preferences'] != null
              ? UserPreferencesModel.fromJson(
                json['preferences'] as Map<String, dynamic>,
              )
              : null,
      roles:
          json['roles'] != null
              ? List<String>.from(json['roles'] as List<dynamic>)
              : null,
      statistics:
          json['statistics'] != null
              ? UserStatisticsModel.fromJson(
                json['statistics'] as Map<String, dynamic>,
              )
              : null,
      status: json['status'] as String?,
      userPartnersDepartments:
          json['user_partners_departments'] != null
              ? List<UserPartnersDepartmentModel>.from(
                json['user_partners_departments'].map(
                  (item) => UserPartnersDepartmentModel.fromJson(item),
                ),
              )
              : null,
      username: json['username'] as String?,
      utcOffsetH: json['utc_offset_h'] as int?,
      utcOffsetM: json['utc_offset_m'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'credits1': credits1,
    'credits2': credits2,
    'email': email,
    'email_verified_at': emailVerifiedAt,
    'expo_token': expoToken,
    'fcm_token': fcmToken,
    'first_name': firstName,
    'full_roles': fullRoles?.map((e) => e.toJson()).toList(),
    'google_token': googleToken,
    'id': id,
    'inserted_at': insertedAt,
    'is_admin': isAdmin,
    'last_name': lastName,
    'name': name,
    'phone_indicative': phoneIndicative,
    'phone_number': phoneNumber,
    'preferences': preferences?.toJson(),
    'roles': roles,
    'statistics': statistics?.toJson(),
    'status': status,
    'user_partners_departments': userPartnersDepartments?.map((e) => e.toJson()).toList(),
    'username': username,
    'utc_offset_h': utcOffsetH,
    'utc_offset_m': utcOffsetM,
  };
}
