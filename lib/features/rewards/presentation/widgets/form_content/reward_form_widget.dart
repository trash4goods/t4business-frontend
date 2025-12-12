import 'package:flutter/material.dart';
import '../../../../../core/app/themes/app_colors.dart';
import '../../../../product_managment/presentation/widgets/primary_button.dart';
import '../../../../product_managment/presentation/widgets/secondary_button.dart';
import 'reward_form_content.dart';
import 'reward_form_header.dart';

class RewardViewFormWidget extends StatelessWidget {
  // Header props
  final bool isEditing;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final Future<void> Function() onSave;
  final Future<void> Function() onCreate;

  // Content props
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

  const RewardViewFormWidget({
    super.key,
    // header
    required this.isEditing,
    required this.isLoading,
    required this.isFormValid,
    required this.onBack,
    required this.onCancel,
    required this.onSave,
    required this.onCreate,
    // content
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        
        return Column(
          children: [
            // Hide header on mobile to avoid clutter with tabs
            if (!isMobile) RewardViewFormHeader(
              isEditing: isEditing,
              isLoading: isLoading,
              isFormValid: isFormValid,
              onBack: onBack,
              onCancel: onCancel,
              onSave: () async => await onSave(),
              onCreate: () async => await onCreate(),
            ),
            Expanded(
              child: RewardViewFormContent(
                title: title,
                onTitleChanged: onTitleChanged,
                description: description,
                onDescriptionChanged: onDescriptionChanged,
                headerImage: headerImage,
                onHeaderUpload: onHeaderUpload,
                onHeaderRemove: onHeaderRemove,
                carouselImages: carouselImages,
                onAddCarouselImage: onAddCarouselImage,
                onRemoveCarouselAt: onRemoveCarouselAt,
                logo: logo,
                onLogoUpload: onLogoUpload,
                onLogoRemove: onLogoRemove,
                // barcode: barcode,
                // onBarcodeChanged: onBarcodeChanged,
                availableCategories: availableCategories,
                selectedCategories: selectedCategories,
                onCategoriesChanged: onCategoriesChanged,
                onLinkRules: onLinkRules,
                selectedRulesCount: selectedRulesCount,
                canCheckout: canCheckout,
                onCanCheckoutChanged: onCanCheckoutChanged,
                quantity: quantity,
                onQuantityChanged: onQuantityChanged,
                expiryDate: expiryDate,
                onExpiryDateChanged: onExpiryDateChanged,
              ),
            ),
            // Add action buttons at bottom for mobile
            if (isMobile) _MobileActionBar(
              isEditing: isEditing,
              isLoading: isLoading,
              isFormValid: isFormValid,
              onCancel: onCancel,
              onSave: () async => await onSave(),
            ),
          ],
        );
      },
    );
  }
}

class _MobileActionBar extends StatelessWidget {
  final bool isEditing;
  final bool isLoading;
  final bool isFormValid;
  final VoidCallback onCancel;
  final Future<void> Function() onSave;

  const _MobileActionBar({
    required this.isEditing,
    required this.isLoading,
    required this.isFormValid,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(
          top: BorderSide(color: AppColors.outline, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCancelButton(),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _buildSaveButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return SecondaryButton(
      onPressed: onCancel,
      label: 'Cancel',
      fullWidth: true,
    );
  }

  Widget _buildSaveButton() {
    return PrimaryButton(
      onPressed: isFormValid && !isLoading ? () async => await onSave() : null,
      icon: isLoading ? null : Icons.check,
      label: isLoading 
          ? 'Saving...' 
          : (isEditing ? 'Update Reward' : 'Create Reward'),
      loading: isLoading,
      fullWidth: true,
    );
  }
}
