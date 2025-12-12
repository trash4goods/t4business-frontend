import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../../core/app/themes/app_colors.dart';
import '../forms/rule_text_field.dart';
import '../forms/rule_status_toggle.dart';
import '../forms/rule_numeric_field.dart';
import '../forms/rule_date_field.dart';
import '../forms/rule_placeholder_field.dart';
import '../forms/rule_toggle_field.dart';
import 'rule_form_mode.dart';

class CreateRuleDialog extends StatelessWidget {
  // Form mode
  final RuleFormMode mode;

  // Form field values
  final bool status;
  final DateTime? expiryDate;

  // Form validation
  final bool isFormValid;
  final String? nameError;
  final String? quantityError;
  final String? cooldownPeriodError;
  final String? usageLimitError;
  final String? expiryDateError;
  final String? barcodeSelectionError;
  final String? rewardSelectionError;

  // Callback functions
  final ValueChanged<String> onNameChanged;
  final ValueChanged<bool> onStatusChanged;
  final ValueChanged<int?> onQuantityChanged;
  final ValueChanged<int?> onCooldownPeriodChanged;
  final ValueChanged<int?> onUsageLimitChanged;
  final ValueChanged<DateTime?> onExpiryDateChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final VoidCallback? onRewardsSelection;
  final VoidCallback? onBarcodesSelection;

  // Selection counts
  final int rewardsCount;
  final int barcodesCount;

  // Toggle states
  final bool allProducts;
  final bool allBarcodes;
  final bool addAllProducts;
  final bool addAllBarcodes;
  final bool removeAll;
  final bool canRemoveAll;
  final bool canAddAllProducts;
  final bool canAddAllBarcodes;

  // Toggle callbacks
  final ValueChanged<bool>? onAllProductsChanged;
  final ValueChanged<bool>? onAllBarcodesChanged;
  final ValueChanged<bool>? onAddAllProductsChanged;
  final ValueChanged<bool>? onAddAllBarcodesChanged;
  final ValueChanged<bool>? onRemoveAllChanged;

  // TextEditingControllers
  final TextEditingController nameTextFieldController;
  final TextEditingController quantityTextFieldController;
  final TextEditingController cooldownPeriodTextFieldController;
  final TextEditingController usageLimitTextFieldController;

  const CreateRuleDialog({
    super.key,
    required this.mode,
    required this.status,
    required this.expiryDate,
    required this.isFormValid,
    required this.nameError,
    required this.quantityError,
    required this.cooldownPeriodError,
    required this.usageLimitError,
    required this.expiryDateError,
    required this.barcodeSelectionError,
    required this.rewardSelectionError,
    required this.onNameChanged,
    required this.onStatusChanged,
    required this.onQuantityChanged,
    required this.onCooldownPeriodChanged,
    required this.onUsageLimitChanged,
    required this.onExpiryDateChanged,
    required this.onCancel,
    required this.onSave,
    this.onRewardsSelection,
    this.onBarcodesSelection,
    required this.rewardsCount,
    required this.barcodesCount,
    required this.allProducts,
    required this.allBarcodes,
    required this.addAllProducts,
    required this.addAllBarcodes,
    required this.removeAll,
    required this.canRemoveAll,
    required this.canAddAllProducts,
    required this.canAddAllBarcodes,
    this.onAllProductsChanged,
    this.onAllBarcodesChanged,
    this.onAddAllProductsChanged,
    this.onAddAllBarcodesChanged,
    this.onRemoveAllChanged,
    required this.nameTextFieldController,
    required this.quantityTextFieldController,
    required this.cooldownPeriodTextFieldController,
    required this.usageLimitTextFieldController,
  });

