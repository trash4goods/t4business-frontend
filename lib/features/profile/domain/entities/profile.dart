class ProfileEntity {
  final String email;
  final String name;
  final String? profilePictureUrl;
  final List<String> logoUrls;
  final String? mainLogoUrl; // Primary logo URL
  final String userId;

  const ProfileEntity({
    required this.email,
    required this.name,
    this.profilePictureUrl,
    required this.logoUrls,
    this.mainLogoUrl,
    required this.userId,
  });

  ProfileEntity copyWith({
    String? email,
    String? name,
    String? profilePictureUrl,
    List<String>? logoUrls,
    String? mainLogoUrl,
    String? userId,
  }) {
    return ProfileEntity(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      logoUrls: logoUrls ?? this.logoUrls,
      mainLogoUrl: mainLogoUrl ?? this.mainLogoUrl,
      userId: userId ?? this.userId,
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

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      email: json['email'] as String,
      name: json['name'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      logoUrls: List<String>.from(json['logoUrls'] ?? []),
      mainLogoUrl: json['mainLogoUrl'] as String?,
      userId: json['userId'] as String,
    );
  }
}
