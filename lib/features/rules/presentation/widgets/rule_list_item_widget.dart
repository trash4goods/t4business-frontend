import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/rule.dart';
import 'priority_indicator.dart';
import 'rule_status_chip.dart';
import 'responsive_category_chips.dart';

class RuleListItemWidget extends StatelessWidget {
  const RuleListItemWidget({
    super.key,
    required this.rule,
    required this.isMobile,
    required this.onShowActions,
  });

  final RuleModel rule;
  final bool isMobile;
  final void Function(RuleModel rule) onShowActions;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Row(
          children: [
            PriorityIndicator(priority: rule.priority, isVerySmall: false),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.title,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (rule.description.isNotEmpty && !isMobile) ...[
                    const SizedBox(height: 4),
                    Text(
                      rule.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${rule.recycleCount}x recycle',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ResponsiveCategoryChips(
                        categories: rule.categories.take(2).toList(),
                        isCompact: true,
                        isVerySmall: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RuleStatusChip(
                  isActive: rule.isActive,
                  isCompact: isMobile,
                  isVerySmall: false,
                ),
                const SizedBox(height: 8),
                ShadButton.ghost(
                  size: ShadButtonSize.sm,
                  onPressed: () => onShowActions(rule),
                  child: const Icon(Icons.more_vert, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
