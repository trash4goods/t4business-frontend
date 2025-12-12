import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../presenters/interface/rule.dart';
import '../../../../core/app/themes/app_colors.dart';

class RulesSidebar extends StatelessWidget {
  const RulesSidebar({
    super.key,
    required this.presenter,
    required this.isCompact,
  });

  final RulesPresenterInterface presenter;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchSection(presenter: presenter, isCompact: isCompact),
          const SizedBox(height: 16),
          _FilterSection(presenter: presenter, isCompact: isCompact),
          const SizedBox(height: 16),
          _QuickActions(presenter: presenter, isCompact: isCompact),
        ],
      ),
    );
  }
}

class _SearchSection extends StatelessWidget {
  const _SearchSection({required this.presenter, required this.isCompact});
  final RulesPresenterInterface presenter;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      backgroundColor: AppColors.surfaceElevated,
      border: Border.all(color: AppColors.fieldBorder, width: 1),
      shadows: const [],
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search',
            style: TextStyle(
              fontSize: isCompact ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ShadInput(
            onChanged: presenter.onSearchChanged,
            placeholder: const Text('Search rules...'),
            leading: const Icon(Icons.search, size: 18),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.presenter, required this.isCompact});
  final RulesPresenterInterface presenter;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      backgroundColor: AppColors.surfaceElevated,
      border: Border.all(color: AppColors.fieldBorder, width: 1),
      shadows: const [],
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: TextStyle(
              fontSize: isCompact ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _FilterChips(presenter: presenter, isCompact: isCompact),
          const SizedBox(height: 20),
          _CategoryFilter(presenter: presenter, isCompact: isCompact),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.presenter, required this.isCompact});
  final RulesPresenterInterface presenter;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: isCompact ? 6 : 8,
        runSpacing: isCompact ? 6 : 8,
        children: [
          _FilterChip(
            label: 'All',
            selected: presenter.selectedFilter.value == 'all',
            isCompact: isCompact,
            onTap: () => presenter.onFilterChanged('all'),
          ),
          _FilterChip(
            label: 'Active',
            selected: presenter.selectedFilter.value == 'active',
            isCompact: isCompact,
            onTap: () => presenter.onFilterChanged('active'),
          ),
          _FilterChip(
            label: 'Inactive',
            selected: presenter.selectedFilter.value == 'inactive',
            isCompact: isCompact,
            onTap: () => presenter.onFilterChanged('inactive'),
          ),
          _FilterChip(
            label: 'Recent',
            selected: presenter.selectedFilter.value == 'recent',
            isCompact: isCompact,
            onTap: () => presenter.onFilterChanged('recent'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.isCompact,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final bool isCompact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return selected
        ? ShadButton(
            onPressed: onTap,
            size: ShadButtonSize.sm,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isCompact ? 12 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : ShadButton.outline(
            onPressed: onTap,
            size: ShadButtonSize.sm,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isCompact ? 12 : 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.presenter, required this.isCompact});
  final RulesPresenterInterface presenter;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: isCompact ? 13 : 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: presenter.availableCategories.map((category) {
              final isSelected = presenter.selectedCategoriesFilter.contains(category);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => presenter.onCategoryFilterChanged(category),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Row(
                      children: [
                        ShadCheckbox(
                          value: isSelected,
                          onChanged: (value) => presenter.onCategoryFilterChanged(category),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: isCompact ? 13 : 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.presenter, required this.isCompact});
  final RulesPresenterInterface presenter;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      backgroundColor: AppColors.surfaceElevated,
      border: Border.all(color: AppColors.fieldBorder, width: 1),
      shadows: const [],
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: isCompact ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              _QuickActionButton(
                label: 'Create Rule',
                icon: Icons.add,
                isCompact: isCompact,
                isPrimary: true,
                onTap: presenter.onCreateRule,
              ),
              const SizedBox(height: 12),
              _QuickActionButton(
                label: 'Clear All Rules',
                icon: Icons.clear_all,
                isCompact: isCompact,
                onTap: () => presenter.showClearAllRulesConfirmation(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isCompact,
    this.isPrimary = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isCompact;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ShadButton(
              onPressed: onTap,
              size: isCompact ? ShadButtonSize.sm : ShadButtonSize.lg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: isCompact ? 16 : 18),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isCompact ? 13 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ShadButton.outline(
              onPressed: onTap,
              size: isCompact ? ShadButtonSize.sm : ShadButtonSize.lg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: isCompact ? 16 : 18),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isCompact ? 13 : 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
