import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../auth/data/models/user_auth/user_auth_model.dart';

abstract class ProfilePresenterInterface extends GetxController {
  // global from parent DashboardShell
  GlobalKey<ScaffoldState> get scaffoldKey;
  RxString get currentRoute;
  void onNavigate(String route);
  void onLogout();
  void onToggle();
  // Core data observables
  bool get isLoading;
  String? get error;
  String? get profilePictureUrl;
  List<String> get logoUrls;
  String? get mainLogoUrl;

  UserAuthModel? get userAuth;
  set userAuth(UserAuthModel? value);

  // Observable properties
  RxBool get isLoadingRx;
  RxnString get profilePictureUrlRx;
  RxList<String> get logoUrlsRx;
  RxnString get mainLogoUrlRx;

  // Personal Information text field controllers
  TextEditingController get fullnameController;
  TextEditingController get firstnameController;
  TextEditingController get lastnameController;
  TextEditingController get phoneController;

  void setLoading(bool loading);
  void setError(String? error);
  void updateName(String name);
  void updateProfilePicture(String? url);
  void addLogo(String url);
  void removeLogo(String url);
  void setMainLogo(String? url);
}
