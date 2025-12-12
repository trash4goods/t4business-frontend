import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../app/themes/app_colors.dart';

class ShadcnDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String placeholder;
  final ValueChanged<DateTime?> onDateSelected;
  final bool enabled;

  const ShadcnDatePicker({
    super.key,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    required this.placeholder,
    required this.onDateSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ShadButton.outline(
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
            selectedDate != null
                ? _formatDate(selectedDate!)
                : placeholder,
            style: TextStyle(
              color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Select Date'),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 300,
              height: 400,
              child: ShadCalendar(
                selected: selectedDate,
                onChanged: (date) {
                  onDateSelected(date);
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
