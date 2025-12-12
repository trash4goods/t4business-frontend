import 'package:flutter/widgets.dart';

class RulesV2ViewResponsiveLayout extends StatelessWidget {
  final Widget Function() buildRulesList;
  const RulesV2ViewResponsiveLayout({
    super.key,
    required this.buildRulesList,
  });

  @override
  Widget build(BuildContext context) {
    return buildRulesList();
  }
}
