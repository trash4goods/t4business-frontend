import 'package:flutter/material.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class RulePlaceholderField extends StatelessWidget {
  final String label;
  final String placeholderText;
  final IconData? icon;
  final VoidCallback? onTap;
  final int? selectedCount;
  final String? selectedText;
  final String itemType; // 'reward' or 'barcode'
  final String? errorText;

  const RulePlaceholderField({
    super.key,
    required this.label,
    required this.placeholderText,
    this.icon,
    this.onTap,
    this.selectedCount,
    this.selectedText,
    required this.itemType,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        // Fixed container for consistent dimensions
        Container(
          height: 56, // Fixed height for consistency
          width: double.infinity, // Full width
          decoration: BoxDecoration(
            border: Border.all(
              color: _hasSelection() ? AppColors.primary.withValues(alpha: 0.3) : AppColors.border,
              width: _hasSelection() ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
            color: _hasSelection() 
                ? AppColors.primary.withValues(alpha: 0.02)
                : AppColors.card,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(6),
              splashColor: AppColors.primary.withValues(alpha: 0.1),
              highlightColor: AppColors.primary.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Icon with fixed width for alignment
                    if (icon != null) 
                      Container(
                        width: 20,
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          icon,
                          size: 18,
                          color: _hasSelection() 
                              ? AppColors.primary 
                              : AppColors.textSecondary,
                        ),
                      ),
                    if (icon != null) const SizedBox(width: 12),
                    
                    // Text content - takes remaining space
                    Expanded(
                      child: Text(
                        _getDisplayText(),
                        style: TextStyle(
                          fontSize: 14,
                          color: _hasSelection() 
                              ? AppColors.textPrimary 
                              : AppColors.textSecondary,
                          fontWeight: _hasSelection() 
                              ? FontWeight.w500 
                              : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    // Arrow with fixed width for alignment
                    Container(
                      width: 20,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  bool _hasSelection() {
    return selectedCount != null && selectedCount! > 0;
  }

  String _getDisplayText() {
    // If custom selectedText is provided, use it (for backward compatibility)
    if (selectedText != null && _hasSelection()) {
      return selectedText!;
    }
    
    // Generate text based on count and item type
    final count = selectedCount ?? 0;
    String pluralType;
    if (itemType == 'reward') {
      pluralType = 'rewards';
    } else if (itemType == 'rule') {
      pluralType = 'rules';
    } else {
      pluralType = 'barcodes';
    }
    final singularType = itemType;
    
    if (count == 0) {
      return 'no $pluralType linked';
    } else if (count == 1) {
      return '1 $singularType linked';
    } else {
      return '$count $pluralType linked';
    }
  }
}