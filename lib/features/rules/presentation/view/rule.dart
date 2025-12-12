import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t4g_for_business/core/app/custom_getview.dart';

import '../../../../core/widgets/sidebar_navigation.dart';
import '../controllers/interface/rule.dart';
import '../presenters/interface/rule.dart';
import '../widgets/create_rule_fab.dart';
import '../widgets/rules_content_header.dart';
import '../widgets/rules_empty_state.dart';
import '../widgets/rules_grid_view.dart';
import '../widgets/rules_header.dart';
import '../widgets/rules_list_view.dart';
import '../widgets/rules_mobile_filters.dart';
import '../widgets/rules_sidebar.dart';

class RulesPage
    extends CustomGetView<RulesControllerInterface, RulesPresenterInterface> {
  const RulesPage({super.key});

  @override
  Widget buildView(BuildContext context) {
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet =
            constraints.maxWidth >= 768 && constraints.maxWidth < 1024;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          key: presenter.scaffoldKey,
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
          body: Stack(
            children: [
              Container(
                color: const Color(0xFFFAFAFA),
                child: Column(
                  children: [
                    if (!hasScaffoldAncestor)
                      RulesHeader(
                        presenter: presenter,
                        isMobile: isMobile,
                        isTablet: isTablet,
                        hasScaffoldAncestor: hasScaffoldAncestor,
                      ),
                    Expanded(
                      child:
                          isMobile
                              ? Column(
                                children: [
                                  // Mobile filters header (search + filter button)
                                  RulesMobileFilters(
                                    onSearchChanged: presenter.onSearchChanged,
                                    onFilterPressed:
                                        () => businessController
                                            .showMobileFiltersBottomSheet(
                                              presenter,
                                            ),
                                  ),
                                  // Main content area
                                  Expanded(
                                    child: Container(
                                      color: const Color(0xFFFAFAFA),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            RulesContentHeader(
                                              presenter: presenter,
                                              isMobile: true,
                                            ),
                                            const SizedBox(height: 24),
                                            Expanded(
                                              child: Obx(() {
                                                if (presenter
                                                    .filteredRules
                                                    .isEmpty) {
                                                  return RulesEmptyState(
                                                    isMobile: true,
                                                    onCreateRule:
                                                        presenter.onCreateRule,
                                                  );
                                                }
                                                return Obx(() {
                                                  if (presenter
                                                          .viewMode
                                                          .value ==
                                                      'grid') {
                                                    return RulesGridView(
                                                      presenter: presenter,
                                                      isMobile: true,
                                                      onShowActions:
                                                          (
                                                            rule,
                                                          ) => businessController
                                                              .showRuleActions(
                                                                rule,
                                                                presenter,
                                                              ),
                                                    );
                                                  } else {
                                                    return RulesListView(
                                                      presenter: presenter,
                                                      isMobile: true,
                                                      onShowActions:
                                                          (
                                                            rule,
                                                          ) => businessController
                                                              .showRuleActions(
                                                                rule,
                                                                presenter,
                                                              ),
                                                    );
                                                  }
                                                });
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Row(
                                children: [
                                  // Sidebar (desktop/tablet)
                                  Container(
                                    width: isTablet ? 280 : 320,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        right: BorderSide(
                                          color: Color(0xFFE2E8F0),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: RulesSidebar(
                                      presenter: presenter,
                                      isCompact: isTablet,
                                    ),
                                  ),
                                  // Main content
                                  Expanded(
                                    child: Container(
                                      color: const Color(0xFFFAFAFA),
                                      child: Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          children: [
                                            RulesContentHeader(
                                              presenter: presenter,
                                              isMobile: false,
                                            ),
                                            const SizedBox(height: 24),
                                            Expanded(
                                              child: Obx(() {
                                                if (presenter
                                                    .filteredRules
                                                    .isEmpty) {
                                                  return RulesEmptyState(
                                                    isMobile: false,
                                                    onCreateRule:
                                                        presenter.onCreateRule,
                                                  );
                                                }
                                                return Obx(() {
                                                  if (presenter
                                                          .viewMode
                                                          .value ==
                                                      'grid') {
                                                    return RulesGridView(
                                                      presenter: presenter,
                                                      isMobile: false,
                                                      onShowActions:
                                                          (
                                                            rule,
                                                          ) => businessController
                                                              .showRuleActions(
                                                                rule,
                                                                presenter,
                                                              ),
                                                    );
                                                  } else {
                                                    return RulesListView(
                                                      presenter: presenter,
                                                      isMobile: false,
                                                      onShowActions:
                                                          (
                                                            rule,
                                                          ) => businessController
                                                              .showRuleActions(
                                                                rule,
                                                                presenter,
                                                              ),
                                                    );
                                                  }
                                                });
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ],
                ),
              ),

              // Mobile FAB
              if (hasScaffoldAncestor) ...{
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 768) {
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CreateRuleFAB(
                            onPressed: presenter.onCreateRule,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              },
            ],
          ),
          floatingActionButton: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < 768
                  ? CreateRuleFAB(onPressed: presenter.onCreateRule)
                  : const SizedBox.shrink();
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
