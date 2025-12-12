import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../presenters/interface/rule.dart';

class RulesContentHeader extends StatelessWidget {
  const RulesContentHeader({
    super.key,
    required this.presenter,
    required this.isMobile,
  });

  final RulesPresenterInterface presenter;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
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
          _ViewToggle(presenter: presenter),
          const SizedBox(width: 12),
          _SortDropdown(presenter: presenter),
        ],
      ],
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.presenter});
  final RulesPresenterInterface presenter;

  @override
  Widget build(BuildContext context) {
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
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({required this.presenter});
  final RulesPresenterInterface presenter;

  @override
  Widget build(BuildContext context) {
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
          value == 'name'
              ? 'Sort by Name'
              : value == 'date'
                  ? 'Sort by Date'
                  : value == 'priority'
                      ? 'Sort by Priority'
                      : value == 'category'
                          ? 'Sort by Category'
                          : 'Sort by Name',
        ),
        onChanged: presenter.onSortChanged,
      ),
    );
  }
}
