import 'package:get/get.dart';

import '../../../profile_change_password/domain/entities/settings_category.dart';
import '../../../utils/profile_settings_utils.dart';
import '../../../profile/presentation/presenters/interface/profile.dart';
import 'profile_settings_presenter.interface.dart';

class ProfileSettingsPresenterImpl extends ProfileSettingsPresenterInterface {
  ProfileSettingsPresenterImpl();

  final _categories = Rx<List<SettingsCategoryModel>>([]);
  final _isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _refreshCategories();

    // Listen for changes in user auth to refresh categories
    try {
      final profilePresenter = Get.find<ProfilePresenterInterface>();
      // Watch for changes in user auth and refresh categories accordingly
      ever(profilePresenter.isLoadingRx, (_) => _refreshCategories());
    } catch (e) {
      // Profile presenter might not be available, continue with initial categories
    }
  }

  @override
  List<SettingsCategoryModel> get categories => _categories.value;

  @override
  bool get isLoading => _isLoading.value;

  /// Refreshes the categories based on current user permissions
  void _refreshCategories() {
    _categories.value = ProfileSettingsUtils.getCategories();
  }

  /// Public method to manually refresh categories
  @override
  void refreshCategories() {
    _refreshCategories();
  }
}
