
abstract class ProfileUseCaseInterface {
  Future<String> uploadProfilePicture(String imagePath);
  Future<String> uploadLogo(String imagePath);
  Future<bool> deleteLogo(String logoUrl);
}
