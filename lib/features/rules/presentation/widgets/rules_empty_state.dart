import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RulesEmptyState extends StatelessWidget {
  const RulesEmptyState({
    super.key,
    required this.isMobile,
    required this.onCreateRule,
  });

  final bool isMobile;
  final VoidCallback onCreateRule;

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
              Icons.rule_outlined,
              size: isMobile ? 48 : 64,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No rules found',
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first rule to get started',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 32),
          ShadButton(
            onPressed: onCreateRule,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 8),
                Text('Create Rule'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
