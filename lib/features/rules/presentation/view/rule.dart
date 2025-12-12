import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/custom_getview.dart';
import '../../data/models/rule.dart';
import '../presenters/interface/rule.dart';
import '../controllers/interface/rule.dart';
import '../../../../utils/helpers/snackbar_service.dart';

class RulesPage
    extends CustomGetView<RulesControllerInterface, RulesPresenterInterface> {
  const RulesPage({super.key});

  @override
  Widget buildView(BuildContext context) {
    // Check if we're being rendered within a dashboard layout
    // by checking if we have a Scaffold ancestor
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;

    final content = LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet =
            constraints.maxWidth >= 768 && constraints.maxWidth < 1024;

        return Container(
          color: const Color(0xFFFAFAFA),
          child: Column(
            children: [
              // Only show header if we're NOT inside a dashboard (standalone page)
              if (!hasScaffoldAncestor)
                _buildHeader(context, isMobile, isTablet, hasScaffoldAncestor),
              Expanded(
                child:
                    isMobile
                        ? _buildMobileLayout(context)
                        : _buildDesktopLayout(context, isTablet),
              ),
            ],
          ),
        );
      },
    );

    if (hasScaffoldAncestor) {
      // We're inside a dashboard, don't create our own Scaffold
      return SafeArea(
        child: Stack(
          children: [
            content,
            // Add mobile FAB for mobile view
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 768) {
                  return Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildMobileFAB(context),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      );
    } else {
      // We're a standalone page, create our own Scaffold
      return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(child: content),
        floatingActionButton: LayoutBuilder(
          builder: (context, constraints) {
            return constraints.maxWidth < 768
                ? _buildMobileFAB(context)
                : const SizedBox.shrink();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }
  }

  Widget _buildHeader(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool hasScaffoldAncestor,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Add hamburger menu for mobile when in dashboard context
              if (isMobile && hasScaffoldAncestor) ...[
                Builder(
                  builder:
                      (context) => IconButton(
                        icon: const Icon(Icons.menu, size: 20),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        style: IconButton.styleFrom(
                          foregroundColor: const Color(0xFF0F172A),
                        ),
                      ),
                ),
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.rule,
                  size: 24,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rules',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    if (!isMobile)
                      const Text(
                        'Create and manage recycling rules for your rewards program',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                  ],
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 16),
                Obx(() => _buildStatsCards(isTablet)),
              ],
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            Obx(() => _buildMobileStats()),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsCards(bool isTablet) {
    return Row(
      children: [
        _buildStatCard(
          'Total Rules',
          presenter.rules.length.toString(),
          Icons.rule_outlined,
          const Color(0xFF0F172A),
          isTablet,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Active Rules',
          presenter.activeRulesCount.toString(),
          Icons.check_circle_outline,
          const Color(0xFF059669),
          isTablet,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Categories',
          presenter.categoriesCount.toString(),
          Icons.category_outlined,
          const Color(0xFFD97706),
          isTablet,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isCompact,
  ) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: isCompact ? 20 : 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isCompact ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isCompact ? 10 : 12,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStats() {
    return Row(
      children: [
        Expanded(
          child: _buildMobileStatCard(
            'Total',
            presenter.rules.length.toString(),
            const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMobileStatCard(
            'Active',
            presenter.activeRulesCount.toString(),
            const Color(0xFF059669),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMobileStatCard(
            'Categories',
            presenter.categoriesCount.toString(),
            const Color(0xFFD97706),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return Row(
      children: [
        // Sidebar
        Container(
          width: isTablet ? 280 : 320,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
          ),
          child: _buildSidebar(context, isTablet),
        ),
        // Main content
        Expanded(child: _buildMainContent(context, false)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Mobile filters (collapsible)
        _buildMobileFilters(context),
        // Main content
        Expanded(child: _buildMainContent(context, true)),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context, bool isCompact) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isCompact ? 16 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(isCompact),
          const SizedBox(height: 24),
          _buildFilterSection(isCompact),
          const SizedBox(height: 24),
          _buildQuickActions(isCompact),
        ],
      ),
    );
  }

  Widget _buildMobileFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSearchBar(true)),
              const SizedBox(width: 12),
              ShadButton.outline(
                onPressed: () => _showMobileFiltersBottomSheet(),
                child: const Icon(Icons.filter_list),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isCompact) {
    return ShadInput(
      onChanged: presenter.onSearchChanged,
      placeholder: const Text('Search rules...'),
      leading: const Icon(Icons.search, size: 18),
    );
  }

  Widget _buildFilterSection(bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filters',
          style: TextStyle(
            fontSize: isCompact ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        _buildFilterChips(isCompact),
        const SizedBox(height: 16),
        _buildCategoryFilter(isCompact),
      ],
    );
  }

  Widget _buildFilterChips(bool isCompact) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildFilterChip(
            'All',
            presenter.selectedFilter.value == 'all',
            isCompact,
          ),
          _buildFilterChip(
            'Active',
            presenter.selectedFilter.value == 'active',
            isCompact,
          ),
          _buildFilterChip(
            'Inactive',
            presenter.selectedFilter.value == 'inactive',
            isCompact,
          ),
          _buildFilterChip(
            'Recent',
            presenter.selectedFilter.value == 'recent',
            isCompact,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, bool isCompact) {
    return isSelected
        ? ShadButton(
            onPressed: () => presenter.onFilterChanged(label.toLowerCase()),
            size: isCompact ? ShadButtonSize.sm : ShadButtonSize.sm,
            child: Text(
              label,
              style: TextStyle(fontSize: isCompact ? 12 : 14),
            ),
          )
        : ShadButton.outline(
            onPressed: () => presenter.onFilterChanged(label.toLowerCase()),
            size: isCompact ? ShadButtonSize.sm : ShadButtonSize.sm,
            child: Text(
              label,
              style: TextStyle(fontSize: isCompact ? 12 : 14),
            ),
          );
  }

  Widget _buildCategoryFilter(bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: isCompact ? 12 : 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Column(
            children:
                presenter.availableCategories.map((category) {
                  final isSelected = presenter.selectedCategoriesFilter
                      .contains(category);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        ShadCheckbox(
                          value: isSelected,
                          onChanged: (value) => presenter.onCategoryFilterChanged(category),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category,
                            style: TextStyle(fontSize: isCompact ? 12 : 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: isCompact ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            _buildQuickActionButton(
              'Create Rule',
              Icons.add,
              () => presenter.onCreateRule(),
              isCompact,
              isPrimary: true,
            ),
            const SizedBox(height: 8),
            /*_buildQuickActionButton('Load Mock Data', Icons.data_object, () {
              presenter.loadMockData();
              SnackbarServiceHelper.showSuccess(
                'Mock data loaded successfully! ${presenter.rules.length} rules added.',
                position: SnackPosition.TOP,
                actionLabel: 'OK',
              );
            }, isCompact),
            const SizedBox(height: 8),
            */
            _buildQuickActionButton(
              'Clear All Rules',
              Icons.clear_all,
              () => _showClearRulesDialog(),
              isCompact,
            ),
            /*
            const SizedBox(height: 8),
            _buildQuickActionButton(
              'Export Rules',
              Icons.download,
              () => presenter.exportRules(),
              isCompact,
            ),
            const SizedBox(height: 8),
            _buildQuickActionButton(
              'Import Rules',
              Icons.upload,
              () => presenter.importRules(),
              isCompact,
            ),
            */
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    VoidCallback onTap,
    bool isCompact, {
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child:
          isPrimary
              ? ShadButton(
                onPressed: onTap,
                size: isCompact ? ShadButtonSize.sm : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: isCompact ? 14 : 16),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
              )
              : ShadButton.outline(
                onPressed: onTap,
                size: isCompact ? ShadButtonSize.sm : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: isCompact ? 14 : 16),
                    const SizedBox(width: 8),
                    Text(label),
                  ],
                ),
              ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isMobile) {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          children: [
            _buildContentHeader(isMobile),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (presenter.filteredRules.isEmpty) {
                  return _buildEmptyState(isMobile);
                }
                return _buildRulesContent(isMobile);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentHeader(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  '${presenter.filteredRules.length} Rules',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              if (!isMobile)
                const Text(
                  'Manage your recycling rules',
                  style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
            ],
          ),
        ),
        if (!isMobile) ...[
          _buildViewToggle(),
          const SizedBox(width: 12),
          _buildSortDropdown(),
        ],
      ],
    );
  }

  Widget _buildViewToggle() {
    return Obx(
      () => Row(
        children: [
          presenter.viewMode.value == 'grid'
              ? ShadButton(
                onPressed: () => presenter.viewMode.value = 'grid',
                size: ShadButtonSize.sm,
                child: const Icon(Icons.grid_view, size: 16),
              )
              : ShadButton.outline(
                onPressed: () => presenter.viewMode.value = 'grid',
                size: ShadButtonSize.sm,
                child: const Icon(Icons.grid_view, size: 16),
              ),
          const SizedBox(width: 4),
          presenter.viewMode.value == 'list'
              ? ShadButton(
                onPressed: () => presenter.viewMode.value = 'list',
                size: ShadButtonSize.sm,
                child: const Icon(Icons.list, size: 16),
              )
              : ShadButton.outline(
                onPressed: () => presenter.viewMode.value = 'list',
                size: ShadButtonSize.sm,
                child: const Icon(Icons.list, size: 16),
              ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Obx(
      () => ShadSelect<String>(
        initialValue: presenter.sortBy.value.isEmpty ? null : presenter.sortBy.value,
        placeholder: const Text('Sort by Name'),
        options: const [
          ShadOption(value: 'name', child: Text('Sort by Name')),
          ShadOption(value: 'date', child: Text('Sort by Date')),
          ShadOption(value: 'priority', child: Text('Sort by Priority')),
          ShadOption(value: 'category', child: Text('Sort by Category')),
        ],
        selectedOptionBuilder: (context, value) => Text(
          value == 'name' ? 'Sort by Name' :
          value == 'date' ? 'Sort by Date' :
          value == 'priority' ? 'Sort by Priority' :
          value == 'category' ? 'Sort by Category' : 'Sort by Name',
        ),
        onChanged: presenter.onSortChanged,
      ),
    );
  }

  Widget _buildRulesContent(bool isMobile) {
    return Obx(() {
      if (presenter.viewMode.value == 'grid') {
        return _buildRulesGrid(isMobile);
      } else {
        return _buildRulesList(isMobile);
      }
    });
  }

  Widget _buildRulesGrid(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth < 600) {
          // Mobile: 1 column
          crossAxisCount = 1;
          childAspectRatio =
              context.width < 800 ? 2.7 : 3.2; // Wider cards on mobile
        } else if (constraints.maxWidth < 900) {
          // Tablet: 2 columns
          crossAxisCount = 2;
          childAspectRatio =
              context.width < 800
                  ? 2.0
                  : context.width > 1290
                  ? 2.1
                  : 1.9;
        } else if (constraints.maxWidth < 1200) {
          // Small desktop: 3 columns
          crossAxisCount = 3;
          childAspectRatio = 1.8;
        } else {
          // Large desktop: 4 columns
          crossAxisCount = 4;
          childAspectRatio = 1.7;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: presenter.filteredRules.length,
          itemBuilder: (context, index) {
            return _buildRuleCard(presenter.filteredRules[index], isMobile);
          },
        );
      },
    );
  }

  Widget _buildRulesList(bool isMobile) {
    return ListView.separated(
      itemCount: presenter.filteredRules.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildRuleListItem(presenter.filteredRules[index], isMobile);
      },
    );
  }

  Widget _buildRuleCard(RuleModel rule, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Dynamic sizing based on available width
        final cardWidth = constraints.maxWidth;
        final isCompact = cardWidth < 280;
        final isVerySmall = cardWidth < 200;

        return ShadCard(
          padding: EdgeInsets.all(isVerySmall ? 8 : (isCompact ? 10 : 12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with priority and actions
              Row(
                children: [
                  _buildPriorityIndicator(rule.priority, isVerySmall),
                  const Spacer(),
                  _buildRuleStatus(rule.isActive, isCompact, isVerySmall),
                  SizedBox(width: isVerySmall ? 4 : 8),
                  ShadButton.ghost(
                    size: isVerySmall ? ShadButtonSize.sm : ShadButtonSize.sm,
                    onPressed: () => _showRuleActions(rule),
                    child: Icon(Icons.more_vert, size: isVerySmall ? 14 : 16),
                  ),
                ],
              ),

              SizedBox(height: 4),

              // Title section
              Text(
                rule.title,
                style: TextStyle(
                  fontSize: isVerySmall ? 14 : (isCompact ? 15 : 16),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Description (only show if space allows and not empty)
              if (rule.description.isNotEmpty && !isVerySmall) ...[
                SizedBox(height: isCompact ? 6 : 8),
                Text(
                  rule.description,
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 13,
                    color: const Color(0xFF64748B),
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const Spacer(),

              //SizedBox(height: isVerySmall ? 8 : 12),

              // Footer with recycle count and categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Recycle count badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isVerySmall ? 6 : 8,
                      vertical: isVerySmall ? 2 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(isVerySmall ? 4 : 6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.recycling,
                          size: isVerySmall ? 12 : 14,
                          color: const Color(0xFF0F172A),
                        ),
                        SizedBox(width: isVerySmall ? 2 : 4),
                        Text(
                          '${rule.recycleCount}x',
                          style: TextStyle(
                            fontSize: isVerySmall ? 10 : 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Categories (show fewer on smaller screens)
                  Flexible(
                    child: _buildResponsiveCategoryChips(
                      rule.categories,
                      isCompact,
                      isVerySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResponsiveCategoryChips(
    List<String> categories,
    bool isCompact,
    bool isVerySmall,
  ) {
    // Always show maximum 2 badges: first category + "+X more" if needed
    if (categories.isEmpty) return const SizedBox.shrink();

    final hasMoreThanOne = categories.length > 1;

    return Wrap(
      spacing: isVerySmall ? 2 : 4,
      runSpacing: 2,
      alignment: WrapAlignment.end,
      children: [
        // Always show the first category
        _buildCategoryChip(categories.first, isCompact, isVerySmall),

        // Show "+X more" indicator if there are more categories
        if (hasMoreThanOne)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isVerySmall ? 4 : 6,
              vertical: isVerySmall ? 1 : 2,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF6B7280).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isVerySmall ? 3 : 4),
            ),
            child: Text(
              '+${categories.length - 1} more',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: isVerySmall ? 8 : 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChip(String category, bool isCompact, bool isVerySmall) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 4 : 6,
        vertical: isVerySmall ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(isVerySmall ? 3 : 4),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: const Color(0xFF0F172A),
          fontSize: isVerySmall ? 8 : (isCompact ? 9 : 10),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority, bool isVerySmall) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'high':
        color = const Color(0xFFDC2626);
        break;
      case 'medium':
        color = const Color(0xFFD97706);
        break;
      case 'low':
        color = const Color(0xFF059669);
        break;
      default:
        color = const Color(0xFF6B7280);
    }

    return Container(
      width: isVerySmall ? 6 : 8,
      height: isVerySmall ? 6 : 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildRuleStatus(bool isActive, bool isCompact, bool isVerySmall) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 4 : (isCompact ? 6 : 8),
        vertical: isVerySmall ? 1 : (isCompact ? 2 : 3),
      ),
      decoration: BoxDecoration(
        color:
            isActive
                ? const Color(0xFF059669).withValues(alpha: 0.1)
                : const Color(0xFF6B7280).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isVerySmall ? 4 : 6),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: isVerySmall ? 9 : (isCompact ? 10 : 11),
          color: isActive ? const Color(0xFF059669) : const Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRuleListItem(RuleModel rule, bool isMobile) {
    return ShadCard(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Row(
          children: [
            _buildPriorityIndicator(
              rule.priority,
              false,
            ), // Fixed: Added second parameter
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.title,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (rule.description.isNotEmpty && !isMobile) ...[
                    const SizedBox(height: 4),
                    Text(
                      rule.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${rule.recycleCount}x recycle',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildResponsiveCategoryChips(
                        rule.categories.take(2).toList(),
                        true,
                        false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildRuleStatus(
                  rule.isActive,
                  isMobile,
                  false,
                ), // Fixed: Added third parameter
                const SizedBox(height: 8),
                ShadButton.ghost(
                  size: ShadButtonSize.sm,
                  onPressed: () => _showRuleActions(rule),
                  child: const Icon(Icons.more_vert, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF64748B).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rule_outlined,
              size: isMobile ? 48 : 64,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No rules found',
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first rule to get started',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 32),
          ShadButton(
            onPressed: () => presenter.onCreateRule(),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 8),
                Text('Create Rule'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFAB(BuildContext context) {
    return ShadButton(
      onPressed: () => presenter.onCreateRule(),
      backgroundColor: const Color(0xFF0F172A),
      foregroundColor: Colors.white,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 16),
          SizedBox(width: 8),
          Text('Create Rule'),
        ],
      ),
    );
  }

  void _showRuleActions(RuleModel rule) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _buildActionButton('Edit Rule', Icons.edit, () {
              Get.back();
              presenter.onEditRule(rule.id);
            }),
            const SizedBox(height: 12),
            _buildActionButton('Duplicate Rule', Icons.copy, () {
              Get.back();
              presenter.onDuplicateRule(rule.id);
            }),
            const SizedBox(height: 12),
            _buildActionButton('Delete Rule', Icons.delete, () {
              Get.back();
              presenter.onDeleteRule(rule.id);
            }, isDestructive: true),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child:
          isDestructive
              ? ShadButton.destructive(
                onPressed: onTap,
                child: Row(
                  children: [
                    Icon(icon, size: 16),
                    const SizedBox(width: 12),
                    Text(label),
                  ],
                ),
              )
              : ShadButton.outline(
                onPressed: onTap,
                child: Row(
                  children: [
                    Icon(icon, size: 16),
                    const SizedBox(width: 12),
                    Text(label),
                  ],
                ),
              ),
    );
  }

  void _showMobileFiltersBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterChips(true),
            const SizedBox(height: 16),
            _buildCategoryFilter(true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ShadButton(
                onPressed: () => Get.back(),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearRulesDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Clear All Rules',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'This action will permanently delete all rules. This cannot be undone.',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ShadButton.outline(
                      onPressed: () {
                        Get.back();
                        presenter.clearAllRules(reloadMockData: true);
                        SnackbarServiceHelper.showSuccess(
                          'All rules cleared and mock data loaded',
                          position: SnackPosition.TOP,
                          actionLabel: 'OK',
                        );
                      },
                      child: const Text('Clear & Load Mock Data'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ShadButton.destructive(
                    onPressed: () {
                      Get.back();
                      presenter.clearAllRules();
                      SnackbarServiceHelper.showSuccess(
                        'All rules have been cleared',
                        position: SnackPosition.TOP,
                        actionLabel: 'OK',
                      );
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ShadButton.outline(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
