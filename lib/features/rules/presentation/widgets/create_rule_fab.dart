import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CreateRuleFAB extends StatelessWidget {
  const CreateRuleFAB({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF0F172A),
      foregroundColor: Colors.white,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 16),
          SizedBox(width: 8),
          Text('Create Rule'),
        ],
      ),
    );
  }
}
