import '../../../data/repositories/interface/profile.dart';
import '../../entities/profile.dart';
import '../interface/profile.dart';

class ProfileUseCaseImpl implements ProfileUseCaseInterface {
  final ProfileRepositoryInterface _repository;

  ProfileUseCaseImpl(this._repository);

  @override
  Future<ProfileEntity?> getUserProfile(String userId) async {
    try {
      return await _repository.getUserProfile(userId);
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  @override
  Future<bool> updateUserProfile(ProfileEntity profile) async {
    try {
      return await _repository.updateUserProfile(profile);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfilePicture(String imagePath) async {
    try {
      return await _repository.uploadProfilePicture(imagePath);
    } catch (e) {
      throw Exception('Failed to upload profile picture: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadLogo(String imagePath) async {
    try {
      return await _repository.uploadLogo(imagePath);
    } catch (e) {
      throw Exception('Failed to upload logo: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteLogo(String logoUrl) async {
    try {
      return await _repository.deleteLogo(logoUrl);
    } catch (e) {
      throw Exception('Failed to delete logo: ${e.toString()}');
    }
  }
}
