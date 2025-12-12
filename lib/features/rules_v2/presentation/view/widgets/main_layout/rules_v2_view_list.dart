import 'package:flutter/material.dart';

class RulesV2ViewListWidget extends StatelessWidget {
  final Widget Function() buildFiltersSection;
  final Widget Function()? buildRulesGrid;
  final Widget Function()? buildPagination;

  const RulesV2ViewListWidget({
    super.key,
    required this.buildFiltersSection,
    this.buildRulesGrid,
    this.buildPagination,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFiltersSection(),
        if (buildPagination != null) buildPagination!(),
        if (buildRulesGrid != null) Expanded(child: buildRulesGrid!()),
      ],
    );
  }
}
