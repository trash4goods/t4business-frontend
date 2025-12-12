import 'package:flutter/widgets.dart';
import '../presenters/interface/rule.dart';

class RulesStatsCards extends StatelessWidget {
  const RulesStatsCards({
    super.key,
    required this.presenter,
    required this.isTablet,
  });

  final RulesPresenterInterface presenter;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    // Placeholder: actual content will be extracted from rule.dart during header refactor
    return const SizedBox.shrink();
  }
}
