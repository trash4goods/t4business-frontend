import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/app_routes.dart';
import '../../../../core/app/constants.dart';
import '../../../../core/app/custom_getview.dart';
import '../../../../core/widgets/sidebar_navigation.dart';
import '../../../../core/utils/municipality_utils.dart';
import '../../../dashboard/presentation/bindings/dashboard.dart';
import '../../../dashboard/views/dashboard.dart';
import '../../../product_managment/presentation/bindings/product.dart';
import '../../../product_managment/presentation/view/product.dart';
import '../../../rewards/presentation/bindings/rewards.dart';
import '../../../rewards/presentation/views/rewards.dart';
import '../../../rules_v2/presentation/binding/rules_v2_binding.dart';
import '../../../rules_v2/presentation/view/rules_v2.dart';
import '../../../user_profile/profile/presentation/bindings/profile.dart';
import '../../../user_profile/profile/presentation/views/profile.dart';
import '../controller/dashboard_shell_controller.interface.dart';
import '../presenter/dashboard_shell_presenter.interface.dart';

class DashboardShellView
    extends
        CustomGetView<
          DashboardShellControllerInterface,
          DashboardShellPresenterInterface
        > {
  const DashboardShellView({super.key});

  @override
  Widget buildView(BuildContext context) {
    final isMobile = Get.size.width < AppConstants.tabletBreakpoint;
    log('isMobile: bool: $isMobile, size: ${Get.size.width}');
    
    return FutureBuilder<bool>(
      future: MunicipalityUtils.isMunicipalityUser(),
      builder: (context, snapshot) {
        // Show loading indicator while checking municipality status
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final isMunicipality = snapshot.data ?? false;
        // Set initial route based on municipality status
        final initialRoute = isMunicipality ? AppRoutes.rewards : AppRoutes.dashboard;
        
        // Update presenter's currentRoute to match the initial route
        WidgetsBinding.instance.addPostFrameCallback((_) {
          presenter.currentRoute = initialRoute;
        });
        
        final Widget bodyContent = Navigator(
          key: Get.nestedKey(1),
          initialRoute: initialRoute,
          onGenerateRoute: (settings) {
            // Check if municipality user is trying to access restricted routes
            if (isMunicipality && MunicipalityUtils.isRouteRestricted(settings.name!)) {
              // Update presenter's currentRoute and redirect to rewards page
              WidgetsBinding.instance.addPostFrameCallback((_) {
                presenter.currentRoute = AppRoutes.rewards;
              });
              return GetPageRoute(
                settings: RouteSettings(name: AppRoutes.rewards),
                page: () => RewardsView(),
                binding: RewardsBinding(),
                routeName: AppRoutes.rewards,
              );
            }
            
            final sidebarPageRoute = {
              AppRoutes.dashboard: () => DashboardView(),
              AppRoutes.productManagement: () => ProductsPage(),
              AppRoutes.rewards: () => RewardsView(),
              AppRoutes.rulesV2: () => RulesV2View(),
              AppRoutes.profile: () => ProfileView(),
            };
        
            final page = sidebarPageRoute[settings.name];
            if (page == null) return null;
        
            final sidebarPageBinding = {
              AppRoutes.dashboard: DashboardBinding(),
              AppRoutes.productManagement: ProductsBinding(),
              AppRoutes.rewards: RewardsBinding(),
              AppRoutes.rulesV2: RulesV2Binding(),
              AppRoutes.profile: ProfileBinding(),
            };
        
            final binding = sidebarPageBinding[settings.name];
            if (binding == null) return null;
        
            return GetPageRoute(settings: settings, page: page, binding: binding, routeName: settings.name);
          },
        );
        return isMobile
            ? bodyContent
            : Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      // SIDEBAR
                      
                        Obx(
                          () => SidebarNavigation(
                            currentRoute: presenter.currentRoute,
                            onNavigate:
                                (route) => businessController.navigateToPage(route),
                            isCollapsed: presenter.isCollapsed,
                            onToggle: businessController.toggleSidebar,
                            onLogout: businessController.logout,
                          ),
                        ),
                      

                      // BODY CONTENT
                      Expanded(child: bodyContent),
                    ],
                  );
                },
              ),
            );
      },
    );
  }
}
