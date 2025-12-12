import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class SelectionSearchBar extends StatefulWidget {
  final String searchQuery;
  final Function(String query) onSearchChanged;

  const SelectionSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  State<SelectionSearchBar> createState() => _SelectionSearchBarState();
}

class _SelectionSearchBarState extends State<SelectionSearchBar> {
  Timer? _searchTimer;

  @override
  Widget build(BuildContext context) {
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
      child: ShadInput(
        placeholder: const Text(
          'Search...',
          style: TextStyle(
            color: AppColors.mutedForeground,
            fontSize: 14,
          ),
        ),
        initialValue: widget.searchQuery,
        onChanged: (value) {
          _searchTimer?.cancel();
          _searchTimer = Timer(const Duration(milliseconds: 300), () {
            widget.onSearchChanged(value);
          });
        },
        leading: const Icon(
          Icons.search,
          size: 16,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }
}