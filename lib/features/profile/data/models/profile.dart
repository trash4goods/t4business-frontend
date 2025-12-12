import '../../domain/entities/profile.dart';

class ProfileModel {
  final String email;
  final String name;
  final String? profilePictureUrl;
  final List<String> logoUrls;
  final String? mainLogoUrl;
  final String userId;

  const ProfileModel({
    required this.email,
    required this.name,
    this.profilePictureUrl,
    required this.logoUrls,
    this.mainLogoUrl,
    required this.userId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: json['email'] as String,
      name: json['name'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      logoUrls: List<String>.from(json['logoUrls'] ?? []),
      mainLogoUrl: json['mainLogoUrl'] as String?,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profilePictureUrl': profilePictureUrl,
      'logoUrls': logoUrls,
      'mainLogoUrl': mainLogoUrl,
      'userId': userId,
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      email: email,
      name: name,
      profilePictureUrl: profilePictureUrl,
      logoUrls: logoUrls,
      mainLogoUrl: mainLogoUrl,
      userId: userId,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      email: entity.email,
      name: entity.name,
      profilePictureUrl: entity.profilePictureUrl,
      logoUrls: entity.logoUrls,
      mainLogoUrl: entity.mainLogoUrl,
      userId: entity.userId,
    );
  }
}
