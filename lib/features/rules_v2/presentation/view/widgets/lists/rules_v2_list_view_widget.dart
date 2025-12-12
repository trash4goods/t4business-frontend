import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../data/models/rules_result.dart';

class RulesV2ListViewWidget extends StatelessWidget {
  final List<RulesResultModel> rules;
  final void Function(RulesResultModel rule) onEdit;
  final void Function(RulesResultModel rule) onDelete;
  final void Function(RulesResultModel rule)? onTap;

  const RulesV2ListViewWidget({
    super.key,
    required this.rules,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _RulesListItem(
            rule: rule,
            onEdit: () => onEdit(rule),
            onDelete: () => onDelete(rule),
            onTap: onTap != null ? () => onTap!(rule) : null,
          ),
        );
      },
    );
  }
}

class _RulesListItem extends StatelessWidget {
  final RulesResultModel rule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const _RulesListItem({
    required this.rule,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            // Rule Icon (similar to ProductListItem's image placeholder)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: (rule.status == 'active') 
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
                border: Border.all(
                  color: (rule.status == 'active') 
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                Icons.rule_rounded,
                size: 28,
                color: (rule.status == 'active') 
                  ? Colors.green.shade600
                  : Colors.orange.shade600,
              ),
            ),

            const SizedBox(width: 12),

            // Rule Info (similar to ProductListItem structure)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.name ?? 'Rule Name',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),
                  
                  // Description with quantity info
                  Row(
                    children: [
                      Icon(
                        Icons.recycling_rounded,
                        size: 14,
                        color: const Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Requires ${rule.quantity ?? 0} items to recycle',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Status chip (matching ProductListItem's status chip)
                  Row(
                    children: [
                      _buildStatusChip(rule.status ?? 'inactive'),
                      if (rule.cooldownPeriod != null || rule.usageLimit != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _buildMetadataText(rule),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Action Buttons (exactly like ProductListItem)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadButton.outline(
                  onPressed: onEdit,
                  size: ShadButtonSize.sm,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, size: 14),
                      SizedBox(width: 4),
                      Text('Edit', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                ShadButton.outline(
                  onPressed: onDelete,
                  size: ShadButtonSize.sm,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outline, size: 14, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        'Delete',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
        ),
      ),
    );
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