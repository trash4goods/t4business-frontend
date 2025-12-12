import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChangePasswordSecurityTips extends StatelessWidget {
  const ChangePasswordSecurityTips({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tips_and_updates,
                size: 16,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                'Password Security Tips',
                style: theme.textTheme.small.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• Use at least 12 characters for maximum security\n'
            '• Include uppercase and lowercase letters\n'
            '• Add numbers and special characters (!@#\$%^&*)\n'
            '• Avoid dictionary words, names, or personal information\n'
            '• Don\'t reuse passwords from other accounts',
            style: theme.textTheme.muted.copyWith(height: 1.4, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
