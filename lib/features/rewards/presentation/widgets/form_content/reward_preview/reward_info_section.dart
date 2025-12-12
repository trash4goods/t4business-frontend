import 'package:flutter/material.dart';

class RewardViewInfoSection extends StatelessWidget {
  final String title;
  final List<String> categories;
  final bool canCheckout;

  const RewardViewInfoSection({
    super.key,
    required this.title,
    this.categories = const [],
    this.canCheckout = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: canCheckout 
                ? const Color(0xFF10B981).withValues(alpha: 0.1)
                : const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: canCheckout 
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  canCheckout ? Icons.local_offer : Icons.block,
                  size: 16,
                  color: canCheckout 
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 4),
                Text(
                  canCheckout ? 'Active Reward' : 'Inactive',
                  style: TextStyle(
                    fontSize: 12,
                    color: canCheckout 
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            title.isNotEmpty ? title : 'Reward Title',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              height: 1.2,
            ),
          ),
          
          // Categories
          if (categories.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: categories.map((category) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
