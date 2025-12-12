import 'package:flutter/widgets.dart';
import '../presenters/interface/rule.dart';

class MobileStatsRow extends StatelessWidget {
  const MobileStatsRow({
    super.key,
    required this.presenter,
  });

  final RulesPresenterInterface presenter;

  @override
  Widget build(BuildContext context) {
    // Placeholder: actual content will be extracted from rule.dart during header refactor
    return const SizedBox.shrink();
  }
}
