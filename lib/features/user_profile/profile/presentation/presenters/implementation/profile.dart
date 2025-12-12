import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/app/app_images.dart';
import '../../../../../../core/app/app_routes.dart';
import '../../../../../auth/data/datasources/auth_cache.dart';
import '../../../../../auth/data/models/user_auth/user_auth_model.dart';
import '../../../../../dashboard_shell/presentation/controller/dashboard_shell_controller.interface.dart';
import '../interface/profile.dart';

class ProfilePresenterImpl extends GetxController
    implements ProfilePresenterInterface {
  ProfilePresenterImpl({required this.dashboardShellController});
  final DashboardShellControllerInterface dashboardShellController;

  final RxString _currentRoute = AppRoutes.profile.obs;
  final _isLoading = RxBool(false);
  final _error = RxnString();
  final _profilePictureUrl = RxnString(AppImages.cocaColaLogo01);
  final _logoUrls = RxList<String>([
    AppImages.cocaColaLogo01,
    AppImages.cocaColaLogo02,
    AppImages.cocaColaLogo03,
  ]);
  final _mainLogoUrl = RxnString(
    AppImages.cocaColaLogo01,
  ); // Track the main logo

  final _userAuth = Rxn<UserAuthModel>(UserAuthModel());

  @override
  late GlobalKey<ScaffoldState> scaffoldKey;
  @override
  late RxString currentRoute = _currentRoute;
  @override
  void onNavigate(String value) =>
      dashboardShellController.handleMobileNavigation(value);
  @override
  void onLogout() => dashboardShellController.logout();
  @override
  void onToggle() => dashboardShellController.toggleSidebar();

  @override
  void onInit() {
    super.onInit();
    scaffoldKey = dashboardShellController.scaffoldKey;
    dashboardShellController.currentRoute.value = currentRoute.value;
    getUserAuth();
  }

  Future<void> getUserAuth() async {
    _userAuth.value = await AuthCacheDataSource.instance.getUserAuth();
    log("## ${_userAuth.value?.toJson() ?? 'no user auth'}");
  }

  @override
  final fullnameController = TextEditingController();
  @override
  final firstnameController = TextEditingController();
  @override
  final lastnameController = TextEditingController();
  @override
  final phoneController = TextEditingController();

  @override
  UserAuthModel? get userAuth => _userAuth.value;
  @override
  set userAuth(UserAuthModel? value) => _userAuth.value = value;

  @override
  bool get isLoading => _isLoading.value;

  @override
  String? get error => _error.value;

  @override
  String? get profilePictureUrl => _profilePictureUrl.value;

  @override
  List<String> get logoUrls => _logoUrls;

  @override
  String? get mainLogoUrl => _mainLogoUrl.value;

  @override
  RxBool get isLoadingRx => _isLoading;

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
  void updateName(String name) {
    _userAuth.value?.profile?.name = name;
    _userAuth.refresh();
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

  @override
  // TODO: implement userNameRx
  RxString get userNameRx => throw UnimplementedError();
}
