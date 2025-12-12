import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/services/navigation.dart';

import '../../../../core/app/app_routes.dart';
import '../../../../utils/helpers/snackbar_service.dart';
import '../../../dashboard/views/dashboard.dart';
import '../../data/usecase/dashboard_shell_usecase.interface.dart';
import '../presenter/dashboard_shell_presenter.interface.dart';
import 'dashboard_shell_controller.interface.dart';

class DashboardShellControllerImpl extends DashboardShellControllerInterface {
  DashboardShellControllerImpl({
    required this.presenter,
    required this.usecase,
  });

  final DashboardShellPresenterInterface presenter;
  final DashboardShellUsecaseInterface usecase;

  @override
  Future<void> logout() async {
    try {
      await usecase.signOut();
      NavigationService.offAll(AppRoutes.login);
    } catch (e) {
      showError('Logout failed: ${e.toString()}');
    }
  }

  @override
  void navigateToPage(String route) {
    // Update observable for sidebar highlighting
    presenter.currentRoute = route;

    // Navigate using nested navigator
    CustomNavigationService.offNested(route);
    NavigationService.to(route);
  }

  @override
  void handleMobileNavigation(String route) {
    // Close any open drawer or route if possible, then navigate
    try {
      if (Get.isOverlaysOpen == true) {
        // If an overlay like Drawer is open, try to close it
        Get.back();
      } else if (Get.key.currentState?.canPop() == true) {
        Get.back();
      }
    } catch (e) {
      // Fallback if overlay check fails
      if (Get.isBottomSheetOpen == true ||
          Get.isDialogOpen == true ||
          Get.isSnackbarOpen == true) {
        Get.back();
      }
    }
    navigateToPage(route);
  }

  @override
  void toggleSidebar() => presenter.isCollapsed = !presenter.isCollapsed;

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

  @override
  RxString get currentRoute => presenter.currentRoute.obs;

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => presenter.scaffoldKey;
}
