import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/widgets/view_toggle_button.dart';

class ProductFiltersSection extends StatelessWidget {
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterPressed;
  final VoidCallback onSortPressed;
  final VoidCallback onUploadPressed;
  final ViewMode currentView;
  final ValueChanged<ViewMode> onViewChanged;

  const ProductFiltersSection({
    super.key,
    required this.categories,
    required this.onCategoryChanged,
    required this.onSearchChanged,
    required this.onFilterPressed,
    required this.onSortPressed,
    required this.onUploadPressed,
    required this.currentView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final isMobile = screenWidth < 768;
    
    return ShadCard(
      backgroundColor: AppColors.surfaceElevated,
      border: Border.all(color: AppColors.surfaceElevated, width: 0.0),
      shadows: const [],
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (isDesktop) _buildDesktopLayout(),
          if (isTablet) _buildTabletLayout(),
          if (isMobile) _buildMobileLayout(),
        ],
      ),
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildSearchField()),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: _buildCategoryFilter()),
        const SizedBox(width: 12),
        SizedBox(width: 100, child: _buildCsvUploadButton()),
        const SizedBox(width: 12),
        SizedBox(width: 100, child: _buildFilterButton()),
        const SizedBox(width: 12),
        _buildViewToggle(),
      ],
    );
  }
  
  Widget _buildTabletLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: _buildSearchField()),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: _buildCategoryFilter()),
            const SizedBox(width: 12),
            SizedBox(width: 100, child: _buildCsvUploadButton()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildFilterButton()),
            const SizedBox(width: 12),
            Expanded(child: _buildSortButton()),
            const SizedBox(width: 12),
            _buildViewToggle(),
          ],
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildSearchField(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(flex: 3, child: _buildCategoryFilter()),
            const SizedBox(width: 8),
            _buildMobileCsvUploadButton(),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildFilterButton()),
            const SizedBox(width: 8),
            Expanded(child: _buildSortButton()),
            const SizedBox(width: 8),
            _buildViewToggle(),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return ShadInput(
      onChanged: (value) => onSearchChanged(value),
      placeholder: const Text('Search products, categories...'),
      leading: const Icon(Icons.search, size: 18),
    );
  }

  Widget _buildCategoryFilter() {
    return ShadSelect<String>(
      placeholder: const Text('All Categories'),
      options: [
        const ShadOption(value: '', child: Text('All Categories')),
        ...categories.map(
          (category) => ShadOption(value: category, child: Text(category)),
        ),
      ],
      selectedOptionBuilder: (context, value) =>
          Text(value.isEmpty ? 'All Categories' : value),
      onChanged: (value) => onCategoryChanged(value ?? ''),
    );
  }

  Widget _buildFilterButton() {
    return ShadButton.outline(
      onPressed: onFilterPressed,
      leading: const Icon(Icons.tune, size: 16),
      child: const Text('Filters'),
    );
  }

  Widget _buildSortButton() {
    return ShadButton.outline(
      onPressed: onSortPressed,
      leading: const Icon(Icons.sort, size: 16),
      child: const Text('Sort'),
    );
  }

  Widget _buildCsvUploadButton() {
    return ShadButton.outline(
      onPressed: onUploadPressed,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.upload_file, size: 16),
          SizedBox(width: 6),
          Text('Upload', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return ViewToggleButton(
      currentView: currentView,
      onViewChanged: onViewChanged,
    );
  }
  
  Widget _buildMobileCsvUploadButton() {
    return ShadButton.outline(
      onPressed: onUploadPressed,
      child: const Icon(Icons.upload_file, size: 16),
    );
  }
}
