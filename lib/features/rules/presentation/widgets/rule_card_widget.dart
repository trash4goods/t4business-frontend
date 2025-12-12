import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/rule.dart';
import 'priority_indicator.dart';
import 'rule_status_chip.dart';
import 'responsive_category_chips.dart';

class RuleCardWidget extends StatelessWidget {
  const RuleCardWidget({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isCompact = cardWidth < 280;
        final isVerySmall = cardWidth < 200;

        return ShadCard(
          padding: EdgeInsets.all(isVerySmall ? 8 : (isCompact ? 10 : 12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  PriorityIndicator(priority: rule.priority, isVerySmall: isVerySmall),
                  const Spacer(),
                  RuleStatusChip(
                    isActive: rule.isActive,
                    isCompact: isCompact,
                    isVerySmall: isVerySmall,
                  ),
                  SizedBox(width: isVerySmall ? 4 : 8),
                  ShadButton.ghost(
                    size: isVerySmall ? ShadButtonSize.sm : ShadButtonSize.sm,
                    onPressed: () => onShowActions(rule),
                    child: Icon(Icons.more_vert, size: isVerySmall ? 14 : 16),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                rule.title,
                style: TextStyle(
                  fontSize: isVerySmall ? 14 : (isCompact ? 15 : 16),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (rule.description.isNotEmpty && !isVerySmall) ...[
                SizedBox(height: isCompact ? 6 : 8),
                Text(
                  rule.description,
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 13,
                    color: const Color(0xFF64748B),
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isVerySmall ? 6 : 8,
                      vertical: isVerySmall ? 2 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(isVerySmall ? 4 : 6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.recycling,
                          size: isVerySmall ? 12 : 14,
                          color: const Color(0xFF0F172A),
                        ),
                        SizedBox(width: isVerySmall ? 2 : 4),
                        Text(
                          '${rule.recycleCount}x',
                          style: TextStyle(
                            fontSize: isVerySmall ? 10 : 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: ResponsiveCategoryChips(
                      categories: rule.categories,
                      isCompact: isCompact,
                      isVerySmall: isVerySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
