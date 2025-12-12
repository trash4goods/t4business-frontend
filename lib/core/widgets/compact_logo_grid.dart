// lib/core/components/profile/compact_logo_grid.dart
import 'package:flutter/material.dart';
import '../app/themes/app_colors.dart';
import '../app/themes/app_text_styles.dart';

class CompactLogoGrid extends StatelessWidget {
  final List<String> logoUrls;
  final VoidCallback? onAddLogo;
  final Function(String)? onDeleteLogo;
  final bool isLoading;

  const CompactLogoGrid({
    super.key,
    required this.logoUrls,
    this.onAddLogo,
    this.onDeleteLogo,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;
        final crossAxisCount = isDesktop ? 4 : 3;
        final itemSize =
            (constraints.maxWidth - (crossAxisCount - 1) * 8) / crossAxisCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.business_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Company Logos',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Upload and manage your company logos',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            // Grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Existing logos
                ...logoUrls.map((url) => _buildLogoItem(url, itemSize)),
                // Add button
                _buildAddLogoButton(itemSize),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogoItem(String url, double size) {
    return Container(
      width: size,
      height: size * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fieldBorder.withOpacity(0.5)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.network(
              url,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: AppColors.surfaceContainer,
                    child: Icon(
                      Icons.business_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => onDeleteLogo?.call(url),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.destructive,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.close,
                  size: 12,
                  color: AppColors.destructiveForeground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddLogoButton(double size) {
    return GestureDetector(
      onTap: isLoading ? null : onAddLogo,
      child: Container(
        width: size,
        height: size * 0.75,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.fieldBorder.withOpacity(0.5),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              Icon(Icons.add, size: 20, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              isLoading ? 'Uploading...' : 'Add Logo',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
