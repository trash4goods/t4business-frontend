import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/barcode/index.dart';
import '../presenters/interface/product.dart';
import 'product_card_widget.dart';

class ProductGridViewWidget extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  final void Function(BarcodeResultModel product) onEdit;
  final void Function(BarcodeResultModel product) onDuplicate;
  final void Function(BarcodeResultModel product) onDelete;

  const ProductGridViewWidget({
    super.key,
    required this.presenter,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  double _getGridSpacing(double width) {
    if (width >= 1200) return 20;
    if (width >= 768) return 16;
    return 12;
  }

  int _getGridCrossAxisCount() {
    final width = Get.width;
    // Match original marketplace products layout
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
    // Match original aspect ratios for smaller cards
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getGridCrossAxisCount(),
        crossAxisSpacing: _getGridSpacing(Get.width),
        mainAxisSpacing: _getGridSpacing(Get.width),
        childAspectRatio: _getChildAspectRatio(),
      ),
      itemCount: presenter.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = presenter.filteredProducts[index];
        return ProductCardWidget(
          product: product,
          onEdit: () => onEdit(product),
          onDuplicate: () => onDuplicate(product),
          onDelete: () => onDelete(product),
        );
      },
    );
  }
}
