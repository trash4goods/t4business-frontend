import 'package:flutter/material.dart';
import '../../../rewards/presentation/views/rewards.dart';
import 'page_header.dart';

class MarketplaceContent extends StatelessWidget {
  final BoxConstraints constraints;
  const MarketplaceContent({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          constraints: constraints,
          title: 'Rewards',
          subtitle: 'Manage your marketplace product catalog',
          icon: Icons.storefront_outlined,
        ),
        const Expanded(child: RewardsView()),
      ],
    );
  }
}
