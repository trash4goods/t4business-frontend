import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TeamManagementEmptyState extends StatelessWidget {
  const TeamManagementEmptyState({
    super.key,
    required this.isMobile,
    required this.onAddMember,
  });

  final bool isMobile;
  final VoidCallback onAddMember;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF64748B).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.group_outlined,
              size: isMobile ? 48 : 64,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No team members yet',
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building your team by adding your first member',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ShadButton(
            onPressed: onAddMember,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 8),
                Text('Add First Member'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
