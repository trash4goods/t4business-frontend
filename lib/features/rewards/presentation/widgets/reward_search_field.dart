import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RewardViewSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RewardViewSearchField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ShadInput(
        placeholder: const Text('Search rewards, rules, categories...'),
        onChanged: onChanged,
        leading: const Padding(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.search, size: 18),
        ),
      ),
    );
  }
}
