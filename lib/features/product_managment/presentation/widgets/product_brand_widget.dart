import 'package:flutter/material.dart';
import '../../../../core/utils/translation_helper.dart';
import '../presenters/scan_product_details_presenter.dart';

class ProductBrandWidget extends StatelessWidget {
  final ScanProductDetailsViewPresentation presenter;

  const ProductBrandWidget({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Text(
        BackendTranslationHelper.translate(
          presenter.scannedProduct?.brand ?? "Product Brand",
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
        ),
      ),
    );
  }
}
