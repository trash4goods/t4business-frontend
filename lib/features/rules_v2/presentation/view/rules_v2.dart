import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/custom_getview.dart';
import '../../../../core/widgets/view_toggle_button.dart';
import '../../../rewards/presentation/widgets/b2b_pagination_widget.dart';
import '../../../rewards/presentation/widgets/create_reward_fab.dart';
import '../../../rewards/presentation/widgets/rewards_grid_view.dart';
import '../controller/rules_v2_controller.interface.dart';
import '../presenter/rules_v2_presenter.interface.dart';
// import 'widgets/body_content/rule_empty_state.dart';
// import 'widgets/body_content/rule_v2_loading_state.dart';
import 'widgets/cards/rules_v2_card_widget.dart';
import 'widgets/filters/rules_v2_view_filters_section.dart';
import 'widgets/lists/rules_v2_list_view_widget.dart';
import 'widgets/main_layout/rules_v2_view_list.dart';
import 'widgets/main_layout/rules_v2_view_responsive_layout.dart';

class RulesV2View
    extends
        CustomGetView<RulesV2ControllerInterface, RulesV2PresenterInterface> {
  const RulesV2View({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      key: presenter.scaffoldKey,
      backgroundColor: const Color(0xFFFAFAFA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final body = RulesV2ViewResponsiveLayout(
            buildRulesList:
                () => RulesV2ViewListWidget(
                  buildFiltersSection:
                      () => Obx(
                        () => RulesV2ViewFiltersSection(
                          selectedStatusFilter: presenter.selectedStatusFilter,
                          onStatusFilterChanged:
                              businessController.onStatusFilterChanged,
                          statusFilters: presenter.statusFilters,
                          onSearchChanged: businessController.searchRewards,
                          selectedFilter: presenter.selectedFilter,
                          onFilterChanged: businessController.onFilterChanged,
                          onRefreshPressed: () => presenter.refreshRules(),
                          currentView:
                              presenter.viewMode == 'grid'
                                  ? ViewMode.grid
                                  : ViewMode.list,
                          onViewChanged:
                              (mode) => businessController.toggleViewMode(
                                mode == ViewMode.grid ? 'grid' : 'list',
                              ),
                        ),
                      ),
                  buildPagination:
                      () => Obx(() {
                        if (presenter.totalCount == 0) {
                          return const SizedBox.shrink();
                        }
                        return RewardsViewPaginationWidget(
                          currentPage: presenter.currentPage,
                          totalCount: presenter.totalCount,
                          perPage: presenter.perPage,
                          hasNext: presenter.hasNextPage,
                          isLoading: presenter.isLoading,
                          onPageChanged:
                              (page) => businessController.goToPage(page),
                        );
                      }),
                  buildRulesGrid: () {
                    return Obx(() {
                      if (presenter.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if ((presenter.filteredRules ?? []).isEmpty) {
                        return const Center(child: Text('No rules found'));
                      }
                      return presenter.viewMode == 'grid'
                          ? RewardsViewGridView(
                            itemCount: presenter.filteredRules!.length,
                            crossAxisCount: businessController
                                .getGridCrossAxisCount(Get.width),
                            crossAxisSpacing: businessController.getGridSpacing(
                              Get.width,
                            ),
                            mainAxisSpacing: businessController.getGridSpacing(
                              Get.width,
                            ),
                            childAspectRatio: businessController
                                .getRewardChildAspectRatio(Get.width),
                            itemBuilder: (context, index) {
                              final rule = presenter.filteredRules![index];
                              return RulesV2CardWidget(
                                rule: rule,
                                onEdit: () => businessController.startEdit(rule),
                                onDelete: () => businessController.confirmDeleteRule(context, rule),
                              );
                            },
                          )
                          : RulesV2ListViewWidget(
                              rules: presenter.filteredRules!,
                              onEdit: businessController.startEdit,
                              onDelete: (rule) => businessController.confirmDeleteRule(context, rule),
                            );
                    });
                  },
                ),
          );

          return body;
        },
      ),

      floatingActionButton: Obx(() {
        // Hide FAB when in create/edit mode
        final showFAB =
            !presenter.isCreatingRule && presenter.isEditingRule == null;
        if (!showFAB) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            return RewardFAButton(
              constraints: constraints,
              onPressed: businessController.startCreate,
              label: 'Create Rule',
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
