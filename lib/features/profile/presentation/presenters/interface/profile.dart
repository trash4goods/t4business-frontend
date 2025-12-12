import 'package:get/get.dart';
import '../../../domain/entities/profile.dart';

abstract class ProfilePresenterInterface extends GetxController {
  bool get isLoading;
  String? get error;
  String get userEmail;
  String get userName;
  String? get profilePictureUrl;
  List<String> get logoUrls;
  String? get mainLogoUrl;

  // Observable properties
  RxBool get isLoadingRx;
  RxString get userNameRx;
  RxnString get profilePictureUrlRx;
  RxList<String> get logoUrlsRx;
  RxnString get mainLogoUrlRx;

  void setLoading(bool loading);
  void setError(String? error);
  void setProfile(ProfileEntity profile);
  void updateName(String name);
  void updateProfilePicture(String? url);
  void addLogo(String url);
  void removeLogo(String url);
  void setMainLogo(String? url);
}
