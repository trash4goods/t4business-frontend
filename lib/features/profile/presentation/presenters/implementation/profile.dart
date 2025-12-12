import 'package:get/get.dart';
import 'package:t4g_for_business/core/app/app_images.dart';
import '../../../domain/entities/profile.dart';
import '../interface/profile.dart';

class ProfilePresenterImpl extends GetxController
    implements ProfilePresenterInterface {
  final _isLoading = RxBool(false);
  final _error = RxnString();
  final _userEmail = RxString('admin@cocacola.com');
  final _userName = RxString('Coca cola Admin');
  final _profilePictureUrl = RxnString(AppImages.cocaColaLogo01);
  final _logoUrls = RxList<String>([
    AppImages.cocaColaLogo01,
    AppImages.cocaColaLogo02,
    AppImages.cocaColaLogo03,
  ]);
  final _mainLogoUrl = RxnString(
    AppImages.cocaColaLogo01,
  ); // Track the main logo

  @override
  bool get isLoading => _isLoading.value;

  @override
  String? get error => _error.value;

  @override
  String get userEmail => _userEmail.value;

  @override
  String get userName => _userName.value;

  @override
  String? get profilePictureUrl => _profilePictureUrl.value;

  @override
  List<String> get logoUrls => _logoUrls;

  @override
  String? get mainLogoUrl => _mainLogoUrl.value;

  @override
  RxBool get isLoadingRx => _isLoading;

  @override
  RxString get userNameRx => _userName;

  @override
  RxnString get profilePictureUrlRx => _profilePictureUrl;

  @override
  RxList<String> get logoUrlsRx => _logoUrls;

  @override
  RxnString get mainLogoUrlRx => _mainLogoUrl;

  @override
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  @override
  void setError(String? error) {
    _error.value = error;
  }

  @override
  void setProfile(ProfileEntity profile) {
    _userEmail.value = profile.email;
    _userName.value = profile.name;
    _profilePictureUrl.value = profile.profilePictureUrl;
    _logoUrls.assignAll(profile.logoUrls);
    _mainLogoUrl.value = profile.mainLogoUrl;
  }

  @override
  void updateName(String name) {
    _userName.value = name;
  }

  @override
  void updateProfilePicture(String? url) {
    _profilePictureUrl.value = url;
  }

  @override
  void addLogo(String url) {
    _logoUrls.add(url);
  }

  @override
  void removeLogo(String url) {
    _logoUrls.remove(url);
    // If removing the main logo, clear the main logo
    if (_mainLogoUrl.value == url) {
      _mainLogoUrl.value = null;
    }
  }

  @override
  void setMainLogo(String? url) {
    _mainLogoUrl.value = url;
  }
}
