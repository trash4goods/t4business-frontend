import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RulesMobileFilters extends StatelessWidget {
  const RulesMobileFilters({
    super.key,
    required this.onSearchChanged,
    required this.onFilterPressed,
  });

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShadInput(
              onChanged: onSearchChanged,
              placeholder: const Text('Search rules...'),
              leading: const Icon(Icons.search, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          ShadButton.outline(
            onPressed: onFilterPressed,
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }
}
