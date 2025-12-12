// lib/features/products/presentation/views/product.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/custom_getview.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../controllers/interface/product.dart';
import '../presenters/interface/product.dart';
import '../components/image_upload_component.dart';
import '../components/form_field_component.dart';
import '../components/category_selection_component.dart';
import 'mobile_preview_fixed.dart';
import 'dart:html' as html;

class RewardsPage extends CustomGetView<RewardsControllerInterface,
    RewardsPresenterInterface> {
  const RewardsPage({super.key});

  @override
  Widget buildView(BuildContext context) {
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;
    html.document.title = 'Trash4Business - Products';
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet =
            constraints.maxWidth >= 768 && constraints.maxWidth < 1200;

        if (hasScaffoldAncestor) {
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFFFAFAFA),
                  child: _buildResponsiveLayout(
                    constraints,
                    isMobile,
                    isTablet,
                  ),
                ),
                _buildCreateRewardFAB(constraints),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            body: SafeArea(
              child: _buildResponsiveLayout(constraints, isMobile, isTablet),
            ),
            floatingActionButton: _buildCreateRewardFAB(constraints),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        }
      },
    );
  }

  Widget _buildResponsiveLayout(
    BoxConstraints constraints,
    bool isMobile,
    bool isTablet,
  ) {
    if (isMobile) {
      return _buildMobileLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Obx(() {
      if (presenter.isCreating.value) {
        return Row(
          children: [
            Expanded(flex: 7, child: _buildFormContent()),
            Container(
              width: 380,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: _buildPreviewPanel(),
            ),
          ],
        );
      } else {
        return _buildRewardsList();
      }
    });
  }

  Widget _buildTabletLayout() {
    return Obx(() {
      if (presenter.isCreating.value) {
        return Column(
          children: [
            Expanded(flex: 3, child: _buildFormContent()),
            Container(
              height: 320,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: _buildPreviewPanel(),
            ),
          ],
        );
      } else {
        return _buildRewardsList();
      }
    });
  }

  Widget _buildMobileLayout() {
    return Obx(() {
      if (presenter.isCreating.value) {
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              ShadCard(
                padding: EdgeInsets.zero,
                child: const TabBar(
                  tabs: [Tab(text: 'Form'), Tab(text: 'Preview')],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [_buildFormContent(), _buildPreviewPanel()],
                ),
              ),
            ],
          ),
        );
      } else {
        return _buildRewardsList();
      }
    });
  }

  Widget _buildRewardsList() {
    return Column(
      children: [_buildFiltersSection(), Expanded(child: _buildRewardsGrid())],
    );
  }

  // Responsive List Header with ShadCN UI
  Widget _buildListHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isVerySmall = screenWidth < 400;
        final isSmall = screenWidth < 600;
        final isMedium = screenWidth < 900;

        return ShadCard(
          padding: EdgeInsets.all(isVerySmall ? 12 : 16),
          child: _buildHeaderContent(isVerySmall, isSmall, isMedium),
        );
      },
    );
  }

  Widget _buildHeaderContent(bool isVerySmall, bool isSmall, bool isMedium) {
    if (isVerySmall) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderText(isVerySmall, isSmall),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatsRow(isVerySmall, isSmall)),
              SizedBox(width: 8),
              _buildCreateButton(isVerySmall, isSmall),
            ],
          ),
        ],
      );
    } else if (isSmall) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildHeaderText(isVerySmall, isSmall)),
              SizedBox(width: 8),
              _buildCreateButton(isVerySmall, isSmall),
            ],
          ),
          SizedBox(height: 12),
          _buildStatsRow(isVerySmall, isSmall),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildHeaderText(isVerySmall, isSmall)),
                if (isMedium) SizedBox(width: 16),
                if (!isMedium)
                  Expanded(child: _buildStatsRow(isVerySmall, isSmall)),
              ],
            ),
          ),
          SizedBox(width: 12),
          _buildCreateButton(isVerySmall, isSmall),
        ],
      );
    }
  }

  Widget _buildHeaderText(bool isVerySmall, bool isSmall) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rewards Management',
          style: (isVerySmall
                  ? AppTextStyles.headlineSmall
                  : (isSmall
                      ? AppTextStyles.headlineMedium
                      : AppTextStyles.headlineLarge))
              .copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 2),
        Text(
          isVerySmall
              ? 'Manage rewards linked to recycling rules'
              : 'Create and manage rewards linked to recycling rules',
          style:
              (isVerySmall ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium)
                  .copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildStatsRow(bool isVerySmall, bool isSmall) {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.card_giftcard,
          value: '3',
          label: isVerySmall ? 'Total' : 'Total Rewards',
          isSmall: isVerySmall || isSmall,
        ),
        SizedBox(width: isVerySmall ? 8 : 16),
        _buildStatItem(
          icon: Icons.check_circle,
          value: '4',
          label: isVerySmall ? 'Active' : 'Active Rules',
          isSmall: isVerySmall || isSmall,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isSmall,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShadBadge(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, size: isSmall ? 12 : 16, color: AppColors.primary),
        ),
        SizedBox(width: isSmall ? 4 : 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: (isSmall
                      ? AppTextStyles.titleSmall
                      : AppTextStyles.titleMedium)
                  .copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style:
                  (isSmall ? AppTextStyles.labelSmall : AppTextStyles.bodySmall)
                      .copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateButton(bool isVerySmall, bool isSmall) {
    return ShadButton(
      onPressed: () => presenter.startCreate(),
      size: isVerySmall ? ShadButtonSize.sm : ShadButtonSize.regular,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: isVerySmall ? 14 : 16),
          SizedBox(width: 4),
          Text(isVerySmall ? 'Create' : 'Create Reward'),
        ],
      ),
    );
  }

  // Responsive Filters Section with ShadCN UI
  Widget _buildFiltersSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return ShadCard(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ShadInput(
                      placeholder: const Text(
                        'Search rewards, rules, categories...',
                      ),
                      onChanged: presenter.searchRewards,
                      leading: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.search, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => ShadSelect<String>(
                        placeholder: const Text('All Categories'),
                        initialValue: presenter.selectedCategory.value.isEmpty
                            ? null
                            : presenter.selectedCategory.value,
                        selectedOptionBuilder: (context, value) => Text(value),
                        onChanged: (value) =>
                            presenter.filterRewards(value ?? ''),
                        options: [
                          const ShadOption(
                            value: '',
                            child: Text('All Categories'),
                          ),
                          ...presenter.categories.map(
                            (category) => ShadOption(
                              value: category,
                              child: Text(category),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 12),
                    ShadButton.outline(
                      onPressed: _showFilterDialog,
                      size: ShadButtonSize.sm,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune, size: 16),
                          SizedBox(width: 4),
                          Text('Filters'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusChip(
                      'All',
                      presenter.selectedFilter.value == 'all',
                    ),
                    _buildStatusChip(
                      'Active',
                      presenter.selectedFilter.value == 'active',
                    ),
                    _buildStatusChip(
                      'Inactive',
                      presenter.selectedFilter.value == 'inactive',
                    ),
                    _buildStatusChip(
                      'Recent',
                      presenter.selectedFilter.value == 'recent',
                    ),
                  ],
                ),
              ),
              if (isMobile) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ShadButton.outline(
                        onPressed: _showFilterDialog,
                        size: ShadButtonSize.sm,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.tune, size: 16),
                            SizedBox(width: 4),
                            Text('Advanced Filters'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ShadButton.outline(
                        onPressed: _showSortDialog,
                        size: ShadButtonSize.sm,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sort, size: 16),
                            SizedBox(width: 4),
                            Text('Sort'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String label, bool isSelected) {
    final buttonChild = Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );

    if (isSelected) {
      return ShadButton(
        onPressed: () => presenter.onFilterChanged(label.toLowerCase()),
        size: ShadButtonSize.sm,
        child: buttonChild,
      );
    }

    return ShadButton.outline(
      onPressed: () => presenter.onFilterChanged(label.toLowerCase()),
      size: ShadButtonSize.sm,
      child: buttonChild,
    );
  }

  // Responsive Rewards Grid with ShadCN UI Cards
  Widget _buildRewardsGrid() {
    return Obx(() {
      if (presenter.isLoading.value) {
        return _buildLoadingState();
      }

      if (presenter.filteredRewards.isEmpty) {
        return _buildEmptyState();
      }

      return GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getGridCrossAxisCount(),
          crossAxisSpacing: _getGridSpacing(Get.width),
          mainAxisSpacing: _getGridSpacing(Get.width),
          childAspectRatio: _getRewardChildAspectRatio(Get.width),
        ),
        itemCount: presenter.filteredRewards.length,
        itemBuilder: (context, index) {
          final reward = presenter.filteredRewards[index];
          return _buildRewardCard(reward);
        },
      );
    });
  }

  int _getGridCrossAxisCount() {
    final width = Get.width;
    // More responsive breakpoints for better card sizing
    // Ensure minimum card width of ~200px for proper content display
    if (width >= 1800) return 6; // Ultra-wide screens
    if (width >= 1400) return 5; // Very large screens
    if (width >= 1100) return 4; // Large screens
    if (width >= 800) return 3; // Medium screens
    if (width >= 500) return 2; // Small screens
    return 1; // Mobile
  }

  // Responsive Reward Card matching ProductCard layout
  Widget _buildRewardCard(dynamic reward) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: _buildRewardCardImage(reward),
            ),
          ),
          Expanded(
            flex: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth;
                final isVerySmallCard = cardWidth < 160;
                final isSmallCard = cardWidth < 200;
                final padding =
                    isVerySmallCard ? 6.0 : (isSmallCard ? 8.0 : 12.0);

                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reward.title ?? 'Reward Title',
                              style: (isVerySmallCard
                                      ? AppTextStyles.titleSmall
                                      : (isSmallCard
                                          ? AppTextStyles.titleMedium
                                          : AppTextStyles.titleLarge))
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isSmallCard)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (reward.canCheckout ?? true)
                                    ? AppColors.success.withOpacity(0.1)
                                    : AppColors.textSecondary.withOpacity(
                                        0.1,
                                      ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (reward.canCheckout ?? true)
                                    ? 'Active'
                                    : 'Inactive',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: (reward.canCheckout ?? true)
                                      ? AppColors.success
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 2 : (isSmallCard ? 4 : 6),
                      ),
                      Flexible(
                        child: Text(
                          reward.description ?? 'Reward description',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 4 : (isSmallCard ? 6 : 8),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.card_giftcard_outlined,
                            size: isSmallCard ? 12 : 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Available',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: isVerySmallCard
                                    ? 10
                                    : (isSmallCard ? 11 : null),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (reward.category != null &&
                              reward.category.isNotEmpty &&
                              !isSmallCard)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                reward.category.first,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 4 : (isSmallCard ? 6 : 8),
                      ),
                      Spacer(),
                      _buildResponsiveRewardActionButtons(
                        reward,
                        isVerySmallCard,
                        isSmallCard,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveRewardActionButtons(
    dynamic reward,
    bool isVerySmallCard,
    bool isSmallCard,
  ) {
    if (isVerySmallCard) {
      // Very small cards: minimal icon-only buttons
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCompactIconButton(
            onPressed: () => _editReward(reward),
            icon: Icons.edit_outlined,
          ),
          _buildCompactIconButton(
            onPressed: () => _deleteReward(reward),
            icon: Icons.delete_outline,
            color: AppColors.error,
          ),
        ],
      );
    } else if (isSmallCard) {
      // Small cards: compact button + icon
      return Row(
        children: [
          Expanded(
            child: _buildSecondaryButton(
              onPressed: () => _editReward(reward),
              icon: Icons.edit_outlined,
              label: 'Edit',
              compact: true,
            ),
          ),
          SizedBox(width: 4),
          _buildCompactIconButton(
            onPressed: () => _deleteReward(reward),
            icon: Icons.delete_outline,
            color: AppColors.error,
          ),
        ],
      );
    } else {
      // Normal cards: standard layout
      return Row(
        children: [
          Expanded(
            child: _buildSecondaryButton(
              onPressed: () => _editReward(reward),
              icon: Icons.edit_outlined,
              label: 'Edit',
              compact: false,
            ),
          ),
          SizedBox(width: 6),
          _buildIconButton(
            onPressed: () => _deleteReward(reward),
            icon: Icons.delete_outline,
            color: AppColors.error,
          ),
        ],
      );
    }
  }

  Widget _buildCompactIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color? color,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Icon(icon, size: 12, color: color ?? AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required VoidCallback? onPressed,
    IconData? icon,
    required String label,
    bool compact = false,
    Color? color,
  }) {
    final buttonColor = color ?? AppColors.textPrimary;
    final borderColor = color == AppColors.error
        ? AppColors.error.withOpacity(0.3)
        : AppColors.fieldBorder;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        side: BorderSide(color: borderColor),
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 16,
          vertical: compact ? 8 : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: compact ? 12 : 16),
          if (icon != null) SizedBox(width: compact ? 3 : 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: compact ? 12 : 14, color: buttonColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        color: color ?? AppColors.textSecondary,
        padding: EdgeInsets.all(6),
        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }

  Widget _buildRewardCardImage(dynamic reward) {
    final imageUrl = reward.headerImage as String?;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        child: imageUrl.contains('http')
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildRewardImagePlaceholder(),
              )
            : Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildRewardImagePlaceholder(),
              ),
      );
    } else {
      return _buildRewardImagePlaceholder();
    }
  }

  Widget _buildRewardImagePlaceholder() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.card_giftcard_outlined,
              size: 24,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'No Image',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Loading and Empty States with ShadCN UI
  Widget _buildLoadingState() {
    return Center(
      child: ShadCard(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadProgress(),
            SizedBox(height: 16),
            Text(
              'Loading rewards...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: ShadCard(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadBadge(
              backgroundColor: AppColors.surfaceContainer,
              child: Icon(
                Icons.card_giftcard_outlined,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'No rewards found',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Create your first reward to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ShadButton(
              onPressed: () => presenter.startCreate(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 8),
                  Text('Create First Reward'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Form Content with ShadCN UI
  Widget _buildFormContent() {
    return Column(
      children: [_buildFormHeader(), Expanded(child: _buildForm())],
    );
  }

  Widget _buildFormHeader() {
    return ShadCard(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          ShadButton.ghost(
            onPressed: () => presenter.cancelEdit(),
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  presenter.editingReward.value != null
                      ? 'Edit Reward'
                      : 'Create Reward',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Create rewards that users can unlock by completing recycling rules',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Row(
            children: [
              ShadButton.outline(
                onPressed: () => presenter.cancelEdit(),
                child: Text('Cancel'),
              ),
              SizedBox(width: 8),
              Obx(
                () => ShadButton(
                  onPressed:
                      presenter.isFormValid.value && !presenter.isLoading.value
                          ? () => presenter.saveReward()
                          : null,
                  child: presenter.isLoading.value
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          presenter.editingReward.value != null
                              ? 'Update Reward'
                              : 'Create Reward',
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Basic Information'),
          SizedBox(height: 16),

          // Title
          RewardFormFieldComponent(
            label: 'Reward Title',
            required: true,
            child: Obx(
              () => ShadInput(
                placeholder: Text('Enter reward title'),
                initialValue: presenter.formTitle.value,
                onChanged: (value) => presenter.updateFormField('title', value),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Description
          RewardFormFieldComponent(
            label: 'Description',
            required: true,
            child: Obx(
              () => ShadInput(
                placeholder: Text('Describe your reward'),
                initialValue: presenter.formDescription.value,
                onChanged: (value) =>
                    presenter.updateFormField('description', value),
                maxLines: 3,
              ),
            ),
          ),
          SizedBox(height: 24),

          _buildSectionHeader('Images'),
          SizedBox(height: 16),

          // Header Image
          RewardFormFieldComponent(
            label: 'Header Image',
            required: true,
            child: _buildHeaderImageUpload(),
          ),
          SizedBox(height: 16),

          // Carousel Images
          RewardFormFieldComponent(
            label: 'Carousel Images (1-3 images)',
            child: _buildCarouselImagesUpload(),
          ),
          SizedBox(height: 16),

          // Logo
          RewardFormFieldComponent(
            label: 'Brand Logo',
            child: _buildLogoUpload(),
          ),
          SizedBox(height: 24),

          _buildSectionHeader('Details'),
          SizedBox(height: 16),

          // Barcode
          RewardFormFieldComponent(
            label: 'Barcode',
            required: true,
            child: Obx(
              () => ShadInput(
                placeholder: Text('13-digit barcode'),
                initialValue: presenter.formBarcode.value,
                onChanged: (value) =>
                    presenter.updateFormField('barcode', value),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Categories
          RewardFormFieldComponent(
            label: 'Categories',
            required: true,
            child: _buildCategorySelection(),
          ),
          SizedBox(height: 24),

          _buildSectionHeader('Linked Rules'),
          SizedBox(height: 16),

          // Rules Section
          _buildRulesSection(),
          SizedBox(height: 24),

          // Status Toggle
          RewardFormFieldComponent(
            label: 'Status',
            child: Obx(
              () => Row(
                children: [
                  ShadSwitch(
                    value: presenter.formCanCheckout.value,
                    onChanged: (value) =>
                        presenter.updateFormField('canCheckout', value),
                  ),
                  SizedBox(width: 8),
                  Text(
                    presenter.formCanCheckout.value ? 'Active' : 'Inactive',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderImageUpload() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (presenter.formHeaderImage.value.isNotEmpty)
            SizedBox(
              height: 100,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 100,
                margin: EdgeInsets.only(bottom: 8),
                child: RewardImageUploadComponent(
                  imageUrl: presenter.formHeaderImage.value,
                  onUpload: () {},
                  onRemove: () => presenter.updateFormField('headerImage', ''),
                  title: '',
                  subtitle: '',
                  compact: true,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          if (presenter.formHeaderImage.value.isEmpty)
            RewardImageUploadComponent(
              onUpload: () => presenter.uploadHeaderImage(),
              title: 'Upload Header Image',
              subtitle: 'This will appear at the top of your reward preview',
              compact: true,
            ),
        ],
      );
    });
  }

  Widget _buildCarouselImagesUpload() {
    return Obx(
      () => Column(
        children: [
          if (presenter.formCarouselImages.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: presenter.formCarouselImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 8),
                    child: RewardImageUploadComponent(
                      imageUrl: presenter.formCarouselImages[index],
                      onUpload: () {},
                      onRemove: () {
                        final updatedList =
                            presenter.formCarouselImages.toList();
                        updatedList.removeAt(index);
                        presenter.updateFormField(
                          'carouselImages',
                          updatedList,
                        );
                      },
                      title: '',
                      subtitle: '',
                      compact: true,
                      width: 100,
                      height: 100,
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 8),
          if (presenter.formCarouselImages.length < 3)
            RewardImageUploadComponent(
              onUpload: () => presenter.uploadCarouselImage(),
              title: 'Add Carousel Image',
              subtitle:
                  'Add ${presenter.formCarouselImages.isEmpty ? "1-3" : "${3 - presenter.formCarouselImages.length} more"} image(s)',
              compact: true,
            ),
        ],
      ),
    );
  }

  Widget _buildLogoUpload() {
    return Obx(
      () => RewardImageUploadComponent(
        imageUrl:
            presenter.formLogo.value.isEmpty ? null : presenter.formLogo.value,
        onUpload: () => presenter.uploadLogo(),
        onRemove: () => presenter.updateFormField('logo', ''),
        title: 'Upload Brand Logo',
        subtitle: 'Brand logo for the reward',
        compact: true,
        width: 100,
        height: 100,
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Obx(
      () => RewardCategorySelectionComponent(
        availableCategories: presenter.categories.toList(),
        selectedCategories: presenter.formCategories.toList(),
        onSelectionChanged: (categories) =>
            presenter.updateFormField('categories', categories),
      ),
    );
  }

  Widget _buildRulesSection() {
    return Obx(
      () => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Linked Rules',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Users must complete ANY of these rules to unlock this reward',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ShadButton.outline(
                  onPressed: () => presenter.showRulesSelectionDialog(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16),
                      SizedBox(width: 4),
                      Text(
                        presenter.formLinkedRules.isEmpty
                            ? 'Link Rules'
                            : 'Edit Rules',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (presenter.selectedRulesData.isNotEmpty)
              ShadCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: presenter.selectedRulesData.map((rule) {
                    return Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: presenter.selectedRulesData.last != rule
                              ? BorderSide(color: AppColors.outline)
                              : BorderSide.none,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(rule.priority),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rule.title,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '${rule.recycleCount}x recycle • ${rule.categories.join(", ")}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ShadButton.ghost(
                            onPressed: () =>
                                presenter.removeLinkedRule(rule.id),
                            size: ShadButtonSize.sm,
                            child: Icon(Icons.close, size: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )
            else
              ShadCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No rules linked yet. Click "Link Rules" to add rules.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShadBadge(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(
                  Icons.phone_iphone,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Preview',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Real-time mobile preview',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Obx(
                  () => RewardMobilePreview(
                    title: presenter.previewTitle.value,
                    description: presenter.previewDescription.value,
                    headerImage: presenter.previewHeaderImage.value,
                    carouselImages: presenter.previewCarouselImages.toList(),
                    logo: presenter.previewLogo.value,
                    barcode: presenter.previewBarcode.value,
                    categories: presenter.previewCategories.toList(),
                    linkedRules: presenter.selectedRulesData.toList(),
                    canCheckout: presenter.formCanCheckout.value,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Methods with ShadCN UI
  void _showFilterDialog() {
    showShadDialog(
      context: Get.context!,
      builder: (context) => ShadDialog(
        title: Text('Advanced Filters'),
        description: Text('Filter rewards by various criteria'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadSelect<String>(
                placeholder: Text('Filter by Status'),
                selectedOptionBuilder: (context, value) => Text(value),
                options: [
                  ShadOption(value: 'all', child: Text('All Status')),
                  ShadOption(value: 'active', child: Text('Active')),
                  ShadOption(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (value) => presenter.onFilterChanged(value ?? 'all'),
              ),
              SizedBox(height: 16),
              ShadSelect<String>(
                placeholder: Text('Filter by Category'),
                selectedOptionBuilder: (context, value) => Text(value),
                options: [
                  ShadOption(value: '', child: Text('All Categories')),
                  ...presenter.categories.map(
                    (category) =>
                        ShadOption(value: category, child: Text(category)),
                  ),
                ],
                onChanged: (value) => presenter.filterRewards(value ?? ''),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortDialog() {
    showShadDialog(
      context: Get.context!,
      builder: (context) => ShadDialog(
        title: Text('Sort Options'),
        description: Text('Choose how to sort the rewards'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Date Created'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement sort logic
                },
              ),
              ListTile(
                title: Text('Title (A-Z)'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement sort logic
                },
              ),
              ListTile(
                title: Text('Status'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Implement sort logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editReward(dynamic reward) {
    presenter.startEdit(reward);
  }

  void _deleteReward(dynamic reward) {
    showShadDialog(
      context: Get.context!,
      builder: (context) => ShadDialog(
        title: Text('Delete Reward'),
        description: Text(
          'Are you sure you want to delete "${reward.title}"? This action cannot be undone.',
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () {
              Navigator.of(context).pop();
              presenter.deleteReward(reward.id);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  double _getGridSpacing(double width) {
    if (width >= 1200) return 20;
    if (width >= 768) return 16;
    return 12;
  }

  int _getRewardGridCrossAxisCount(double width) {
    // More responsive breakpoints for better card sizing
    // Ensure minimum card width of ~200px for proper content display
    if (width >= 1800) return 6; // Ultra-wide screens
    if (width >= 1400) return 5; // Very large screens
    if (width >= 1100) return 4; // Large screens
    if (width >= 800) return 3; // Medium screens
    if (width >= 500) return 2; // Small screens
    return 1; // Mobile
  }

  double _getRewardChildAspectRatio(double width) {
    final crossAxisCount = _getRewardGridCrossAxisCount(width);
    // Adjust aspect ratio based on screen size and grid columns
    // Higher ratio = wider cards, lower ratio = taller cards
    if (width >= 1400) {
      return crossAxisCount >= 5
          ? 0.7 // More vertical space for very dense grids
          : 0.75; // Slightly more vertical space for dense grids
    } else if (width >= 1100) {
      return crossAxisCount >= 4
          ? 0.75 // More vertical space for smaller cards with many columns
          : 0.8; // Standard ratio for fewer columns
    } else if (width >= 800) {
      return 0.8; // Slightly more vertical space for medium screens
    } else if (width >= 500) {
      return 0.9; // More balanced for small screens with 2 columns
    } else {
      return 1.0; // Balanced ratio on mobile for better readability
    }
  }

  Widget _buildCreateRewardFAB(BoxConstraints constraints) {
    final isMobile = constraints.maxWidth < 768;
    final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1200;

    return Positioned(
      bottom: 16,
      right: 16,
      child: ShadButton(
        onPressed: () => presenter.startCreate(),
        size: isMobile
            ? ShadButtonSize.sm
            : (isTablet ? ShadButtonSize.regular : ShadButtonSize.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: isMobile ? 16 : (isTablet ? 18 : 20)),
            SizedBox(width: isMobile ? 4 : 8),
            Text(
              isMobile ? 'Create' : 'Create Reward',
              style: TextStyle(fontSize: isMobile ? 12 : (isTablet ? 14 : 16)),
            ),
          ],
        ),
      ),
    );
  }
}
