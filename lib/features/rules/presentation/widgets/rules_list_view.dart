import 'package:flutter/material.dart';
import '../../data/models/rule.dart';
import '../presenters/interface/rule.dart';
import 'rule_list_item_widget.dart';

class RulesListView extends StatelessWidget {
  const RulesListView({
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
    return ListView.separated(
      itemCount: presenter.filteredRules.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final rule = presenter.filteredRules[index];
        return RuleListItemWidget(
          rule: rule,
          isMobile: isMobile,
          onShowActions: onShowActions,
        );
      },
    );
  }
}
