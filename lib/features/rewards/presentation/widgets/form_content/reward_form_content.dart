import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../../core/app/themes/app_text_styles.dart';
import '../../../../../core/widgets/shadcn_date_picker.dart';
import '../../../../rules_v2/presentation/view/widgets/forms/rule_placeholder_field.dart';
import 'category_selection_component.dart';
import 'form_field_component.dart';
import 'reward_image_upload_section.dart';
import 'reward_section_header.dart';

class RewardViewFormContent extends StatelessWidget {
  final String title;
  final ValueChanged<String> onTitleChanged;

  final String description;
  final ValueChanged<String> onDescriptionChanged;

  final String headerImage;
  final VoidCallback onHeaderUpload;
  final VoidCallback onHeaderRemove;

  final List<String> carouselImages;
  final VoidCallback onAddCarouselImage;
  final ValueChanged<int> onRemoveCarouselAt;

  final String? logo;
  final VoidCallback onLogoUpload;
  final VoidCallback onLogoRemove;

  // final String barcode;
  // final ValueChanged<String> onBarcodeChanged;

  final List<String> availableCategories;
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onCategoriesChanged;

  final VoidCallback? onLinkRules;
  final int selectedRulesCount;

  final bool canCheckout;
  final ValueChanged<bool> onCanCheckoutChanged;

  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  final DateTime? expiryDate;
  final ValueChanged<DateTime?> onExpiryDateChanged;

  const RewardViewFormContent({
    super.key,
    required this.title,
    required this.onTitleChanged,
    required this.description,
    required this.onDescriptionChanged,
    required this.headerImage,
    required this.onHeaderUpload,
    required this.onHeaderRemove,
    required this.carouselImages,
    required this.onAddCarouselImage,
    required this.onRemoveCarouselAt,
    required this.logo,
    required this.onLogoUpload,
    required this.onLogoRemove,
    // required this.barcode,
    // required this.onBarcodeChanged,
    required this.availableCategories,
    required this.selectedCategories,
    required this.onCategoriesChanged,
    this.onLinkRules,
    this.selectedRulesCount = 0,
    required this.canCheckout,
    required this.onCanCheckoutChanged,
    required this.quantity,
    required this.onQuantityChanged,
    required this.expiryDate,
    required this.onExpiryDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RewardViewSectionHeader(title: 'Basic Information'),
          const SizedBox(height: 16),

          // Title
          RewardViewFormFieldComponent(
            label: 'Reward Title',
            required: true,
            child: ShadInput(
              placeholder: const Text('Enter reward title'),
              initialValue: title,
              onChanged: onTitleChanged,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          RewardViewFormFieldComponent(
            label: 'Description',
            required: true,
            child: ShadTextarea(
              placeholder: const Text(
                'Describe the reward and how to unlock it',
              ),
              initialValue: description,
              onChanged: onDescriptionChanged,
            ),
          ),
          const SizedBox(height: 16),

          // Quantity
          RewardViewFormFieldComponent(
            label: 'Quantity',
            required: true,
            helpText: 'Available quantity for this reward',
            child: ShadInput(
              placeholder: const Text('Enter quantity'),
              initialValue: quantity.toString(),
              onChanged: (value) => onQuantityChanged(int.tryParse(value) ?? 0),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          const SizedBox(height: 16),

          // Expiry Date
          RewardViewFormFieldComponent(
            label: "Expiry Date",
            helpText: "Date when this reward expires",
            child: ShadcnDatePicker(
              selectedDate: expiryDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
              placeholder: 'Select expiry date',
              onDateSelected: onExpiryDateChanged,
            ),
          ),
          const SizedBox(height: 24),

          const RewardViewSectionHeader(title: 'Images'),
          const SizedBox(height: 16),

          // Header Image
          RewardViewFormFieldComponent(
            label: 'Header Image',
            required: true,
            child: RewardViewHeaderImageUploadSection(
              headerImage: headerImage,
              onUpload: onHeaderUpload,
              onRemove: onHeaderRemove,
            ),
          ),
          const SizedBox(height: 16),

          // Carousel Images
          RewardViewFormFieldComponent(
            label: 'Carousel Images (1-3 images)',
            child: RewardCarouselImagesUploadSection(
              carouselImages: carouselImages,
              onAddImage: onAddCarouselImage,
              onRemoveAt: onRemoveCarouselAt,
            ),
          ),
          const SizedBox(height: 16),

          // Logo
          RewardViewFormFieldComponent(
            label: 'Brand Logo',
            child: RewardLogoUploadSection(
              logo: logo,
              onUpload: onLogoUpload,
              onRemove: onLogoRemove,
            ),
          ),
          const SizedBox(height: 24),

          const RewardViewSectionHeader(title: 'Details'),
          const SizedBox(height: 16),

          // Categories
          RewardViewFormFieldComponent(
            label: 'Categories',
            required: true,
            child: RewardViewCategorySelectionComponent(
              availableCategories: availableCategories,
              selectedCategories: selectedCategories,
              onSelectionChanged: onCategoriesChanged,
            ),
          ),
          const SizedBox(height: 24),

          // Rule placeholder
          RulePlaceholderField(
            label: 'Link Rules',
            placeholderText: 'Select rules to associate with this reward',
            icon: Icons.priority_high,
            onTap: onLinkRules,
            selectedCount: selectedRulesCount,
            itemType: 'rule',
            errorText: null,
          ),
          const SizedBox(height: 16),

          // Rules Section not implemented yet
          /* const RewardViewSectionHeader(title: 'Linked Rules'),
          const SizedBox(height: 16),

          RewardViewLinkedRulesSection(
            linkedRules: linkedRules,
            onLinkRules: onLinkRules,
            onRemoveRule: onRemoveRule,
          ),
          const SizedBox(height: 24),*/

          // Status Toggle
          RewardViewFormFieldComponent(
            label: 'Status',
            child: Row(
              children: [
                ShadSwitch(value: canCheckout, onChanged: onCanCheckoutChanged),
                const SizedBox(width: 8),
                Text(
                  canCheckout ? 'Active' : 'Archived',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
