import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RulesV2ViewSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RulesV2ViewSearchField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ShadInput(
        placeholder: const Text('Search rules ...'),
        onChanged: onChanged,
        leading: const Padding(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.search, size: 18),
        ),
      ),
    );
  }
}
