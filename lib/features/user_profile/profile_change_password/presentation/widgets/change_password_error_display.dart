import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ChangePasswordErrorDisplay extends StatelessWidget {
  final String? error;
  const ChangePasswordErrorDisplay({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error!,
                style: ShadTheme.of(
                  context,
                ).textTheme.small.copyWith(color: const Color(0xFFDC2626)),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
