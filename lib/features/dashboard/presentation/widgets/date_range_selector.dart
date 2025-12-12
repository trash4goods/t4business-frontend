import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../../../../core/widgets/shadcn_date_picker.dart';
import 'preset_button.dart';

class DateRangeSelector extends StatelessWidget {
  final Rx<DateTimeRange?> selectedRange;
  final void Function(int days) onPresetDays;
  final VoidCallback onThisYear;
  final void Function(DateTime? date) onFromDateSelected;
  final void Function(DateTime? date) onToDateSelected;

  const DateRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onPresetDays,
    required this.onThisYear,
    required this.onFromDateSelected,
    required this.onToDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            PresetButton(label: 'Last 7 days', onPressed: () => onPresetDays(7)),
            PresetButton(label: 'Last 30 days', onPressed: () => onPresetDays(30)),
            PresetButton(label: 'Last 90 days', onPressed: () => onPresetDays(90)),
            PresetButton(label: 'This Year', onPressed: onThisYear),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From Date',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => ShadcnDatePicker(
                      selectedDate: selectedRange.value?.start,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      placeholder: 'Select start date',
                      onDateSelected: onFromDateSelected,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'To Date',
                    style: AppTextStyles.small.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => ShadcnDatePicker(
                      selectedDate: selectedRange.value?.end,
                      firstDate: selectedRange.value?.start ?? DateTime(2020),
                      lastDate: DateTime.now(),
                      placeholder: 'Select end date',
                      onDateSelected: onToDateSelected,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
