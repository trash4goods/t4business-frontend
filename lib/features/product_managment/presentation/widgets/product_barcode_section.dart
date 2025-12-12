import 'package:flutter/material.dart';
import '../../../../core/widgets/barcode_input_field.dart';
import '../presenters/interface/product.dart';

class ProductBarcodeSection extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const ProductBarcodeSection({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return BarcodeInputField(
      controller: presenter.barcodeController,
      placeholder: 'Enter product barcode',
      onChanged: (value) => presenter.updateFormField('barcode', value),
    );
  }
}
