import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';

class CsvStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CsvStepIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(
          steps.length,
          (index) => Expanded(
            child: Row(
              children: [
                if (index > 0) _buildConnector(index <= currentStep),
                Expanded(
                  child: _buildStep(
                    index: index + 1,
                    label: steps[index],
                    isActive: index <= currentStep,
                    isCompleted: index < currentStep,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      height: 2,
      width: 24,
      color: isActive ? AppColors.primary : AppColors.border,
    );
  }

  Widget _buildStep({
    required int index,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : AppColors.surfaceElevated,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : Text(
                    index.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}