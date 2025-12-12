import 'package:flutter/material.dart';
import '../../../../core/widgets/product_list_item.dart';
import '../../data/models/reward_result.dart';
import '../presenters/interface/rewards_presenter.interface.dart';

class RewardsViewListViewWidget extends StatelessWidget {
  final RewardsPresenterInterface presenter;
  final void Function(RewardResultModel reward) onEdit;
  final void Function(RewardResultModel reward) onDelete;
  final void Function(RewardResultModel reward) onTap;

  const RewardsViewListViewWidget({
    super.key,
    required this.presenter,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: presenter.filteredRewards?.length ?? 0,
      itemBuilder: (context, index) {
        final reward = presenter.filteredRewards?[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ProductListItem(
            imageUrl: reward?.headerImage,
            title: (reward?.name ?? '').isNotEmpty ? reward!.name! : 'Unnamed Reward',
            description: (reward?.description ?? '').isNotEmpty ? reward!.description! : 'No description available',
            status: reward?.status ?? 'Unknown',
            onEdit: () => onEdit(reward!),
            onDelete: () => onDelete(reward!),
            onTap: () => onTap(reward!),
          ),
        );
      },
    );
  }
}