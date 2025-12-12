import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app/themes/app_colors.dart';
import '../presenters/interface/product.dart';
import 'product_preview_panel.dart';
import 'products_list_container.dart';
import 'product_form_widget.dart';

class ProductsResponsiveLayout extends StatelessWidget {
  final ProductsPresenterInterface presenter;

  const ProductsResponsiveLayout({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;

    if (isDesktop) return _DesktopLayout(presenter: presenter);
    if (isTablet) return _TabletLayout(presenter: presenter);
    return _MobileLayout(presenter: presenter);
  }
}

class _DesktopLayout extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const _DesktopLayout({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasEditOrTitle =
          presenter.editingProduct.value != null ||
          presenter.formTitle.value.isNotEmpty;
      final leftFlex = hasEditOrTitle ? 7 : 12;
      final showPreview = presenter.isCreating.value;

      return Row(
        children: [
          Expanded(
            flex: leftFlex,
            child:
                presenter.isCreating.value
                    ? ProductFormWidget(presenter: presenter)
                    : ProductsListContainer(
                      presenter: presenter,
                      onEdit: presenter.startEdit,
                      onDuplicate: presenter.duplicateProduct,
                      onDeleteRequest: (p) => presenter.deleteProduct(p.id!),
                    ),
          ),
          if (showPreview)
            Container(
              width: 360,
              decoration: BoxDecoration(
                color: AppColors.previewBackground,
                border: Border(
                  left: BorderSide(color: AppColors.previewBorder, width: 1),
                ),
              ),
              child: ProductPreviewPanel(presenter: presenter),
            ),
        ],
      );
    });
  }
}

class _TabletLayout extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const _TabletLayout({required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (presenter.isCreating.value) {
        return Column(
          children: [
            Expanded(flex: 3, child: ProductFormWidget(presenter: presenter)),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.previewBackground,
                border: Border(
                  top: BorderSide(color: AppColors.previewBorder, width: 1),
                ),
              ),
              child: ProductPreviewPanel(presenter: presenter),
            ),
          ],
        );
      } else {
        return ProductsListContainer(
          presenter: presenter,
          onEdit: presenter.startEdit,
          onDuplicate: presenter.duplicateProduct,
          onDeleteRequest: (p) => presenter.deleteProduct(p.id!),
        );
      }
    });
  }
}

class _MobileLayout extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  const _MobileLayout({required this.presenter});

  @override
  Widget build(BuildContext context) {
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
                child: const TabBar(
                  tabs: [Tab(text: 'Form'), Tab(text: 'Preview')],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ProductFormWidget(presenter: presenter),
                    ProductPreviewPanel(presenter: presenter),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return ProductsListContainer(
          presenter: presenter,
          onEdit: presenter.startEdit,
          onDuplicate: presenter.duplicateProduct,
          onDeleteRequest: (p) => presenter.deleteProduct(p.id!),
        );
      }
    });
  }
}
