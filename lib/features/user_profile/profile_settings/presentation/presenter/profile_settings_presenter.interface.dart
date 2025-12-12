import 'package:get/get.dart';

import '../../../profile_change_password/domain/entities/settings_category.dart';

abstract class ProfileSettingsPresenterInterface extends GetxController {
  // variables
  List<SettingsCategoryModel> get categories;
  bool get isLoading;

  // methods
  void refreshCategories();
}
