import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/navigation.dart';

import '../../../../../core/app/app_routes.dart';
import '../../../profile_delete_account/presentation/bindings/profile_delete_account_bindings.dart';
import '../../../profile_delete_account/presentation/controller/profile_delete_account_controller.interface.dart';
import 'profile_settings_controller.interface.dart';

class ProfileSettingsControllerImpl
    implements ProfileSettingsControllerInterface {
  ProfileSettingsControllerImpl();

  @override
  void onBack() => NavigationService.back();

  @override
  void onCategoryTapped(String categoryId) {
    switch (categoryId) {
      case 'change_password':
        navigateTo(AppRoutes.profileChangePassword);
        break;
      case 'delete_user':
        _showDeleteAccountDialog();
        break;
      case 'transfer_ownership':
        navigateTo(AppRoutes.transferOwnership);
        break;
      case 'manage_team':
        navigateTo(AppRoutes.manageTeam);
        break;
      case 'leave_department':
        navigateTo(AppRoutes.leaveDepartment);
        break;
      case 'answer_invite':
        navigateTo(AppRoutes.answerInvite);
        break;
    }
  }

  void navigateTo(String route) => NavigationService.to(route);

  /// Shows the delete account confirmation dialog
  ///
  /// Initializes the delete account dependencies and displays the dialog
  /// using the delete account controller's showDeleteDialog method.
  Future<void> _showDeleteAccountDialog() async {
    // Initialize delete account dependencies
    ProfileDeleteAccountBindings().dependencies();

    // Get the delete account controller and show dialog
    final deleteAccountController =
        Get.find<ProfileDeleteAccountControllerInterface>();
    await deleteAccountController.showDeleteDialog();
  }
}
