import 'package:flutter/material.dart';

import '../../../../core/app/themes/app_colors.dart';
import '../../../../core/app/themes/app_text_styles.dart';
import '../../data/models/barcode/index.dart';
import 'product_card_image.dart';

class ProductCardWidget extends StatelessWidget {
  final BarcodeResultModel product;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: ProductCardImage(product: product),
            ),
          ),
          Expanded(
            flex: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth;
                final isVerySmallCard = cardWidth < 160;
                final isSmallCard = cardWidth < 200;
                final padding =
                    isVerySmallCard ? 6.0 : (isSmallCard ? 8.0 : 12.0);

                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name ?? 'Unnamed Product',
                              style: (isVerySmallCard
                                      ? AppTextStyles.titleSmall
                                      : (isSmallCard
                                          ? AppTextStyles.titleMedium
                                          : AppTextStyles.titleLarge))
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isSmallCard)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Active',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 2 : (isSmallCard ? 4 : 6),
                      ),
                      Flexible(
                        child: Text(
                          product.instructions ?? 'No description available',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 4 : (isSmallCard ? 6 : 8),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: isSmallCard ? 12 : 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Available',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    isVerySmallCard
                                        ? 10
                                        : (isSmallCard ? 11 : null),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (product.trashType?.isNotEmpty == true &&
                              !isSmallCard)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.trashType!,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: isVerySmallCard ? 4 : (isSmallCard ? 6 : 8),
                      ),
                      _ResponsiveActionButtons(
                        onEdit: onEdit,
                        onDuplicate: onDuplicate,
                        onDelete: onDelete,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const _ResponsiveActionButtons({
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final isVerySmall = cardWidth < 140;
        final isSmall = cardWidth < 180;

        if (isVerySmall) {
          return Row(
            children: [
              _compactIconButton(onPressed: onEdit, icon: Icons.edit_outlined),
              const SizedBox(width: 4),
              _compactIconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline,
                color: AppColors.error,
              ),
            ],
          );
        } else if (isSmall) {
          return Row(
            children: [
              Expanded(
                child: _secondaryButton(
                  onPressed: onEdit,
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  compact: true,
                ),
              ),
              const SizedBox(width: 4),
              _compactIconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline,
                color: AppColors.error,
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(
                child: _secondaryButton(
                  onPressed: onEdit,
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  compact: cardWidth < 220,
                ),
              ),
              const SizedBox(width: 6),
              _iconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline,
                color: AppColors.error,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _compactIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color? color,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Icon(icon, size: 12, color: color ?? AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _iconButton({
    required VoidCallback onPressed,
    required IconData icon,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        color: color ?? AppColors.textSecondary,
        padding: const EdgeInsets.all(6),
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }

  Widget _secondaryButton({
    required VoidCallback onPressed,
    IconData? icon,
    required String label,
    bool compact = false,
  }) {
    final buttonColor = AppColors.textPrimary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: compact ? 12 : 14, color: buttonColor),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                label,
                style: (compact
                        ? AppTextStyles.buttonSmall
                        : AppTextStyles.buttonMedium)
                    .copyWith(color: buttonColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
