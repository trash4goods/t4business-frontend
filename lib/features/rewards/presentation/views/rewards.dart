import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/custom_getview.dart';
import '../../../../core/widgets/sidebar_navigation.dart';
import '../../../../core/widgets/view_toggle_button.dart';
import '../controllers/interface/rewards_controller.interface.dart';
import '../presenters/interface/rewards_presenter.interface.dart';
import '../widgets/b2b_pagination_widget.dart';
import '../widgets/create_reward_fab.dart';
import '../widgets/form_content/reward_preview/reward_preview_panel.dart';
import '../widgets/reward_card_widget.dart';
import '../widgets/reward_empty_state.dart';
import '../widgets/form_content/reward_form_widget.dart';
import '../widgets/reward_loading_state.dart';
import '../widgets/rewards_filters_section.dart';
import '../widgets/rewards_grid_view.dart';
import '../widgets/rewards_list_view_widget.dart';
import '../widgets/rewards_list_widget.dart';
import '../widgets/rewards_responsive_layout.dart';

class RewardsView
    extends
        CustomGetView<RewardsControllerInterface, RewardsPresenterInterface> {
  const RewardsView({super.key});

  @override
  Widget buildView(BuildContext context) {
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          final isTablet =
              constraints.maxWidth >= 768 && constraints.maxWidth < 1200;

          final body = RewardsViewResponsiveLayout(
            constraints: constraints,
            isMobile: isMobile,
            isTablet: isTablet,
            presenter: presenter,
            buildPreviewPanel: () => Obx(
                          () => RewardViewPreviewPanel(
                            title: presenter.previewTitle,
                            description: presenter.previewDescription,
                            headerImage: presenter.previewHeaderImage,
                            carouselImages:
                                presenter.previewCarouselImages.toList(),
                            logo: presenter.previewLogo,
                            categories: presenter.previewCategories.toList(),
                            linkedRules: presenter.selectedRulesData.toList(),
                            canCheckout: presenter.formCanCheckout,
                            quantity: presenter.formQuantity,
                            expiryDate: presenter.formExpiryDate,
                          ),
                        ),
            buildFormContent:
                () => Obx(
                  () => RewardViewFormWidget(
                    // header
                    isEditing: presenter.editingReward != null,
                    isLoading: presenter.isLoading,
                    isFormValid: presenter.isFormValid,
                    onBack: businessController.cancelEdit,
                    onCancel: businessController.cancelEdit,
                    onSave: () async => await businessController.updateReward(),
                    onCreate: () async => await businessController.createReward(),
                    // content
                    title: presenter.formTitle,
                    onTitleChanged:
                        (v) => businessController.updateFormField('title', v),
                    description: presenter.formDescription,
                    onDescriptionChanged:
                        (v) => businessController.updateFormField(
                          'description',
                          v,
                        ),
                    headerImage: presenter.formHeaderImage,
                    onHeaderUpload:
                        () => businessController.uploadHeaderImage(),
                    onHeaderRemove:
                        () => businessController.updateFormField(
                          'headerImage',
                          '',
                        ),
                    carouselImages: presenter.formCarouselImages.toList(),
                    onAddCarouselImage:
                        () async =>
                            await businessController.uploadCarouselImage(),
                    onRemoveCarouselAt: (index) {
                      final imageUrl = presenter.formCarouselImages[index];
                      businessController.removeCarouselImage(imageUrl);
                    },
                    logo:
                        presenter.formLogo.isEmpty ? null : presenter.formLogo,
                    onLogoUpload:
                        () async => await businessController.uploadLogo(),
                    onLogoRemove:
                        () => businessController.updateFormField('logo', ''),
                    availableCategories: presenter.categories.toList(),
                    selectedCategories: presenter.formCategories.toList(),
                    onCategoriesChanged:
                        (cats) => businessController.updateFormField(
                          'categories',
                          cats,
                        ),
                    canCheckout: presenter.formCanCheckout,
                    onCanCheckoutChanged:
                        (val) => businessController.updateFormField(
                          'canCheckout',
                          val,
                        ),
                    quantity: presenter.formQuantity,
                    onQuantityChanged:
                        (val) => businessController.updateFormField(
                          'quantity',
                          val,
                        ),
                    expiryDate: presenter.formExpiryDate,
                    onExpiryDateChanged:
                        (val) => businessController.updateFormField(
                          "expiryDate",
                          val,
                        ),
                    onLinkRules: () => businessController.onRuleSelection(),
                    selectedRulesCount: presenter.formLinkedRules.length,
                  ),
                ),
            buildRewardsList:
                () => RewardsViewListWidget(
                  buildFiltersSection:
                      () => Obx(() => RewardsViewFiltersSection(
                        selectedStatusFilter: presenter.selectedStatusFilter,
                        onStatusFilterChanged: businessController.onStatusFilterChanged,
                        statusFilters: presenter.statusFilters,
                        onSearchChanged: businessController.searchRewards,
                        selectedCategory: presenter.selectedCategory,
                        categories: presenter.categories,
                        onCategoryChanged:
                            (value) => businessController.filterRewards(value),
                        selectedFilter: presenter.selectedFilter,
                        onFilterChanged: businessController.onFilterChanged,
                        currentView:
                            presenter.viewMode == 'grid'
                                ? ViewMode.grid
                                : ViewMode.list,
                        onViewChanged:
                            (mode) => businessController.toggleViewMode(
                              mode == ViewMode.grid ? 'grid' : 'list',
                            ),
                        onValidateReward: businessController.openValidationDialog,
                        onRefreshPressed: () => presenter.refreshRewards(),
                      ),),
                  buildRewardsGrid: () {
                    return Obx(() {
                      if (presenter.isLoading) {
                        return const RewardViewLoadingState();
                      }
                      if ((presenter.filteredRewards ?? []).isEmpty) {
                        return RewardViewEmptyState(
                          onCreatePressed: businessController.startCreate,
                        );
                      }
                      return presenter.viewMode == 'grid'
                          ? RewardsViewGridView(
                            itemCount: presenter.filteredRewards!.length,
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
                              final reward = presenter.filteredRewards![index];
                              return RewardViewCardWidget(
                                reward: reward,
                                onEdit:
                                    () => businessController.startEdit(reward),

                                onDelete:
                                    () =>
                                        businessController.confirmDeleteReward(
                                          context,
                                          reward,
                                          onConfirm:
                                              () async => await businessController
                                                  .deleteReward(reward.id),
                                        ),
                              );
                            },
                          )
                          : RewardsViewListViewWidget(
                            presenter: presenter,
                            onEdit: businessController.startEdit,
                            onDelete:
                                (reward) =>
                                    businessController.confirmDeleteReward(
                                      context,
                                      reward,
                                      onConfirm:
                                          () => businessController.deleteReward(
                                            reward.id,
                                          ),
                                    ),
                            onTap: businessController.startEdit,
                          );
                    });
                  },
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
                ),
          );

          if (hasScaffoldAncestor) {
            return SafeArea(
              child: Stack(
                children: [
                  Container(color: const Color(0xFFFAFAFA), child: body),
                ],
              ),
            );
          } else {
            return Scaffold(
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
                                  presenter.scaffoldKey.currentState
                                      ?.openDrawer(),
                        ),
                      )
                      : null,
              drawer:
                  (isMobile || isTablet)
                      ? Drawer(
                        child: SidebarNavigation(
                          currentRoute: presenter.currentRoute,
                          isCollapsed: false,
                          onToggle: businessController.onToggle,
                          onNavigate:
                              (route) => businessController.onNavigate(route),
                          onLogout: businessController.onLogout,
                        ),
                      )
                      : null,
              body: SafeArea(child: body),
            );
          }
        },
      ),

      floatingActionButton: Obx(() {
        // Hide FAB when in create/edit mode
        final showFAB =
            !presenter.isCreating && presenter.editingReward == null;
        if (!showFAB) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            return RewardFAButton(
              constraints: constraints,
              onPressed: businessController.startCreate,
            );
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
