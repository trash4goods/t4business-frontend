import 'package:flutter/material.dart';
import '../../../../core/widgets/product_list_item.dart';
import '../../data/models/barcode/index.dart';
import '../presenters/interface/product.dart';

class ProductListViewWidget extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  final void Function(BarcodeResultModel product) onEdit;
  final void Function(BarcodeResultModel product) onDuplicate;
  final void Function(int id) onDelete;
  final void Function(BarcodeResultModel product) onTap;

  const ProductListViewWidget({
    super.key,
    required this.presenter,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: presenter.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = presenter.filteredProducts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ProductListItem(
            imageUrl: product.headerImage,
            title: product.name ?? 'Unnamed Product',
            description: product.instructions ?? 'No description available',
            onEdit: () => onEdit(product),
            onDuplicate: () => onDuplicate(product),
            onDelete: () => onDelete(product.id!),
            onTap: () => onTap(product),
          ),
        );
      },
    );
  }
}
