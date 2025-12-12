import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';
import '../../../../../../core/widgets/view_toggle_button.dart';
import 'rules_v2_category_filter.dart';
import 'rules_v2_view_search_field.dart';

class RulesV2ViewFiltersSection extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final String selectedFilter; // 'all' | 'active' | 'inactive'
  final ValueChanged<String> onFilterChanged;
  final ViewMode currentView;
  final ValueChanged<ViewMode> onViewChanged;
  final String selectedStatusFilter;
  final ValueChanged<String> onStatusFilterChanged;
  final List<String> statusFilters;

  const RulesV2ViewFiltersSection({
    super.key,
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.currentView,
    required this.onViewChanged,
    required this.selectedStatusFilter,
    required this.onStatusFilterChanged,
    required this.statusFilters,
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
          child: RulesV2ViewSearchField(onChanged: onSearchChanged),
        ),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: _buildStatusFilter()),
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
              child: RulesV2ViewSearchField(onChanged: onSearchChanged),
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
            Expanded(flex: 2, child: _buildStatusFilter()),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: RulesV2ViewSearchField(onChanged: onSearchChanged)),
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
            Expanded(child: _buildStatusFilter()),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return RulesV2AdaptiveFilter(
      selectedCategory: selectedStatusFilter,
      categories: statusFilters,
      onChanged: onStatusFilterChanged,
    );
  }
}
