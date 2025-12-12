import 'package:hive_flutter/hive_flutter.dart';

import 'user_profile_model.dart';

part 'user_auth_model.g.dart';

// UserAuthModel - Main authentication response model
@HiveType(typeId: 0)
class UserAuthModel {
  @HiveField(0)
  String? accessToken;
  @HiveField(1)
  String? expiresIn;
  @HiveField(2)
  UserProfileModel? profile;
  @HiveField(3)
  String? refreshToken;
  @HiveField(4)
  String? tokenType;

  UserAuthModel({
    this.accessToken,
    this.expiresIn,
    this.profile,
    this.refreshToken,
    this.tokenType,
  });

  factory UserAuthModel.fromJson(Map<String, dynamic> json) {
    return UserAuthModel(
      accessToken: json['access_token'] as String?,
      expiresIn: json['expires_in'] as String?,
      profile:
          json['profile'] != null
              ? UserProfileModel.fromJson(
                json['profile'] as Map<String, dynamic>,
              )
              : null,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'expires_in': expiresIn,
    'profile': profile?.toJson(),
    'refresh_token': refreshToken,
    'token_type': tokenType,
  };
}
