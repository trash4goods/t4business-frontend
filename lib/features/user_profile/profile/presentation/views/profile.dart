import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/app/constants.dart';
import '../../../../../core/app/custom_getview.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/widgets/sidebar_navigation.dart';
import '../controllers/interface/profile.dart';
import '../presenters/interface/profile.dart';
import '../widgets/company_details_card.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/statistics_overview_card.dart';
import '../widgets/subscription_status_card.dart';

class ProfileView
    extends
        CustomGetView<ProfileControllerInterface, ProfilePresenterInterface> {
  const ProfileView({super.key});

  @override
  Widget buildView(BuildContext context) {
    // Load profile when view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      businessController.loadProfile();
    });

    // Check if we're being rendered within a dashboard layout
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;
    return Container(
      color: const Color(0xFFFAFAFA),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          final isDesktop = constraints.maxWidth > AppConstants.tabletBreakpoint;
          final isTablet =
              constraints.maxWidth > AppConstants.mobileBreakpoint &&
              constraints.maxWidth <= AppConstants.tabletBreakpoint;
      
          final content = RefreshIndicator(
            onRefresh: () async => businessController.loadProfile(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 16)),
              child: Center(
                child: Container(
                  color: const Color(0xFFFAFAFA),
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : double.infinity,
                  ),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header Section
                        ProfileHeaderCard(
                          businessController: businessController,
                          presenter: presenter,
                          isDesktop: isDesktop,
                          isTablet: isTablet,
                        ),
                        const SizedBox(height: 24),
      
                        // Personal Info and Company Details Row
                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: PersonalInfoCard(
                                  businessController: businessController,
                                  userAuth: presenter.userAuth,
                                  isDesktop: isDesktop,
                                  isTablet: isTablet,
                                  fullnameController:
                                      presenter.fullnameController,
                                  firstnameController:
                                      presenter.firstnameController,
                                  lastnameController:
                                      presenter.lastnameController,
                                  phoneController: presenter.phoneController,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: CompanyDetailsCard(
                                  businessController: businessController,
                                  userAuth: presenter.userAuth,
                                  isDesktop: isDesktop,
                                  isTablet: isTablet,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          PersonalInfoCard(
                            businessController: businessController,
                            userAuth: presenter.userAuth,
                            isDesktop: isDesktop,
                            isTablet: isTablet,
                            fullnameController: presenter.fullnameController,
                            firstnameController: presenter.firstnameController,
                            lastnameController: presenter.lastnameController,
                            phoneController: presenter.phoneController,
                          ),
                          const SizedBox(height: 24),
                          CompanyDetailsCard(
                            businessController: businessController,
                            userAuth: presenter.userAuth,
                            isDesktop: isDesktop,
                            isTablet: isTablet,
                          ),
                        ],
                        const SizedBox(height: 24),
      
                        // Statistics and Subscription Row
                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 7,
                                child: StatisticsOverviewCard(
                                  businessController: businessController,
                                  presenter: presenter,
                                  isDesktop: isDesktop,
                                  isTablet: isTablet,
                                ),
                              ),
                              const SizedBox(width: 24),
                              /*Expanded(
                                flex: 5,
                                child: SubscriptionStatusCard(
                                  businessController: businessController,
                                  presenter: presenter,
                                  isDesktop: isDesktop,
                                  isTablet: isTablet,
                                ),
                              ),*/
                            ],
                          )
                        else ...[
                          StatisticsOverviewCard(
                            businessController: businessController,
                            presenter: presenter,
                            isDesktop: isDesktop,
                            isTablet: isTablet,
                          ),
                          const SizedBox(height: 24),
                          /*SubscriptionStatusCard(
                            businessController: businessController,
                            presenter: presenter,
                            isDesktop: isDesktop,
                            isTablet: isTablet,
                          ),*/
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
      
          return hasScaffoldAncestor ? content : Scaffold(
            key: presenter.scaffoldKey,
            backgroundColor: const Color(0xFFFAFAFA),
            appBar:
                (isMobile || isTablet)
                    ? AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed:
                            () =>
                                presenter.scaffoldKey.currentState?.openDrawer(),
                      ),
                    )
                    : null,
            drawer:
                (isMobile || isTablet)
                    ? Drawer(
                      child: SidebarNavigation(
                        currentRoute: presenter.currentRoute.value,
                        isCollapsed: false,
                        onToggle: presenter.onToggle,
                        onNavigate: (route) => presenter.onNavigate(route),
                        onLogout: presenter.onLogout,
                      ),
                    )
                    : null,
            body: content);
        },
      ),
    );
  }
}
