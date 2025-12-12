import '../../../domain/entities/profile.dart';

abstract class ProfileRepositoryInterface {
  Future<ProfileEntity?> getUserProfile(String userId);
  Future<bool> updateUserProfile(ProfileEntity profile);
  Future<String> uploadProfilePicture(String imagePath);
  Future<String> uploadLogo(String imagePath);
  Future<bool> deleteLogo(String logoUrl);
}
