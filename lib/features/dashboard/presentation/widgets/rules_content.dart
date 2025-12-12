import 'package:flutter/material.dart';
import 'package:t4g_for_business/features/rules/presentation/view/rule.dart' as rules_view;
import 'page_header.dart';

class RulesContent extends StatelessWidget {
  final BoxConstraints constraints;
  const RulesContent({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          constraints: constraints,
          title: 'Rules',
          subtitle: 'Create and manage recycling rules for your rewards program',
          icon: Icons.rule_outlined,
        ),
        const Expanded(child: rules_view.RulesPage()),
      ],
    );
  }
}