  @override
  Widget build(BuildContext context) {
    return ShadDialog(
      closeIcon: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Semantics(
          enabled: true,
          button: true,
          child: GestureDetector(
            onTap: onCancel,
            child: Icon(Icons.close, size: 17),
          ),
        ),
      ),
      title: Text(mode.title),
      actions: [
        ShadButton.outline(onPressed: onCancel, child: const Text('Cancel')),
        ShadButton(
          enabled: isFormValid,
          onPressed: onSave,
          child: Text(mode.saveButtonText),
        ),
      ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mode.isCreate
                      ? 'Create a new rule by filling in the details below.'
                      : 'Update the rule details below.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Name field (required)
                RuleTextField(
                  controller: nameTextFieldController,
                  label: 'Rule Name',
                  placeholder: 'Enter rule name',
                  isRequired: true,
                  onChanged: onNameChanged,
                  errorText: nameError,
                ),
                const SizedBox(height: 16),

                // Status toggle
                RuleStatusToggle(
                  label: 'Status',
                  value: status,
                  onChanged: onStatusChanged,
                ),
                const SizedBox(height: 16),

                // Quantity field (required)
                RuleNumericField(
                  controller: quantityTextFieldController,
                  label: 'Quantity',
                  placeholder: 'Number of items needed',
                  isRequired: true,
                  onChanged: onQuantityChanged,
                  errorText: quantityError,
                ),
                const SizedBox(height: 16),

                // Cooldown period field (optional)
                RuleNumericField(
                  controller: cooldownPeriodTextFieldController,
                  label: 'Cooldown Period (days)',
                  placeholder: 'Days before rule can be used again',
                  onChanged: onCooldownPeriodChanged,
                  errorText: cooldownPeriodError,
                ),
                const SizedBox(height: 16),

                // Usage limit field (optional)
                RuleNumericField(
                  controller: usageLimitTextFieldController,
                  label: 'Usage Limit',
                  placeholder: 'Maximum times rule can be triggered',
                  onChanged: onUsageLimitChanged,
                  errorText: usageLimitError,
                ),
                const SizedBox(height: 16),

                // Expiry date field (optional)
                RuleDateField(
                  label: 'Expiry Date',
                  value: expiryDate,
                  placeholder: 'Select expiry date',
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 3650),
                  ), // 10 years
                  onChanged: onExpiryDateChanged,
                  errorText: expiryDateError,
                ),
                const SizedBox(height: 24),

                // Section divider
                const Divider(color: AppColors.border),
                const SizedBox(height: 16),

                // Rewards placeholder
                RulePlaceholderField(
                  label: 'Link Rewards',
                  placeholderText: 'Select rewards to associate with this rule',
                  icon: Icons.card_giftcard,
                  onTap: onRewardsSelection,
                  selectedCount: rewardsCount,
                  itemType: 'reward',
                  errorText: rewardSelectionError,
                ),
                const SizedBox(height: 16),

                // Barcodes placeholder
                RulePlaceholderField(
                  label: 'Select Barcodes',
                  placeholderText: 'Choose barcodes required for this rule',
                  icon: Icons.qr_code_scanner,
                  onTap: onBarcodesSelection,
                  selectedCount: barcodesCount,
                  itemType: 'barcode',
                  errorText: barcodeSelectionError,
                ),
                const SizedBox(height: 16),

                // Bulk operation toggles
                const Divider(color: AppColors.border),
                const SizedBox(height: 16),

                // Show toggles based on mode
                if (mode.isCreate) ...[
                  // CREATE MODE: All Products/Barcodes toggles
                  RuleToggleField(
                    label: 'Link All Rewards',
                    description:
                        'Automatically link all products from your department',
                    value: allProducts,
                    onChanged: onAllProductsChanged ?? (value) {},
                    enabled: onAllProductsChanged != null,
                  ),
                  const SizedBox(height: 12),
                  RuleToggleField(
                    label: 'Link All Barcodes',
                    description:
                        'Automatically link all barcodes from your department',
                    value: allBarcodes,
                    onChanged: onAllBarcodesChanged ?? (value) {},
                    enabled: onAllBarcodesChanged != null,
                  ),
                ] else ...[
                  // EDIT MODE: Add All/Remove All toggles
                  RuleToggleField(
                    label: 'Add All Rewards',
                    description: canAddAllProducts
                        ? 'Add all rewards from your department to this rule'
                        : 'You must disable the Remove All Items first',
                    value: addAllProducts,
                    onChanged: onAddAllProductsChanged ?? (value) {},
                    enabled: canAddAllProducts && onAddAllProductsChanged != null,
                  ),
                  const SizedBox(height: 12),
                  RuleToggleField(
                    label: 'Add All Barcodes',
                    description: canAddAllBarcodes
                        ? 'Add all barcodes from your department to this rule'
                        : 'You must disable the Remove All Items first',
                    value: addAllBarcodes,
                    onChanged: onAddAllBarcodesChanged ?? (value) {},
                    enabled: canAddAllBarcodes && onAddAllBarcodesChanged != null,
                  ),
                  const SizedBox(height: 12),
                  RuleToggleField(
                    label: 'Remove All Items',
                    description:
                        canRemoveAll
                            ? 'Remove all products and barcodes from this rule'
                            : 'Must have at least one reward or barcode linked first',
                    value: removeAll,
                    onChanged:
                        canRemoveAll
                            ? (onRemoveAllChanged ?? (value) {})
                            : (value) {},
                    enabled: canRemoveAll && onRemoveAllChanged != null,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
