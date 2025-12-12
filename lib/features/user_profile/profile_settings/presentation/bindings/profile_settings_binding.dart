import 'package:get/get.dart';

import '../controller/profile_settings_controller.impl.dart';
import '../controller/profile_settings_controller.interface.dart';
import '../presenter/profile_settings_presenter.impl.dart';
import '../presenter/profile_settings_presenter.interface.dart';

class ProfileSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSettingsControllerInterface>(
      () => ProfileSettingsControllerImpl(),
      fenix: true,
    );
    Get.lazyPut<ProfileSettingsPresenterInterface>(
      () => ProfileSettingsPresenterImpl(),
      fenix: true,
    );
  }
}
