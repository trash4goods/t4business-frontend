import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';
import '../../../../../../core/widgets/pagination/core_pagination_widget.dart';
import 'selection_item.dart';
import 'selection_header.dart';
import 'selection_counter.dart';
import 'selection_actions.dart';

class SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final RxList<int> selectedIds;
  final bool isLoading;
  final String searchQuery;
  // Pagination properties
  final int currentPage;
  final int totalCount;
  final int perPage;
  final bool hasNext;
  final String Function(T item) getDisplayName;
  final int Function(T item) getId;
  final String? Function(T item) getSubtitle;
  final String? Function(T item) getImageUrl;
  final Function(String query) onSearchChanged;
  final Function(int id) onItemToggled;
  final Function(int page) onPageChanged;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  // Optional create button functionality
  final String? createButtonText;
  final VoidCallback? onCreateNew;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedIds,
    required this.isLoading,
    required this.searchQuery,
    required this.currentPage,
    required this.totalCount,
    required this.perPage,
    required this.hasNext,
    required this.getDisplayName,
    required this.getId,
    required this.getSubtitle,
    required this.getImageUrl,
    required this.onSearchChanged,
    required this.onItemToggled,
    required this.onPageChanged,
    required this.onConfirm,
    required this.onCancel,
    this.createButtonText,
    this.onCreateNew,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap the content in Obx so changes to the RxList selectedIds
    // cause the bottom sheet to rebuild and reflect selection state.
    return Obx(
      () => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          border: Border(
            top: BorderSide(color: AppColors.border),
            left: BorderSide(color: AppColors.border),
            right: BorderSide(color: AppColors.border),
          ),
        ),
        child: Column(
          children: [
            SelectionHeader(title: title, onCancel: onCancel),

            _buildSearchSection(),

            SelectionCounter(selectedCount: selectedIds.length),

            // Items list
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final itemId = getId(item);
                          // Use the reactive selectedIds inside this Obx-wrapped
                          // parent so contains() will trigger rebuilds when
                          // the RxList changes.
                          final isSelected = selectedIds.contains(itemId);

                          return SelectionItem(
                            isSelected: isSelected,
                            displayName: getDisplayName(item),
                            subtitle: getSubtitle(item),
                            imageUrl: getImageUrl(item),
                            onTap: () => onItemToggled(itemId),
                          );
                        },
                      ),
            ),

            // Pagination
            CorePaginationWidget(
              currentPage: currentPage,
              totalCount: totalCount,
              perPage: perPage,
              hasNext: hasNext,
              onPageChanged: onPageChanged,
              isLoading: isLoading,
            ),

            SelectionActions(
              selectedCount: selectedIds.length,
              onConfirm: onConfirm,
              onCancel: onCancel,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShadInput(
              placeholder: const Text(
                'Search...',
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: 14,
                ),
              ),
              initialValue: searchQuery,
              onChanged: onSearchChanged,
              leading: const Icon(
                Icons.search,
                size: 16,
                color: AppColors.mutedForeground,
              ),
            ),
          ),
          if (createButtonText != null && onCreateNew != null) ...[
            const SizedBox(width: 12),
            ShadButton.outline(
              onPressed: onCreateNew,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    createButtonText!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
