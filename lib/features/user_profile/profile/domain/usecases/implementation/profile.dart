import '../../../data/repositories/interface/profile.dart';
import '../interface/profile.dart';

class ProfileUseCaseImpl implements ProfileUseCaseInterface {
  final ProfileRepositoryInterface _repository;

  ProfileUseCaseImpl(this._repository);

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
