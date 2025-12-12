import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';

class RuleDateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String? placeholder;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String? errorText;

  const RuleDateField({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    this.placeholder,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
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
        ShadButton.outline(
          onPressed: enabled ? () => _showDatePicker(context) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                value != null
                    ? _formatDate(value!)
                    : placeholder ?? 'Select $label',
                style: TextStyle(
                  color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: Text('Select $label'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              height: 400,
              child: ShadCalendar(
                selected: value,
                onChanged: (date) {
                  onChanged(date);
                  Navigator.of(context).pop();
                },
                selectableDayPredicate: (date) {
                  if (firstDate != null && date.isBefore(firstDate!)) {
                    return false;
                  }
                  if (lastDate != null && date.isAfter(lastDate!)) {
                    return false;
                  }
                  return true;
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                if (value != null)
                  ShadButton.outline(
                    onPressed: () {
                      onChanged(null);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}