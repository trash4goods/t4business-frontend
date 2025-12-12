import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/view_toggle_button.dart';
import 'reward_search_field.dart';
import 'reward_category_filter.dart';
// import 'reward_status_chips.dart';

class RewardsViewFiltersSection extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;
  final String selectedFilter; // 'all' | 'active' | 'inactive' | 'recent'
  final ValueChanged<String> onFilterChanged;
  final ViewMode currentView;
  final ValueChanged<ViewMode> onViewChanged;
  final String selectedStatusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final List<String> statusFilters;
  final VoidCallback onValidateReward;

  const RewardsViewFiltersSection({
    super.key,
    required this.onSearchChanged,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.currentView,
    required this.onViewChanged,
    required this.selectedStatusFilter,
    required this.onStatusFilterChanged,
    required this.statusFilters,
    required this.onValidateReward,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final isMobile = screenWidth < 768;

    return ShadCard(
      backgroundColor: AppColors.surfaceElevated,
      border: Border.all(color: AppColors.surfaceElevated, width: 0.0),
      shadows: const [],
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (isDesktop) _buildDesktopLayout(),
          if (isTablet) _buildTabletLayout(),
          if (isMobile) _buildMobileLayout(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: RewardViewSearchField(onChanged: onSearchChanged),
        ),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: _buildCategoryFilter()),
        const SizedBox(width: 12),
        /*SizedBox(width: 100, child: _buildFilterButton()),*/
        Expanded(flex: 2, child: _buildStatusFilter()),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: _buildValidateRewardButton()),
        const SizedBox(width: 12),
        ViewToggleButton(
          currentView: currentView,
          onViewChanged: onViewChanged,
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: RewardViewSearchField(onChanged: onSearchChanged),
            ),
            const SizedBox(width: 12),
            ViewToggleButton(
              currentView: currentView,
              onViewChanged: onViewChanged,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(flex: 2, child: _buildCategoryFilter()),
            const SizedBox(width: 4),
            Expanded(flex: 2, child: _buildStatusFilter()),
            const SizedBox(width: 4),
            Expanded(flex: 2, child: _buildValidateRewardButton()),
          ],
        ),
        /*const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildFilterButton()),
            const SizedBox(width: 12),
            ViewToggleButton(
              currentView: currentView,
              onViewChanged: onViewChanged,
            ),
          ],
        ),*/
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: RewardViewSearchField(onChanged: onSearchChanged)),
            const SizedBox(width: 4),
            ViewToggleButton(
              currentView: currentView,
              onViewChanged: onViewChanged,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: _buildCategoryFilter()),
            const SizedBox(width: 4),
            Expanded(child: _buildStatusFilter()),
            const SizedBox(width: 4),
            Expanded(flex: 2, child: _buildValidateRewardButton()),
          ],
        ),
        /*const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildFilterButton()),
            const SizedBox(width: 8),
            ViewToggleButton(
              currentView: currentView,
              onViewChanged: onViewChanged,
            ),
          ],
        ),*/
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return RewardAdaptiveFilter(
      selectedCategory: selectedCategory,
      categories: categories,
      onChanged: onCategoryChanged,
    );
  }

  Widget _buildStatusFilter() {
    return RewardAdaptiveFilter(
      selectedCategory: selectedStatusFilter,
      categories: statusFilters,
      onChanged: onStatusFilterChanged,
    );
  }

  Widget _buildValidateRewardButton() {
    return ShadButton.outline(
      onPressed: onValidateReward,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 16),
          SizedBox(width: 6),
          Text('Validate Reward', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
