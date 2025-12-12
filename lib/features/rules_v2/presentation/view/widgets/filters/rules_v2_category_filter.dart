import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RulesV2AdaptiveFilter extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onChanged;

  const RulesV2AdaptiveFilter({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ShadSelect<String>(
      initialValue: selectedCategory.isEmpty ? categories.first : selectedCategory,
      selectedOptionBuilder: (context, value) => Text(value),
      onChanged: (value) => onChanged(value ?? ''),
      options: [
        ...categories.map(
          (category) => ShadOption(value: category, child: Text(category)),
        ),
      ],
    );
  }
}
