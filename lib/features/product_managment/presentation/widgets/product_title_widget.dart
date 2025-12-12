import 'package:flutter/material.dart';
import '../../../../core/utils/translation_helper.dart';
import '../presenters/scan_product_details_presenter.dart';

class ProductTitleWidget extends StatelessWidget {
  final ScanProductDetailsViewPresentation presenter;

  const ProductTitleWidget({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Text(
        BackendTranslationHelper.translate(
          presenter.scannedProduct?.name ?? "PRODUCT NAME",
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
