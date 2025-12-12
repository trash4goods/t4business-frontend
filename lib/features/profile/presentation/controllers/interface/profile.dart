abstract class ProfileControllerInterface {
  Future<void> loadProfile();
  Future<void> updateName(String name);
  Future<void> uploadProfilePicture();
  Future<void> uploadLogo();
  Future<void> deleteLogo(String logoUrl);
  Future<void> setMainLogo(String logoUrl);
  Future<void> saveProfile();
}
