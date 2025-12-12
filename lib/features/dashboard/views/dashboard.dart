import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/widgets/sidebar_navigation.dart';
import '../../../core/app/custom_getview.dart';
import '../presentation/controllers/interface/dashboard.dart';
import '../presentation/presenters/interface/dashboard.dart';
import '../presentation/widgets/dashboard_content.dart';
import '../presentation/widgets/dashboard_main_section.dart';

class CustomNavigationService {
  // Navigate within nested navigator
  static Future<T?> toNested<T>(String route, {int? id = 1}) async {
    final navigator = Get.nestedKey(id)?.currentState;
    if (navigator != null) {
      return navigator.pushNamed<T>(route);
    }
    return null;
  }

  // Replace current nested route
  static Future<T?> offNested<T>(String route, {int? id = 1}) async {
    final navigator = Get.nestedKey(id)?.currentState;
    if (navigator != null) {
      return navigator.pushReplacementNamed<T, T>(route);
    }
    return null;
  }
}

class DashboardView
    extends
        CustomGetView<
          DashboardControllerInterface,
          DashboardPresenterInterface
        > {
  const DashboardView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      key: presenter.scaffoldKey,
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: Drawer(
        child: Obx(
          () => SidebarNavigation(
            currentRoute: presenter.currentRoute.value,
            isCollapsed: false,
            onToggle: presenter.onToggle,
            onNavigate: presenter.onNavigate,
            onLogout: presenter.onLogout,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return DashboardContent(
            constraints: constraints,
            selectedDateRangeText: presenter.selectedDateRangeText,
            onRefresh: businessController.refreshData,
            onDownloadReport: businessController.downloadReport,
            onShowDateRangePicker:
                () => businessController.showDateRangePicker(context),
            isLoading: () => presenter.isLoading,
            error: () => presenter.error,
            onRetry: businessController.refreshData,
            buildMainContent:
                (ctx, cons) => DashboardMainSection(
                  businessController: businessController,
                  presenter: presenter,
                  constraints: cons,
                ),
            scaffoldKey: presenter.scaffoldKey,
          );
        },
      ),
    );
  }
}
