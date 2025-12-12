import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/navigation.dart';

import '../../../../../core/app/app_routes.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../utils/helpers/snackbar_service.dart';
import '../../../domain/usecase/usecase.dart';
import '../../presenters/interface/dashboard.dart';
import '../interface/dashboard.dart';

class DashboardControllerImpl implements DashboardControllerInterface {
  DashboardControllerImpl(this.presenter, this._usecase);
  final DashboardPresenterInterface presenter;
  final DashboardUsecaseInterface _usecase;

  @override
  void refreshData() {
    presenter.loadDashboardData();
  }

  @override
  void toggleSidebar() {
    presenter.isCollapsed.toggle();
  }

  @override
  void navigateToPage(String route) {
    presenter.currentRoute.value = route;
  }

  @override
  Future<void> logout() async {
    try {
      await AuthService.instance.logout();
      NavigationService.offAll(AppRoutes.login);
    } catch (e) {
      showError('Logout failed: ${e.toString()}');
    }
  }

  void showError(String message) => SnackbarServiceHelper.showError(
    message,
    position: SnackPosition.TOP,
    actionLabel: 'Dismiss',
    onActionPressed: () => Get.back(),
  );

  void showSuccess(String message) => SnackbarServiceHelper.showSuccess(
    message,
    position: SnackPosition.TOP,
    actionLabel: 'OK',
  );
}
