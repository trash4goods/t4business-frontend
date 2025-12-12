import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../data/models/rules_result.dart';

class RulesV2CardWidget extends StatelessWidget {
  final RulesResultModel rule;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RulesV2CardWidget({
    super.key,
    required this.rule,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rule Icon Header - Fixed height
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color:
                  (rule.status == 'active')
                      ? Colors.green.withValues(alpha: 0.05)
                      : Colors.orange.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth;
                final isVerySmallCard = cardWidth < 140;
                final isActive = (rule.status ?? 'inactive').toLowerCase() == 'active';
                
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color:
                              isActive
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isActive
                                    ? Colors.green.withValues(alpha: 0.3)
                                    : Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.rule_rounded,
                          size: 24,
                          color:
                              isActive
                                  ? Colors.green.shade600
                                  : Colors.orange.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (rule.status ?? 'inactive').toUpperCase(),
                        style: TextStyle(
                          fontSize: isVerySmallCard ? 8 : 9,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Content area - Flexible
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth;
                final isVerySmallCard = cardWidth < 140;
                final isSmallCard = cardWidth < 180;
                final padding =
                    isVerySmallCard ? 8.0 : (isSmallCard ? 10.0 : 12.0);

                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        rule.name ?? 'Rule Name',
                        style: TextStyle(
                          fontSize:
                              isVerySmallCard ? 11 : (isSmallCard ? 13 : 14),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                        maxLines: isVerySmallCard ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: isVerySmallCard ? 6 : 8),

                      // Quantity requirement
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isVerySmallCard ? 6 : 8,
                          vertical: isVerySmallCard ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.recycling_rounded,
                              size: isVerySmallCard ? 12 : 14,
                              color: const Color(0xFF3B82F6),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${rule.quantity ?? 0} items',
                                style: TextStyle(
                                  fontSize: isVerySmallCard ? 10 : 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF3B82F6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Show metadata on normal cards only
                      if (!isSmallCard &&
                          (rule.cooldownPeriod != null ||
                              rule.usageLimit != null)) ...[
                        const SizedBox(height: 6),
                        Flexible(
                          child: Text(
                            _buildMetadataText(rule),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],

                    ],
                  ),
                );
              },
            ),
          ),

          // Action buttons at bottom - Fixed height
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final buttonWidth = constraints.maxWidth;
                final isVerySmallButton = buttonWidth < 140;
                final isSmallButton = buttonWidth < 180;

                return _buildActionButtons(isVerySmallButton, isSmallButton);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isVerySmall, bool isSmall) {
    if (isVerySmall) {
      // Icon-only buttons for very small cards
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CompactIconButton(onPressed: onEdit, icon: Icons.edit_outlined),
          _CompactIconButton(
            onPressed: onDelete,
            icon: Icons.delete_outline,
            isDelete: true,
          ),
        ],
      );
    } else if (isSmall) {
      // One expanded button + one icon button for small cards
      return Row(
        children: [
          Expanded(
            child: _SecondaryButton(
              onPressed: onEdit,
              icon: Icons.edit_outlined,
              label: 'Edit',
              compact: true,
            ),
          ),
          const SizedBox(width: 4),
          _CompactIconButton(
            onPressed: onDelete,
            icon: Icons.delete_outline,
            isDelete: true,
          ),
        ],
      );
    } else {
      // Full buttons for normal cards
      return Row(
        children: [
          Expanded(
            child: _SecondaryButton(
              onPressed: onEdit,
              icon: Icons.edit_outlined,
              label: 'Edit',
              compact: false,
            ),
          ),
          const SizedBox(width: 6),
          _SecondaryButton(
            onPressed: onDelete,
            icon: Icons.delete_outline,
            label: 'Delete',
            compact: false,
            isDelete: true,
          ),
        ],
      );
    }
  }

  String _buildMetadataText(RulesResultModel rule) {
    final parts = <String>[];
    if (rule.cooldownPeriod != null) {
      parts.add('${rule.cooldownPeriod}d cooldown');
    }
    if (rule.usageLimit != null) {
      parts.add('${rule.usageLimit} uses max');
    }
    return parts.join(' • ');
  }
}

// Custom compact icon button matching rewards pattern
class _CompactIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final bool isDelete;

  const _CompactIconButton({
    required this.onPressed,
    required this.icon,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color:
              isDelete
                  ? Colors.red.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Icon(
            icon,
            size: 12,
            color: isDelete ? Colors.red.shade700 : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

// Custom secondary button matching rewards pattern
class _SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String label;
  final bool compact;
  final bool isDelete;

  const _SecondaryButton({
    required this.onPressed,
    this.icon,
    required this.label,
    this.compact = false,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        isDelete ? Colors.red.shade700 : const Color(0xFF374151);
    final borderColor =
        isDelete
            ? Colors.red.withValues(alpha: 0.3)
            : Colors.grey.withValues(alpha: 0.3);

    return SizedBox(
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: BorderSide(color: borderColor),
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 12,
            vertical: 0,
          ),
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: compact ? 12 : 14),
            if (icon != null) SizedBox(width: compact ? 3 : 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: compact ? 11 : 12,
                  color: buttonColor,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
