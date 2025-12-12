import 'package:flutter/material.dart';

class RewardsViewListWidget extends StatelessWidget {
  final Widget Function() buildFiltersSection;
  final Widget Function() buildRewardsGrid;
  final Widget Function()? buildPagination;

  const RewardsViewListWidget({
    super.key,
    required this.buildFiltersSection,
    required this.buildRewardsGrid,
    this.buildPagination,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFiltersSection(),
        if (buildPagination != null) buildPagination!(),
        Expanded(child: buildRewardsGrid()),
      ],
    );
  }
}
