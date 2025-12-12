import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../app/themes/app_colors.dart';
import '../app/themes/app_text_styles.dart';

class RulesSelectionDialog extends StatelessWidget {
  final dynamic presenter;

  const RulesSelectionDialog({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      child: ShadCard(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.rule,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Link Rules to Reward',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select rules that users must complete to unlock this reward',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ShadButton.ghost(
                  onPressed: () => Get.back(),
                  size: ShadButtonSize.sm,
                  child: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Rules list
            Container(
              height: 350,
              child: Obx(() {
                final availableRules = presenter.availableRules;
                return availableRules.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.rule_outlined,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No rules available',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: availableRules.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final rule = availableRules[index];
                          return Obx(() {
                            final isSelected = presenter.formLinkedRules.contains(rule.id);

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected 
                                  ? AppColors.primary 
                                  : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                            color: isSelected 
                                ? AppColors.primary.withOpacity(0.05) 
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (presenter.formLinkedRules.contains(rule.id)) {
                                  presenter.removeLinkedRule(rule.id);
                                } else {
                                  presenter.addLinkedRule(rule.id);
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                              children: [
                                // Rule icon
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? AppColors.primary 
                                        : AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected 
                                          ? AppColors.primary 
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Icon(
                                    isSelected ? Icons.check : Icons.rule,
                                    color: isSelected 
                                        ? Colors.white 
                                        : AppColors.textSecondary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Rule details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rule.title,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          fontWeight: isSelected 
                                              ? FontWeight.w600 
                                              : FontWeight.w500,
                                          color: isSelected 
                                              ? AppColors.primary 
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${rule.recycleCount}x recycle • ${rule.categories.join(", ")}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Toggle switch
                                ShadSwitch(
                                  value: isSelected,
                                  onChanged: (_) {
                                    if (presenter.formLinkedRules.contains(rule.id)) {
                                      presenter.removeLinkedRule(rule.id);
                                    } else {
                                      presenter.addLinkedRule(rule.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        );
                          });
                        },
                      );
              }),
            ),
            const SizedBox(height: 24),

            // Footer buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ShadButton.outline(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ShadButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Confirm Selection'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
