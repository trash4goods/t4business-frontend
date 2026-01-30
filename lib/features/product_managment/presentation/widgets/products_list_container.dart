import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/widgets/csv_upload_dialog_stateless.dart';
import '../../../../core/widgets/view_toggle_button.dart';
import '../presenters/interface/product.dart';
import 'product_filters_section.dart';
import 'products_view_widget.dart';
import 'b2b_pagination_widget.dart';
import '../../data/models/barcode/index.dart';

class ProductsListContainer extends StatelessWidget {
  final ProductsPresenterInterface presenter;
  final void Function(BarcodeResultModel product) onEdit;
  final void Function(BarcodeResultModel product) onDuplicate;
  final void Function(BarcodeResultModel product) onDeleteRequest;

  const ProductsListContainer({
    super.key,
    required this.presenter,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDeleteRequest,
  });

  void _showFilterDialog() {
    showShadDialog(
      context: Get.context!,
      builder:
          (context) => const ShadDialog(
            title: Text('Filter Rewards'),
            description: Text('Advanced filter options coming soon...'),
          ),
    );
  }

  void _showSortDialog() {
    showShadDialog(
      context: Get.context!,
      builder:
          (context) => const ShadDialog(
            title: Text('Sort Rewards'),
            description: Text('Sort options coming soon...'),
          ),
    );
  }

  void _showCsvUploadDialog() {
    // Clear any previous selection when opening dialog
    presenter.clearCsvSelection();
    
    showShadDialog(
      context: Get.context!,
      builder: (context) => Obx(() => CsvUploadDialogStateless(
        selectedFileName: presenter.csvFileName?.value,
        selectedFilePath: presenter.csvFilePath?.value,
        selectedFileBytes: presenter.csvFileBytes.value,
        isUploading: presenter.isCsvUploading.value,
        isDownloadingTemplate: presenter.isDownloadingTemplate.value,
        hasDownloadedTemplate: presenter.hasDownloadedTemplate.value,
        hasSelectedFile: presenter.hasSelectedCsvFile.value,
        onDownloadTemplate: () => presenter.downloadCsvTemplate(),
        onPickFile: () => presenter.pickCsvFile(),
        onCancel: () => presenter.clearCsvSelection(),
        onFileSelected: ({
          String? filePath,
          String? fileName,
          Uint8List? fileBytes,
        }) {
          if (fileName == null) return;

          // Handle file selection based on platform
          if (kIsWeb) {
            // Use fileBytes for web
            if (fileBytes != null) {
              presenter.uploadCsvFile(
                fileBytes: fileBytes,
                fileName: fileName,
              );
            }
          }
        },
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => ProductFiltersSection(
                categories: presenter.categories,
                onCategoryChanged: (value) => presenter.filterProducts(value),
                onSearchChanged: (value) => presenter.searchProducts(value),
                onFilterPressed: _showFilterDialog,
                onSortPressed: _showSortDialog,
                onUploadPressed: _showCsvUploadDialog,
                onRefreshPressed: () => presenter.refreshProducts(),
                currentView:
                    presenter.viewMode.value == 'grid'
                        ? ViewMode.grid
                        : ViewMode.list,
                onViewChanged:
                    (mode) => presenter.toggleViewMode(
                      mode == ViewMode.grid ? 'grid' : 'list',
                    ),
              ),
            ),
            // Pagination at top
            Obx(() => B2BPaginationWidget(
              currentPage: presenter.currentPage.value,
              totalCount: presenter.totalCount.value,
              perPage: presenter.perPage.value,
              hasNext: presenter.hasNextPage.value,
              onPageChanged: (page) => presenter.goToPage(page),
              isLoading: presenter.isLoading.value,
            )),
          ],
        ),
        Expanded(
          child: ProductsViewWidget(
            presenter: presenter,
            onEdit: onEdit,
            onDuplicate: onDuplicate,
            onDeleteRequest: onDeleteRequest,
          ),
        ),
      ],
    );
  }
}
