import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../presenters/interface/product.dart';
import '../view/mobile_preview_fixed.dart';

class ProductPreviewPanel extends StatelessWidget {
  final ProductsPresenterInterface presenter;

  const ProductPreviewPanel({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
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
              const SizedBox(width: 8),
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
          const SizedBox(height: 16),
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
}
