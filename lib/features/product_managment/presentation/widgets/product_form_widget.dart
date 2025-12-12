import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../presenters/interface/product.dart';
import '../components/image_upload_component.dart';
import '../components/form_field_component.dart';
import '../components/category_selection_component.dart';
import '../../../../core/widgets/barcode_input_field.dart';
import 'primary_button.dart';
import 'secondary_button.dart';
import 'icon_button_widget.dart';

class ProductFormWidget extends StatelessWidget {
  final ProductsPresenterInterface presenter;

  const ProductFormWidget({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        
        return Column(
          children: [
            // Hide header on mobile to avoid clutter with tabs
            if (!isMobile) _FormHeader(presenter: presenter),
            if (!isMobile) const SizedBox(height: 0),
            Expanded(child: _FormContent(presenter: presenter)),
            // Add action buttons at bottom for mobile
            if (isMobile) _MobileActionBar(presenter: presenter),
          ],
        );
      },
    );
  }
}

class _FormHeader extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const _FormHeader({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceElevated),
      child: Row(
        children: [
          IconButtonWidget(
            onPressed: () => presenter.cancelEdit(),
            icon: Icons.arrow_back,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    presenter.editingProduct.value != null
                        ? 'Edit Product'
                        : 'Create Product',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    presenter.editingProduct.value != null
                        ? 'Update product information and preview changes'
                        : 'Add a new product to your catalog with live preview',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              SecondaryButton(
                onPressed: () => presenter.cancelEdit(),
                label: 'Cancel',
              ),
              const SizedBox(width: 8),
              Obx(
                () => PrimaryButton(
                  onPressed:
                      presenter.isFormValid.value && !presenter.isLoading.value
                          ? () => presenter.saveProduct()
                          : null,
                  icon: presenter.isLoading.value ? null : Icons.check,
                  label:
                      presenter.isLoading.value
                          ? 'Saving...'
                          : (presenter.editingProduct.value != null
                              ? 'Update Product'
                              : 'Create Product'),
                  loading: presenter.isLoading.value,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormContent extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const _FormContent({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'Basic Information'),
              const SizedBox(height: 12),
              _FormField(
                label: 'Title',
                required: true,
                child: Obx(
                  () => _TextInput(
                    value: presenter.formTitle.value,
                    onChanged: (v) => presenter.updateFormField('title', v),
                    hintText: 'Enter your product title',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _FormField(
                label: 'Brand',
                required: true,
                child: Obx(
                  () => _TextInput(
                    value: presenter.formBrand.value,
                    onChanged: (v) => presenter.updateFormField('brand', v),
                    hintText: 'Enter product brand',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _FormField(
                label: 'Description',
                required: true,
                child: Obx(
                  () => _TextInput(
                    value: presenter.formDescription.value,
                    onChanged:
                        (v) => presenter.updateFormField('description', v),
                    hintText: 'Describe your product',
                    maxLines: 3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: 'Product Images'),
              const SizedBox(height: 12),
              _FormField(
                label: 'Header Image',
                required: true,
                child: _HeaderImageUpload(presenter: presenter),
              ),
              /*const SizedBox(height: 12),
              _FormField(
                label: 'Carousel Images (1-2 images)',
                child: _CarouselImagesUpload(presenter: presenter),
              ),*/
              const SizedBox(height: 16),
              _SectionHeader(title: 'Barcode'),
              const SizedBox(height: 16),
              _FormField(
                label: 'Barcode',
                required: true,
                child: BarcodeInputField(
                  controller: presenter.barcodeController,
                  placeholder: 'Enter product barcode',
                  onChanged: (v) => presenter.updateFormField('barcode', v),
                ),
              ),
              const SizedBox(height: 16),
              _FormField(
                label: 'Category',
                required: true,
                child: Obx(
                  () => CategorySelectionComponent(
                    availableCategories: presenter.categories.toList(),
                    selectedCategory:
                        presenter.formCategories.isNotEmpty
                            ? presenter.formCategories.first
                            : null,
                    onSelectionChanged:
                        (category) =>
                            presenter.updateFormField('category', category),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderImageUpload extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const _HeaderImageUpload({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      log(
        '🔄 HeaderImageUpload rebuild: \\nformHeaderImage: ${presenter.formHeaderImage.value}',
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (presenter.formHeaderImage.value.isNotEmpty)
            SizedBox(
              height: 100,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 100,
                margin: const EdgeInsets.only(bottom: 8),
                child: ImageUploadComponent(
                  imageUrl: presenter.formHeaderImage.value,
                  onUpload: () {},
                  onRemove: () => presenter.updateFormField('headerImage', ''),
                  title: '',
                  subtitle: '',
                  compact: true,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          if (presenter.formHeaderImage.value.isEmpty)
            ImageUploadComponent(
              onUpload: () => presenter.uploadHeaderImage(),
              title: 'Upload Header Image',
              subtitle: 'This will appear at the top of your product preview',
              compact: true,
            ),
        ],
      );
    });
  }
}

/*class _CarouselImagesUpload extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const _CarouselImagesUpload({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          if (presenter.formCarouselImages.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: presenter.formCarouselImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8),
                    child: ImageUploadComponent(
                      imageUrl: presenter.formCarouselImages[index],
                      onUpload: () {},
                      onRemove: () {
                        final updatedList =
                            presenter.formCarouselImages.toList();
                        updatedList.removeAt(index);
                        presenter.updateFormField(
                          'carouselImages',
                          updatedList,
                        );
                      },
                      title: '',
                      subtitle: '',
                      compact: true,
                      width: 100,
                      height: 100,
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          if (presenter.formCarouselImages.length < 2)
            ImageUploadComponent(
              onUpload: () async => await presenter.uploadCarouselImage(),
              title: 'Add Carousel Image',
              subtitle:
                  'Add ${presenter.formCarouselImages.isEmpty ? "1-2" : "1 more"} image(s) for the carousel',
              compact: true,
            ),
        ],
      );
    });
  }
}*/

class _MobileActionBar extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const _MobileActionBar({required this.presenter});

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
            child: SecondaryButton(
              onPressed: () => presenter.cancelEdit(),
              label: 'Cancel',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Obx(
              () => PrimaryButton(
                onPressed:
                    presenter.isFormValid.value && !presenter.isLoading.value
                        ? () => presenter.saveProduct()
                        : null,
                icon: presenter.isLoading.value ? null : Icons.check,
                label:
                    presenter.isLoading.value
                        ? 'Saving...'
                        : (presenter.editingProduct.value != null
                            ? 'Update Product'
                            : 'Create Product'),
                loading: presenter.isLoading.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;
  final bool required;

  const _FormField({
    required this.label,
    required this.child,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormFieldComponent(label: label, required: required, child: child);
  }
}

class _TextInput extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final String? hintText;
  final int maxLines;

  const _TextInput({
    required this.value,
    required this.onChanged,
    this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value)
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.fieldText),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.fieldPlaceholder,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: AppColors.fieldBorderFocused,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.fieldBorder),
          ),
        ),
      ),
    );
  }
}
