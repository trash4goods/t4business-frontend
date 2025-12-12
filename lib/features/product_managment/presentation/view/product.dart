// lib/features/products/presentation/views/product.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/app/custom_getview.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../../data/models/product.dart';
import '../controllers/interface/product.dart';
import '../presenters/interface/product.dart';
import '../components/image_upload_component.dart';
import '../components/form_field_component.dart';
import '../components/category_selection_component.dart';
import 'mobile_preview_fixed.dart';

class ProductsPage
    extends
        CustomGetView<ProductsControllerInterface, ProductsPresenterInterface> {
  const ProductsPage({super.key});

  @override
  Widget buildView(BuildContext context) {
    final hasScaffoldAncestor = Scaffold.maybeOf(context) != null;

    if (hasScaffoldAncestor) {
      return SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                ShadDecorator(
                  decoration: ShadDecoration(color: AppColors.surfaceElevated),
                  child: _buildResponsiveLayout(constraints),
                ),
                _buildCreateProductFAB(constraints),
              ],
            );
          },
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ShadDecorator(
                decoration: ShadDecoration(color: AppColors.surfaceElevated),
                child: _buildResponsiveLayout(constraints),
              );
            },
          ),
        ),
        floatingActionButton: LayoutBuilder(
          builder: (context, constraints) {
            return _buildCreateProductFAB(constraints);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }
  }

  // Search field with ShadCN UI Input
  Widget _buildSearchField() {
    return ShadInput(
      onChanged: (value) => presenter.searchProducts(value),
      placeholder: const Text('Search products, categories...'),
      leading: const Icon(Icons.search, size: 18),
    );
  }

  // Category filter with ShadCN UI Select
  Widget _buildCategoryFilter() {
    return Obx(
      () => ShadSelect<String>(
        placeholder: const Text('All Categories'),
        options: [
          const ShadOption(value: '', child: Text('All Categories')),
          ...presenter.categories.map(
            (category) => ShadOption(value: category, child: Text(category)),
          ),
        ],
        selectedOptionBuilder:
            (context, value) => Text(value.isEmpty ? 'All Categories' : value),
        onChanged: (value) => presenter.filterProducts(value ?? ''),
      ),
    );
  }

  // Filter section with responsive layout
  Widget _buildFiltersSection() {
    return ShadCard(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: _buildSearchField()),
              SizedBox(width: 12),
              Expanded(child: _buildCategoryFilter()),
              if (Get.width >= 768) ...[
                SizedBox(width: 12),
                _buildFilterButton(),
              ],
            ],
          ),
          if (Get.width < 768) ...[
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildFilterButton()),
                SizedBox(width: 8),
                Expanded(child: _buildSortButton()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // Filter and sort buttons with ShadCN UI
  Widget _buildFilterButton() {
    return ShadButton.outline(
      onPressed: () => _showFilterDialog(),
      leading: const Icon(Icons.tune, size: 16),
      child: const Text('Filters'),
    );
  }

  Widget _buildSortButton() {
    return ShadButton.outline(
      onPressed: () => _showSortDialog(),
      leading: const Icon(Icons.sort, size: 16),
      child: const Text('Sort'),
    );
  }

  // Enhanced dialog with ShadCN UI
  void _showFilterDialog() {
    showShadDialog(
      context: Get.context!,
      builder:
          (context) => ShadDialog(
            title: const Text('Filter Rewards'),
            description: const Text('Advanced filter options coming soon...'),
            actions: [
              ShadButton.outline(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showSortDialog() {
    showShadDialog(
      context: Get.context!,
      builder:
          (context) => ShadDialog(
            title: const Text('Sort Rewards'),
            description: const Text('Sort options coming soon...'),
            actions: [
              ShadButton.outline(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  // Loading state with ShadCN UI
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ShadProgress(),
          const SizedBox(height: 16),
          Text(
            'Loading products...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Empty state with ShadCN UI
  Widget _buildEmptyState() {
    return Center(
      child: ShadCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadBadge(
              backgroundColor: AppColors.surfaceContainer,
              child: Icon(
                Icons.card_giftcard,
                size: 48,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No products found',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try adjusting your search or filters, or create your first product',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ShadButton(
              onPressed: () => presenter.startCreate(),
              leading: const Icon(Icons.add),
              child: const Text('Create First Reward'),
            ),
          ],
        ),
      ),
    );
  }

  double _getGridSpacing(double width) {
    if (width >= 1200) return 20;
    if (width >= 768) return 16;
    return 12;
  }

  Widget _buildResponsiveLayout(BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;

    if (isDesktop) {
      return _buildDesktopLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex:
              presenter.editingProduct.value != null ||
                      presenter.formTitle.value.isNotEmpty
                  ? 7
                  : 12,
          child: _buildMainContent(),
        ),
        Obx(() {
          if (presenter.isCreating.value) {
            return Container(
              width: 360, // Reduced width for better balance
              decoration: BoxDecoration(
                color: AppColors.previewBackground,
                border: Border(
                  left: BorderSide(color: AppColors.previewBorder, width: 1),
                ),
              ),
              child: _buildPreviewPanel(),
            );
          }
          return SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Obx(() {
      if (presenter.isCreating.value) {
        return Column(
          children: [
            Expanded(flex: 3, child: _buildProductForm()),
            Container(
              height: 300, // Fixed height for preview
              decoration: BoxDecoration(
                color: AppColors.previewBackground,
                border: Border(
                  top: BorderSide(color: AppColors.previewBorder, width: 1),
                ),
              ),
              child: _buildPreviewPanel(),
            ),
          ],
        );
      } else {
        return _buildProductsList();
      }
    });
  }

  Widget _buildMobileLayout() {
    return Obx(() {
      if (presenter.isCreating.value) {
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    bottom: BorderSide(color: AppColors.outline, width: 1),
                  ),
                ),
                child: TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  tabs: [Tab(text: 'Form'), Tab(text: 'Preview')],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [_buildProductForm(), _buildPreviewPanel()],
                ),
              ),
            ],
          ),
        );
      } else {
        return _buildProductsList();
      }
    });
  }

  Widget _buildMainContent() {
    return Obx(() {
      if (presenter.isCreating.value) {
        return _buildProductForm();
      } else {
        return _buildProductsList();
      }
    });
  }

  Widget _buildPreviewPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.phone_iphone,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Preview',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Real-time mobile preview',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Obx(
                  () => MobilePreviewWidgetFixed(
                    title: presenter.previewTitle.value,
                    description: presenter.previewDescription.value,
                    headerImage: presenter.formHeaderImage.value,
                    carouselImages: presenter.formCarouselImages,
                    recyclingImage: presenter.formRecyclingImage.value,
                    barcode: presenter.previewBarcode.value,
                    categories: presenter.previewCategories.toList(),
                    brand: presenter.previewBrand.value,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Column(
      children: [_buildFiltersSection(), Expanded(child: _buildProductsGrid())],
    );
  }

  Widget _buildProductsGrid() {
    return Obx(() {
      if (presenter.isLoading.value) {
        return _buildLoadingState();
      }

      if (presenter.filteredProducts.isEmpty) {
        return _buildEmptyState();
      }

      return GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getGridCrossAxisCount(),
          crossAxisSpacing: _getGridSpacing(Get.width),
          mainAxisSpacing: _getGridSpacing(Get.width),
          childAspectRatio: _getChildAspectRatio(),
        ),
        itemCount: presenter.filteredProducts.length,
        itemBuilder: (context, index) {
          final product = presenter.filteredProducts[index];
          return _buildProductCard(product);
        },
      );
    });
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: _buildProductCardImage(product),
            ),
          ),
          Expanded(
            flex: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth;
                final isVerySmallCard = cardWidth < 160;
                final isSmallCard = cardWidth < 200;
                final padding =
                    isVerySmallCard ? 6.0 : (isSmallCard ? 8.0 : 12.0);

                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              style: (isVerySmallCard
                                      ? AppTextStyles.titleSmall
                                      : (isSmallCard
                                          ? AppTextStyles.titleMedium
                                          : AppTextStyles.titleLarge))
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isSmallCard)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Active',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 2 : (isSmallCard ? 4 : 6),
                      ),
                      Flexible(
                        child: Text(
                          product.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 4 : (isSmallCard ? 6 : 8),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: isSmallCard ? 12 : 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Available',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    isVerySmallCard
                                        ? 10
                                        : (isSmallCard ? 11 : null),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (product.category.isNotEmpty && !isSmallCard)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.category.first,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 4 : (isSmallCard ? 6 : 8),
                      ),
                      _buildResponsiveActionButtons(product),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCardImage(ProductModel product) {
    // Try header image first, then fallback to first carousel image
    String? imageUrl;
    if (product.headerImage.isNotEmpty) {
      imageUrl = product.headerImage;
    } else if (product.carouselImage.isNotEmpty) {
      imageUrl = product.carouselImage.first;
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        child:
            imageUrl.contains('http')
                ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          _buildCardImagePlaceholder(),
                )
                : Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          _buildCardImagePlaceholder(),
                ),
      );
    } else {
      return _buildCardImagePlaceholder();
    }
  }

  Widget _buildCardImagePlaceholder() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.image_outlined,
              size: 24,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'No Image',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductForm() {
    return Column(
      children: [_buildFormHeader(), Expanded(child: _buildFormContent())],
    );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: Row(
        children: [
          _buildIconButton(
            onPressed: () => presenter.cancelEdit(),
            icon: Icons.arrow_back,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  presenter.editingProduct.value != null
                      ? 'Edit Product'
                      : 'Create Product',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  presenter.editingProduct.value != null
                      ? 'Update product information and preview changes'
                      : 'Add a new product to your catalog with live preview',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Row(
            children: [
              _buildSecondaryButton(
                onPressed: () => presenter.cancelEdit(),
                label: 'Cancel',
              ),
              SizedBox(width: 8),
              Obx(
                () => _buildPrimaryButton(
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

  Widget _buildFormContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Basic Information'),
              SizedBox(height: 12),

              // Product Title
              _buildFormField(
                label: 'Title',
                required: true,
                child: Obx(
                  () => _buildTextInput(
                    value: presenter.formTitle.value,
                    onChanged:
                        (value) => presenter.updateFormField('title', value),
                    hintText: 'Enter your product title',
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Brand
              _buildFormField(
                label: 'Brand',
                required: true,
                child: Obx(
                  () => _buildTextInput(
                    value: presenter.formBrand.value,
                    onChanged:
                        (value) => presenter.updateFormField('brand', value),
                    hintText: 'Enter product brand',
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Description
              _buildFormField(
                label: 'Description',
                required: true,
                child: Obx(
                  () => _buildTextInput(
                    value: presenter.formDescription.value,
                    onChanged:
                        (value) =>
                            presenter.updateFormField('description', value),
                    hintText: 'Describe your product',
                    maxLines: 3,
                  ),
                ),
              ),
              SizedBox(height: 16),

              _buildSectionHeader('Product Images'),
              SizedBox(height: 12),

              // Header Image
              _buildFormField(
                label: 'Header Image',
                required: true,
                child: _buildHeaderImageUpload(),
              ),
              SizedBox(height: 12),

              // Carousel Images
              _buildFormField(
                label: 'Carousel Images (1-2 images)',
                child: _buildCarouselImagesUpload(),
              ),
              SizedBox(height: 16),

              _buildSectionHeader('Items'),
              SizedBox(height: 12),

              // Items Section
              _buildFormField(
                label: 'Items',
                required: true,
                child: _buildItemsSection(isMobile),
              ),
              SizedBox(height: 16),

              // Categories with better visibility
              _buildFormField(
                label: 'Categories',
                required: true,
                child: _buildCategorySelection(),
              ),
              SizedBox(height: 16),

              /*
              _buildSectionHeader('Linked Rewards'),
              SizedBox(height: 12),

              // Rewards Section
              _buildFormField(
                label: 'Associated Reward',
                child: _buildRewardsSection(),
              ),
              SizedBox(height: 20),
              */
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderImageUpload() {
    return Obx(() {
      log(
        '🔄 _buildHeaderImageUpload Obx rebuild - formHeaderImage: ${presenter.formHeaderImage.value}',
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show uploaded header image as a small card (like carousel images)
          if (presenter.formHeaderImage.value.isNotEmpty)
            SizedBox(
              height: 100,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 100,
                margin: EdgeInsets.only(bottom: 8),
                child: ImageUploadComponent(
                  imageUrl: presenter.formHeaderImage.value,
                  onUpload: () {}, // No upload on existing image
                  onRemove: () => presenter.updateFormField('headerImage', ''),
                  title: '',
                  subtitle: '',
                  compact: true,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          // Show upload zone only when no image
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

  Widget _buildCarouselImagesUpload() {
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
                    margin: EdgeInsets.only(right: 8),
                    child: ImageUploadComponent(
                      imageUrl: presenter.formCarouselImages[index],
                      onUpload: () {}, // No upload on existing image
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
          SizedBox(height: 8),
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

  Widget _buildSectionHeader(String title) {
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
        SizedBox(width: 8),
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

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool required = false,
    String? helpText,
  }) {
    return FormFieldComponent(
      label: label,
      required: required,
      helpText: helpText,
      child: child,
    );
  }

  Widget _buildTextInput({
    required String value,
    required Function(String) onChanged,
    String? hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.02),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: TextEditingController(text: value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.fieldText),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.fieldPlaceholder,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

  // Category selection with Shad Select
  Widget _buildCategorySelection() {
    return Obx(
      () => CategorySelectionComponent(
        availableCategories: presenter.categories.toList(),
        selectedCategories: presenter.formCategories.toList(),
        onSelectionChanged:
            (categories) => presenter.updateFormField('categories', categories),
      ),
    );
  }

  // Items section (list + add new)
  Widget _buildItemsSection(bool isMobile) {
    return Obx(() {
      final items = presenter.formItems;
      final isAdding = presenter.isAddingItem.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Existing items list
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isEditing = presenter.editingItemIndex.value == idx;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child:
                  isEditing
                      ? _buildEditItemInputs(idx, isMobile)
                      : _buildItemDisplay(idx, item),
            );
          }),
          const SizedBox(height: 8),
          if (isAdding)
            _buildNewItemInputs(isMobile)
          else if (presenter.editingItemIndex.value ==
              -1) // Only show when not editing
            ShadButton.outline(
              onPressed: presenter.startAddingItem,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: 8),
                  Text('Create New Item'),
                ],
              ),
            ),
        ],
      );
    });
  }

  // Inline new-item inputs
  Widget _buildNewItemInputs(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: ShadInput(
                  placeholder: const Text('Item title'),
                  controller: presenter.newItemTitleController,
                  onChanged: (val) => presenter.updateNewItemTitle(val),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: ShadInput(
                  placeholder: const Text('Barcode (13 digits)'),
                  controller: presenter.newItemBarcodeController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => presenter.handleBarcodeInput(val),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => ShadButton(
                onPressed:
                    presenter.isNewItemValid()
                        ? presenter.addItemFromState
                        : null,
                size: ShadButtonSize.sm,
                child: const Text('Save'),
              ),
            ),
            const SizedBox(width: 8),
            ShadButton.outline(
              onPressed: presenter.cancelAddingItem,
              size: ShadButtonSize.sm,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }

  // Item display widget (read-only mode)
  Widget _buildItemDisplay(int index, Map<String, String> item) {
    return Row(
      children: [
        Expanded(
          child: Text(item['title'] ?? '', style: AppTextStyles.bodyMedium),
        ),
        const SizedBox(width: 12),
        Text(
          item['barcode'] ?? '',
          style: AppTextStyles.bodyMedium.copyWith(fontFamily: 'monospace'),
        ),
        const SizedBox(width: 8),
        _buildIconButton(
          onPressed: () => presenter.startEditingItem(index),
          icon: Icons.edit,
        ),
        const SizedBox(width: 4),
        _buildIconButton(
          onPressed: () => presenter.removeItem(index),
          icon: Icons.close,
        ),
      ],
    );
  }

  // Edit item inputs widget
  Widget _buildEditItemInputs(int index, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: ShadInput(
                  placeholder: const Text('Item title'),
                  controller: presenter.editItemTitleController,
                  onChanged: (val) => presenter.updateEditItemTitle(val),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: ShadInput(
                  placeholder: const Text('Barcode (13 digits)'),
                  controller: presenter.editItemBarcodeController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => presenter.handleEditBarcodeInput(val),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => ShadButton(
                onPressed:
                    presenter.isEditItemValid()
                        ? presenter.updateEditItemFromState
                        : null,
                size: ShadButtonSize.sm,
                child: const Text('Save'),
              ),
            ),
            const SizedBox(width: 8),
            ShadButton.outline(
              onPressed: presenter.cancelEditingItem,
              size: ShadButtonSize.sm,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required VoidCallback? onPressed,
    IconData? icon,
    required String label,
    bool loading = false,
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else if (icon != null)
              Icon(icon, size: 16),
            if (icon != null || loading) SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.buttonMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required VoidCallback? onPressed,
    IconData? icon,
    required String label,
    bool compact = false,
    bool fullWidth = false,
    Color? color,
  }) {
    final buttonColor = color ?? AppColors.textPrimary;
    final borderColor =
        color == AppColors.error
            ? AppColors.error.withOpacity(0.3)
            : AppColors.fieldBorder;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: buttonColor,
          side: BorderSide(color: borderColor),
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 16,
            vertical: compact ? 8 : 12,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: compact ? 12 : 16),
            if (icon != null) SizedBox(width: compact ? 3 : 6),
            Flexible(
              child: Text(
                label,
                style: (compact
                        ? AppTextStyles.buttonSmall
                        : AppTextStyles.buttonMedium)
                    .copyWith(color: buttonColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        color: color ?? AppColors.textSecondary,
        padding: EdgeInsets.all(6),
        constraints: BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }

  int _getGridCrossAxisCount() {
    final width = Get.width;
    // More responsive breakpoints for better card sizing
    // Ensure minimum card width of ~200px for proper content display
    if (width >= 1800) return 6; // Ultra-wide screens
    if (width >= 1400) return 5; // Very large screens
    if (width >= 1100) return 4; // Large screens
    if (width >= 800) return 3; // Medium screens
    if (width >= 500) return 2; // Small screens
    return 1; // Mobile
  }

  double _getChildAspectRatio() {
    final width = Get.width;
    final crossAxisCount = _getGridCrossAxisCount();

    // Adjust aspect ratio based on screen size and grid columns
    // Higher ratio = wider cards, lower ratio = taller cards
    if (width >= 1400) {
      return crossAxisCount >= 5
          ? 0.7 // More vertical space for very dense grids
          : 0.75; // Slightly more vertical space for dense grids
    } else if (width >= 1100) {
      return crossAxisCount >= 4
          ? 0.75 // More vertical space for smaller cards with many columns
          : 0.8; // Standard ratio for fewer columns
    } else if (width >= 800) {
      return 0.8; // Slightly more vertical space for medium screens
    } else if (width >= 500) {
      return 0.9; // More balanced for small screens with 2 columns
    } else {
      return 1.0; // Balanced ratio on mobile for better readability
    }
  }

  void _showDeleteDialog(ProductModel product) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 18,
              ),
            ),
            SizedBox(width: 10),
            Text('Delete Product', style: AppTextStyles.headlineSmall),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${product.title}"?',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: 6),
            Text(
              'This action cannot be undone and will permanently remove all product data.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          _buildSecondaryButton(onPressed: () => Get.back(), label: 'Cancel'),
          _buildPrimaryButton(
            onPressed: () {
              Get.back();
              presenter.deleteProduct(product.id);
            },
            icon: Icons.delete_outline,
            label: 'Delete Product',
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveActionButtons(ProductModel product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isVerySmall = cardWidth < 140;
        final isSmall = cardWidth < 180;

        if (isVerySmall) {
          // Very small cards: minimal icon-only buttons
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCompactIconButton(
                onPressed: () => presenter.startEdit(product),
                icon: Icons.edit_outlined,
              ),
              _buildCompactIconButton(
                onPressed: () => _showDeleteDialog(product),
                icon: Icons.delete_outline,
                color: AppColors.error,
              ),
            ],
          );
        } else if (isSmall) {
          // Small cards: compact button + icon
          return Row(
            children: [
              Expanded(
                child: _buildSecondaryButton(
                  onPressed: () => presenter.startEdit(product),
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  compact: true,
                ),
              ),
              SizedBox(width: 4),
              _buildCompactIconButton(
                onPressed: () => _showDeleteDialog(product),
                icon: Icons.delete_outline,
                color: AppColors.error,
              ),
            ],
          );
        } else {
          // Normal cards: standard layout
          return Row(
            children: [
              Expanded(
                child: _buildSecondaryButton(
                  onPressed: () => presenter.startEdit(product),
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  compact: cardWidth < 220,
                ),
              ),
              SizedBox(width: 6),
              _buildIconButton(
                onPressed: () => _showDeleteDialog(product),
                icon: Icons.delete_outline,
                color: AppColors.error,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildCompactIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color? color,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Icon(icon, size: 12, color: color ?? AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildCreateProductFAB(BoxConstraints constraints) {
    final isMobile = constraints.maxWidth < 768;
    final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1200;

    return Positioned(
      bottom: 16,
      right: 16,
      child: ShadButton(
        onPressed: () => presenter.startCreate(),
        size:
            isMobile
                ? ShadButtonSize.sm
                : (isTablet ? ShadButtonSize.regular : ShadButtonSize.lg),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: isMobile ? 16 : (isTablet ? 18 : 20)),
            SizedBox(width: isMobile ? 4 : 8),
            Text(
              isMobile ? 'Create' : 'Create Product',
              style: TextStyle(fontSize: isMobile ? 12 : (isTablet ? 14 : 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsSelectionSheet({String? currentSelectedReward}) {
    return ShadSheet(
      title: Text('Link Reward'),
      description: Text('Select one reward to link to this product'),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rewards list using ShadCard components
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: 5, // Replace with actual rewards count
                itemBuilder: (context, index) {
                  final rewardId = 'reward_$index';
                  final isSelected = presenter.formLinkedRewards.contains(
                    rewardId,
                  );

                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.fieldBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            // Update selection through presenter's existing method
                            presenter.formLinkedRewards.clear();
                            presenter.formLinkedRewards.add(rewardId);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.card_giftcard,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reward #$index',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Sample reward description',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Actions using ShadButton
            Row(
              children: [
                Expanded(
                  child: ShadButton.outline(
                    onPressed: () => Navigator.of(Get.context!).pop(),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ShadButton(
                    onPressed: () => Navigator.of(Get.context!).pop(),
                    child: Text('Done'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
