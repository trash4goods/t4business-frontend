import 'package:flutter/material.dart';
import '../presenters/scan_product_details_presenter.dart';
import 'drag_handle_widget.dart';
import 'product_title_widget.dart';
import 'product_brand_widget.dart';
import 'product_categories_widget.dart';
import 'product_barcode_widget.dart';

class ProductInfoSection extends StatelessWidget {
  final ScanProductDetailsViewPresentation presenter;
  final List<String> categories;
  final String barcode;

  const ProductInfoSection({
    super.key,
    required this.presenter,
    required this.categories,
    required this.barcode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag Handle
        DragHandleWidget(),
        
        // Product Title
        ProductTitleWidget(presenter: presenter),
        
        // Product Brand
        ProductBrandWidget(presenter: presenter),
        
        // Categories section
        ProductCategoriesWidget(categories: categories),
        
        // Barcode section
        ProductBarcodeWidget(barcode: barcode),
      ],
    );
  }
}
