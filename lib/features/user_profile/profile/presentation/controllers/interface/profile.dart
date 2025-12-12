abstract class ProfileControllerInterface {
  Future<void> loadProfile();
  Future<void> updateName(String name);
  Future<void> updateFirstName(String firstName);
  Future<void> updateLastName(String lastName);
  Future<void> updatePhoneNumber(String phoneNumber);
  Future<void> uploadProfilePicture();
  Future<void> uploadLogo();
  Future<void> deleteLogo(String logoUrl);
  Future<void> setMainLogo(String logoUrl);
  Future<void> saveProfile();
}
