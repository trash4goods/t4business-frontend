import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import 'performer_item.dart';

class TopPerformers extends StatelessWidget {
  final VoidCallback? onViewAll;

  const TopPerformers({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final products = const ['Plastic Bottles', 'Paper Waste', 'Metal Cans', 'Glass Items'];
    final counts = const ['847', '623', '459', '234'];
    final percentages = const ['32%', '24%', '18%', '26%'];

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(
                  'Top Performers',
                  style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
                ),
                ShadButton.outline(
                  onPressed: onViewAll,
                  size: ShadButtonSize.sm,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: index < 3 ? 16 : 0),
                child: PerformerItem(
                  rank: index + 1,
                  name: products[index],
                  count: counts[index],
                  percentage: percentages[index],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
