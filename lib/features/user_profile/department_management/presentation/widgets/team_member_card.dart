import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../data/models/manage_team.dart';

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    super.key,
    required this.member,
    required this.onEdit,
    required this.onTransfer,
    required this.onDelete,
  });

  final ManageTeamModel member;
  final VoidCallback onEdit;
  final VoidCallback onTransfer;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            member.name ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          if (member.isMyAccount ?? false) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'YOU',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF16A34A),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        member.displayEmail,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                // _StatusBadge(status: member.status ?? 'unknown'),
              ],
            ),

            const SizedBox(height: 16),

            // Role and last modified info
            Row(
              children: [
                _RoleBadge(role: member.roleName ?? 'member'),
                const Spacer(),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons
            if (member.isMyAccount ?? false) ... {
                   Expanded(
                    child: ShadButton.outline(
                  size: ShadButtonSize.sm,
                  onPressed: onDelete,
                  child: Icon(
                    Icons.exit_to_app,
                    size: 16,
                    color: Colors.red.shade600,
                  ),
                ),
                   ),    
            } else ... {
              Row(
              children: [
                Expanded(
                  child: ShadButton.outline(
                    size: ShadButtonSize.sm,
                    onPressed: onEdit,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 6),
                        Text('Edit'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ShadButton.outline(
                    size: ShadButtonSize.sm,
                    onPressed: onTransfer,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.swap_horiz, size: 16),
                        SizedBox(width: 6),
                        Text('Transfer'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ShadButton.outline(
                  size: ShadButtonSize.sm,
                  onPressed: onDelete,
                  child: Icon(
                    Icons.exit_to_app,
                    size: 16,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
            }
          ],
        ),
      ),
    );
  }

}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final isAdmin = role.toLowerCase() == 'admin';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color:
            isAdmin
                ? const Color(0xFF0F172A).withValues(alpha: 0.1)
                : const Color(0xFF64748B).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isAdmin ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}