import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presenters/interface/product.dart';
import 'product_loading_state.dart';
import 'product_empty_state.dart';
import 'product_grid_view.dart';
import 'product_list_view_widget.dart';
import '../../data/models/barcode/index.dart';

class ProductsViewWidget extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  final void Function(BarcodeResultModel product) onEdit;
  final void Function(BarcodeResultModel product) onDuplicate;
  final void Function(BarcodeResultModel product) onDeleteRequest;

  const ProductsViewWidget({
    super.key,
    required this.presenter,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDeleteRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (presenter.isLoading.value) {
        return const ProductLoadingState();
      }

      if (presenter.filteredProducts.isEmpty) {
        return ProductEmptyState(onCreate: () => presenter.startCreate());
      }

      return presenter.viewMode.value == 'grid'
          ? ProductGridViewWidget(
            presenter: presenter,
            onEdit: onEdit,
            onDuplicate: onDuplicate,
            onDelete: (p) => onDeleteRequest(p),
          )
          : ProductListViewWidget(
            presenter: presenter,
            onEdit: onEdit,
            onDuplicate: onDuplicate,
            onDelete:
                (id) => onDeleteRequest(
                  presenter.filteredProducts.firstWhere((e) => e.id == id),
                ),
            onTap: onEdit,
          );
    });
  }
}
