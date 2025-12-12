import 'package:flutter/material.dart';
import '../../data/models/rule.dart';
import '../presenters/interface/rule.dart';
import 'rule_card_widget.dart';

class RulesGridView extends StatelessWidget {
  const RulesGridView({
    super.key,
    required this.presenter,
    required this.isMobile,
    required this.onShowActions,
  });

  final RulesPresenterInterface presenter;
  final bool isMobile;
  final void Function(RuleModel rule) onShowActions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
          childAspectRatio = MediaQuery.of(context).size.width < 800 ? 2.7 : 3.2;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
          final w = MediaQuery.of(context).size.width;
          childAspectRatio = w < 800 ? 2.0 : w > 1290 ? 2.1 : 1.9;
        } else if (constraints.maxWidth < 1200) {
          crossAxisCount = 3;
          childAspectRatio = 1.8;
        } else {
          crossAxisCount = 4;
          childAspectRatio = 1.7;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: presenter.filteredRules.length,
          itemBuilder: (context, index) {
            final rule = presenter.filteredRules[index];
            return RuleCardWidget(
              rule: rule,
              isMobile: isMobile,
              onShowActions: onShowActions,
            );
          },
        );
      },
    );
  }
}
