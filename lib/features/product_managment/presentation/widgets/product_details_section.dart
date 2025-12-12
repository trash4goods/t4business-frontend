import 'package:flutter/material.dart';
import '../../../../core/utils/translation_helper.dart';
import '../components/banner_image_component.dart';
import '../presenters/scan_product_details_presenter.dart';

class ProductDetailsSection extends StatelessWidget {
  final ScanProductDetailsViewPresentation presenter;

  const ProductDetailsSection({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate('scan_product.product_details.how_to_recycle'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF557159),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      BackendTranslationHelper.translate(
                        presenter.scannedProduct?.instructions ??
                            'No Instructions Given',
                      ),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF557159),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                width: 60,
                child: BannerImage(
                  placeholderPath: "assets/images/default_event_picture.jpg",
                  files: presenter.scannedProduct?.middleImages ?? [],
                  lastImageUrl: presenter.scannedProduct?.lastImageUrl ?? '',
                  shoudlShowT4Glogo: true,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
