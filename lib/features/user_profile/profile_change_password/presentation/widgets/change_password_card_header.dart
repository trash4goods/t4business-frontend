import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChangePasswordCardHeader extends StatelessWidget {
  const ChangePasswordCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.lock_outline,
            size: 20,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Your Password',
                style: ShadTheme.of(context).textTheme.large.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                'Choose a strong password to keep your account secure',
                style: ShadTheme.of(context).textTheme.muted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
